From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 30 Nov 2017 12:17:38 -0800
Message-ID: <20171130201738.56wMvZm3h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdK3URk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:17:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/btrfs/compression.c~linux-next-git-rejects fs/btrfs/compression.c
--- a/fs/btrfs/compression.c~linux-next-git-rejects
+++ a/fs/btrfs/compression.c
@@ -1537,12 +1537,8 @@ unsigned int btrfs_compress_str2level(co
 	if (*str == ':')
 		str++;
 
-<<<<<<< HEAD
-	return BTRFS_ZLIB_DEFAULT_LEVEL;
-=======
 	if (kstrtoul(str, 10, &level))
 		return BTRFS_ZLIB_DEFAULT_LEVEL;
 
 	return (level > max) ? BTRFS_ZLIB_DEFAULT_LEVEL : level;
->>>>>>> linux-next/akpm-base
 }
diff -puN fs/btrfs/file.c~linux-next-git-rejects fs/btrfs/file.c
--- a/fs/btrfs/file.c~linux-next-git-rejects
+++ a/fs/btrfs/file.c
@@ -1519,11 +1519,7 @@ lock_and_cleanup_extent_if_need(struct b
 		clear_extent_bit(&inode->io_tree, start_pos, last_pos,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-<<<<<<< HEAD
-				 0, 0, cached_state, GFP_NOFS);
-=======
 				 0, 0, cached_state);
->>>>>>> linux-next/akpm-base
 		*lockstart = start_pos;
 		*lockend = last_pos;
 		ret = 1;
diff -puN fs/btrfs/volumes.c~linux-next-git-rejects fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c~linux-next-git-rejects
+++ a/fs/btrfs/volumes.c
@@ -260,13 +260,7 @@ static void free_fs_devices(struct btrfs
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
-<<<<<<< HEAD
-		rcu_string_free(device->name);
-		bio_put(device->flush_bio);
-		kfree(device);
-=======
 		free_device(device);
->>>>>>> linux-next/akpm-base
 	}
 	kfree(fs_devices);
 }
@@ -659,13 +653,7 @@ static void btrfs_free_stale_device(stru
 			} else {
 				fs_devs->num_devices--;
 				list_del(&dev->dev_list);
-<<<<<<< HEAD
-				rcu_string_free(dev->name);
-				bio_put(dev->flush_bio);
-				kfree(dev);
-=======
 				free_device(dev);
->>>>>>> linux-next/akpm-base
 			}
 			break;
 		}
@@ -781,12 +769,7 @@ static noinline int device_list_add(cons
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
-<<<<<<< HEAD
-			bio_put(device->flush_bio);
-			kfree(device);
-=======
 			free_device(device);
->>>>>>> linux-next/akpm-base
 			return -ENOMEM;
 		}
 		rcu_assign_pointer(device->name, name);
@@ -898,12 +881,7 @@ static struct btrfs_fs_devices *clone_fs
 			name = rcu_string_strdup(orig_dev->name->str,
 					GFP_KERNEL);
 			if (!name) {
-<<<<<<< HEAD
-				bio_put(device->flush_bio);
-				kfree(device);
-=======
 				free_device(device);
->>>>>>> linux-next/akpm-base
 				goto error;
 			}
 			rcu_assign_pointer(device->name, name);
@@ -967,13 +945,7 @@ again:
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
-<<<<<<< HEAD
-		rcu_string_free(device->name);
-		bio_put(device->flush_bio);
-		kfree(device);
-=======
 		free_device(device);
->>>>>>> linux-next/akpm-base
 	}
 
 	if (fs_devices->seed) {
@@ -2451,11 +2423,6 @@ int btrfs_init_new_device(struct btrfs_f
 
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
-<<<<<<< HEAD
-		bio_put(device->flush_bio);
-		kfree(device);
-=======
->>>>>>> linux-next/akpm-base
 		ret = -ENOMEM;
 		goto error_free_device;
 	}
@@ -2463,12 +2430,6 @@ int btrfs_init_new_device(struct btrfs_f
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-<<<<<<< HEAD
-		rcu_string_free(device->name);
-		bio_put(device->flush_bio);
-		kfree(device);
-=======
->>>>>>> linux-next/akpm-base
 		ret = PTR_ERR(trans);
 		goto error_free_device;
 	}
@@ -2610,14 +2571,8 @@ error_trans:
 		sb->s_flags |= SB_RDONLY;
 	if (trans)
 		btrfs_end_transaction(trans);
-<<<<<<< HEAD
-	rcu_string_free(device->name);
-	bio_put(device->flush_bio);
-	kfree(device);
-=======
 error_free_device:
 	free_device(device);
->>>>>>> linux-next/akpm-base
 error:
 	blkdev_put(bdev, FMODE_EXCL);
 	if (seeding_dev && !unlocked) {
@@ -2683,12 +2638,7 @@ int btrfs_init_dev_replace_tgtdev(struct
 
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
-<<<<<<< HEAD
-		bio_put(device->flush_bio);
-		kfree(device);
-=======
 		free_device(device);
->>>>>>> linux-next/akpm-base
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -6404,12 +6354,7 @@ struct btrfs_device *btrfs_alloc_device(
 
 		ret = find_next_devid(fs_info, &tmp);
 		if (ret) {
-<<<<<<< HEAD
-			bio_put(dev->flush_bio);
-			kfree(dev);
-=======
 			free_device(dev);
->>>>>>> linux-next/akpm-base
 			return ERR_PTR(ret);
 		}
 	}
diff -puN fs/lockd/host.c~linux-next-git-rejects fs/lockd/host.c
--- a/fs/lockd/host.c~linux-next-git-rejects
+++ a/fs/lockd/host.c
@@ -593,11 +593,7 @@ static void nlm_complain_hosts(struct ne
 		if (net && host->net != net)
 			continue;
 		dprintk("       %s (cnt %d use %d exp %ld net %x)\n",
-<<<<<<< HEAD
-			host->h_name, atomic_read(&host->h_count),
-=======
 			host->h_name, refcount_read(&host->h_count),
->>>>>>> linux-next/akpm-base
 			host->h_inuse, host->h_expires, host->net->ns.inum);
 	}
 }
@@ -670,11 +666,7 @@ nlm_gc_hosts(struct net *net)
 		 || time_before(jiffies, host->h_expires)) {
 			dprintk("nlm_gc_hosts skipping %s "
 				"(cnt %d use %d exp %ld net %x)\n",
-<<<<<<< HEAD
-				host->h_name, atomic_read(&host->h_count),
-=======
 				host->h_name, refcount_read(&host->h_count),
->>>>>>> linux-next/akpm-base
 				host->h_inuse, host->h_expires,
 				host->net->ns.inum);
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

