Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CBAC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391130AbiDFB46 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbiDEUdG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E415CF9F84
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 959BA6198D
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE2AC385A3;
        Tue,  5 Apr 2022 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189799;
        bh=srR0OKmdyzLfWINK4wobRT03MiQwRESIoXhmMfV/1Jc=;
        h=Date:To:From:Subject:From;
        b=R1s1BYXxWGL/jjim3GsBezeK/RWnY6N+VFq9N2Y3yjsu73oSZZvL8twrvCOBtWIRI
         QCV8LluzitwPUYaWuwbo4tahHsfDZ6bDWCPaak+P6JTOva8L2iJTzcXtwRgtNbwn3r
         4MaHCdEjh2Y1GMiW0XgnjomVnn8Ov5NJCHAqGCpE=
Date:   Tue, 05 Apr 2022 13:16:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-pte_marker_uffd_wp.patch added to -mm tree
Message-Id: <20220405201638.ECE2AC385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: PTE_MARKER_UFFD_WP
has been added to the -mm tree.  Its filename is
     mm-uffd-pte_marker_uffd_wp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-uffd-pte_marker_uffd_wp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-uffd-pte_marker_uffd_wp.patch

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
Subject: mm/uffd: PTE_MARKER_UFFD_WP

This patch introduces the 1st user of pte marker: the uffd-wp marker.

When the pte marker is installed with the uffd-wp bit set, it means this
pte was wr-protected by uffd.

We will use this special pte to arm the ptes that got either unmapped or
swapped out for a file-backed region that was previously wr-protected. 
This special pte could trigger a page fault just like swap entries.

This idea is greatly inspired by Hugh and Andrea in the discussion, which
is referenced in the links below.

Some helpers are introduced to detect whether a swap pte is uffd
wr-protected.  After the pte marker introduced, one swap pte can be
wr-protected in two forms: either it is a normal swap pte and it has
_PAGE_SWP_UFFD_WP set, or it's a pte marker that has PTE_MARKER_UFFD_WP
set.

Link: https://lore.kernel.org/lkml/20201126222359.8120-1-peterx@redhat.com/
Link: https://lore.kernel.org/lkml/20201130230603.46187-1-peterx@redhat.com/
Link: https://lkml.kernel.org/r/20220405014838.14131-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h       |    3 +-
 include/linux/userfaultfd_k.h |   43 ++++++++++++++++++++++++++++++++
 mm/Kconfig                    |    9 ++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

--- a/include/linux/swapops.h~mm-uffd-pte_marker_uffd_wp
+++ a/include/linux/swapops.h
@@ -276,7 +276,8 @@ static inline int is_readable_migration_
 
 typedef unsigned long pte_marker;
 
-#define  PTE_MARKER_MASK     (0)
+#define  PTE_MARKER_UFFD_WP  BIT(0)
+#define  PTE_MARKER_MASK     (PTE_MARKER_UFFD_WP)
 
 #ifdef CONFIG_PTE_MARKER
 
--- a/include/linux/userfaultfd_k.h~mm-uffd-pte_marker_uffd_wp
+++ a/include/linux/userfaultfd_k.h
@@ -15,6 +15,8 @@
 
 #include <linux/fcntl.h>
 #include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 #include <asm-generic/pgtable_uffd.h>
 
 /* The set of all possible UFFD-related VM flags. */
@@ -236,4 +238,45 @@ static inline void userfaultfd_unmap_com
 
 #endif /* CONFIG_USERFAULTFD */
 
+static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
+{
+	return is_pte_marker_entry(entry) &&
+	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
+}
+
+static inline bool pte_marker_uffd_wp(pte_t pte)
+{
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	swp_entry_t entry;
+
+	if (!is_swap_pte(pte))
+		return false;
+
+	entry = pte_to_swp_entry(pte);
+
+	return pte_marker_entry_uffd_wp(entry);
+#else
+	return false;
+#endif
+}
+
+/*
+ * Returns true if this is a swap pte and was uffd-wp wr-protected in either
+ * forms (pte marker or a normal swap pte), false otherwise.
+ */
+static inline bool pte_swp_uffd_wp_any(pte_t pte)
+{
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!is_swap_pte(pte))
+		return false;
+
+	if (pte_swp_uffd_wp(pte))
+		return true;
+
+	if (pte_marker_uffd_wp(pte))
+		return true;
+#endif
+	return false;
+}
+
 #endif /* _LINUX_USERFAULTFD_K_H */
--- a/mm/Kconfig~mm-uffd-pte_marker_uffd_wp
+++ a/mm/Kconfig
@@ -915,6 +915,15 @@ config PTE_MARKER
 	help
 	  Allows to create marker PTEs for file-backed memory.
 
+config PTE_MARKER_UFFD_WP
+	bool "Marker PTEs support for userfaultfd write protection"
+	depends on PTE_MARKER && HAVE_ARCH_USERFAULTFD_WP
+
+	help
+	  Allows to create marker PTEs for userfaultfd write protection
+	  purposes.  It is required to enable userfaultfd write protection on
+	  file-backed memory types like shmem and hugetlbfs.
+
 source "mm/damon/Kconfig"
 
 endmenu
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

