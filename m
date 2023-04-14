Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519AEC77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 19:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDNTKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 15:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjDNTKg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 15:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046C3270D
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 12:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D06462BBC
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 19:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEE1C433EF;
        Fri, 14 Apr 2023 19:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681499429;
        bh=xW6lf95jbON1wT1ykEXpgiDXzSGTqOrREIjJe+lQmVE=;
        h=Date:To:From:Subject:From;
        b=fdBaYK6NX+inbPsSDU3fGWBq/SHOJv3XHEJ8ylXekzcIsgSraZ+R2v44hIDPb24kB
         VJIfKoVn1WJILlEs3riK1RwUfhag3EjgzojZbLVjeLTkCfB4jcd+OBK3KUdGgZ2u6Y
         Fq9sF9+clKl++Nw1I1qmHe/xCTrQ/ufpBZq7XFBU=
Date:   Fri, 14 Apr 2023 12:10:28 -0700
To:     mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-regression-fix-for-unmapped_area_topdown.patch added to mm-unstable branch
Message-Id: <20230414191028.DEEE1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: regression fix for unmapped_area{_topdown}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-regression-fix-for-unmapped_area_topdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-regression-fix-for-unmapped_area_topdown.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: regression fix for unmapped_area{_topdown}
Date: Fri, 14 Apr 2023 14:59:19 -0400

The maple tree limits the gap returned to a window that specifically fits
what was asked.  This may not be optimal in the case of switching search
directions or a gap that does not satisfy the requested space for other
reasons.  Fix the search by retrying the operation and limiting the search
window in the rare occasion that a conflict occurs.

Link: https://lkml.kernel.org/r/20230414185919.4175572-1-Liam.Howlett@oracle.com
Fixes: 3499a13168da ("mm/mmap: use maple tree for unmapped_area{_topdown}")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-regression-fix-for-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -1547,7 +1547,8 @@ static inline int accountable_mapping(st
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, low_limit;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
@@ -1556,12 +1557,29 @@ static unsigned long unmapped_area(struc
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
-				  length))
+	low_limit = info->low_limit;
+retry:
+	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
 	gap += (info->align_offset - gap) & info->align_mask;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) < gap + length - 1) {
+			low_limit = tmp->vm_end;
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			low_limit = vm_end_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
@@ -1577,7 +1595,8 @@ static unsigned long unmapped_area(struc
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, high_limit, gap_end;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	/* Adjust search length to account for worst case alignment overhead */
@@ -1585,12 +1604,31 @@ static unsigned long unmapped_area_topdo
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
+	high_limit = info->high_limit;
+retry:
+	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
 				length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
 	gap -= (gap - info->align_offset) & info->align_mask;
+	gap_end = mas.last;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) <= gap_end) {
+			high_limit = vm_start_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			high_limit = tmp->vm_start;
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch
mm-mempolicy-fix-use-after-free-of-vma-iterator.patch
mm-mmap-regression-fix-for-unmapped_area_topdown.patch

