Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8566E82CA7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjI0Pz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbjI0PzJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:55:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7DC19E
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 08:53:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610DBC433C8;
        Wed, 27 Sep 2023 15:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695829995;
        bh=C5KJjQMG7OMlt1RB/DVduJb0FMRgEDjfrMH4Pq0OrSk=;
        h=Date:To:From:Subject:From;
        b=ywVDV51D9tBn8lBAv3oTnGLQ+qKvbKkpPsQBbcjM2Hv8GHMNS7a6C5xaA3oQN172O
         0Y7OZegFBG7ealeNsVszgmkeVLOzk1mAL3lAwxHTiEqHexnq99ROo0SZhd+gSWG006
         ObJDRpOCKPyV2ZQ+EPD1S42aR9e6wrY6dY/unDPM=
Date:   Wed, 27 Sep 2023 08:53:14 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch added to mm-unstable branch
Message-Id: <20230927155315.610DBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu: hide unused pagemap_scan_backout_range() function
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch

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

fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch

