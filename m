Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE70ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiILDac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiILD26 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F4C27CF5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCF64B80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BFCC433B5;
        Mon, 12 Sep 2022 03:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953334;
        bh=SKEdY0UE/9yjk6OJo/OOxIMZEijx5JZjKB9ZXzZxHvQ=;
        h=Date:To:From:Subject:From;
        b=GSJmwxpNSrfmxl8LnYcBcLlYuDngxUpEYZ3cCN1VDuyDFYi5n6CaKVaATXM737T4f
         UDz2tyIMasXJ3vsS1MzEevdxNBkOewyh41evwyanP51ZoSjOiiyEWGAf3CQapYSPBQ
         A1//ucb0S9GL7f44tNBqt7ljAhM4a/V3UjzbdRxk=
Date:   Sun, 11 Sep 2022 20:28:53 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch removed from -mm tree
Message-Id: <20220912032854.70BFCC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_cgroup: remove unneeded nr_pages > 0 check
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: remove unneeded nr_pages > 0 check
Date: Fri, 29 Jul 2022 16:01:02 +0800

Patch series "A few cleanup patches for hugetlb_cgroup", v2.

This series contains a few cleaup patches to remove unneeded check, use
helper macro, remove unneeded return value and so on.  More details can be
found in the respective changelogs.


This patch (of 5):

When code reaches here, nr_pages must be > 0. Remove unneeded nr_pages > 0
check to simplify the code.

Link: https://lkml.kernel.org/r/20220729080106.12752-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220729080106.12752-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-remove-unneeded-nr_pages-0-check
+++ a/mm/hugetlb_cgroup.c
@@ -442,7 +442,7 @@ void hugetlb_cgroup_uncharge_file_region
 	if (hugetlb_cgroup_disabled() || !resv || !rg || !nr_pages)
 		return;
 
-	if (rg->reservation_counter && resv->pages_per_hpage && nr_pages > 0 &&
+	if (rg->reservation_counter && resv->pages_per_hpage &&
 	    !resv->reservation_counter) {
 		page_counter_uncharge(rg->reservation_counter,
 				      nr_pages * resv->pages_per_hpage);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

