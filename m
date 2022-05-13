Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B48C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356867AbiEMCxN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiEMCxN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:53:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E3F6C0EA
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D08D6B828B3
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F74EC385B8;
        Fri, 13 May 2022 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410389;
        bh=wphjjojgCyp69h/SFJSFhQE+RaCuq0Mxd5fYNlZrYGE=;
        h=Date:To:From:Subject:From;
        b=dhcJB/r0s8Z8Qf52Uj6ti7jbWebROlUvk1tWoI3DxuWYC+n4yI2LZBXzmYAREpuKG
         +hE29hRaya++A/cIfLsWuTIjPQ8MvRjIX5HUnvQWBV7qmkUuWx7jETZUheziibPRlH
         f5zZcZTCdbYuP8LbZ7y3K7Nhiyphz/o3h/AplG3o=
Date:   Thu, 12 May 2022 19:53:08 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-pte_marker-swap-entry-fix.patch removed from -mm tree
Message-Id: <20220513025309.7F74EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup! mm: Introduce PTE_MARKER swap entry
has been removed from the -mm tree.  Its filename was
     mm-introduce-pte_marker-swap-entry-fix.patch

This patch was dropped because it was folded into mm-introduce-pte_marker-swap-entry.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm: Introduce PTE_MARKER swap entry

Link: https://lkml.kernel.org/r/Yk2rdB7SXZf+2BDF@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/s390/include/asm/hugetlb.h~mm-introduce-pte_marker-swap-entry-fix
+++ a/arch/s390/include/asm/hugetlb.h
@@ -85,6 +85,11 @@ static inline int huge_pte_none(pte_t pt
 	return pte_none(pte);
 }
 
+static inline int huge_pte_none_mostly(pte_t pte)
+{
+	return huge_pte_none(pte);
+}
+
 static inline int huge_pte_write(pte_t pte)
 {
 	return pte_write(pte);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-teach-core-mm-about-pte-markers-fix.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-check-against-orig_pte-for-finish_fault-fix.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-uffd-pte_marker_uffd_wp-fix.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
mm-enable-pte-markers-by-default-fix.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch
mm-uffd-move-userfaultfd-configs-into-mm.patch

