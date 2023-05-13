Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F82FC77B7F
	for <mm-commits@archiver.kernel.org>; Sat, 13 May 2023 00:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbjEMAKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 20:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjEMAKh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 20:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998381BE6
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 17:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C19963AB8
        for <mm-commits@vger.kernel.org>; Sat, 13 May 2023 00:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B20DC433D2;
        Sat, 13 May 2023 00:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683936635;
        bh=7+XLpVd7tPfumuT2K+NPAr+0sODYyDbLkUjzXRrHTE0=;
        h=Date:To:From:Subject:From;
        b=C4m3XMh9QyNIXoUyhgNAmD0kyHfKzJrFYIo+kvGS9C7XOEFMSW8jv8Q9DhQgAi7IY
         WyAa98P+XqrkoNtmzccSMTXw08WlEqjrOuMX6bBh1xYL4h51UA69F6ZVmCUDCkkkPu
         ZHj+66dObtfJCHbYzGGYhxz5gBTEC5MLxf+azV3A=
Date:   Fri, 12 May 2023 17:10:34 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch added to mm-unstable branch
Message-Id: <20230513001035.7B20DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_failure: move memory_failure_attr_group under MEMORY_FAILURE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -3600,6 +3600,10 @@ extern void shake_page(struct page *p);
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
@@ -3692,11 +3696,6 @@ enum mf_action_page_type {
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

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch

