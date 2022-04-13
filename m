Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA39C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 04:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiDMEtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 00:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDMEtW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 00:49:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4477426ADA
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0D50B820FE
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 04:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9259C385A4;
        Wed, 13 Apr 2022 04:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649825219;
        bh=UnOAkf8/Z2onIzxfORUzudvgXUwAVuJE42vQm47kRaM=;
        h=Date:To:From:Subject:From;
        b=BrN/K3RuaugTfSYoN8kvGCnquTk/rmktHQ6NlJvsiTozxodSFD1AybpmFyjJhVvSz
         rfd0WlWLKgux7sOP45ZjKmM51XmanNo6MQtYTzIdqe8Wyf3tgmO7xMbm9wXoB+wyX5
         dechCUc7rQ02c3qTbgxJ1SJqqVefurp26orcxNlA=
Date:   Tue, 12 Apr 2022 21:46:59 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        liuyuntao10@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-return-value-of-__setup-handlers.patch added to -mm tree
Message-Id: <20220413044659.A9259C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix return value of __setup handlers
has been added to the -mm tree.  Its filename is
     hugetlb-fix-return-value-of-__setup-handlers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-return-value-of-__setup-handlers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-return-value-of-__setup-handlers.patch

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-fix-return-value-of-__setup-handlers
+++ a/mm/hugetlb.c
@@ -4159,7 +4159,7 @@ static int __init hugepages_setup(char *
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
-		return 0;
+		return 1;
 	}
 
 	/*
@@ -4175,7 +4175,7 @@ static int __init hugepages_setup(char *
 
 	if (mhp == last_mhp) {
 		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	while (*p) {
@@ -4186,7 +4186,7 @@ static int __init hugepages_setup(char *
 		if (p[count] == ':') {
 			if (!hugetlb_node_alloc_supported()) {
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
-				return 0;
+				return 1;
 			}
 			if (!node_online(tmp))
 				goto invalid;
@@ -4228,7 +4228,7 @@ static int __init hugepages_setup(char *
 invalid:
 	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
 	hugepages_clear_pages_in_node();
-	return 0;
+	return 1;
 }
 __setup("hugepages=", hugepages_setup);
 
@@ -4249,7 +4249,7 @@ static int __init hugepagesz_setup(char
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	h = size_to_hstate(size);
@@ -4264,7 +4264,7 @@ static int __init hugepagesz_setup(char
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
 			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
-			return 0;
+			return 1;
 		}
 
 		/*
@@ -4295,14 +4295,14 @@ static int __init default_hugepagesz_set
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

hugetlb-fix-wrong-use-of-nr_online_nodes.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
hugetlb-clean-up-hugetlb_cma_reserve.patch

