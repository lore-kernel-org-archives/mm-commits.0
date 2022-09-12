Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD72CECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiILDfy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiILDdt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0D42A260
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A2BF61171
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E060AC433C1;
        Mon, 12 Sep 2022 03:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953442;
        bh=UjJYSPSg/o7nDuMy7VzCrU0XpWzfikvZeyR/UYezgZo=;
        h=Date:To:From:Subject:From;
        b=kAHyzGbCTHNLu173SmOUdN0QfCqoIQZTzE2dXHwkY3G+NvNzdHph6KAqmKwUVDFwo
         sDroLXtfAZEkHUl8rq3St5pmw152q4oJHeS0Rg+UZUT3uFeGJp32TrFzdf4pqwiaRC
         aVadliQxOLRRqqr2Lw6MDX6DG0UKS5UhvmTGU4Dk=
Date:   Sun, 11 Sep 2022 20:30:41 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-use-helper-macro-sz_1k.patch removed from -mm tree
Message-Id: <20220912033041.E060AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: Use helper macro SZ_1K
has been removed from the -mm tree.  Its filename was
     hugetlb-use-helper-macro-sz_1k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: Use helper macro SZ_1K
Date: Thu, 1 Sep 2022 20:00:22 +0800

Use helper macro SZ_1K to do the size conversion to make code more
consistent in this file. Minor readability improvement.

Link: https://lkml.kernel.org/r/20220901120030.63318-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-use-helper-macro-sz_1k
+++ a/mm/hugetlb.c
@@ -4137,7 +4137,7 @@ void __init hugetlb_add_hstate(unsigned
 	h->next_nid_to_alloc = first_memory_node;
 	h->next_nid_to_free = first_memory_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
-					huge_page_size(h)/1024);
+					huge_page_size(h)/SZ_1K);
 
 	parsed_hstate = h;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

