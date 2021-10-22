Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335F2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1304261A38
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhJVDri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhJVDrh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D69C161A09;
        Fri, 22 Oct 2021 03:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634874321;
        bh=y/bQV/hGsLXHfY8RLoDupMMGG0oiQE2DCLEgclGWBcg=;
        h=Date:From:To:Subject:From;
        b=2Dmgyxy+f1Ypl9dnnaovDdekhqeWzr0TB3AgtKHeeyuD7OF8w3lbPYEZ6PgyFgEhd
         uRiuyhewAJE2Ca4hrApZLO6/fUUpjkNH58eCu8bG2rzBXNsUh+acUDufWRBy09CBmV
         /7MEFJgKmbcbM8UCzynygGs8w0yUyDMQvKXN55DE=
Date:   Thu, 21 Oct 2021 20:45:20 -0700
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch added
 to -mm tree
Message-ID: <20211022034520.sdbChb6eQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove redundant validation in has_same_uncharge_info()
has been added to the -mm tree.  Its filename is
     hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: remove redundant validation in has_same_uncharge_info()

The callers of has_same_uncharge_info() has accessed the original
file_region and new file_region, and they are impossible to be NULL now. 
So we can remove the file_region validation in has_same_uncharge_info() to
simplify the code.

Link: https://lkml.kernel.org/r/97fc68d3f8d34f63c204645e10d7a718997e50b7.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-redundant-validation-in-has_same_uncharge_info
+++ a/mm/hugetlb.c
@@ -332,8 +332,7 @@ static bool has_same_uncharge_info(struc
 				   struct file_region *org)
 {
 #ifdef CONFIG_CGROUP_HUGETLB
-	return rg && org &&
-	       rg->reservation_counter == org->reservation_counter &&
+	return rg->reservation_counter == org->reservation_counter &&
 	       rg->css == org->css;
 
 #else
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages.patch
hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch
hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch
hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch
hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

