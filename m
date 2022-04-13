Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67769C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 04:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiDMEtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 00:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiDMEtU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 00:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7D927CEE
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BD82B820FF
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 04:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8D7C385A3;
        Wed, 13 Apr 2022 04:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649825218;
        bh=7rzgUmL2qPS2+O7wdxMRlqVmgqKWOtWb+HA4YQTS2iU=;
        h=Date:To:From:Subject:From;
        b=a2vABR9JXlMYGW5fzReLMtOElHCoXTS+JQPVnYI3yuWPjcIEQxDmk0LFlkGvq4ywt
         j1Y0sSBCLc+6HCbhoSUIOeUaz2uB0fii+EMSA5C++8xbget62gQU0oKOkXDIuoMdED
         Bf/SoiSCpPdD2H0WW5xAwwQnr7dOX39/SM5Gd08E=
Date:   Tue, 12 Apr 2022 21:46:57 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        liuyuntao10@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch added to -mm tree
Message-Id: <20220413044658.0C8D7C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix hugepages_setup when deal with pernode
has been added to the -mm tree.  Its filename is
     hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: hugetlb: fix hugepages_setup when deal with pernode

Hugepages can be specified to pernode since "hugetlbfs: extend the
definition of hugepages parameter to support node allocation", but the
following problem is observed.

Confusing behavior is observed when both 1G and 2M hugepage is set
after "numa=off".
 cmdline hugepage settings:
  hugepagesz=1G hugepages=0:3,1:3
  hugepagesz=2M hugepages=0:1024,1:1024
 results:
  HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
  HugeTLB registered 2.00 MiB page size, pre-allocated 1024 pages

Furthermore, confusing behavior can be also observed when an invalid node
behind a valid node.  To fix this, never allocate any typical hugepage
when an invalid parameter is received.

Link: https://lkml.kernel.org/r/20220413032915.251254-3-liupeng256@huawei.com
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-fix-hugepages_setup-when-deal-with-pernode
+++ a/mm/hugetlb.c
@@ -4126,6 +4126,20 @@ bool __init __weak hugetlb_node_alloc_su
 {
 	return true;
 }
+
+static void __init hugepages_clear_pages_in_node(void)
+{
+	if (!hugetlb_max_hstate) {
+		default_hstate_max_huge_pages = 0;
+		memset(default_hugepages_in_node, 0,
+			MAX_NUMNODES * sizeof(unsigned int));
+	} else {
+		parsed_hstate->max_huge_pages = 0;
+		memset(parsed_hstate->max_huge_pages_node, 0,
+			MAX_NUMNODES * sizeof(unsigned int));
+	}
+}
+
 /*
  * hugepages command line processing
  * hugepages normally follows a valid hugepagsz or default_hugepagsz
@@ -4213,6 +4227,7 @@ static int __init hugepages_setup(char *
 
 invalid:
 	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
+	hugepages_clear_pages_in_node();
 	return 0;
 }
 __setup("hugepages=", hugepages_setup);
_

Patches currently in -mm which might be from liupeng256@huawei.com are

hugetlb-fix-wrong-use-of-nr_online_nodes.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
hugetlb-clean-up-hugetlb_cma_reserve.patch

