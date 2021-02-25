Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49CBC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D3E564F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhBYTbB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234619AbhBYT2A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:28:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF8A64F94;
        Thu, 25 Feb 2021 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280596;
        bh=WO5uaZtCQ8og/Bet+BInMKkliCM/aun7Btn5C9t/s8E=;
        h=Date:From:To:Subject:From;
        b=vqc+DnaYFlwsAzW2KQ1yIxb3RxX0pwq40Ds3x11tLaMokqh1Oi6yG8srj0vBMyvo3
         WtSkT+clIu2s3b1TuZ8o6SjrogUyeD2Cw0URzQ5ZnVvclGDsKJkBXEK6r6rTnA6ldz
         9w5H/eWq892M2tFuSi3jMxz8yUB41PtkUmOfonEY=
Date:   Thu, 25 Feb 2021 11:16:35 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, smuchun@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-fix-potential-double-free-in-hugetlb=5Fregist?=
 =?US-ASCII?Q?er=5Fnode-error-path.patch?= removed from -mm tree
Message-ID: <20210225191635.mYASrx18k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix potential double free in hugetlb_register_node() error path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential double free in hugetlb_register_node() error path

In hugetlb_sysfs_add_hstate(), we would do kobject_put() on hstate_kobjs
when failed to create sysfs group but forget to set hstate_kobjs to NULL. 
Then in hugetlb_register_node() error path, we may free it again via
hugetlb_unregister_node().

Link: https://lkml.kernel.org/r/20210107123249.36964-1-linmiaohe@huawei.com
Fixes: a3437870160c ("hugetlb: new sysfs interface")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <smuchun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path
+++ a/mm/hugetlb.c
@@ -2988,8 +2988,10 @@ static int hugetlb_sysfs_add_hstate(stru
 		return -ENOMEM;
 
 	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
-	if (retval)
+	if (retval) {
 		kobject_put(hstate_kobjs[hi]);
+		hstate_kobjs[hi] = NULL;
+	}
 
 	return retval;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

