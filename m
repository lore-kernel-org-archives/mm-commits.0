Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7130C636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF596613CA
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbhGOS5c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 14:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240404AbhGOS4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB575613D0;
        Thu, 15 Jul 2021 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626375241;
        bh=SSBa475UhIctf2pLuiBkgWP7ZzFwz93i7ul2SbsM188=;
        h=Date:From:To:Subject:From;
        b=xyRoz0MGxgkzp7Pjt9Ug6JJXeaizRiRTT4x7kpwpXStr8OPvQWRlTyCKRbhx7uOeq
         4AD1nB0HMSrAiX84eHPvUtauHltXr5kyg9Umi+Xv+8sViM0rXiAJw83nYP2KYo59g6
         jsd2KEVVrq+8B//DuGYetle5uuGTCqFqfJGLMC+I=
Date:   Thu, 15 Jul 2021 11:54:01 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-vmstat-remove-unneeded-return-value.patch added to
 -mm tree
Message-ID: <20210715185401.BTBVUxRf8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: remove unneeded return value
has been added to the -mm tree.  Its filename is
     mm-vmstat-remove-unneeded-return-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-remove-unneeded-return-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-remove-unneeded-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmstat: remove unneeded return value

The return value of pagetypeinfo_showfree and pagetypeinfo_showblockcount
are unused now.  Remove them.

Link: https://lkml.kernel.org/r/20210715122911.15700-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-remove-unneeded-return-value
+++ a/mm/vmstat.c
@@ -1452,7 +1452,7 @@ static void pagetypeinfo_showfree_print(
 }
 
 /* Print out the free pages at each order for each migatetype */
-static int pagetypeinfo_showfree(struct seq_file *m, void *arg)
+static void pagetypeinfo_showfree(struct seq_file *m, void *arg)
 {
 	int order;
 	pg_data_t *pgdat = (pg_data_t *)arg;
@@ -1464,8 +1464,6 @@ static int pagetypeinfo_showfree(struct
 	seq_putc(m, '\n');
 
 	walk_zones_in_node(m, pgdat, true, false, pagetypeinfo_showfree_print);
-
-	return 0;
 }
 
 static void pagetypeinfo_showblockcount_print(struct seq_file *m,
@@ -1501,7 +1499,7 @@ static void pagetypeinfo_showblockcount_
 }
 
 /* Print out the number of pageblocks for each migratetype */
-static int pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
+static void pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
 {
 	int mtype;
 	pg_data_t *pgdat = (pg_data_t *)arg;
@@ -1512,8 +1510,6 @@ static int pagetypeinfo_showblockcount(s
 	seq_putc(m, '\n');
 	walk_zones_in_node(m, pgdat, true, false,
 		pagetypeinfo_showblockcount_print);
-
-	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

