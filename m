From: akpm@linux-foundation.org
Subject: + readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch added to -mm tree
Date: Tue, 17 Jul 2007 23:58:13 -0700
Message-ID: <200707180702.l6I72cUq029457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbXGRHDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 03:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, wfg@mail.ustc.edu.cn


The patch titled
     readahead-split-ondemand-readahead-interface-into-two-functions-fix
has been added to the -mm tree.  Its filename is
     readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead-split-ondemand-readahead-interface-into-two-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

Not sure how this happened.  Please check?

Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~readahead-split-ondemand-readahead-interface-into-two-functions-fix mm/filemap.c
--- a/mm/filemap.c~readahead-split-ondemand-readahead-interface-into-two-functions-fix
+++ a/mm/filemap.c
@@ -1348,14 +1348,14 @@ retry_find:
 	 */
 	if (VM_SequentialReadHint(vma)) {
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_async_readahead(mapping, ra, file, page,
 							   vmf->pgoff, 1);
 			page = find_lock_page(mapping, vmf->pgoff);
 			if (!page)
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_async_readahead(mapping, ra, file, page,
 							   vmf->pgoff, 1);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
