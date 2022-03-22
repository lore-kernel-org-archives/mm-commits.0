Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57AEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbiCVVrD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiCVVrA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3DE2B27E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A17C06104C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E1EC340EC;
        Tue, 22 Mar 2022 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985521;
        bh=jH8dF7GDqUGZPmmXDZ4LtM2Kj40YUDVUvC12nBofJUE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=0w+vLIgBJ6Y0OOXMHFc2ZCycmpK2I/yanNMe6iD9OLNpVDCf1NyvXdeGRWotLn1p3
         R7ZtxbsbKPGx8Wju5EWlwV8ttD1E+Ow6Ud+4EpMvprE6p8J1/t2EMCaPVxLBVKXMIo
         2GGhH1+aM0pkv5wOPJmjzctEMoFnNPMp9QtxEJRk=
Date:   Tue, 22 Mar 2022 14:45:20 -0700
To:     yaozhenguo1@gmail.com, mhocko@suse.com, liuyuntao10@huawei.com,
        dan.carpenter@oracle.com, baolin.wang@linux.alibaba.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 134/227] hugetlb: clean up potential spectre issue warnings
Message-Id: <20220322214521.06E1EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: clean up potential spectre issue warnings

Recently introduced code allows numa nodes to be specified on the kernel
command line for hugetlb allocations or CMA reservations.  The node values
are user specified and used as indicies into arrays.  This generated the
following smatch warnings:

mm/hugetlb.c:4170 hugepages_setup() warn: potential spectre issue 'default_hugepages_in_node' [w]
mm/hugetlb.c:4172 hugepages_setup() warn: potential spectre issue 'parsed_hstate->max_huge_pages_node' [w]
mm/hugetlb.c:6898 cmdline_parse_hugetlb_cma() warn: potential spectre issue 'hugetlb_cma_size_in_node' [w] (local cap)

Clean up by using array_index_nospec to sanitize array indicies.

The routine cmdline_parse_hugetlb_cma has the same overflow/truncation
issue addressed in [1].  That is also fixed with this change.

[1] https://lore.kernel.org/linux-mm/20220209134018.8242-1-liuyuntao10@huawei.com/

As Michal pointed out, this is unlikely to be exploitable because it is
__init code.  But the patch suppresses the warnings.

[mike.kravetz@oracle.com: v2]
  Link: https://lkml.kernel.org/r/20220218212946.35441-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20220217234218.192885-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-clean-up-potential-spectre-issue-warnings
+++ a/mm/hugetlb.c
@@ -31,6 +31,7 @@
 #include <linux/llist.h>
 #include <linux/cma.h>
 #include <linux/migrate.h>
+#include <linux/nospec.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -4161,7 +4162,7 @@ static int __init hugepages_setup(char *
 			}
 			if (tmp >= nr_online_nodes)
 				goto invalid;
-			node = tmp;
+			node = array_index_nospec(tmp, nr_online_nodes);
 			p += count + 1;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
@@ -6889,9 +6890,9 @@ static int __init cmdline_parse_hugetlb_
 			break;
 
 		if (s[count] == ':') {
-			nid = tmp;
-			if (nid < 0 || nid >= MAX_NUMNODES)
+			if (tmp >= MAX_NUMNODES)
 				break;
+			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
 			s += count + 1;
 			tmp = memparse(s, &s);
_
