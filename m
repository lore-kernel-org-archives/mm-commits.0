Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2442BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC3061208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKKCsD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234132AbhKKCsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B4161108;
        Thu, 11 Nov 2021 02:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598714;
        bh=54tXmIU9YgnZkZOdoebs4eXcC++GTtjZ8ScIKE5QJOA=;
        h=Date:From:To:Subject:From;
        b=aIMMxA88oZjKq2PGFSR64A8GQRtL+YIpfVQL0jazwkt9odkf6A45btmYNNe5XONjW
         Ny2kxIMH37WCijTjubkHfu9eYELlbh1Ha2UuAr7Gm1PVMBlSX36pgx7dwgUY/0QYqx
         iRbqARqF+EQjcdxo7XlhiPZwTFTHPzU+PZuRWtlM=
Date:   Wed, 10 Nov 2021 18:45:14 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch
 removed from -mm tree
Message-ID: <20211111024514.I2icMRtYL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: remove unused hugetlb_cgroup_from_counter macro
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

