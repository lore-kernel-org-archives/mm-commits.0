From: akpm@linux-foundation.org
Subject: + mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch added to -mm tree
Date: Mon, 30 Nov 2015 16:26:49 -0800
Message-ID: <565ce949.ktwQ9St0BLcFvvI4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbLAA0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 19:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix
has been added to the -mm tree.  Its filename is
     mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix

Don't print opening parenthesis twice.

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/debug.c~mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix mm/debug.c
--- a/mm/debug.c~mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix
+++ a/mm/debug.c
@@ -240,7 +240,7 @@ void dump_mm(const struct mm_struct *mm)
 		""		/* This is here to not have a comma! */
 		);
 
-	pr_emerg("def_flags: %#lx(", mm->def_flags);
+	pr_emerg("def_flags: %#lx", mm->def_flags);
 	dump_flag_names(mm->def_flags, vmaflags_names,
 					ARRAY_SIZE(vmaflags_names));
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-track-and-print-last-migrate-reason-fix.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

