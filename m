Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841B8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 03:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376691AbiEMDUL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 23:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351676AbiEMDUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 23:20:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1743F1EEE0F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 20:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE70AB82BCC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 03:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F5C34114;
        Fri, 13 May 2022 03:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652412006;
        bh=T+VSrVIaf0M00ZDeqGNC5Xz7eGhjHE3trhL8801hEmk=;
        h=Date:To:From:Subject:From;
        b=CO/S4RvqdPAMEMfhKT5M+LDZ39lQ6uKoDcmXlL7AQyeS0WLosWu/Zbgm70ajSFcqb
         gOWAcRtHDYDhqXjThdeztjwe81mk6AY1clVOJ8tRzIwPMRuTT7tTWkcG7M0dg5jwlB
         gSJgm0Jyut1vdOZiyU2jpA0CVu3gQtCjd0lzRLds=
Date:   Thu, 12 May 2022 20:20:05 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-uffd-pte_marker_uffd_wp-fix.patch removed from -mm tree
Message-Id: <20220513032006.591F5C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup! mm/uffd: PTE_MARKER_UFFD_WP
has been removed from the -mm tree.  Its filename was
     mm-uffd-pte_marker_uffd_wp-fix.patch

This patch was dropped because it was folded into mm-uffd-pte_marker_uffd_wp.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm/uffd: PTE_MARKER_UFFD_WP

Link: https://lkml.kernel.org/r/YkzKiM8tI4+qOfXF@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/userfaultfd_k.h~mm-uffd-pte_marker_uffd_wp-fix
+++ a/include/linux/userfaultfd_k.h
@@ -240,8 +240,12 @@ static inline void userfaultfd_unmap_com
 
 static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
 {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	return is_pte_marker_entry(entry) &&
 	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
+#else
+	return false;
+#endif
 }
 
 static inline bool pte_marker_uffd_wp(pte_t pte)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
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
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch
mm-uffd-move-userfaultfd-configs-into-mm.patch

