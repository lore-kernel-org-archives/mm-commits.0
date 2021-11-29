Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D522C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhK2Wgx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbhK2WgK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8C8C0254FC
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 12:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40A81B8163A
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 20:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CAAC53FC7;
        Mon, 29 Nov 2021 20:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638217575;
        bh=dqslqTC0ov12SxQG9Ed1NQD/N6oTuuHekLF9VYYtv98=;
        h=Date:From:To:Subject:From;
        b=VvWG2yI85T1cCdu9ip279klg+u72haqTUFFm77y91DkuvGOvrBRl/j+9mA3MVcfXz
         4D826qh0UqjZBT7yZTorB5psuGFRfvJdO9xjU6imqV/da7A9KQLkrc6Sp992XcLY/0
         d0HGsk+w0Fg4BPJsENjjCHWyeykn7JY/CQvwA0N4=
Date:   Mon, 29 Nov 2021 12:26:15 -0800
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mlevitsk@redhat.com,
        mm-commits@vger.kernel.org, yaozhenguo1@gmail.com
Subject:  +
 hugetlbfs-fix-issue-of-preallocation-of-gigantic-pages-cant-work.patch
 added to -mm tree
Message-ID: <20211129202615.ft0hdk7AM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix issue of preallocation of gigantic pages can't work
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-issue-of-preallocation-of-gigantic-pages-cant-work.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-fix-issue-of-preallocation-of-gigantic-pages-cant-work.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-fix-issue-of-preallocation-of-gigantic-pages-cant-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: hugetlbfs: fix issue of preallocation of gigantic pages can't work

Preallocation of gigantic pages can't work bacause of commit b5389086ad7b
("hugetlbfs: extend the definition of hugepages parameter to support node
allocation").  When nid is NUMA_NO_NODE(-1), alloc_bootmem_huge_page will
always return without doing allocation.  Fix this by adding more check.

Link: https://lkml.kernel.org/r/20211129133803.15653-1-yaozhenguo1@gmail.com
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlbfs-fix-issue-of-preallocation-of-gigantic-pages-cant-work
+++ a/mm/hugetlb.c
@@ -2973,7 +2973,7 @@ int __alloc_bootmem_huge_page(struct hst
 	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node;
 
-	if (nid >= nr_online_nodes)
+	if (nid != NUMA_NO_NODE && nid >= nr_online_nodes)
 		return 0;
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are

hugetlbfs-fix-issue-of-preallocation-of-gigantic-pages-cant-work.patch

