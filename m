From: akpm@linux-foundation.org
Subject: [patch 040/124] mm/migration: make isolate_movable_page always
 defined
Date: Fri, 24 Feb 2017 14:57:32 -0800
Message-ID: <58b0ba5c.oLxe/CVaVx7tK/1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdBXW5e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, guohanjun@huawei.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com

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
