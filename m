Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4A9C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiCVTOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiCVTOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BB390CCB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C07861657
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B4BC340EC;
        Tue, 22 Mar 2022 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976388;
        bh=uGfBAFRsvJTT2wPmdGNO7qsvIpaZxnATJDtCy6mxol0=;
        h=Date:To:From:Subject:From;
        b=NB/Fp9kjWJm7GRzg1rMDee6tgqt0p9YDTT3RRG9BAAPSwWfN0L0fldOf7l1/ZkmUj
         VWe9AJYLakDBynppV1F3DA25/rTGRxoijdXbfcYvWExfVH35yMBUk2KlkSxHZmhPjl
         nWEcZQEVLbe49cqP9mhSrtxyyNIDPY3+fEF3HhLw=
Date:   Tue, 22 Mar 2022 12:13:07 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com, mhocko@suse.com,
        liuyuntao10@huawei.com, dan.carpenter@oracle.com,
        baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch removed from -mm tree
Message-Id: <20220322191308.72B4BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-clean-up-potential-spectre-issue-warnings-v2
has been removed from the -mm tree.  Its filename was
     hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch

This patch was dropped because it was folded into hugetlb-clean-up-potential-spectre-issue-warnings.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-clean-up-potential-spectre-issue-warnings-v2

Link: https://lkml.kernel.org/r/20220218212946.35441-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-clean-up-potential-spectre-issue-warnings-v2
+++ a/mm/hugetlb.c
@@ -6893,7 +6893,7 @@ static int __init cmdline_parse_hugetlb_
 			break;
 
 		if (s[count] == ':') {
-			if (tmp < 0 || tmp >= MAX_NUMNODES)
+			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-clean-up-potential-spectre-issue-warnings.patch
hugetlb-do-not-demote-poisoned-hugetlb-pages.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

