From: akpm@linux-foundation.org
Subject: + mm-use-radix_tree_iter_retry-fix.patch added to -mm tree
Date: Mon, 01 Feb 2016 14:41:55 -0800
Message-ID: <56afdf33.8BeZ4CVSOhDQ6nwW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbcBAWl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 17:41:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-radix_tree_iter_retry-fix
has been added to the -mm tree.  Its filename is
     mm-use-radix_tree_iter_retry-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-radix_tree_iter_retry-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-radix_tree_iter_retry-fix.patch

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
Subject: mm-use-radix_tree_iter_retry-fix

Remove now-obsolete-and-misleading comment.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Matthwe Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/shmem.c~mm-use-radix_tree_iter_retry-fix mm/shmem.c
--- a/mm/shmem.c~mm-use-radix_tree_iter_retry-fix
+++ a/mm/shmem.c
@@ -383,11 +383,6 @@ restart:
 
 		page = radix_tree_deref_slot(slot);
 
-		/*
-		 * This should only be possible to happen at index 0, so we
-		 * don't need to reset the counter, nor do we risk infinite
-		 * restarts.
-		 */
 		if (radix_tree_deref_retry(page)) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-use-radix_tree_iter_retry-fix.patch

