Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EACCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjJRVUX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjJRVUS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:20:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA8AFA
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:20:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8C7C433C9;
        Wed, 18 Oct 2023 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664017;
        bh=F6amvU8rlYDlBS0HlKTQ/vfUYnliMHvoNBeyBJGFPMQ=;
        h=Date:To:From:Subject:From;
        b=XD9ohPxLzR71qqSERZTWisOwiFDsCqutg6fNt8uUd68wHc7ugXdmdo7h8PAGvFeo2
         7WHkuQW725VSiZHm8M48ZKTynSYLtNuDsSL7A2fGAbe05j3KQWe9JxlYy6t3Myh0Gt
         BZMmvpdjQbiX9WB9X9lCKU/LXCY/PVECx25n9Lig=
Date:   Wed, 18 Oct 2023 14:20:16 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch removed from -mm tree
Message-Id: <20231018212016.DC8C7C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/task_mmu: hide unused pagemap_scan_backout_range() function
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch

This patch was dropped because it was folded into fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fs/proc/task_mmu: hide unused pagemap_scan_backout_range() function
Date: Wed, 27 Sep 2023 08:02:23 +0200

This function has two callers, each of which are hidden behind an #ifdef:

fs/proc/task_mmu.c:2022:13: error: 'pagemap_scan_backout_range' defined but not used [-Werror=unused-function]

Add another conditional to check for both options to avoid the
unused-function warning.

Link: https://lkml.kernel.org/r/20230927060257.2975412-1-arnd@kernel.org
Fixes: 93538f467c0f6 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3
+++ a/fs/proc/task_mmu.c
@@ -1941,6 +1941,7 @@ static void make_uffd_wp_huge_pte(struct
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
 }
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
 static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
 				       unsigned long addr, unsigned long end)
 {
@@ -1966,6 +1967,7 @@ static bool pagemap_scan_is_interesting_
 
 	return true;
 }
+#endif
 
 static bool pagemap_scan_is_interesting_vma(unsigned long categories,
 					    const struct pagemap_scan_private *p)
_

Patches currently in -mm which might be from arnd@arndb.de are

fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

