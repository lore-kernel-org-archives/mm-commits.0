From: akpm@linux-foundation.org
Subject: + mm-migration-make-isolate_movable_page-return-int-type-v6.patch added to -mm tree
Date: Fri, 03 Feb 2017 15:30:35 -0800
Message-ID: <5895129b.tB+YgySgKxdRq1wy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbdBCXag (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:30:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: make isolate_movable_page() return int type
has been added to the -mm tree.  Its filename is
     mm-migration-make-isolate_movable_page-return-int-type-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migration-make-isolate_movable_page-return-int-type-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-make-isolate_movable_page-return-int-type-v6.patch

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

Link: http://lkml.kernel.org/r/1486108770-630-2-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/migrate.c~mm-migration-make-isolate_movable_page-return-int-type-v6 mm/migrate.c
--- a/mm/migrate.c~mm-migration-make-isolate_movable_page-return-int-type-v6
+++ a/mm/migrate.c
@@ -76,7 +76,6 @@ int migrate_prep_local(void)
 
 int isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
-	int ret = -EBUSY;
 	struct address_space *mapping;
 
 	/*
@@ -96,10 +95,8 @@ int isolate_movable_page(struct page *pa
 	 * assumes anybody doesn't touch PG_lock of newly allocated page
 	 * so unconditionally grapping the lock ruins page's owner side.
 	 */
-	if (unlikely(!__PageMovable(page))) {
-		ret = -EINVAL;
+	if (unlikely(!__PageMovable(page)))
 		goto out_putpage;
-	}
 	/*
 	 * As movable pages are not isolated from LRU lists, concurrent
 	 * compaction threads can race against page migration functions
@@ -135,7 +132,7 @@ out_no_isolated:
 out_putpage:
 	put_page(page);
 out:
-	return ret;
+	return -EBUSY;
 }
 
 /* It should be called on page which is PG_movable */
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-migration-make-isolate_movable_page-return-int-type.patch
mm-migration-make-isolate_movable_page-return-int-type-v6.patch
mm-migration-make-isolate_movable_page-always-defined.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages.patch

