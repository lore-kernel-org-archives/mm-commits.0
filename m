From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch removed from -mm
 tree
Date: Thu, 07 Jan 2016 15:48:53 -0800
Message-ID: <568ef965.6HBSY+wwNMIFQrtk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbcAGXsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix
has been removed from the -mm tree.  Its filename was
     mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch

This patch was dropped because it was folded into mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch

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

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
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
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

