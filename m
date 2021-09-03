Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456E0C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3100B610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhICVCu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhICVCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D54060E8B;
        Fri,  3 Sep 2021 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702906;
        bh=4L3i9giC1VcFBPJSVxWfElC7NpbChkk3APBHdt6hTOU=;
        h=Date:From:To:Subject:From;
        b=TujU0TU8TXe6o7Cv4030Hz3+At4gu4xUi5gpgqwoq9efuGB3TRX7KbtIpYfdUBsVw
         Jk466cGR8ZAz3av9Rip+6KlMh0PX1QYHIUtUtR38BDxIK9s2A1ltJIJd54wVzR9qsY
         PEPGJNxPmtH0suY77rL2KsDFMT6gCCSkrSgHGAU0=
Date:   Fri, 03 Sep 2021 14:01:46 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-vmstat-remove-unneeded-return-value.patch
 removed from -mm tree
Message-ID: <20210903210146.2OSv63qpv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: remove unneeded return value
has been removed from the -mm tree.  Its filename was
     mm-vmstat-remove-unneeded-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmstat: remove unneeded return value

The return value of pagetypeinfo_showfree and pagetypeinfo_showblockcount
are unused now.  Remove them.

Link: https://lkml.kernel.org/r/20210715122911.15700-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-remove-unneeded-return-value
+++ a/mm/vmstat.c
@@ -1454,7 +1454,7 @@ static void pagetypeinfo_showfree_print(
 }
 
 /* Print out the free pages at each order for each migatetype */
-static int pagetypeinfo_showfree(struct seq_file *m, void *arg)
+static void pagetypeinfo_showfree(struct seq_file *m, void *arg)
 {
 	int order;
 	pg_data_t *pgdat = (pg_data_t *)arg;
@@ -1466,8 +1466,6 @@ static int pagetypeinfo_showfree(struct
 	seq_putc(m, '\n');
 
 	walk_zones_in_node(m, pgdat, true, false, pagetypeinfo_showfree_print);
-
-	return 0;
 }
 
 static void pagetypeinfo_showblockcount_print(struct seq_file *m,
@@ -1503,7 +1501,7 @@ static void pagetypeinfo_showblockcount_
 }
 
 /* Print out the number of pageblocks for each migratetype */
-static int pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
+static void pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
 {
 	int mtype;
 	pg_data_t *pgdat = (pg_data_t *)arg;
@@ -1514,8 +1512,6 @@ static int pagetypeinfo_showblockcount(s
 	seq_putc(m, '\n');
 	walk_zones_in_node(m, pgdat, true, false,
 		pagetypeinfo_showblockcount_print);
-
-	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

