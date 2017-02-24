From: akpm@linux-foundation.org
Subject: [patch 039/124] mm/migration: make isolate_movable_page() return
 int type
Date: Fri, 24 Feb 2017 14:57:29 -0800
Message-ID: <58b0ba59.iU4H/cXjUHu7f03r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdBXW5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, guohanjun@huawei.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/migration: make isolate_movable_page() return int type

Patch series "HWPOISON: soft offlining for non-lru movable page", v6.

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
will return 0 when isolate movable page successfully, and return -EBUSY
when it isolates failed.

There is no functional change within this patch but prepare for later
patch.

[xieyisheng1@huawei.com: v6]
  Link: http://lkml.kernel.org/r/1486108770-630-2-git-send-email-xieyisheng1@huawei.com
Link: http://lkml.kernel.org/r/1485867981-16037-2-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
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
 mm/migrate.c            |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

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
@@ -74,7 +74,7 @@ int migrate_prep_local(void)
 	return 0;
 }
 
-bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+int isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
 	struct address_space *mapping;
 
@@ -125,14 +125,14 @@ bool isolate_movable_page(struct page *p
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
+	return -EBUSY;
 }
 
 /* It should be called on page which is PG_movable */
_
