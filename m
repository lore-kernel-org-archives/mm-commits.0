Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1DFC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjBWTsS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBWTsL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:48:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48264D511
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:48:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9104B81AE7
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D996C433EF;
        Thu, 23 Feb 2023 19:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677181686;
        bh=HR6Vyh9cUmNsx1hsXmaTSQ9m9cpwetfFrgIOyIaikkA=;
        h=Date:To:From:Subject:From;
        b=W6vgazQqmXpfnXzPnI5ZvDkDgVdXBsBkMEMX+4jImYF9NSd0Su4Qn98XzAf/otYPm
         WoKRH/3kmEUeR63ycxDPnjAf6bRyU8TnmR72bNC9oH56tpV9vwlOEOrXi7Ji7m6sh4
         tMqkyKTKMOn8unQ6O0HMU8MHp8lC2vmQTfRExGIA=
Date:   Thu, 23 Feb 2023 11:48:06 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch added to mm-unstable branch
Message-Id: <20230223194806.9D996C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: simplify hugetlb_vmemmap_init() a bit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: simplify hugetlb_vmemmap_init() a bit
Date: Thu, 23 Feb 2023 14:59:47 +0800

The check of IS_ENABLED(CONFIG_PROC_SYSCTL) is unnecessary since
register_sysctl_init() will be empty in this case.  So, there is no
warnings after removing the check.

Link: https://lkml.kernel.org/r/20230223065947.64134-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

