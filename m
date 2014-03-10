From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 10 Mar 2014 11:48:31 -0700
Message-ID: <531e08ff.aTeF4Pe8BzIRNxs4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaCJSsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 14:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 11:48:31 -0700


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

 block/blk-mq.c                       |    5 -
 drivers/gpu/drm/i915/intel_display.c |    4 -
 drivers/spi/spi-atmel.c              |    3 -
 drivers/staging/cxt1e1/linux.c       |   72 -------------------------
 fs/bio-integrity.c                   |   37 ------------
 kernel/cpuset.c                      |    4 -
 6 files changed, 125 deletions(-)

diff -puN block/blk-mq.c~linux-next-git-rejects block/blk-mq.c
--- a/block/blk-mq.c~linux-next-git-rejects
+++ a/block/blk-mq.c
@@ -285,10 +285,6 @@ void blk_mq_free_request(struct request
 
 bool blk_mq_end_io_partial(struct request *rq, int error, unsigned int nr_bytes)
 {
-<<<<<<< HEAD
-	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
-		return true;
-=======
 	struct bio *bio = rq->bio;
 	unsigned int bytes = 0;
 
@@ -304,7 +300,6 @@ bool blk_mq_end_io_partial(struct reques
 	}
 
 	blk_account_io_completion(rq, bytes);
->>>>>>> linux-next/akpm-base
 
 	blk_account_io_done(rq);
 
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -1095,10 +1095,6 @@ static void assert_cursor(struct drm_i91
 	struct drm_device *dev = dev_priv->dev;
 	bool cur_state;
 
-<<<<<<< HEAD
-=======
-
->>>>>>> linux-next/akpm-base
 	if (IS_845G(dev) || IS_I865G(dev))
 		cur_state = I915_READ(_CURACNTR) & CURSOR_ENABLE;
 	else if (INTEL_INFO(dev)->gen <= 6 || IS_VALLEYVIEW(dev))
diff -puN drivers/spi/spi-atmel.c~linux-next-git-rejects drivers/spi/spi-atmel.c
--- a/drivers/spi/spi-atmel.c~linux-next-git-rejects
+++ a/drivers/spi/spi-atmel.c
@@ -1461,11 +1461,8 @@ static int atmel_spi_resume(struct devic
 	struct spi_master	*master = dev_get_drvdata(dev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	int ret;
-<<<<<<< HEAD
-=======
 
 	pinctrl_pm_select_default_state(dev);
->>>>>>> linux-next/akpm-base
 
 	clk_prepare_enable(as->clk);
 
diff -puN drivers/staging/cxt1e1/linux.c~linux-next-git-rejects drivers/staging/cxt1e1/linux.c
--- a/drivers/staging/cxt1e1/linux.c~linux-next-git-rejects
+++ a/drivers/staging/cxt1e1/linux.c
@@ -879,77 +879,6 @@ c4_ioctl(struct net_device *ndev, struct
 		_IOC_DIR(iocmd), _IOC_TYPE(iocmd), _IOC_NR(iocmd),
 		_IOC_SIZE(iocmd));
 #endif
-<<<<<<< HEAD
-    iolen = _IOC_SIZE (iocmd);
-    if (iolen > sizeof(arg))
-        return -EFAULT;
-    data = ifr->ifr_data + sizeof (iocmd);
-    if (copy_from_user (&arg, data, iolen))
-        return -EFAULT;
-
-    ret = 0;
-    switch (iocmd)
-    {
-    case SBE_IOC_PORT_GET:
-        //pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
-        ret = do_get_port (ndev, data);
-        break;
-    case SBE_IOC_PORT_SET:
-        //pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
-        ret = do_set_port (ndev, data);
-        break;
-    case SBE_IOC_CHAN_GET:
-        //pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
-        ret = do_get_chan (ndev, data);
-        break;
-    case SBE_IOC_CHAN_SET:
-        //pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
-        ret = do_set_chan (ndev, data);
-        break;
-    case C4_DEL_CHAN:
-        //pr_info(">> C4_DEL_CHAN Ioctl...\n");
-        ret = do_del_chan (ndev, data);
-        break;
-    case SBE_IOC_CHAN_NEW:
-        ret = do_create_chan (ndev, data);
-        break;
-    case SBE_IOC_CHAN_GET_STAT:
-        ret = do_get_chan_stats (ndev, data);
-        break;
-    case SBE_IOC_LOGLEVEL:
-        ret = do_set_loglevel (ndev, data);
-        break;
-    case SBE_IOC_RESET_DEV:
-        ret = do_reset (ndev, data);
-        break;
-    case SBE_IOC_CHAN_DEL_STAT:
-        ret = do_reset_chan_stats (ndev, data);
-        break;
-    case C4_LOOP_PORT:
-        ret = do_port_loop (ndev, data);
-        break;
-    case C4_RW_FRMR:
-        ret = do_framer_rw (ndev, data);
-        break;
-    case C4_RW_MSYC:
-        ret = do_musycc_rw (ndev, data);
-        break;
-    case C4_RW_PLD:
-        ret = do_pld_rw (ndev, data);
-        break;
-    case SBE_IOC_IID_GET:
-        ret = (iolen == sizeof (struct sbe_iid_info)) ? c4_get_iidinfo (ci, &arg.u.iip) : -EFAULT;
-        if (ret == 0)               /* no error, copy data */
-            if (copy_to_user (data, &arg, iolen))
-                return -EFAULT;
-        break;
-    default:
-        //pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
-        ret = -EINVAL;
-        break;
-    }
-    return mkret (ret);
-=======
 	iolen = _IOC_SIZE(iocmd);
 	if (iolen > sizeof(arg))
 		return -EFAULT;
@@ -1020,7 +949,6 @@ c4_ioctl(struct net_device *ndev, struct
 		break;
 	}
 	return mkret(ret);
->>>>>>> linux-next/akpm-base
 }
 
 static const struct net_device_ops c4_ops = {
diff -puN fs/bio-integrity.c~linux-next-git-rejects fs/bio-integrity.c
--- a/fs/bio-integrity.c~linux-next-git-rejects
+++ a/fs/bio-integrity.c
@@ -478,44 +478,7 @@ EXPORT_SYMBOL(bio_integrity_prep);
  */
 static int bio_integrity_verify(struct bio *bio)
 {
-<<<<<<< HEAD
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
-	struct bio_vec *bv;
-	sector_t sector = bio->bi_integrity->bip_iter.bi_sector;
-	unsigned int sectors, ret = 0;
-	void *prot_buf = bio->bi_integrity->bip_buf;
-	int i;
-
-	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size = bi->sector_size;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
-
-		bix.data_buf = kaddr + bv->bv_offset;
-		bix.data_size = bv->bv_len;
-		bix.prot_buf = prot_buf;
-		bix.sector = sector;
-
-		ret = bi->verify_fn(&bix);
-
-		if (ret) {
-			kunmap_atomic(kaddr);
-			return ret;
-		}
-
-		sectors = bv->bv_len / bi->sector_size;
-		sector += sectors;
-		prot_buf += sectors * bi->tuple_size;
-
-		kunmap_atomic(kaddr);
-	}
-
-	return ret;
-=======
 	return bio_integrity_generate_verify(bio, 0);
->>>>>>> linux-next/akpm-base
 }
 
 /**
diff -puN kernel/cpuset.c~linux-next-git-rejects kernel/cpuset.c
--- a/kernel/cpuset.c~linux-next-git-rejects
+++ a/kernel/cpuset.c
@@ -2413,11 +2413,7 @@ int __cpuset_node_allowed_softwall(int n
 	rcu_read_lock();
 	cs = nearest_hardwall_ancestor(task_cs(current));
 	allowed = node_isset(node, cs->mems_allowed);
-<<<<<<< HEAD
-	task_unlock(current);
-=======
 	rcu_read_unlock();
->>>>>>> linux-next/akpm-base
 
 	mutex_unlock(&callback_mutex);
 	return allowed;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
revert-kallsyms-fix-absolute-addresses-for-kaslr.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

