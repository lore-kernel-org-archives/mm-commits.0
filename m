From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 10 Jun 2016 12:11:51 -0700
Message-ID: <575b10f7.pW7Dhb/mmTj0jg9F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbcFJTLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 15:11:52 -0400
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

 kernel/locking/qspinlock.c |    3 ---
 net/sched/cls_u32.c        |    9 ---------
 2 files changed, 12 deletions(-)

diff -puN kernel/locking/qspinlock.c~linux-next-git-rejects kernel/locking/qspinlock.c
--- a/kernel/locking/qspinlock.c~linux-next-git-rejects
+++ a/kernel/locking/qspinlock.c
@@ -268,8 +268,6 @@ static __always_inline u32  __pv_wait_he
 #endif
 
 /*
-<<<<<<< HEAD
-=======
  * Various notes on spin_is_locked() and spin_unlock_wait(), which are
  * 'interesting' functions:
  *
@@ -327,7 +325,6 @@ static __always_inline u32  __pv_wait_he
  */
 
 /*
->>>>>>> linux-next/akpm-base
  * queued_spin_lock_slowpath() can (load-)ACQUIRE the lock before
  * issuing an _unordered_ store to set _Q_LOCKED_VAL.
  *
diff -puN net/sched/cls_u32.c~linux-next-git-rejects net/sched/cls_u32.c
--- a/net/sched/cls_u32.c~linux-next-git-rejects
+++ a/net/sched/cls_u32.c
@@ -508,19 +508,10 @@ static int u32_replace_hw_knode(struct t
 	offload.type = TC_SETUP_CLSU32;
 	offload.cls_u32 = &u32_offload;
 
-<<<<<<< HEAD
-	if (!tc_should_offload(dev, tp, flags))
-		return tc_skip_sw(flags) ? -EINVAL : 0;
-
-	offload.cls_u32->command = TC_CLSU32_REPLACE_KNODE;
-	offload.cls_u32->knode.handle = n->handle;
-	offload.cls_u32->knode.fshift = n->fshift;
-=======
 	if (tc_should_offload(dev, tp, flags)) {
 		offload.cls_u32->command = TC_CLSU32_REPLACE_KNODE;
 		offload.cls_u32->knode.handle = n->handle;
 		offload.cls_u32->knode.fshift = n->fshift;
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_CLS_U32_MARK
 	offload.cls_u32->knode.val = n->val;
 	offload.cls_u32->knode.mask = n->mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

