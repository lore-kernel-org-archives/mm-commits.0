From: akpm@linux-foundation.org
Subject: +
 mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2.patch added to -mm tree
Date: Fri, 12 Sep 2014 17:07:51 -0700
Message-ID: <54138ad7.ChmeCv7yc9yF0Fwo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIMAHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 20:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2 include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2
+++ a/include/linux/balloon_compaction.h
@@ -258,6 +258,11 @@ static inline void balloon_page_delete(s
 	list_del(&page->lru);
 }
 
+static inline bool __is_movable_balloon_page(struct page *page)
+{
+	return false;
+}
+
 static inline bool balloon_page_movable(struct page *page)
 {
 	return false;
@@ -293,11 +298,5 @@ static inline bool balloon_compaction_ch
 {
 	return false;
 }
-
-static inline bool __is_movable_balloon_page(struct page *page)
-{
-	return false;
-}
