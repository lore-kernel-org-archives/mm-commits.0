From: akpm@linux-foundation.org
Subject: + mm-migration-make-isolate_movable_page-always-defined.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 14:52:58 -0800
Message-ID: <5891154a.fyFgN6FWceOxC7Id%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdAaWxB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, guohanjun@huawei.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: make isolate_movable_page always defined
has been added to the -mm tree.  Its filename is
     mm-migration-make-isolate_movable_page-always-defined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migration-make-isolate_movable_page-always-defined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-make-isolate_movable_page-always-defined.patch

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
Subject: mm/migration: make isolate_movable_page always defined

Define isolate_movable_page as a static inline function when
CONFIG_MIGRATION is not enable.  It should return -EBUSY here which means
failed to isolate movable pages.

This patch do not have any functional change but prepare for later patch.

Link: http://lkml.kernel.org/r/1485867981-16037-3-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/migrate.h~mm-migration-make-isolate_movable_page-always-defined include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migration-make-isolate_movable_page-always-defined
+++ a/include/linux/migrate.h
@@ -56,6 +56,8 @@ static inline int migrate_pages(struct l
 		free_page_t free, unsigned long private, enum migrate_mode mode,
 		int reason)
 	{ return -ENOSYS; }
+static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
+	{ return -EBUSY; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-migration-make-isolate_movable_page-return-int-type.patch
mm-migration-make-isolate_movable_page-always-defined.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages.patch

