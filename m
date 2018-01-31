From: akpm@linux-foundation.org
Subject: +
 ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch added to -mm tree
Date: Wed, 31 Jan 2018 12:01:20 -0800
Message-ID: <5a722090.2nYS2yD02ylrEZUq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751326AbeAaUBW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 15:01:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, john@nixnuts.net, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix
has been added to the -mm tree.  Its filename is
     ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch

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
Subject: ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix

brelse(NULL) is legal

Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Lightsey <john@nixnuts.net>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix
+++ a/fs/ocfs2/alloc.c
@@ -6757,10 +6757,8 @@ static int ocfs2_reuse_blk_from_dealloc(
 
 bail:
 	if (unlikely(status < 0)) {
-		for (i = 0; i < blk_wanted; i++) {
-			if (new_eb_bh[i])
-				brelse(new_eb_bh[i]);
-		}
+		for (i = 0; i < blk_wanted; i++)
+			brelse(new_eb_bh[i]);
 	}
 
 	return status;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

