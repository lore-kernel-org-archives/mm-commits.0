From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 09 Jul 2013 14:04:04 -0700
Message-ID: <51dc7ac4.KpoXREXJjAlHR44L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GIVEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 17:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 14:04:04 -0700


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

 drivers/block/rbd.c   |   13 -------------
 net/ceph/osd_client.c |    6 ------
 2 files changed, 19 deletions(-)

diff -puN drivers/block/rbd.c~linux-next-git-rejects drivers/block/rbd.c
--- a/drivers/block/rbd.c~linux-next-git-rejects
+++ a/drivers/block/rbd.c
@@ -5165,7 +5165,6 @@ static ssize_t rbd_remove(struct bus_typ
 			ret = 0;
 			break;
 		}
-<<<<<<< HEAD
 	}
 	if (!ret) {
 		spin_lock_irq(&rbd_dev->lock);
@@ -5176,18 +5175,6 @@ static ssize_t rbd_remove(struct bus_typ
 							&rbd_dev->flags);
 		spin_unlock_irq(&rbd_dev->lock);
 	}
-=======
-	}
-	if (!ret) {
-		spin_lock_irq(&rbd_dev->lock);
-		if (rbd_dev->open_count)
-			ret = -EBUSY;
-		else
-			already = test_and_set_bit(RBD_DEV_FLAG_REMOVING,
-							&rbd_dev->flags);
-		spin_unlock_irq(&rbd_dev->lock);
-	}
->>>>>>> linux-next/akpm-base
 	spin_unlock(&rbd_dev_list_lock);
 	if (ret < 0 || already)
 		return ret;
diff -puN net/ceph/osd_client.c~linux-next-git-rejects net/ceph/osd_client.c
--- a/net/ceph/osd_client.c~linux-next-git-rejects
+++ a/net/ceph/osd_client.c
@@ -1553,12 +1553,6 @@ static void handle_reply(struct ceph_osd
 	mutex_unlock(&osdc->request_mutex);
 
 	if (!already_completed) {
-<<<<<<< HEAD
-		if (req->r_unsafe_callback &&
-		    result >= 0 && !(flags & CEPH_OSD_FLAG_ONDISK))
-			req->r_unsafe_callback(req, true);
-=======
->>>>>>> linux-next/akpm-base
 		if (req->r_callback)
 			req->r_callback(req, msg);
 		else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

