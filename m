Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8227C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiEJEUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbiEJESQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19294101161
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7B5EB81AF4
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F20C385C7;
        Tue, 10 May 2022 04:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156053;
        bh=YzhVjU1zmiquTANmOc0r9nNhQF67lmTzuDpTVIM6cCM=;
        h=Date:To:From:Subject:From;
        b=qTiffU3NtKiVCQDYv/XvbJkH9XNoikWnpwmIqLBlPVU+RcpT9Ifkn2nHymD+zjpb8
         R57zIgpGOWSUcdlY/KrE6bxGqSXdjK0OFTh7clajkDcXiDcfm+ndLCr0uMrrd4LVfh
         xKHwzUkcXCPDFA5eLc/Tm1jdvuQErhHnOplGmyPo=
Date:   Mon, 09 May 2022 21:14:12 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        wangkefeng.wang@huawei.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, liuyuntao10@huawei.com, david@redhat.com,
        dave@stgolabs.net, baolin.wang@linux.alibaba.com,
        liupeng256@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-fix-return-value-of-__setup-handlers.patch removed from -mm tree
Message-Id: <20220510041413.70F20C385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix return value of __setup handlers
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-return-value-of-__setup-handlers.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: hugetlb: fix return value of __setup handlers

When __setup() return '0', using invalid option values causes the entire
kernel boot option string to be reported as Unknown.  Hugetlb calls
__setup() and will return '0' when set invalid parameter string.

The following phenomenon is observed:
 cmdline:
  hugepagesz=1Y hugepages=1
 dmesg:
  HugeTLB: unsupported hugepagesz=1Y
  HugeTLB: hugepages=1 does not follow a valid hugepagesz, ignoring
  Unknown kernel command line parameters "hugepagesz=1Y hugepages=1"

Since hugetlb will print warning/error information before return for
invalid parameter string, just use return '1' to avoid print again.

Link: https://lkml.kernel.org/r/20220413032915.251254-4-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-return-value-of-__setup-handlers
+++ a/mm/hugetlb.c
@@ -4155,7 +4155,7 @@ static int __init hugepages_setup(char *
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
-		return 0;
+		return 1;
 	}
 
 	/*
@@ -4171,7 +4171,7 @@ static int __init hugepages_setup(char *
 
 	if (mhp == last_mhp) {
 		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	while (*p) {
@@ -4182,7 +4182,7 @@ static int __init hugepages_setup(char *
 		if (p[count] == ':') {
 			if (!hugetlb_node_alloc_supported()) {
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
-				return 0;
+				return 1;
 			}
 			if (tmp >= MAX_NUMNODES || !node_online(tmp))
 				goto invalid;
@@ -4224,7 +4224,7 @@ static int __init hugepages_setup(char *
 invalid:
 	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
 	hugepages_clear_pages_in_node();
-	return 0;
+	return 1;
 }
 __setup("hugepages=", hugepages_setup);
 
@@ -4245,7 +4245,7 @@ static int __init hugepagesz_setup(char
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	h = size_to_hstate(size);
@@ -4260,7 +4260,7 @@ static int __init hugepagesz_setup(char
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
 			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
-			return 0;
+			return 1;
 		}
 
 		/*
@@ -4291,14 +4291,14 @@ static int __init default_hugepagesz_set
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
 		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
-		return 0;
+		return 1;
 	}
 
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported default_hugepagesz=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
_

Patches currently in -mm which might be from liupeng256@huawei.com are


