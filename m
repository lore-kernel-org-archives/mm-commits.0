Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BBEC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BCF61262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhKEUok (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhKEUof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA4F461262;
        Fri,  5 Nov 2021 20:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144915;
        bh=wBVtpUZVtf2kVw+I46otS9bS+X/Pz+en6b3B9FC13vM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PDejLvKN42gFXcPh7W8eHTpFlyYFyiOOpmKcHZbQPp/mjkO5Gxv0ijZlcjhq1FgGY
         Qpzqiw7//+ECx0RKMuiFsrjGufp0NMhEzkTJCTolGnVOmZIkw565DcMbNIaawG7Toq
         0/9SUFJqrN7yRduD88xK17Ij6iYGyf6I1bjGUDNo=
Date:   Fri, 05 Nov 2021 13:41:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 139/262] hugetlb: replace the obsolete
 hugetlb_instantiation_mutex in the comments
Message-ID: <20211105204155.cbkgqZqnW%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
