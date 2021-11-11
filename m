Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F23C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2BCA60F46
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhKKCsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234132AbhKKCsE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 777556103C;
        Thu, 11 Nov 2021 02:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598716;
        bh=COwDGWLvFluMzD17QznuRIRqRiu3c+vM38Ix/wyaleQ=;
        h=Date:From:To:Subject:From;
        b=ip6FTvrTzzcAMiwIPCcWC7PUAJMIEjcdBHLhOeE1So0TZgG95xuikX0JtN+/4HxHj
         AkNNbl3KvKexrwRQncsT7ARAb5T5IRepAs6wj+vZaC+ubuG4UhwWPHJaf9+20LIocd
         HS3HJL0Mop4uSdMgE3xP6k4QYUxN0XpF0zOEY1g8=
Date:   Wed, 10 Nov 2021 18:45:16 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?hugetlb-replace-the-obsolete-hugetlb=5Finstantiation=5Fmut?=
 =?US-ASCII?Q?ex-in-the-comments.patch?= removed from -mm tree
Message-ID: <20211111024516.L9JVZA6GL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: replace the obsolete hugetlb_instantiation_mutex in the comments
has been removed from the -mm tree.  Its filename was
     hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: replace the obsolete hugetlb_instantiation_mutex in the comments

After commit 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability"),
the hugetlb_instantiation_mutex lock had been replaced by
hugetlb_fault_mutex_table to serializes faults on the same logical page. 
Thus update the obsolete hugetlb_instantiation_mutex related comments.

Link: https://lkml.kernel.org/r/4b3febeae37455ff7b74aa0aad16cc6909cf0926.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments
+++ a/mm/hugetlb.c
@@ -5014,7 +5014,7 @@ static void unmap_ref_private(struct mm_
 
 /*
  * Hugetlb_cow() should be called with page lock of the original hugepage held.
- * Called with hugetlb_instantiation_mutex held and pte_page locked so we
+ * Called with hugetlb_fault_mutex_table held and pte_page locked so we
  * cannot race with other handlers or page migration.
  * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

