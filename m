Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04A6C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjC1XUz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC1XUy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:20:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E72BE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB17619E9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E6AC433D2;
        Tue, 28 Mar 2023 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045652;
        bh=yeu5YN/OQ2sQFeB7X2dErIV349q1FweKv7O3j9zVSlU=;
        h=Date:To:From:Subject:From;
        b=jeKvSGHzaPtukFSWTzLcQszgd68J7QsEia/sRS8FUf/A3JplcCHXPGtqBWUpJH/Nz
         u1QXScNzuofMbPZDbQ7QNS82PWR/Ud/rv11CznvvhxfEFB9U3T3aGojAVbCEk2HX45
         kcod/7RiNWFsv1RjQQCvDxYvFiElUyfnKZPzGmnk=
Date:   Tue, 28 Mar 2023 16:20:51 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch removed from -mm tree
Message-Id: <20230328232052.76E6AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: simplify hugetlb_vmemmap_init() a bit
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: simplify hugetlb_vmemmap_init() a bit
Date: Thu, 23 Feb 2023 14:59:47 +0800

The check of IS_ENABLED(CONFIG_PROC_SYSCTL) is unnecessary since
register_sysctl_init() will be empty in this case.  So, there is no
warnings after removing the check.

Link: https://lkml.kernel.org/r/20230223065947.64134-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit
+++ a/mm/hugetlb_vmemmap.c
@@ -590,17 +590,15 @@ static struct ctl_table hugetlb_vmemmap_
 
 static int __init hugetlb_vmemmap_init(void)
 {
+	const struct hstate *h;
+
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE * sizeof(struct page) > HUGETLB_VMEMMAP_RESERVE_SIZE);
 
-	if (IS_ENABLED(CONFIG_PROC_SYSCTL)) {
-		const struct hstate *h;
-
-		for_each_hstate(h) {
-			if (hugetlb_vmemmap_optimizable(h)) {
-				register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
-				break;
-			}
+	for_each_hstate(h) {
+		if (hugetlb_vmemmap_optimizable(h)) {
+			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
+			break;
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


