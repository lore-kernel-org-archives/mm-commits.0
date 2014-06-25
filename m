From: akpm@linux-foundation.org
Subject: [merged] revert-block-add-__init-to-blkcg_policy_register.patch
 removed from -mm tree
Date: Wed, 25 Jun 2014 11:12:36 -0700
Message-ID: <53ab1114.4vOuBcHlEx2wdmDb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaFYSMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 14:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, axboe@kernel.dk, damien.wyart@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "block: add __init to blkcg_policy_register"
has been removed from the -mm tree.  Its filename was
     revert-block-add-__init-to-blkcg_policy_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: revert "block: add __init to blkcg_policy_register"

This reverts commit a2d445d44000 ("block: add __init to
blkcg_policy_register"").

Adding __init to blkcg_policy_register makes it unreliable when
loading cfq at runtime.

(Similar problem to b5097e956a4d ("block: add __init to elv_register")
reported by Damien Wyart).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Damien Wyart <damien.wyart@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-cgroup.c |    2 +-
 block/blk-cgroup.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN block/blk-cgroup.c~revert-block-add-__init-to-blkcg_policy_register block/blk-cgroup.c
--- a/block/blk-cgroup.c~revert-block-add-__init-to-blkcg_policy_register
+++ a/block/blk-cgroup.c
@@ -1093,7 +1093,7 @@ EXPORT_SYMBOL_GPL(blkcg_deactivate_polic
  * Register @pol with blkcg core.  Might sleep and @pol may be modified on
  * successful registration.  Returns 0 on success and -errno on failure.
  */
-int __init blkcg_policy_register(struct blkcg_policy *pol)
+int blkcg_policy_register(struct blkcg_policy *pol)
 {
 	int i, ret;
 
diff -puN block/blk-cgroup.h~revert-block-add-__init-to-blkcg_policy_register block/blk-cgroup.h
--- a/block/blk-cgroup.h~revert-block-add-__init-to-blkcg_policy_register
+++ a/block/blk-cgroup.h
@@ -145,7 +145,7 @@ void blkcg_drain_queue(struct request_qu
 void blkcg_exit_queue(struct request_queue *q);
 
 /* Blkio controller policy registration */
-int __init blkcg_policy_register(struct blkcg_policy *pol);
+int blkcg_policy_register(struct blkcg_policy *pol);
 void blkcg_policy_unregister(struct blkcg_policy *pol);
 int blkcg_activate_policy(struct request_queue *q,
 			  const struct blkcg_policy *pol);
@@ -580,7 +580,7 @@ static inline struct blkcg_gq *blkg_look
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_drain_queue(struct request_queue *q) { }
 static inline void blkcg_exit_queue(struct request_queue *q) { }
-static inline int __init blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
+static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct request_queue *q,
 					const struct blkcg_policy *pol) { return 0; }
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

