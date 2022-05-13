Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEBCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376588AbiEMC43 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352613AbiEMC43 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:56:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D9D237D4
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77B88B8015B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E4BC385B8;
        Fri, 13 May 2022 02:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410585;
        bh=dOWRH5lNdX2phEIVIZdo21di31DuWd4la++buPiK0q4=;
        h=Date:To:From:Subject:From;
        b=xWv6jfTA14PFwir56UxpY58NUtZPYQCSJU+fXdjLxJmqFSB/AS2O0sk+Pd3/M6KMN
         fY9CXkV7T8Imj6AxKFQsQulkfbTJaDDSa1GlLhuMuyjWQ0rEp8a5zO3owcNMtUKceC
         0RvO1cCMtu5E1W5dA8i1d1Et/YXxXD7RfT9dAjIg=
Date:   Thu, 12 May 2022 19:56:24 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-enable-pte-markers-by-default-fix.patch removed from -mm tree
Message-Id: <20220513025625.21E4BC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: hide PTE_MARKER option
has been removed from the -mm tree.  Its filename was
     mm-enable-pte-markers-by-default-fix.patch

This patch was dropped because it was folded into mm-enable-pte-markers-by-default.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: hide PTE_MARKER option

The PTE_MARKER option should not need to be exposed to the kernel builder,
keep it internal and remove the prompt so it won't be seen.

Instead, make the PTE_MARKER_UFFD_WP option to explicitly choose
PTE_MARKER when necessary.

While PTE_MARKER_UFFD_WP will still prompt to user, change the wording so
that it'll not mention PTE_MARKER at all but renaming it to "Userfaultfd
write protection support for shmem/hugetlbfs".

Link: https://lkml.kernel.org/r/20220419202531.27415-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/Kconfig~mm-enable-pte-markers-by-default-fix
+++ a/mm/Kconfig
@@ -910,16 +910,16 @@ config ANON_VMA_NAME
 	  difference in their name.
 
 config PTE_MARKER
-	bool "Marker PTEs support"
-	default y
+	bool
 
 	help
 	  Allows to create marker PTEs for file-backed memory.
 
 config PTE_MARKER_UFFD_WP
-	bool "Marker PTEs support for userfaultfd write protection"
+	bool "Userfaultfd write protection support for shmem/hugetlbfs"
 	default y
-	depends on PTE_MARKER && HAVE_ARCH_USERFAULTFD_WP
+	depends on HAVE_ARCH_USERFAULTFD_WP
+	select PTE_MARKER
 
 	help
 	  Allows to create marker PTEs for userfaultfd write protection
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
mm-uffd-move-userfaultfd-configs-into-mm.patch

