Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32AAC636D6
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjBJAyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjBJAxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C909F6F8DF
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C9A8B8239A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29806C4339B;
        Fri, 10 Feb 2023 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990390;
        bh=dPYfz1SUI8t/O3ArBVFHjvvv2FBTtHVN7nHJR8q42Kw=;
        h=Date:To:From:Subject:From;
        b=TZ9FvQUCvHMhjxYl3zrhDKyGYJDtfYUYthsLzqcrjcZBY3d9+11AkTtKRt+Wevp9O
         IAZhGo7Ix8OYvqtLsdFpkeTIMm5b9P1ydRbVen6Cp/DTE9cwo8ulKI1MVLPZQ7yR5U
         5xfUueoKNb5a6Avi+7MTquXAo2sPV860p7ixS0sQ=
Date:   Thu, 09 Feb 2023 16:53:09 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] madvise-use-split_vma-instead-of-__split_vma.patch removed from -mm tree
Message-Id: <20230210005310.29806C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise: use split_vma() instead of __split_vma()
has been removed from the -mm tree.  Its filename was
     madvise-use-split_vma-instead-of-__split_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: madvise: use split_vma() instead of __split_vma()
Date: Fri, 20 Jan 2023 11:26:34 -0500

The split_vma() wrapper is specifically for this use case, so use it.

[Liam.Howlett@oracle.com: fix VMA_ITERATOR start position]
  Link: https://lkml.kernel.org/r/20230125135809.85262-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230120162650.984577-34-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~madvise-use-split_vma-instead-of-__split_vma
+++ a/mm/madvise.c
@@ -142,7 +142,7 @@ static int madvise_update_vma(struct vm_
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
-	VMA_ITERATOR(vmi, mm, 0);
+	VMA_ITERATOR(vmi, mm, start);
 
 	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
 		*prev = vma;
@@ -161,17 +161,13 @@ static int madvise_update_vma(struct vm_
 	*prev = vma;
 
 	if (start != vma->vm_start) {
-		if (unlikely(mm->map_count >= sysctl_max_map_count))
-			return -ENOMEM;
-		error = __split_vma(&vmi, vma, start, 1);
+		error = split_vma(&vmi, vma, start, 1);
 		if (error)
 			return error;
 	}
 
 	if (end != vma->vm_end) {
-		if (unlikely(mm->map_count >= sysctl_max_map_count))
-			return -ENOMEM;
-		error = __split_vma(&vmi, vma, end, 0);
+		error = split_vma(&vmi, vma, end, 0);
 		if (error)
 			return error;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


