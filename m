Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61903C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiILDae (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiILD3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CFB27DE9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBAAAB80C7B
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EF5C433D7;
        Mon, 12 Sep 2022 03:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953335;
        bh=W4C2dV2pp6M0nDiD6kqC37Hl5NpFQm7ywuxUi8JrjAQ=;
        h=Date:To:From:Subject:From;
        b=xh9FuIBlPeISTJqKvQ5jrgJHe2FacWUR36qCYiY8lg1ysQyX2uh7N8bdu+UIvApcQ
         xZq6DqgTaz+krxG/W3TfXJ06PSSp3Qvn0GKe9Hn8iHNqxBOTY1zZLfEZGQFxA5vGeR
         2KoEfe68CsddC7kIg+fHt8asXL3IQKEk7B2SS9RM=
Date:   Sun, 11 Sep 2022 20:28:54 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch removed from -mm tree
Message-Id: <20220912032855.95EF5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_cgroup: hugetlbfs: use helper macro SZ_1{K,M,G}
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: hugetlbfs: use helper macro SZ_1{K,M,G}
Date: Fri, 29 Jul 2022 16:01:03 +0800

Use helper macro SZ_1K, SZ_1M and SZ_1G to do the size conversion. Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220729080106.12752-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg
+++ a/mm/hugetlb_cgroup.c
@@ -675,12 +675,12 @@ static ssize_t hugetlb_cgroup_reset(stru
 
 static char *mem_fmt(char *buf, int size, unsigned long hsize)
 {
-	if (hsize >= (1UL << 30))
-		snprintf(buf, size, "%luGB", hsize >> 30);
-	else if (hsize >= (1UL << 20))
-		snprintf(buf, size, "%luMB", hsize >> 20);
+	if (hsize >= SZ_1G)
+		snprintf(buf, size, "%luGB", hsize / SZ_1G);
+	else if (hsize >= SZ_1M)
+		snprintf(buf, size, "%luMB", hsize / SZ_1M);
 	else
-		snprintf(buf, size, "%luKB", hsize >> 10);
+		snprintf(buf, size, "%luKB", hsize / SZ_1K);
 	return buf;
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

