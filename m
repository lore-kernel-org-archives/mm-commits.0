From: akpm@linux-foundation.org
Subject: + vmscan-limit-vm_exec-protection-to-file-pages.patch added to -mm tree
Date: Tue, 13 Oct 2009 10:38:12 -0700
Message-ID: <200910131738.n9DHcCrp020947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760754AbZJMRjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 13:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, borntraeger@de.ibm.com, hugh.dickins@tiscali.co.uk, riel@redhat.com


The patch titled
     vmscan: limit VM_EXEC protection to file pages
has been added to the -mm tree.  Its filename is
     vmscan-limit-vm_exec-protection-to-file-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: limit VM_EXEC protection to file pages
From: Wu Fengguang <fengguang.wu@intel.com>

It is possible to have !Anon but SwapBacked pages, and some apps could
create huge number of such pages with MAP_SHARED|MAP_ANONYMOUS.  These
pages go into the ANON lru list, and hence shall not be protected: we only
care mapped executable files.  Failing to do so may trigger OOM.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/vmscan.c~vmscan-limit-vm_exec-protection-to-file-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-limit-vm_exec-protection-to-file-pages
+++ a/mm/vmscan.c
@@ -1356,7 +1356,7 @@ static void shrink_active_list(unsigned 
 			 * IO, plus JVM can create lots of anon VM_EXEC pages,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
+			if ((vm_flags & VM_EXEC) && page_is_file_cache(page)) {
 				list_add(&page->lru, &l_active);
 				continue;
 			}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
vmscan-limit-vm_exec-protection-to-file-pages.patch
readahead-add-blk_run_backing_dev.patch
page-types-constify-read-only-arrays.patch
page-types-trivial-typo-fixes.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

