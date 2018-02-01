From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Thu, 01 Feb 2018 15:54:47 -0800
Message-ID: <5a73a8c7.HIrVCb/bpRD3mTua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbeBAXys (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 18:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/fork.c~linux-next-rejects kernel/fork.c
--- a/kernel/fork.c~linux-next-rejects
+++ a/kernel/fork.c
@@ -606,6 +606,11 @@ static void __mmdrop(struct mm_struct *m
 
 void mmdrop(struct mm_struct *mm)
 {
+	/*
+	 * The implicit full barrier implied by atomic_dec_and_test is
+	 * required by the membarrier system call before returning to
+	 * user-space, after storing to rq->curr.
+	 */
 	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
 		__mmdrop(mm);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-git-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

