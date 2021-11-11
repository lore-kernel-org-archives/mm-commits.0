Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57D8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF1D161260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhKKCsH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234132AbhKKCsG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 795AD60F46;
        Thu, 11 Nov 2021 02:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598718;
        bh=K3RSl1GMz68zej1BxqY1GdGW4SKsCOPpETTBV9HH5zw=;
        h=Date:From:To:Subject:From;
        b=pqtZ4VFbcIszuqk3Wo62yu/xlJb+qwJj0wGhLwnfdLehXQEAbAHArcCuwDPyX5F4K
         Z1H1fZ7oEM/1RUM/Ee5mj0zGQmssH5gn4mhyUK7ZHxNEPiSVeu68elpCjYSZWDtOjm
         GORts5FDOTTpasI/eD3MEgRJPvWe2HBY7XQayQQk=
Date:   Wed, 10 Nov 2021 18:45:18 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch removed
 from -mm tree
Message-ID: <20211111024518.qQrC3TxN5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove redundant validation in has_same_uncharge_info()
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: remove redundant validation in has_same_uncharge_info()

The callers of has_same_uncharge_info() has accessed the original
file_region and new file_region, and they are impossible to be NULL now. 
So we can remove the file_region validation in has_same_uncharge_info() to
simplify the code.

Link: https://lkml.kernel.org/r/97fc68d3f8d34f63c204645e10d7a718997e50b7.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
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

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

