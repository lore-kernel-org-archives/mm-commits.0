Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F247C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 18 Feb 2022 00:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiBRAgz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 19:36:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBRAgy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 19:36:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C281F2619
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 16:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E674B819EE
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 00:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA86C340E8;
        Fri, 18 Feb 2022 00:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645144596;
        bh=VWLxW3Zdc3vZR7D63ziwoRte2POYS0S5cG1+ExdXxcY=;
        h=Date:To:From:Subject:From;
        b=JUpTI0Y73voZamMc2zxJNgYKWOkhfbJq0p7u6v7Pt1mC9n3NlULxqqbTzh1W7v+ly
         sGQIWBaIY/OPvds8Yy6MO25SRolotPiQPsgvTb/OFzR2kjHHwIJ1UkQkbuU9aXTNtk
         oItd30aXdoVX8vbMxicZH/oEAYeIZOT3ZqIAZQlo=
Date:   Thu, 17 Feb 2022 16:36:35 -0800
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        liuyuntao10@huawei.com, dan.carpenter@oracle.com,
        baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-clean-up-potential-spectre-issue-warnings.patch added to -mm tree
Message-Id: <20220218003635.EDA86C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: clean up potential spectre issue warnings
has been added to the -mm tree.  Its filename is
     hugetlb-clean-up-potential-spectre-issue-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-clean-up-potential-spectre-issue-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-clean-up-potential-spectre-issue-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20220217234218.192885-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
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
+			if (tmp < 0 || tmp >= MAX_NUMNODES)
 				break;
+			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
 			s += count + 1;
 			tmp = memparse(s, &s);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch
hugetlb-clean-up-potential-spectre-issue-warnings.patch

