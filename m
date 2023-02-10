Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2517EC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjBJAxs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjBJAxB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C5D6E9A6
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A74261C11
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B494EC433EF;
        Fri, 10 Feb 2023 00:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990375;
        bh=U2EcqU1R3uzt8FpTamX6D6On/PpsSWhFgIeJ86rI/A0=;
        h=Date:To:From:Subject:From;
        b=KsUd4gb7ZawNEnRacJdXIz10SE2E1P9eO5ww+GJVTjFhPUEOvLBBvK08AYJGCknjy
         Xse/yXKhRyezSNP/95MLtMJGKFnNONhlF+GxkXS5HvpsySMcMuIIJl4qc5vIZKvqXX
         ZCkVb4N34vLGOazkZK/f/HG+Qvpf+gBkgeOXCEUk=
Date:   Thu, 09 Feb 2023 16:52:55 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch removed from -mm tree
Message-Id: <20230210005255.B494EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise: use vmi iterator for __split_vma() and vma_merge()
has been removed from the -mm tree.  Its filename was
     madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: madvise: use vmi iterator for __split_vma() and vma_merge()
Date: Fri, 20 Jan 2023 11:26:24 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-24-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~madvise-use-vmi-iterator-for-__split_vma-and-vma_merge
+++ a/mm/madvise.c
@@ -142,6 +142,7 @@ static int madvise_update_vma(struct vm_
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
 		*prev = vma;
@@ -149,8 +150,8 @@ static int madvise_update_vma(struct vm_
 	}
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
-	*prev = vma_merge(mm, *prev, start, end, new_flags, vma->anon_vma,
-			  vma->vm_file, pgoff, vma_policy(vma),
+	*prev = vmi_vma_merge(&vmi, mm, *prev, start, end, new_flags,
+			  vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
 			  vma->vm_userfaultfd_ctx, anon_name);
 	if (*prev) {
 		vma = *prev;
@@ -162,7 +163,7 @@ static int madvise_update_vma(struct vm_
 	if (start != vma->vm_start) {
 		if (unlikely(mm->map_count >= sysctl_max_map_count))
 			return -ENOMEM;
-		error = __split_vma(mm, vma, start, 1);
+		error = vmi__split_vma(&vmi, mm, vma, start, 1);
 		if (error)
 			return error;
 	}
@@ -170,7 +171,7 @@ static int madvise_update_vma(struct vm_
 	if (end != vma->vm_end) {
 		if (unlikely(mm->map_count >= sysctl_max_map_count))
 			return -ENOMEM;
-		error = __split_vma(mm, vma, end, 0);
+		error = vmi__split_vma(&vmi, mm, vma, end, 0);
 		if (error)
 			return error;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


