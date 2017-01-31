From: akpm@linux-foundation.org
Subject: + mm-migration-make-isolate_movable_page-return-int-type.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 14:52:55 -0800
Message-ID: <58911547.Ad9QOHucLqe6vHzW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdAaWw5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:52:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, guohanjun@huawei.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: make isolate_movable_page() return int type
has been added to the -mm tree.  Its filename is
     mm-migration-make-isolate_movable_page-return-int-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migration-make-isolate_movable_page-return-int-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-make-isolate_movable_page-return-int-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/migration: make isolate_movable_page() return int type

Patch series "HWPOISON: soft offlining for non-lru movable page", v5.

After Minchan's commit bda807d44454 ("mm: migrate: support non-lru movable
page migration"), some type of non-lru page like zsmalloc and
virtio-balloon page also support migration.

Therefore, we can:

1) soft offlining no-lru movable pages, which means when memory
   corrected errors occur on a non-lru movable page, we can stop to use it
   by migrating data onto another page and disable the original (maybe
   half-broken) one.

2) enable memory hotplug for non-lru movable pages, i.e.  we may
   offline blocks, which include such pages, by using non-lru page
   migration.

This patchset is heavily dependent on non-lru movable page migration.


This patch (of 4):

Change the return type of isolate_movable_page() from bool to int.  It
will return 0 when isolate movable page successfully, return -EINVAL when
the page is not a non-lru movable page, and for other cases it will return
-EBUSY.

There is no functional change within this patch but prepare for later
patch.

Link: http://lkml.kernel.org/r/1485867981-16037-2-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 mm/compaction.c         |    2 +-
 mm/migrate.c            |   11 +++++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/migrate.h~mm-migration-make-isolate_movable_page-return-int-type include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migration-make-isolate_movable_page-return-int-type
+++ a/include/linux/migrate.h
@@ -37,7 +37,7 @@ extern int migrate_page(struct address_s
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
-extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 extern void putback_movable_page(struct page *page);
 
 extern int migrate_prep(void);
diff -puN mm/compaction.c~mm-migration-make-isolate_movable_page-return-int-type mm/compaction.c
--- a/mm/compaction.c~mm-migration-make-isolate_movable_page-return-int-type
+++ a/mm/compaction.c
@@ -802,7 +802,7 @@ isolate_migratepages_block(struct compac
 					locked = false;
 				}
 
-				if (isolate_movable_page(page, isolate_mode))
+				if (!isolate_movable_page(page, isolate_mode))
 					goto isolate_success;
 			}
 
diff -puN mm/migrate.c~mm-migration-make-isolate_movable_page-return-int-type mm/migrate.c
--- a/mm/migrate.c~mm-migration-make-isolate_movable_page-return-int-type
+++ a/mm/migrate.c
@@ -74,8 +74,9 @@ int migrate_prep_local(void)
 	return 0;
 }
 
-bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+int isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
+	int ret = -EBUSY;
 	struct address_space *mapping;
 
 	/*
@@ -95,8 +96,10 @@ bool isolate_movable_page(struct page *p
 	 * assumes anybody doesn't touch PG_lock of newly allocated page
 	 * so unconditionally grapping the lock ruins page's owner side.
 	 */
-	if (unlikely(!__PageMovable(page)))
+	if (unlikely(!__PageMovable(page))) {
+		ret = -EINVAL;
 		goto out_putpage;
+	}
 	/*
 	 * As movable pages are not isolated from LRU lists, concurrent
 	 * compaction threads can race against page migration functions
@@ -125,14 +128,14 @@ bool isolate_movable_page(struct page *p
 	__SetPageIsolated(page);
 	unlock_page(page);
 
-	return true;
+	return 0;
 
 out_no_isolated:
 	unlock_page(page);
 out_putpage:
 	put_page(page);
 out:
-	return false;
+	return ret;
 }
 
 /* It should be called on page which is PG_movable */
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-migration-make-isolate_movable_page-return-int-type.patch
mm-migration-make-isolate_movable_page-always-defined.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages.patch

