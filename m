Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ED9C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D773E611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhKEUom (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhKEUoi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A86A6126A;
        Fri,  5 Nov 2021 20:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144918;
        bh=AQysa+n5ZPxXt7NfGtd1LvpmRCrYopYheHGaUrrks8I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qmJckTD67WT0N1oxAvBYG0AqWJmNEfq+fzKf6aktPbAB0ONQWUtBr+6luxQX4j0Dw
         2lEm3p85qu43OEElOIE3l8wnwOSpgMUrYHNTVIyTbOVzkS9dQL1pBSey57rKiRK+Q0
         kK7S6ynN275bEDwSZF7ZoVs6a/AlaQ5/WSqa4AWo=
Date:   Fri, 05 Nov 2021 13:41:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 140/262] hugetlb: remove redundant validation in
 has_same_uncharge_info()
Message-ID: <20211105204158.dBpgUQHuO%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
