Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08026C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbhLJWus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbhLJWur (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8CBC0617A1
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:47:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88B73B82A10
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15827C00446;
        Fri, 10 Dec 2021 22:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176429;
        bh=Ipr7UkUlp1rdnsMHDy+j401Xup9F5oldxVpPXNcII90=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lwuidf5HBCtNe2+WpBJueFCAKwf4ZaJMYISai6pIjl/DFLMwoOoKUaa5k3oLrEoKw
         arhA97WaI94xhSn3DOIcq6No11Vq5HheOJbC9fKRvzg6qkhuV3OOZaekzPvn3N5nED
         RIenXNMWUF5Aw9Cf0JcYgCSgHiNPkO7abAPrKDp4=
Date:   Fri, 10 Dec 2021 14:47:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com, mlevitsk@redhat.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, yaozhenguo1@gmail.com
Subject:  [patch 20/21] hugetlbfs: fix issue of preallocation of
 gigantic pages can't work
Message-ID: <20211210224708.7z79_4XIx%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: hugetlbfs: fix issue of preallocation of gigantic pages can't work

Preallocation of gigantic pages can't work bacause of commit b5389086ad7b
("hugetlbfs: extend the definition of hugepages parameter to support node
allocation").  When nid is NUMA_NO_NODE(-1), alloc_bootmem_huge_page will
always return without doing allocation.  Fix this by adding more check.

Link: https://lkml.kernel.org/r/20211129133803.15653-1-yaozhenguo1@gmail.com
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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
