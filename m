Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D08BC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiDFB4Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443516AbiDFBPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 21:15:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9512B10FC3
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 16:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456EAB81E4F
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 23:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D49C385A0;
        Tue,  5 Apr 2022 23:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649200116;
        bh=V2887bw1RCDfFFxDp90oZ83Yj1IFO2dzrwOuaZw385U=;
        h=Date:To:From:Subject:From;
        b=z10gh28yfyiBscdLSXiWfCNqBsopALFoRL2C6OZT9FdxgEVKqEMwyOePP7u19VTzJ
         NIoWtoBrhaf/VQCB8CbbrIo7YDHMFIUEygqregWhlIigYx8/ROYCSIkepTaXfmpSRp
         p6mxWo8UMvuaN52cYLgnWLwXVVHx4YKbVoGpIcNw=
Date:   Tue, 05 Apr 2022 16:08:36 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-pte_marker_uffd_wp-fix.patch added to -mm tree
Message-Id: <20220405230836.C6D49C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm/uffd: PTE_MARKER_UFFD_WP
has been added to the -mm tree.  Its filename is
     mm-uffd-pte_marker_uffd_wp-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-uffd-pte_marker_uffd_wp-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-uffd-pte_marker_uffd_wp-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

