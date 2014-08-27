From: akpm@linux-foundation.org
Subject: +
 mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch added to -mm tree
Date: Wed, 27 Aug 2014 14:04:28 -0700
Message-ID: <53fe47dc.9KiPBurEuvRtDMXp%akpm__31069.2928419032$1409173502$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:48275 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201AbaH0VE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:04:29 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so144858oif.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:04:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: isolate balloon pages without lru_lock
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch

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
Subject: mm/balloon_compaction: isolate balloon pages without lru_lock

LRU-lock isn't required for balloon page isolation.  This check makes
migration of some ballooned pages mostly impossible because
isolate_migratepages_range() drops LRU lock periodically.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>	[v3.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-balloon_compaction-isolate-balloon-pages-without-lru_lock mm/compaction.c
--- a/mm/compaction.c~mm-balloon_compaction-isolate-balloon-pages-without-lru_lock
+++ a/mm/compaction.c
@@ -643,7 +643,7 @@ isolate_migratepages_block(struct compac
 		 */
 		if (!PageLRU(page)) {
 			if (unlikely(balloon_page_movable(page))) {
-				if (locked && balloon_page_isolate(page)) {
+				if (balloon_page_isolate(page)) {
 					/* Successfully isolated */
 					goto isolate_success;
 				}
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

mm-balloon_compaction-ignore-anonymous-pages.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch

