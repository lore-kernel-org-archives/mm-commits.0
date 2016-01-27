From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch added to -mm tree
Date: Wed, 27 Jan 2016 12:07:31 -0800
Message-ID: <56a92383.E4kAiEMw9om2peol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965755AbcA0UHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:07:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch

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
Subject: ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix

tweak comment

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: xuejiufei <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -213,8 +213,8 @@ grant:
 		memcpy(res->lvb, lock->lksb->lvb, DLM_LVB_LEN);
 
 	/*
-	 * move the lock to tail because it may be the only lock who has
-	 * a invalid lvb.
+	 * Move the lock to the tail because it may be the only lock which has
+	 * an invalid lvb.
 	 */
 	list_move_tail(&lock->list, &res->granted);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

