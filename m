Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE68C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72B3610FC
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347953AbhIBWCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ACA0610E6;
        Thu,  2 Sep 2021 22:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620069;
        bh=50SmS36AsJlM2rruHqoFR/e0nC1Urx/6JTqVV1IaHxA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lDvdCuQ7k8uVgIpzjC/xxqnmzdQT6aKkruwhEAbHjyJc2pTv1wNb4JY+W+AnTyq0G
         5PtgFDrnYF7ZlodjQRx0EBXi1s3P5MT/OIER5VffKF5TdgW7Ynl5m59Zl/Ej/Mdm7h
         Y9mPQaTqQd4iF+6PBqdo2pRWXChAyAyHBaWNg+Bo=
Date:   Thu, 02 Sep 2021 15:01:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 211/212] mm/vmstat: remove unneeded return value
Message-ID: <20210902220108.NK_Han4Vh%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
