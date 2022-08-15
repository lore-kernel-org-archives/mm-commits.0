Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FD4C25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiHOAGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiHOAGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1846ADFF6
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A3660F3E
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A08AC433D6;
        Mon, 15 Aug 2022 00:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660521961;
        bh=wEsqMyneHvXEf3QXutiw6vYSZX34XaQmABo8qgYFh7M=;
        h=Date:To:From:Subject:From;
        b=lOYdwnCp1LPxwTpZo0OMOeAJJtDygDBdd+NsXOxVLwcPuHWJ/cOCok3S7lWWi96vJ
         S9iq+OD1A5WEXIsygxKUDf/wMQXXCb5xW/BhAJDwj1n9CqdDww31Yh2k8ssjP+YS0b
         YotVobwPUx7Abz+yCn62gfEfr3ie5Tniym60e9So=
Date:   Sun, 14 Aug 2022 17:06:00 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch added to mm-unstable branch
Message-Id: <20220815000601.0A08AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: hugetlbfs: use helper macro SZ_1{K,M,G}
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

