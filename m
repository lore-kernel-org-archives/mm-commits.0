Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A22D052
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219301; cv=none; b=GAEqGuL9nmkdma8U5HOMeiBqQvXCdQwYOaynlwZNBTJ2U9BTyp128dJjdX97xzn/RdNlSHeJ28/wjjWSw1beSIOaD6eFER9zv00Y5yfngZyU0iDDV++loENscbQDoMEkGzKiywCZDwpaw/z0j4lMlAGxC+koFdBrwxqFiOZ8n1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219301; c=relaxed/simple;
	bh=HnCZYNKuijpXUNxucLd4Am86c1NGlb2AziCA2kBBYdw=;
	h=Date:To:From:Subject:Message-Id; b=TZfSh2DcC1m7y4v5XZrR5PuSpblKxHfDw5ueF1TVc/q3YhWHAvsGLbTWICL9pcR0YOY0D5H3HvEJKPDzUU2+7709gZocWhm8wwEhM7FVSjk5CrdOoBDNAEzRCIPDRNd7uzF72RztO5AafWu5PRMoMdkDT1OOYBXdOo9BNBnKRt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMjrw4G9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMjrw4G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474DAC4CEED;
	Fri, 15 Aug 2025 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755219301;
	bh=HnCZYNKuijpXUNxucLd4Am86c1NGlb2AziCA2kBBYdw=;
	h=Date:To:From:Subject:From;
	b=gMjrw4G9mmGZ41rKBDCUMXGHWCpwonjKpO8lRnfd4sl/d+1lfjeP5nLpvgt3X87mw
	 l/IbdF+fePKXhgciDJapla77aBc5gFARr5vE3lfL2JpaWdMGtQ275hXZ76AjD2weLd
	 ZdRKSh3Nual70+hzqe6fdYOTmqBKsaSuAvrf+QyA=
Date: Thu, 14 Aug 2025 17:55:00 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typos-in-vma-comments.patch added to mm-new branch
Message-Id: <20250815005501.474DAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix typos in VMA comments
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-typos-in-vma-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typos-in-vma-comments.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: fix typos in VMA comments
Date: Thu, 14 Aug 2025 15:37:59 +0800

Fix the following typos in VMA-related files:
1. "operationr" -> "operation" in mm/vma.h
2. "initialisaing" -> "initializing" in mm/vma_init.c

Link: https://lkml.kernel.org/r/20250814073800.13617-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h      |    2 +-
 mm/vma_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vma.h~mm-fix-typos-in-vma-comments
+++ a/mm/vma.h
@@ -145,7 +145,7 @@ struct vma_merge_struct {
 	 */
 	bool __remove_middle :1;
 	/*
-	 * Internal flag used during the merge operationr to indicate we will
+	 * Internal flag used during the merge operation to indicate we will
 	 * remove vmg->next.
 	 */
 	bool __remove_next :1;
--- a/mm/vma_init.c~mm-fix-typos-in-vma-comments
+++ a/mm/vma_init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 /*
- * Functions for initialisaing, allocating, freeing and duplicating VMAs. Shared
+ * Functions for initializing, allocating, freeing and duplicating VMAs. Shared
  * between CONFIG_MMU and non-CONFIG_MMU kernel configurations.
  */
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch
mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch
mm-fix-typos-in-vma-comments.patch

