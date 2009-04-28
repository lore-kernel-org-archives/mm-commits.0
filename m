From: akpm@linux-foundation.org
Subject: + pagemap-document-clarifications.patch added to -mm tree
Date: Tue, 28 Apr 2009 14:32:53 -0700
Message-ID: <200904282132.n3SLWrN7022708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbZD1Vhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 17:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com


The patch titled
     pagemap: document clarifications
has been added to the -mm tree.  Its filename is
     pagemap-document-clarifications.patch

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
Subject: pagemap: document clarifications
From: Wu Fengguang <fengguang.wu@intel.com>

Some bit ranges were inclusive and some not.  Fix them to be consistently
inclusive.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-document-clarifications Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-document-clarifications
+++ a/Documentation/vm/pagemap.txt
@@ -12,9 +12,9 @@ There are three components to pagemap:
    value for each virtual page, containing the following data (from
    fs/proc/task_mmu.c, above pagemap_read):
 
-    * Bits 0-55  page frame number (PFN) if present
+    * Bits 0-54  page frame number (PFN) if present
     * Bits 0-4   swap type if swapped
-    * Bits 5-55  swap offset if swapped
+    * Bits 5-54  swap offset if swapped
     * Bits 55-60 page shift (page size = 1<<page shift)
     * Bit  61    reserved for future use
     * Bit  62    page swapped
@@ -36,7 +36,7 @@ There are three components to pagemap:
  * /proc/kpageflags.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
-   The flags are (from fs/proc/proc_misc, above kpageflags_read):
+   The flags are (from fs/proc/page.c, above kpageflags_read):
 
      0. LOCKED
      1. ERROR
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch

