From: akpm@linux-foundation.org
Subject: - mm-bdi-init-hooks.patch removed from -mm tree
Date: Sun, 22 Apr 2007 12:02:09 -0700
Message-ID: <200704221902.l3MJ29vr032066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965379AbXDVTCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 15:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: bdi init hooks
has been removed from the -mm tree.  Its filename was
     mm-bdi-init-hooks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: bdi init hooks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide BDI constructor/destructor hooks

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c               |    2 ++
 drivers/block/rd.c              |    6 ++++++
 drivers/char/mem.c              |    2 ++
 drivers/mtd/mtdcore.c           |    5 +++++
 fs/char_dev.c                   |    1 +
 fs/configfs/configfs_internal.h |    2 ++
 fs/configfs/inode.c             |    8 ++++++++
 fs/configfs/mount.c             |    2 ++
 fs/fuse/inode.c                 |    2 ++
 fs/hugetlbfs/inode.c            |    3 +++
 fs/nfs/client.c                 |    3 +++
 fs/ocfs2/dlm/dlmfs.c            |    6 +++++-
 fs/ramfs/inode.c                |    7 ++++++-
 fs/sysfs/inode.c                |    5 +++++
 fs/sysfs/mount.c                |    2 ++
 fs/sysfs/sysfs.h                |    1 +
 include/linux/backing-dev.h     |    7 +++++++
 kernel/cpuset.c                 |    3 +++
 mm/shmem.c                      |    1 +
 mm/swap.c                       |    2 ++
 20 files changed, 68 insertions(+), 2 deletions(-)

diff -puN block/ll_rw_blk.c~mm-bdi-init-hooks block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~mm-bdi-init-hooks
+++ a/block/ll_rw_blk.c
@@ -1774,6 +1774,7 @@ static void blk_release_queue(struct kob
 
 	blk_trace_shutdown(q);
 
+	bdi_destroy(&q->backing_dev_info);
 	kmem_cache_free(requestq_cachep, q);
 }
 
@@ -1838,6 +1839,7 @@ request_queue_t *blk_alloc_queue_node(gf
 	snprintf(q->kobj.name, KOBJ_NAME_LEN, "%s", "queue");
 	q->kobj.ktype = &queue_ktype;
 	kobject_init(&q->kobj);
+	bdi_init(&q->backing_dev_info);
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
diff -puN drivers/block/rd.c~mm-bdi-init-hooks drivers/block/rd.c
--- a/drivers/block/rd.c~mm-bdi-init-hooks
+++ a/drivers/block/rd.c
@@ -411,6 +411,9 @@ static void __exit rd_cleanup(void)
 		blk_cleanup_queue(rd_queue[i]);
 	}
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
+
+	bdi_destroy(&rd_file_backing_dev_info);
+	bdi_destroy(&rd_backing_dev_info);
 }
 
 /*
@@ -421,6 +424,9 @@ static int __init rd_init(void)
 	int i;
 	int err = -ENOMEM;
 
+	bdi_init(&rd_backing_dev_info);
+	bdi_init(&rd_file_backing_dev_info);
+
 	if (rd_blocksize > PAGE_SIZE || rd_blocksize < 512 ||
 			(rd_blocksize & (rd_blocksize-1))) {
 		printk("RAMDISK: wrong blocksize %d, reverting to defaults\n",
diff -puN drivers/char/mem.c~mm-bdi-init-hooks drivers/char/mem.c
--- a/drivers/char/mem.c~mm-bdi-init-hooks
+++ a/drivers/char/mem.c
@@ -987,6 +987,8 @@ static int __init chr_dev_init(void)
 			      MKDEV(MEM_MAJOR, devlist[i].minor),
 			      devlist[i].name);
 
+	bdi_init(&zero_bdi);
+
 	return 0;
 }
 
diff -puN drivers/mtd/mtdcore.c~mm-bdi-init-hooks drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mm-bdi-init-hooks
+++ a/drivers/mtd/mtdcore.c
@@ -60,6 +60,7 @@ int add_mtd_device(struct mtd_info *mtd)
 			break;
 		}
 	}
+	bdi_init(mtd->backing_dev_info);
 
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
@@ -142,6 +143,10 @@ int del_mtd_device (struct mtd_info *mtd
 	}
 
 	mutex_unlock(&mtd_table_mutex);
+
+	if (mtd->backing_dev_info)
+		bdi_destroy(mtd->backing_dev_info);
+
 	return ret;
 }
 
diff -puN fs/char_dev.c~mm-bdi-init-hooks fs/char_dev.c
--- a/fs/char_dev.c~mm-bdi-init-hooks
+++ a/fs/char_dev.c
@@ -546,6 +546,7 @@ static struct kobject *base_probe(dev_t 
 void __init chrdev_init(void)
 {
 	cdev_map = kobj_map_init(base_probe, &chrdevs_lock);
+	bdi_init(&directly_mappable_cdev_bdi);
 }
 
 
diff -puN fs/configfs/configfs_internal.h~mm-bdi-init-hooks fs/configfs/configfs_internal.h
--- a/fs/configfs/configfs_internal.h~mm-bdi-init-hooks
+++ a/fs/configfs/configfs_internal.h
@@ -55,6 +55,8 @@ extern int configfs_is_root(struct confi
 
 extern struct inode * configfs_new_inode(mode_t mode, struct configfs_dirent *);
 extern int configfs_create(struct dentry *, int mode, int (*init)(struct inode *));
+extern void configfs_inode_init(void);
+extern void configfs_inode_exit(void);
 
 extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
 extern int configfs_make_dirent(struct configfs_dirent *,
diff -puN fs/configfs/inode.c~mm-bdi-init-hooks fs/configfs/inode.c
--- a/fs/configfs/inode.c~mm-bdi-init-hooks
+++ a/fs/configfs/inode.c
@@ -255,4 +255,12 @@ void configfs_hash_and_remove(struct den
 	mutex_unlock(&dir->d_inode->i_mutex);
 }
 
+void __init configfs_inode_init(void)
+{
+	bdi_init(&configfs_backing_dev_info);
+}
 
+void __exit configfs_inode_exit(void)
+{
+	bdi_destroy(&configfs_backing_dev_info);
+}
diff -puN fs/configfs/mount.c~mm-bdi-init-hooks fs/configfs/mount.c
--- a/fs/configfs/mount.c~mm-bdi-init-hooks
+++ a/fs/configfs/mount.c
@@ -156,6 +156,7 @@ static int __init configfs_init(void)
 		configfs_dir_cachep = NULL;
 	}
 
+	configfs_inode_init();
 out:
 	return err;
 }
@@ -166,6 +167,7 @@ static void __exit configfs_exit(void)
 	subsystem_unregister(&config_subsys);
 	kmem_cache_destroy(configfs_dir_cachep);
 	configfs_dir_cachep = NULL;
+	configfs_inode_exit();
 }
 
 MODULE_AUTHOR("Oracle");
diff -puN fs/fuse/inode.c~mm-bdi-init-hooks fs/fuse/inode.c
--- a/fs/fuse/inode.c~mm-bdi-init-hooks
+++ a/fs/fuse/inode.c
@@ -415,6 +415,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
+		bdi_init(&fc->bdi);
 		fc->reqctr = 0;
 		fc->blocked = 1;
 		get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
@@ -428,6 +429,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
 		mutex_destroy(&fc->inst_mutex);
+		bdi_destroy(&fc->bdi);
 		kfree(fc);
 	}
 }
diff -puN fs/hugetlbfs/inode.c~mm-bdi-init-hooks fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-bdi-init-hooks
+++ a/fs/hugetlbfs/inode.c
@@ -818,6 +818,8 @@ static int __init init_hugetlbfs_fs(void
  out:
 	if (error)
 		kmem_cache_destroy(hugetlbfs_inode_cachep);
+	else
+		bdi_init(&hugetlbfs_backing_dev_info);
 	return error;
 }
 
@@ -825,6 +827,7 @@ static void __exit exit_hugetlbfs_fs(voi
 {
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
 	unregister_filesystem(&hugetlbfs_fs_type);
+	bdi_destroy(&hugetlbfs_backing_dev_info);
 }
 
 module_init(init_hugetlbfs_fs)
diff -puN fs/nfs/client.c~mm-bdi-init-hooks fs/nfs/client.c
--- a/fs/nfs/client.c~mm-bdi-init-hooks
+++ a/fs/nfs/client.c
@@ -657,6 +657,8 @@ static void nfs_server_set_fsinfo(struct
 	if (server->rsize > NFS_MAX_FILE_IO_SIZE)
 		server->rsize = NFS_MAX_FILE_IO_SIZE;
 	server->rpages = (server->rsize + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	bdi_init(&server->backing_dev_info);
 	server->backing_dev_info.ra_pages = server->rpages * NFS_MAX_READAHEAD;
 
 	if (server->wsize > max_rpc_payload)
@@ -786,6 +788,7 @@ void nfs_free_server(struct nfs_server *
 	nfs_put_client(server->nfs_client);
 
 	nfs_free_iostats(server->io_stats);
+	bdi_destroy(&server->backing_dev_info);
 	kfree(server);
 	nfs_release_automount_timer();
 	dprintk("<-- nfs_free_server()\n");
diff -puN fs/ocfs2/dlm/dlmfs.c~mm-bdi-init-hooks fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~mm-bdi-init-hooks
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -613,8 +613,10 @@ bail:
 			kmem_cache_destroy(dlmfs_inode_cache);
 		if (cleanup_worker)
 			destroy_workqueue(user_dlm_worker);
-	} else
+	} else {
+		bdi_init(&dlmfs_backing_dev_info);
 		printk("OCFS2 User DLM kernel interface loaded\n");
+	}
 	return status;
 }
 
@@ -626,6 +628,8 @@ static void __exit exit_dlmfs_fs(void)
 	destroy_workqueue(user_dlm_worker);
 
 	kmem_cache_destroy(dlmfs_inode_cache);
+
+	bdi_destroy(&dlmfs_backing_dev_info);
 }
 
 MODULE_AUTHOR("Oracle");
diff -puN fs/ramfs/inode.c~mm-bdi-init-hooks fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~mm-bdi-init-hooks
+++ a/fs/ramfs/inode.c
@@ -210,12 +210,17 @@ static struct file_system_type rootfs_fs
 
 static int __init init_ramfs_fs(void)
 {
-	return register_filesystem(&ramfs_fs_type);
+	int ret;
+	ret = register_filesystem(&ramfs_fs_type);
+	if (!ret)
+		bdi_init(&ramfs_backing_dev_info);
+	return ret;
 }
 
 static void __exit exit_ramfs_fs(void)
 {
 	unregister_filesystem(&ramfs_fs_type);
+	bdi_destroy(&ramfs_backing_dev_info);
 }
 
 module_init(init_ramfs_fs)
diff -puN fs/sysfs/inode.c~mm-bdi-init-hooks fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~mm-bdi-init-hooks
+++ a/fs/sysfs/inode.c
@@ -316,3 +316,8 @@ int sysfs_hash_and_remove(struct dentry 
 
 	return 0;
 }
+
+void __init sysfs_inode_init(void)
+{
+	bdi_init(&sysfs_backing_dev_info);
+}
diff -puN fs/sysfs/mount.c~mm-bdi-init-hooks fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~mm-bdi-init-hooks
+++ a/fs/sysfs/mount.c
@@ -102,6 +102,8 @@ int __init sysfs_init(void)
 	} else
 		goto out_err;
 out:
+	if (!err)
+		sysfs_inode_init();
 	return err;
 out_err:
 	kmem_cache_destroy(sysfs_dir_cachep);
diff -puN fs/sysfs/sysfs.h~mm-bdi-init-hooks fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~mm-bdi-init-hooks
+++ a/fs/sysfs/sysfs.h
@@ -48,6 +48,7 @@ extern int sysfs_path_depth(struct sysfs
 extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
+extern void sysfs_inode_init(void);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
diff -puN include/linux/backing-dev.h~mm-bdi-init-hooks include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-init-hooks
+++ a/include/linux/backing-dev.h
@@ -34,6 +34,13 @@ struct backing_dev_info {
 	void *unplug_io_data;
 };
 
+static inline void bdi_init(struct backing_dev_info *bdi)
+{
+}
+
+static inline void bdi_destroy(struct backing_dev_info *bdi)
+{
+}
 
 /*
  * Flags in backing_dev_info::capability
diff -puN kernel/cpuset.c~mm-bdi-init-hooks kernel/cpuset.c
--- a/kernel/cpuset.c~mm-bdi-init-hooks
+++ a/kernel/cpuset.c
@@ -1918,6 +1918,7 @@ int __init cpuset_init_early(void)
 
 	tsk->cpuset = &top_cpuset;
 	tsk->cpuset->mems_generation = cpuset_mems_generation++;
+
 	return 0;
 }
 
@@ -1960,6 +1961,8 @@ int __init cpuset_init(void)
 	/* memory_pressure_enabled is in root cpuset only */
 	if (err == 0)
 		err = cpuset_add_file(root, &cft_memory_pressure_enabled);
+	if (!err)
+		bdi_init(&cpuset_backing_dev_info);
 out:
 	return err;
 }
diff -puN mm/shmem.c~mm-bdi-init-hooks mm/shmem.c
--- a/mm/shmem.c~mm-bdi-init-hooks
+++ a/mm/shmem.c
@@ -2477,6 +2477,7 @@ static int __init init_tmpfs(void)
 		printk(KERN_ERR "Could not kern_mount tmpfs\n");
 		goto out1;
 	}
+	bdi_init(&shmem_backing_dev_info);
 	return 0;
 
 out1:
diff -puN mm/swap.c~mm-bdi-init-hooks mm/swap.c
--- a/mm/swap.c~mm-bdi-init-hooks
+++ a/mm/swap.c
@@ -564,6 +564,8 @@ void __init swap_setup(void)
 {
 	unsigned long megs = num_physpages >> (20 - PAGE_SHIFT);
 
+	bdi_init(swapper_space.backing_dev_info);
+
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
 		page_cluster = 2;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
mm-optimize-kill_bdev.patch
mm-optimize-kill_bdev-fix.patch
mm-optimize-acorn-partition-truncate.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
exec-fix-remove_arg_zero-add-comment.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
mm-bdi-init-hooks.patch
mm-bdi-init-hooks-fix.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
mm-expose-bdi-statistics-in-sysfs-printk-fixes.patch
mm-per-device-dirty-threshold.patch
