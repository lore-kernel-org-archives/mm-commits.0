From: akpm@linux-foundation.org
Subject: + mm-speculative-page-references-fix-fix.patch added to -mm tree
Date: Mon, 09 Jun 2008 21:06:35 -0700
Message-ID: <200806100406.m5A46Zno024491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYFJEHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 00:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, hugh@veritas.com, jeff@garzik.org, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     mm-speculative-page-references-fix-fix
has been added to the -mm tree.  Its filename is
     mm-speculative-page-references-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-speculative-page-references-fix-fix
From: Nick Piggin <nickpiggin@yahoo.com.au>

free_it obviously should be below the unlock_page.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-speculative-page-references-fix-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-speculative-page-references-fix-fix
+++ a/mm/vmscan.c
@@ -391,7 +391,7 @@ static pageout_t pageout(struct page *pa
 }
 
 /*
- * Save as remove_mapping, but if the page is removed from the mapping, it
+ * Same as remove_mapping, but if the page is removed from the mapping, it
  * gets returned with a refcount of 0.
  */
 static int __remove_mapping(struct address_space *mapping, struct page *page)
@@ -619,6 +619,13 @@ static unsigned long shrink_page_list(st
 				if (put_page_testzero(page))
 					goto free_it;
 				else {
+					/*
+					 * rare race with speculative reference.
+					 * the speculative reference will free
+					 * this page shortly, so we may
+					 * increment nr_reclaimed here (and
+					 * leave it off the LRU).
+					 */
 					nr_reclaimed++;
 					continue;
 				}
@@ -628,8 +635,8 @@ static unsigned long shrink_page_list(st
 		if (!mapping || !__remove_mapping(mapping, page))
 			goto keep_locked;
 
-free_it:
 		unlock_page(page);
+free_it:
 		nr_reclaimed++;
 		if (!pagevec_add(&freed_pvec, page)) {
 			__pagevec_free(&freed_pvec);
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

git-unionfs.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
generic_file_aio_read-cleanups.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
mm-speculative-page-references-fix-fix.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

