Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824C1C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D46B6500F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhCEBxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhCEBxn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:53:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 295F364F79;
        Fri,  5 Mar 2021 01:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614909223;
        bh=rwgXW95ozEPEQJN3OTQek7W6xS6V9OUXqnd/Ni0RykQ=;
        h=Date:From:To:Subject:From;
        b=RKM1RYRS/7E1t/UHR5ZL+mTmzeFc8+XZltIPxfOZ+RI4G38w+d4nWbH2t7cYJBDXT
         F2tOXH5mKKo2ibd9AGmJkmfJ3M8AO+octeePrG6l7qi3TTr1OYOtjJTFVhAFQcDLVu
         xqCztGiVwcFZelW0qxWJgNRDdGdRj3MJVauIwidE=
Date:   Thu, 04 Mar 2021 17:53:42 -0800
From:   akpm@linux-foundation.org
To:     chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        rui.xiang@huawei.com, shakeelb@google.com,
        wangkefeng.wang@huawei.com, zhouguanghui1@huawei.com,
        ziy@nvidia.com
Subject:  + mm-memcg-set-memcg-when-split-page.patch added to -mm
 tree
Message-ID: <20210305015342.vGara5H1P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: set memcg when split page
has been added to the -mm tree.  Its filename is
     mm-memcg-set-memcg-when-split-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-set-memcg-when-split-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-set-memcg-when-split-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Subject: mm/memcg: set memcg when split page

As described in the split_page function comment, for the non-compound high
order page, the sub-pages must be freed individually.  If the memcg of the
first page is valid, the tail pages cannot be uncharged when be freed.

For example, when alloc_pages_exact is used to allocate 1MB continuous
physical memory, 2MB is charged(kmemcg is enabled and __GFP_ACCOUNT is
set).  When make_alloc_exact free the unused 1MB and free_pages_exact free
the applied 1MB, actually, only 4KB(one page) is uncharged.

Therefore, the memcg of the tail page needs to be set when split page.

Link: https://lkml.kernel.org/r/20210304074053.65527-3-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-memcg-set-memcg-when-split-page
+++ a/mm/page_alloc.c
@@ -3314,6 +3314,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
+	split_page_memcg(page, 1 << order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
_

Patches currently in -mm which might be from zhouguanghui1@huawei.com are

mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch
mm-memcg-set-memcg-when-split-page.patch

