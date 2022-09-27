Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7C6C6FA86
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiI0Crq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiI0Crc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0E36171E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F553B81902
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC8FC433C1;
        Tue, 27 Sep 2022 02:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246848;
        bh=G6aDR2Qm85kz1Hx5H4OhY4GOs2gn6x4VoN+YyMpyG9k=;
        h=Date:To:From:Subject:From;
        b=XVTeItEJshAhwiumUFdikJ1RXe5gp7XC2jjAheOZLe1WmfctNZV7VZPu+r/pYzOqD
         ORchD8ygOb9V0Ahgr5KEJDBsmGsn3mW/y7Y6TC5rmecZ/ewwqGuZc6GMtF3cLZNfy9
         t6/lk83+uJMZo4WbNWfOK9EfBg+tsVWUPyPM7aJk=
Date:   Mon, 26 Sep 2022 19:47:27 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, dave.hansen@intel.com,
        apopple@nvidia.com, andi.kleen@intel.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-comment-all-the-ifdef-in-swapopsh.patch removed from -mm tree
Message-Id: <20220927024728.0EC8FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: comment all the ifdef in swapops.h
has been removed from the -mm tree.  Its filename was
     mm-swap-comment-all-the-ifdef-in-swapopsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/swap: comment all the ifdef in swapops.h
Date: Thu, 11 Aug 2022 12:13:26 -0400

swapops.h contains quite a few layers of ifdef, some of the "else" and
"endif" doesn't get proper comment on the macro so it's hard to follow on
what are they referring to.  Add the comments.

Link: https://lkml.kernel.org/r/20220811161331.37055-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/swapops.h~mm-swap-comment-all-the-ifdef-in-swapopsh
+++ a/include/linux/swapops.h
@@ -247,8 +247,8 @@ extern void migration_entry_wait(struct
 #ifdef CONFIG_HUGETLB_PAGE
 extern void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl);
 extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
-#endif
-#else
+#endif	/* CONFIG_HUGETLB_PAGE */
+#else  /* CONFIG_MIGRATION */
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
@@ -276,7 +276,7 @@ static inline void migration_entry_wait(
 #ifdef CONFIG_HUGETLB_PAGE
 static inline void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl) { }
 static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
-#endif
+#endif	/* CONFIG_HUGETLB_PAGE */
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
@@ -286,7 +286,7 @@ static inline int is_readable_migration_
 	return 0;
 }
 
-#endif
+#endif	/* CONFIG_MIGRATION */
 
 typedef unsigned long pte_marker;
 
@@ -426,7 +426,7 @@ static inline int is_pmd_migration_entry
 {
 	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
 }
-#else
+#else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
@@ -455,7 +455,7 @@ static inline int is_pmd_migration_entry
 {
 	return 0;
 }
-#endif
+#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
 #ifdef CONFIG_MEMORY_FAILURE
 
@@ -490,7 +490,7 @@ static inline void num_poisoned_pages_su
 	atomic_long_sub(i, &num_poisoned_pages);
 }
 
-#else
+#else  /* CONFIG_MEMORY_FAILURE */
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
 {
@@ -509,7 +509,7 @@ static inline void num_poisoned_pages_in
 static inline void num_poisoned_pages_sub(long i)
 {
 }
-#endif
+#endif  /* CONFIG_MEMORY_FAILURE */
 
 static inline int non_swap_entry(swp_entry_t entry)
 {
_

Patches currently in -mm which might be from peterx@redhat.com are


