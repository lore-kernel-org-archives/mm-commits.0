Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8521C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjFIX2G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjFIX1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CF13A81
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC24065CD7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE06C433D2;
        Fri,  9 Jun 2023 23:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353243;
        bh=s3L5VJeuHvCo8A0+EA8Et1upWiV9CQDQzmmO6KtDvq4=;
        h=Date:To:From:Subject:From;
        b=oN4Zyk7N0rWdNe2nsGnbtKvLPptqq+629I2gYe0ZcU/vUl9A/JZAqqbf3R/c8CmL8
         uIEOAiUnBNRzhLwktY7ozOHIB972yDDA0uIdnd4jfs87s/6UnAaITy/RYEHipAzmQy
         TbFsdVS2tJV+7N+rupm5Zc6KHAA1GGOak0RXnBwM=
Date:   Fri, 09 Jun 2023 16:27:22 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch removed from -mm tree
Message-Id: <20230609232723.0EE06C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory_failure: move memory_failure_attr_group under MEMORY_FAILURE
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory_failure: move memory_failure_attr_group under MEMORY_FAILURE
Date: Mon, 8 May 2023 19:41:27 +0800

The memory_failure_attr_group is only called if MEMORY_FAILURE enabled,
move it under this configuration.

Link: https://lkml.kernel.org/r/20230508114128.37081-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-memory_failure-move-memory_failure_attr_group-under-memory_failure
+++ a/include/linux/mm.h
@@ -3586,6 +3586,10 @@ extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Sysfs entries for memory failure handling statistics.
+ */
+extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
@@ -3678,11 +3682,6 @@ enum mf_action_page_type {
 	MF_MSG_UNKNOWN,
 };
 
-/*
- * Sysfs entries for memory failure handling statistics.
- */
-extern const struct attribute_group memory_failure_attr_group;
-
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr_hint,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


