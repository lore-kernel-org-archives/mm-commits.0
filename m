From: akpm@linux-foundation.org
Subject: + mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch added to -mm tree
Date: Fri, 22 Apr 2011 13:15:56 -0700
Message-ID: <201104222015.p3MKFuun029722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256Ab1DVUQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 16:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mem-hwpoison: fix page refcount around isolate_lru_page()
has been added to the -mm tree.  Its filename is
     mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch

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
Subject: mem-hwpoison: fix page refcount around isolate_lru_page()
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Drop first page reference only after calling isolate_lru_page() to keep
page stable reference while isolating.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memory-failure.c~mem-hwpoison-fix-page-refcount-around-isolate_lru_page mm/memory-failure.c
--- a/mm/memory-failure.c~mem-hwpoison-fix-page-refcount-around-isolate_lru_page
+++ a/mm/memory-failure.c
@@ -1440,16 +1440,12 @@ int soft_offline_page(struct page *page,
 	 */
 	ret = invalidate_inode_page(page);
 	unlock_page(page);
-
 	/*
-	 * Drop count because page migration doesn't like raised
-	 * counts. The page could get re-allocated, but if it becomes
-	 * LRU the isolation will just fail.
 	 * RED-PEN would be better to keep it isolated here, but we
 	 * would need to fix isolation locking first.
 	 */
-	put_page(page);
 	if (ret == 1) {
+		put_page(page);
 		ret = 0;
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		goto done;
@@ -1461,6 +1457,11 @@ int soft_offline_page(struct page *page,
 	 * handles a large number of cases for us.
 	 */
 	ret = isolate_lru_page(page);
+	/*
+	 * Drop page reference which is came from get_any_page()
+	 * successful isolate_lru_page() already took another one.
+	 */
+	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
tmpfs-fix-race-between-umount-and-writepage.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch

