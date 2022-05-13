Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E17C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377209AbiEMTVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383694AbiEMTVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7121826F1
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B058B83135
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA08C34100;
        Fri, 13 May 2022 19:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469651;
        bh=nSa9A9unKNJGpnxx+/sXc7yZS32rcaK97kSpd5+4JnQ=;
        h=Date:To:From:Subject:From;
        b=ff+xkaKh4VwWKgFs2WH39vXhxdnFgI0izPFSvjRvCFskRmMfp4nEbxLWWjRcNhZkf
         pEHf8/pnHkOF9l64bNyS+zSTLvd/sEkrv0qp0hjMWrY8b8GZQMtOKkyiDiOVubGrox
         v/PqZklQa+Jvnb43E26TamCfo5VEgifPxqGv0r6w=
Date:   Fri, 13 May 2022 12:20:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-pte_marker_uffd_wp.patch removed from -mm tree
Message-Id: <20220513192051.CDA08C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: PTE_MARKER_UFFD_WP
has been removed from the -mm tree.  Its filename was
     mm-uffd-pte_marker_uffd_wp.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[peterx@redhat.com: fixup]
  Link: https://lkml.kernel.org/r/YkzKiM8tI4+qOfXF@xz-m1.local
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
 include/linux/userfaultfd_k.h |   47 ++++++++++++++++++++++++++++++++
 mm/Kconfig                    |    9 ++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

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
@@ -236,4 +238,49 @@ static inline void userfaultfd_unmap_com
 
 #endif /* CONFIG_USERFAULTFD */
 
+static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
+{
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	return is_pte_marker_entry(entry) &&
+	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
+#else
+	return false;
+#endif
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


