Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0369BC41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjJRVUY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjJRVUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:20:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFB7118
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:20:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4DAC433CA;
        Wed, 18 Oct 2023 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664018;
        bh=0v13AagMICHSpZRLiVecghFPYP4nMz94jg/6ilgNLtE=;
        h=Date:To:From:Subject:From;
        b=QfwTzOngTMLpk6VHoi4GH9bQ5dHZZJZXbi2gD5jKmvd+rYj+ROdDHjWa/anbcYhtB
         CdK1VVFgYt+AZ+DlctRm880SiGI1EOd/Tnj8VsIOOA3tThmiclrg39uWBFDukYU4I4
         FkCJockT9HII3WWCBRh/pA+S3Tjh+Pmre3zRe9NQ=
Date:   Wed, 18 Oct 2023 14:20:17 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, arnd@arndb.de, sfr@canb.auug.org.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix.patch removed from -mm tree
Message-Id: <20231018212017.EF4DAC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fix for "fs/proc/task_mmu: hide unused pagemap_scan_backout_range() function"
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix.patch

This patch was dropped because it was folded into fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix for "fs/proc/task_mmu: hide unused pagemap_scan_backout_range() function"
Date: Thu, 28 Sep 2023 09:09:26 +1000

Link: https://lkml.kernel.org/r/20230928092223.0625c6bf@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix
+++ a/fs/proc/task_mmu.c
@@ -1940,6 +1940,7 @@ static void make_uffd_wp_huge_pte(struct
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
 }
+#endif /* CONFIG_HUGETLB_PAGE */
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
 static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
@@ -1954,7 +1955,7 @@ static void pagemap_scan_backout_range(s
 
 	p->found_pages -= (end - addr) / PAGE_SIZE;
 }
-#endif /* CONFIG_HUGETLB_PAGE */
+#endif
 
 static bool pagemap_scan_is_interesting_page(unsigned long categories,
 					     const struct pagemap_scan_private *p)
@@ -1967,7 +1968,6 @@ static bool pagemap_scan_is_interesting_
 
 	return true;
 }
-#endif
 
 static bool pagemap_scan_is_interesting_vma(unsigned long categories,
 					    const struct pagemap_scan_private *p)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

