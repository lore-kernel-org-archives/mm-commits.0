Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211C4C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiB1AtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiB1AtV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C022E3DA68;
        Sun, 27 Feb 2022 16:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEA861204;
        Mon, 28 Feb 2022 00:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6770AC340EE;
        Mon, 28 Feb 2022 00:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009322;
        bh=HkeM4Ge6h9ijyKMaDhgafhnKnLjzUI3q9VBTeiNalq4=;
        h=Date:To:From:Subject:From;
        b=KvtN+Prn6wKdT0Prw8Y3v6ZRZTIlMGNtPRVLkCtV5bSna517j52f4imxBJ4Bct9MF
         r2bqgIVPeZAdHvy7KCpyWaa7SBOc+uU3LC+I4551Md1MBcETGS8C897tLRdHquUfgn
         TFN/7ii+OI+ZZnaEwrHkbHNrz2KM/NeBKXHr0E9c=
Date:   Sun, 27 Feb 2022 16:48:41 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, liuyuntao10@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch removed from -mm tree
Message-Id: <20220228004842.6770AC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix a truncation issue in hugepages parameter
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Yuntao <liuyuntao10@huawei.com>
Subject: hugetlbfs: fix a truncation issue in hugepages parameter

When we specify a large number for node in hugepages parameter, it may be
parsed to another number due to truncation in this statement:

	node = tmp;

For example, add following parameter in command line:

	hugepagesz=1G hugepages=4294967297:5

and kernel will allocate 5 hugepages for node 1 instead of ignoring it.

I move the validation check earlier to fix this issue, and slightly
simplifies the condition here.

Link: https://lkml.kernel.org/r/20220209134018.8242-1-liuyuntao10@huawei.com
Fixes: b5389086ad7be0 ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Liu Yuntao <liuyuntao10@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter
+++ a/mm/hugetlb.c
@@ -4159,10 +4159,10 @@ static int __init hugepages_setup(char *
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
+			if (tmp >= nr_online_nodes)
+				goto invalid;
 			node = tmp;
 			p += count + 1;
-			if (node < 0 || node >= nr_online_nodes)
-				goto invalid;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
 				goto invalid;
_

Patches currently in -mm which might be from liuyuntao10@huawei.com are


