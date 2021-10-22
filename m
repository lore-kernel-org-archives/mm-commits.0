Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8C3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8020B61A09
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhJVDrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhJVDrf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC31C61A35;
        Fri, 22 Oct 2021 03:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634874319;
        bh=GCF4xZ7wB8vGR1v3YpM3XBc8qjbfQpDPZ0m7T8QdLfY=;
        h=Date:From:To:Subject:From;
        b=CHtef1j/JX36l0ygrTOMOy+wIHeHdo6hPXRZD72Yw3EGdlQinNbf9z4Ncwz2+Wb0k
         Bf7joJ3oOLeQejgIWAvVKCfNDFVs8x31M3S1qxPdba8uywNkzBY26iXHgxS7N2VbJn
         RipoBb2G0+o2njkrQvC6dPrd0vTKhWwusBQAaXm0=
Date:   Thu, 21 Oct 2021 20:45:18 -0700
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?hugetlb-replace-the-obsolete-hugetlb=5Finstantiation=5Fmut?=
 =?US-ASCII?Q?ex-in-the-comments.patch?= added to -mm tree
Message-ID: <20211022034518.e5vkHeqCh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: replace the obsolete hugetlb_instantiation_mutex in the comments
has been added to the -mm tree.  Its filename is
     hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch

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
Subject: hugetlb: replace the obsolete hugetlb_instantiation_mutex in the comments

After commit 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability"),
the hugetlb_instantiation_mutex lock had been replaced by
hugetlb_fault_mutex_table to serializes faults on the same logical page. 
Thus update the obsolete hugetlb_instantiation_mutex related comments.

Link: https://lkml.kernel.org/r/4b3febeae37455ff7b74aa0aad16cc6909cf0926.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages.patch
hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch
hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch
hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch
hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

