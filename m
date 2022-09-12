Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4440CECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiILDfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiILDdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24065286E5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B344AB80C75
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57566C433D6;
        Mon, 12 Sep 2022 03:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953444;
        bh=RkdMwdSMxRR7YZ4aZ1CPVAL3aZJHe1vG3oUnBbP7XJE=;
        h=Date:To:From:Subject:From;
        b=yItpCM2EG5FxHOP6OXgUKHEtBsTL6dby1aK09Ok4pxQz1iCFUkPxgA9xTDqyS7W6z
         ZAcSzBGt6PNeZSelUMy7F8S7UBU1wCdz4jqSBjtMKqrpbZeeJTCpZofzfJTSJoWanh
         wMp6A11DkJkn+5Ov8iJd78A0FtZsIbmpUUg28jN8=
Date:   Sun, 11 Sep 2022 20:30:43 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-use-sizeof-to-get-the-array-size.patch removed from -mm tree
Message-Id: <20220912033044.57566C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: use sizeof() to get the array size
has been removed from the -mm tree.  Its filename was
     hugetlb-use-sizeof-to-get-the-array-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: use sizeof() to get the array size
Date: Thu, 1 Sep 2022 20:00:24 +0800

It's better to use sizeof() to get the array size instead of manual
calculation. Minor readability improvement.

Link: https://lkml.kernel.org/r/20220901120030.63318-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-sizeof-to-get-the-array-size
+++ a/mm/hugetlb.c
@@ -4149,11 +4149,11 @@ static void __init hugepages_clear_pages
 	if (!hugetlb_max_hstate) {
 		default_hstate_max_huge_pages = 0;
 		memset(default_hugepages_in_node, 0,
-			MAX_NUMNODES * sizeof(unsigned int));
+			sizeof(default_hugepages_in_node));
 	} else {
 		parsed_hstate->max_huge_pages = 0;
 		memset(parsed_hstate->max_huge_pages_node, 0,
-			MAX_NUMNODES * sizeof(unsigned int));
+			sizeof(parsed_hstate->max_huge_pages_node));
 	}
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

