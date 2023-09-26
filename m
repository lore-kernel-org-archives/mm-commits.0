Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34578E7F146
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjIZXhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjIZXfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:35:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3849EEF
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:42:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE530C4166B;
        Tue, 26 Sep 2023 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695763498;
        bh=MxS0jvRBtskx1ixfX0nwLD/w4MdMA4KuySarWFXI1Ro=;
        h=Date:To:From:Subject:From;
        b=jO8zx57066e+xiY4YROIx3mrqQvI6TIJ/ReyeRHmdmxjaUX7X+dc/bdWbR97EpvpS
         fUFS8tmSPNPj7P413atCgnOchpyT6qkypo/u3zGIm6s5LP110R2KCsCIdJpaOBL4Ry
         oABuVNH+ENM+URBWsNSrp17fX6iAV96HmvmnVsHE=
Date:   Tue, 26 Sep 2023 14:24:57 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch added to mm-unstable branch
Message-Id: <20230926212457.EE530C4166B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2
Date: Tue Sep 26 02:20:27 PM PDT 2023

fix CONFIG_HUGETLB_PAGE=n warning

| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309260903.qzpqNFz3-lkp@intel.com/
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2
+++ a/fs/proc/task_mmu.c
@@ -1940,6 +1940,19 @@ static void make_uffd_wp_huge_pte(struct
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
 }
+
+static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
+				       unsigned long addr, unsigned long end)
+{
+	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
+
+	if (cur_buf->start != addr)
+		cur_buf->end = addr;
+	else
+		cur_buf->start = cur_buf->end = 0;
+
+	p->found_pages -= (end - addr) / PAGE_SIZE;
+}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 static bool pagemap_scan_is_interesting_page(unsigned long categories,
@@ -2019,19 +2032,6 @@ static bool pagemap_scan_push_range(unsi
 	return true;
 }
 
-static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
-				       unsigned long addr, unsigned long end)
-{
-	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
-
-	if (cur_buf->start != addr)
-		cur_buf->end = addr;
-	else
-		cur_buf->start = cur_buf->end = 0;
-
-	p->found_pages -= (end - addr) / PAGE_SIZE;
-}
-
 static int pagemap_scan_output(unsigned long categories,
 			       struct pagemap_scan_private *p,
 			       unsigned long addr, unsigned long *end)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
kthread-add-kthread_stop_put-v2-fix.patch

