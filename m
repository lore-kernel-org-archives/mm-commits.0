Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867A5C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjBJAxz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjBJAxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044D16BD33
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DF80B82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EB3C4339B;
        Fri, 10 Feb 2023 00:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990377;
        bh=AGbydGhHgcJF14wEAJJLl2rdpi4rTFW9qgZXenC1rNs=;
        h=Date:To:From:Subject:From;
        b=Nt17HW3tJBel9Sx2R30p2oFLm+V4dVSA4Lbnq7KGEhd326XyQGYndZ54G4FnhLp8h
         rd+UCa0n3HDiMxwhflCHfyUwnznHkgqT86DF5pye/xle+tIWQJ0jyZ+jiHcWPepSqT
         abMzv93hxWawzAjL2gto3j56uWnVMT/lBTQAJ+nQ=
Date:   Thu, 09 Feb 2023 16:52:56 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-pass-through-vmi-iterator-to-__split_vma.patch removed from -mm tree
Message-Id: <20230210005257.34EB3C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: pass through vmi iterator to __split_vma()
has been removed from the -mm tree.  Its filename was
     mmap-pass-through-vmi-iterator-to-__split_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mmap: pass through vmi iterator to __split_vma()
Date: Fri, 20 Jan 2023 11:26:25 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-25-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mmap-pass-through-vmi-iterator-to-__split_vma
+++ a/mm/mmap.c
@@ -2388,7 +2388,7 @@ do_vmi_align_munmap(struct vma_iterator
 		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
 			goto map_count_exceeded;
 
-		error = __split_vma(mm, vma, start, 0);
+		error = vmi__split_vma(vmi, mm, vma, start, 0);
 		if (error)
 			goto start_split_failed;
 
@@ -2409,7 +2409,7 @@ do_vmi_align_munmap(struct vma_iterator
 		if (next->vm_end > end) {
 			struct vm_area_struct *split;
 
-			error = __split_vma(mm, next, end, 1);
+			error = vmi__split_vma(vmi, mm, next, end, 1);
 			if (error)
 				goto end_split_failed;
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


