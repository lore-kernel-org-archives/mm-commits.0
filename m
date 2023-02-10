Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965A3C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjBJAxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjBJAwx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC9C6D8F7
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF5161BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237D4C433EF;
        Fri, 10 Feb 2023 00:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990371;
        bh=I8efdeZeusIMk9EF5QLJXp/ZAWGdWobr7PBt02ji4Bo=;
        h=Date:To:From:Subject:From;
        b=IcGgAdnL1wELoXpTD5qEGTVFyBuJB5Ifm+mHI0G2SZWrtHeXwEj+7XvjMeSjR3MQF
         00/rxdpJbDbzu95qSH3OTf6Y6N4r6URBXUCSjvVz6B08xYyxdr72UaqWnMZqQRZAUP
         NG2mmoDFj/C+iZh+Osy6HhOtfBx50hTxZ9cOxKEY=
Date:   Thu, 09 Feb 2023 16:52:50 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempolicy-convert-to-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005251.237D4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempolicy: convert to vma iterator
has been removed from the -mm tree.  Its filename was
     mempolicy-convert-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mempolicy: convert to vma iterator
Date: Fri, 20 Jan 2023 11:26:21 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-21-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/mm/mempolicy.c~mempolicy-convert-to-vma-iterator
+++ a/mm/mempolicy.c
@@ -787,24 +787,21 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	MA_STATE(mas, &mm->mm_mt, start, start);
+	VMA_ITERATOR(vmi, mm, start);
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
 	pgoff_t pgoff;
 
-	prev = mas_prev(&mas, 0);
-	if (unlikely(!prev))
-		mas_set(&mas, start);
-
-	vma = mas_find(&mas, end - 1);
+	prev = vma_prev(&vmi);
+	vma = vma_find(&vmi, end);
 	if (WARN_ON(!vma))
 		return 0;
 
 	if (start > vma->vm_start)
 		prev = vma;
 
-	for (; vma; vma = mas_next(&mas, end - 1)) {
+	do {
 		unsigned long vmstart = max(start, vma->vm_start);
 		unsigned long vmend = min(end, vma->vm_end);
 
@@ -813,29 +810,23 @@ static int mbind_range(struct mm_struct
 
 		pgoff = vma->vm_pgoff +
 			((vmstart - vma->vm_start) >> PAGE_SHIFT);
-		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
+		prev = vmi_vma_merge(&vmi, mm, prev, vmstart, vmend, vma->vm_flags,
 				 vma->anon_vma, vma->vm_file, pgoff,
 				 new_pol, vma->vm_userfaultfd_ctx,
 				 anon_vma_name(vma));
 		if (prev) {
-			/* vma_merge() invalidated the mas */
-			mas_pause(&mas);
 			vma = prev;
 			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
-			err = split_vma(vma->vm_mm, vma, vmstart, 1);
+			err = vmi_split_vma(&vmi, vma->vm_mm, vma, vmstart, 1);
 			if (err)
 				goto out;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
 		}
 		if (vma->vm_end != vmend) {
-			err = split_vma(vma->vm_mm, vma, vmend, 0);
+			err = vmi_split_vma(&vmi, vma->vm_mm, vma, vmend, 0);
 			if (err)
 				goto out;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
 		}
 replace:
 		err = vma_replace_policy(vma, new_pol);
@@ -843,7 +834,7 @@ replace:
 			goto out;
 next:
 		prev = vma;
-	}
+	} for_each_vma_range(vmi, vma, end);
 
 out:
 	return err;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


