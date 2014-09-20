From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch removed from -mm tree
Date: Fri, 19 Sep 2014 23:26:31 -0700
Message-ID: <541d1e17.EB/0cGy5Lo7xz8bj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaITG0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:26:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: keep ballooned pages away from normal migration path
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch

This patch was dropped because an updated version will be merged

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

[akpm@linux-foundation.org: fix CONFIG_BALLOON_COMPACTION=n build]
Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>	[v3.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    5 +++++
 mm/migrate.c                       |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

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
diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path
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
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch
linux-next.patch

