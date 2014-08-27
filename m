From: akpm@linux-foundation.org
Subject: +
 mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch added to -mm tree
Date: Wed, 27 Aug 2014 14:04:27 -0700
Message-ID: <53fe47db.5Ul9VDV9uKDlJyI6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58688 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935574AbaH0VE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:04:28 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so101567qap.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:04:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: keep ballooned pages away from normal migration path
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch

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
Subject: mm/balloon_compaction: keep ballooned pages away from normal migration path

Proper testing shows yet another problem in balloon migration: it works
only once for each page.  balloon_page_movable() check page flags and
page_count.  In __unmap_and_move page is locked, reference counter is
elevated, so balloon_page_movable() _always_ fails here.  As result in
__unmap_and_move() migration goes to the normal migration path.

Balloon ->migratepage() is so special, it returns
MIGRATEPAGE_BALLOON_SUCCESS instead of MIGRATEPAGE_SUCCESS.  After that in
move_to_new_page() successfully migrated page got NULL into its mapping
pointer and loses connectivity with balloon and ability for further
migration.

It's safe to use __is_movable_balloon_page here: page is isolated and pinned.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>	[v3.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path mm/migrate.c
--- a/mm/migrate.c~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path
+++ a/mm/migrate.c
@@ -873,7 +873,7 @@ static int __unmap_and_move(struct page
 		}
 	}
 
-	if (unlikely(balloon_page_movable(page))) {
+	if (unlikely(__is_movable_balloon_page(page))) {
 		/*
 		 * A ballooned page does not need any special attention from
 		 * physical to virtual reverse mapping procedures.
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

mm-balloon_compaction-ignore-anonymous-pages.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch

