Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A2ACD4857
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 18:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjIYSa5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 14:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjIYSa5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 14:30:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA8B9B
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 11:30:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDFEC433CA;
        Mon, 25 Sep 2023 18:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695666650;
        bh=GMGV0un6B+pzlG43vTu5tnBWXT3/iCCSfUPFUjHU8jw=;
        h=Date:To:From:Subject:From;
        b=ulV/wHuE22ZtVtdY56yNfi9nlyIQ2kpzg68+w9a6cTBwD/XEwxq0eGucAvoJhPGlK
         nSlsHZO2wiE5EceLwFp9o1yx38jfXS7k3F502Np8mkR3LpOX6sy2nHc/xH2YAGsSwk
         OpCcLPu/dy6MdqdtGSGv4f9C8Ysn4JLPmygRBDqk=
Date:   Mon, 25 Sep 2023 11:30:49 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch added to mm-unstable branch
Message-Id: <20230925183050.1FDFEC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch

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
Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix
Date: Mon Sep 25 11:28:48 AM PDT 2023

update it for "mm: hugetlb: add huge page size param to set_huge_pte_at()".

Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix
+++ a/mm/hugetlb.c
@@ -6238,7 +6238,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		}
 
 		entry = huge_pte_clear_uffd_wp(entry);
-		set_huge_pte_at(mm, haddr, ptep, entry);
+		set_huge_pte_at(mm, haddr, ptep, entry,
+				huge_page_size(hstate_vma(vma)));
 		/* Fallthrough to CoW */
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
vmscan-add-trace-events-for-lru_gen-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

