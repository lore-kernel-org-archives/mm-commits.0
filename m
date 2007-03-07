From: akpm@linux-foundation.org
Subject: + mm-debug-check-for-the-fault-vs-invalidate-race.patch added to -mm tree
Date: Tue, 06 Mar 2007 22:16:53 -0800
Message-ID: <200703070616.l276Grtg021388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbXCGGQ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 01:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: debug check for the fault vs invalidate race
has been added to the -mm tree.  Its filename is
     mm-debug-check-for-the-fault-vs-invalidate-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: debug check for the fault vs invalidate race
From: Nick Piggin <npiggin@suse.de>

Add a bugcheck for Andrea's pagefault vs invalidate race.  This is triggerable
for both linear and nonlinear pages with a userspace test harness (using
direct IO and truncate, respectively).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/filemap.c~mm-debug-check-for-the-fault-vs-invalidate-race mm/filemap.c
--- a/mm/filemap.c~mm-debug-check-for-the-fault-vs-invalidate-race
+++ a/mm/filemap.c
@@ -120,6 +120,8 @@ void __remove_from_page_cache(struct pag
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
+
+	BUG_ON(page_mapped(page));
 }
 
 void remove_from_page_cache(struct page *page)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
exec-fix-remove_arg_zero.patch
