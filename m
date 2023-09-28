Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45491E732E5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjI1QER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjI1QEQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:04:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B338D6
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 09:04:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E19C433C8;
        Thu, 28 Sep 2023 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695917054;
        bh=8QmpPvsL3ti+ZRyaHv5jPTIQMSNTNPKoeFNrOKhVblI=;
        h=Date:To:From:Subject:From;
        b=QJ9xc8VNfF4vaHK41L5v7VkR1cdwe4LAAScA9SewdCEr/tHN6vke/DVmjwIA7crUN
         4MgxRBOJPrH6IajVTKEreHwBejmAhnRHjn6SX/dtCL06mj1iKFf7qD31MXV8PNRrHY
         KgpX7z6hXqBqcbNWSTB8ecXP2F3Lu6q0LjrncYDQ=
Date:   Thu, 28 Sep 2023 09:04:13 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, arnd@arndb.de, sfr@canb.auug.org.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix.patch added to mm-unstable branch
Message-Id: <20230928160414.71E19C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Thu, 28 Sep 2023 09:09:26 +1000
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Sep 2023 09:09:26 +1000
Subject: fix for "fs/proc/task_mmu: hide unused pagemap_scan_backout_range() function"

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

fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3-fix.patch

