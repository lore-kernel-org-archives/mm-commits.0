Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7899C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A726113D
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbhICVAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350144AbhICVAw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83AAA61107;
        Fri,  3 Sep 2021 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702791;
        bh=PdFktuLSTamnbJoQAnaXc02F0YEY8SeP9EK1P87K9xc=;
        h=Date:From:To:Subject:From;
        b=ay/RVe9BDtQCC8wNighWLBk4MHVUXFWpD6yJU32RQh/IUsgS8b9uZjDtb6u25M/kI
         GZdhgT1gfuTGAHq0JdrYkE7otuKzGZjSxIpzn2XEm8f97OSfZSHTVlNGu0EheIpviV
         6PICzQkLbOuBnWSgUtmBY5zaIxPYym7TYrG15rgA=
Date:   Fri, 03 Sep 2021 13:59:51 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged] mm-hwpoison-fix-some-obsolete-comments.patch
 removed from -mm tree
Message-ID: <20210903205951.dF5xFH2V4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix some obsolete comments
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-some-obsolete-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: fix some obsolete comments

Since commit cb731d6c62bb ("vmscan: per memory cgroup slab shrinkers"),
shrink_node_slabs is renamed to drop_slab_node.  And doit argument is
changed to forcekill since commit 6751ed65dc66 ("x86/mce: Fix
siginfo_t->si_addr value for non-recoverable memory faults").

Link: https://lkml.kernel.org/r/20210814105131.48814-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-some-obsolete-comments
+++ a/mm/memory-failure.c
@@ -296,7 +296,7 @@ void shake_page(struct page *p, int acce
 	}
 
 	/*
-	 * Only call shrink_node_slabs here (which would also shrink
+	 * Only call drop_slab_node here (which would also shrink
 	 * other caches) if access is not potentially fatal.
 	 */
 	if (access)
@@ -391,8 +391,8 @@ static void add_to_kill(struct task_stru
 /*
  * Kill the processes that have been collected earlier.
  *
- * Only do anything when DOIT is set, otherwise just free the list
- * (this is used for clean pages which do not need killing)
+ * Only do anything when FORCEKILL is set, otherwise just free the
+ * list (this is used for clean pages which do not need killing)
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

