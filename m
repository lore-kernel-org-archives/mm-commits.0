Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525F2C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F7F36128A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhKEUof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhKEUoc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54BB6127A;
        Fri,  5 Nov 2021 20:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144913;
        bh=LB85HUFu8ll1X2iiu5LzCoBLih9nDO9SXo2caohty+0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tSx8jdf7iIyNLcWIdFcvD6aBD6I0IIYA7DoKkLCOCr0ATkqtuj4q/9oOE/Vcr+sFx
         WLE189IrXvwmSJQdy/Y/qc/VagPSnnTnSlV43Ebgu9mtexTwTnMY7AmDerhgCVhyfi
         ji/NbBIQmMfUGYBm2rtmV0kjjWbOjrs+v25aLfhk=
Date:   Fri, 05 Nov 2021 13:41:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 138/262] hugetlb_cgroup: remove unused
 hugetlb_cgroup_from_counter macro
Message-ID: <20211105204152.MEVe-4gQM%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb_cgroup: remove unused hugetlb_cgroup_from_counter macro

Patch series "Some cleanups and improvements for hugetlb".

This patchset does some cleanups and improvements for hugetlb and
hugetlb_cgroup.


This patch (of 4):

Since commit 726b7bbe ("hugetlb_cgroup: fix illegal access to memory"),
the hugetlb_cgroup_from_counter() macro is not used any more, remove it.

Link: https://lkml.kernel.org/r/cover.1634797639.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/f03b29b801fa9942466ab15334ec09988e124ae6.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro
+++ a/mm/hugetlb_cgroup.c
@@ -27,9 +27,6 @@
 #define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
-#define hugetlb_cgroup_from_counter(counter, idx)                   \
-	container_of(counter, struct hugetlb_cgroup, hugepage[idx])
-
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
 static inline struct page_counter *
_
