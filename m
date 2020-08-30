Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACD8C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 20:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04530208A9
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598820534;
	bh=dc/3VRVy/P4hiOehBpXbnhZEPZRet4bJXaXmQ72HC44=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=l/UsjENIcYd/R7xysJv9RuMXHxib5+iqSZeNHTtKFK+74jmKdN3At3vcjxhB0dKDM
	 QrSRdSOgPDJEnSYClbBYIqPSF94DemhdqaSNozCCCjVdNyvv+vmgFDmfvnwD5NlgCL
	 l8BGzZf3W9JbTM2dxwv3LaXKpCHTJfAEyT42M8oU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgH3Usx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 16:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgH3Usw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 16:48:52 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D59C5206FA;
        Sun, 30 Aug 2020 20:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598820532;
        bh=dc/3VRVy/P4hiOehBpXbnhZEPZRet4bJXaXmQ72HC44=;
        h=Date:From:To:Subject:From;
        b=lSih3PqaDSuAi+guCeM3IRz3obdao5SOy/MfZn9lGon++GyuSx7/vMskvlICd/jGt
         uIeOkdMibINkAdGUFFmMOGq/H1Vbuq/DPYtTM5I+1BLrrcm8tn6NG8KHyrnHlMF8g3
         J/iiBcL0Pbyv361U605MhqX4RwSXz1B/tM3ZAZEU=
Date:   Sun, 30 Aug 2020 13:48:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        richard.weiyang@linux.alibaba.com
Subject:  +
 =?us-ascii?Q?mm-mmap-leave-adjust=5Fnext-as-virtual-address-instead-of?=
 =?us-ascii?Q?-page-frame-number.patch?= added to -mm tree
Message-ID: <20200830204851.8E-W7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: leave adjust_next as virtual address instead of page frame number
has been added to the -mm tree.  Its filename is
     mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: leave adjust_next as virtual address instead of page frame number

Instead of converting adjust_next between virtual address and page frame
number, let's just store the virtual address into adjust_next.

Also, this patch fixes one typo in the comment of vma_adjust_trans_huge().

Link: http://lkml.kernel.org/r/20200828081031.11306-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/mmap.c        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number
+++ a/mm/huge_memory.c
@@ -2273,13 +2273,13 @@ void vma_adjust_trans_huge(struct vm_are
 
 	/*
 	 * If we're also updating the vma->vm_next->vm_start, if the new
-	 * vm_next->vm_start isn't page aligned and it could previously
+	 * vm_next->vm_start isn't hpage aligned and it could previously
 	 * contain an hugepage: check if we need to split an huge pmd.
 	 */
 	if (adjust_next > 0) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long nstart = next->vm_start;
-		nstart += adjust_next << PAGE_SHIFT;
+		nstart += adjust_next;
 		if (nstart & ~HPAGE_PMD_MASK &&
 		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
 		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
--- a/mm/mmap.c~mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number
+++ a/mm/mmap.c
@@ -758,7 +758,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * vma expands, overlapping part of the next:
 			 * mprotect case 5 shifting the boundary up.
 			 */
-			adjust_next = (end - next->vm_start) >> PAGE_SHIFT;
+			adjust_next = (end - next->vm_start);
 			exporter = next;
 			importer = vma;
 			VM_WARN_ON(expand != importer);
@@ -768,7 +768,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * split_vma inserting another: so it must be
 			 * mprotect case 4 shifting the boundary down.
 			 */
-			adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
+			adjust_next = -(vma->vm_end - end);
 			exporter = vma;
 			importer = next;
 			VM_WARN_ON(expand != importer);
@@ -840,8 +840,8 @@ again:
 	}
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
-		next->vm_start += adjust_next << PAGE_SHIFT;
-		next->vm_pgoff += adjust_next;
+		next->vm_start += adjust_next;
+		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
 	}
 
 	if (root) {
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

