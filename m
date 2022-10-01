Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAED5C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  1 Oct 2022 01:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiJABQz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Sep 2022 21:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiJABQS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2022 21:16:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1315FC1
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 18:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5857FB82AC3
        for <mm-commits@vger.kernel.org>; Sat,  1 Oct 2022 01:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037EBC433C1;
        Sat,  1 Oct 2022 01:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664586874;
        bh=nq7DwAMDSh0uN/QKxr/MjS/ftmzj3mEhg/LCwZWIefU=;
        h=Date:To:From:Subject:From;
        b=wRDLIlEHe0vlqcVk1Z0xJg2/9klxiXi1Y1JgfjlD/lwUfbi031C162ejzyxK/ei7q
         nJJ+uYpZ+NczegfC3ZlZ48l4cqbnKIDVMSrJz35/wVsgbQf1RDQiR0FuLpOoPFEG/U
         gAwh3/yYEjNjp+s6Q4Bc9j5r2dn96SQVvqOjqQtU=
Date:   Fri, 30 Sep 2022 18:14:33 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+2b9b4f0895be09a6dec3@syzkaller.appspotmail.com,
        mike.kravetz@oracle.com, liushixin2@huawei.com, edliaw@google.com,
        bgeffon@google.com, axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch added to mm-hotfixes-unstable branch
Message-Id: <20221001011434.037EBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in
Date: Fri, 30 Sep 2022 20:25:55 -0400

When PTE_MARKER_UFFD_WP not configured, it's still possible to reach pte
marker code and trigger an warning. Add a few CONFIG_PTE_MARKER_UFFD_WP
ifdefs to make sure the code won't be reached when not compiled in.

Link: https://lkml.kernel.org/r/YzeR+R6b4bwBlBHh@x1n
Fixes: 679d10331910180 ("mm: introduce PTE_MARKER swap entry")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: <syzbot+2b9b4f0895be09a6dec3@syzkaller.appspotmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Edward Liaw <edliaw@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    4 ++++
 mm/memory.c   |    2 ++
 mm/mprotect.c |    2 ++
 3 files changed, 8 insertions(+)

--- a/mm/hugetlb.c~mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/hugetlb.c
@@ -5059,6 +5059,7 @@ static void __unmap_hugepage_range(struc
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to
@@ -5070,6 +5071,7 @@ static void __unmap_hugepage_range(struc
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 			else
+#endif
 				huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
@@ -5098,11 +5100,13 @@ static void __unmap_hugepage_range(struc
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP));
+#endif
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
 
--- a/mm/memory.c~mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/memory.c
@@ -1393,10 +1393,12 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte,
 			      struct zap_details *details, pte_t pteval)
 {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	if (zap_drop_file_uffd_wp(details))
 		return;
 
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
+#endif
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
--- a/mm/mprotect.c~mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/mprotect.c
@@ -260,6 +260,7 @@ static unsigned long change_pte_range(st
 		} else {
 			/* It must be an none page, or what else?.. */
 			WARN_ON_ONCE(!pte_none(oldpte));
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			if (unlikely(uffd_wp && !vma_is_anonymous(vma))) {
 				/*
 				 * For file-backed mem, we need to be able to
@@ -271,6 +272,7 @@ static unsigned long change_pte_range(st
 					   make_pte_marker(PTE_MARKER_UFFD_WP));
 				pages++;
 			}
+#endif
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

