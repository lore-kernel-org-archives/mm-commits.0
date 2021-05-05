Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5D0C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60BB861415
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhEEBgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230451AbhEEBgn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62D8D6140F;
        Wed,  5 May 2021 01:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178546;
        bh=MMnxZRafg49jSancWKzcRK9JqITgkXif/9fd1lNcf8c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M9h4I5qPX6eIci5TYLKb2qfdFFS12r5gN98JzaoJ3NIHefyGyrr4pJyk3RzqWr4bv
         Hyza9cJXFQosIDlv8I+E9RbT4+dBS6Fsw9e+aWXQSM8ObIEYXFgb/Z8JaeZgRJ8T4L
         2afw0V5C4eCHG20ZeD+ojJ02yrzvBF+KFBPt8FWk=
Date:   Tue, 04 May 2021 18:35:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org,
        lokeshgidra@google.com, mike.kravetz@oracle.com, mingo@redhat.com,
        mkoutny@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rostedt@goodmis.org, rppt@linux.vnet.ibm.com,
        ruprecht@google.com, shawn@anastas.io, shli@fb.com,
        steven.price@arm.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 056/143] userfaultfd: hugetlbfs: only compile UFFD
 helpers if config enabled
Message-ID: <20210505013545.iT2lFP6ap%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: hugetlbfs: only compile UFFD helpers if config enabled

For background, mm/userfaultfd.c provides a general mcopy_atomic
implementation.  But some types of memory (i.e., hugetlb and shmem) need a
slightly different implementation, so they provide their own helpers for
this.  In other words, userfaultfd is the only caller of these functions.

This patch achieves two things:

1. Don't spend time compiling code which will end up never being
   referenced anyway (a small build time optimization).

2. In patches later in this series, we extend the signature of these
   helpers with UFFD-specific state (a mode enumeration).  Once this
   happens, we *have to* either not compile the helpers, or
   unconditionally define the UFFD-only state (which seems messier to me).
   This includes the declarations in the headers, as otherwise they'd
   yield warnings about implicitly defining the type of those arguments.

Link: https://lkml.kernel.org/r/20210301222728.176417-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Price <steven.price@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++++
 mm/hugetlb.c            |    2 ++
 2 files changed, 6 insertions(+)

--- a/include/linux/hugetlb.h~userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled
+++ a/include/linux/hugetlb.h
@@ -134,11 +134,13 @@ void hugetlb_show_meminfo(void);
 unsigned long hugetlb_total_pages(void);
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
+#ifdef CONFIG_USERFAULTFD
 int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm, pte_t *dst_pte,
 				struct vm_area_struct *dst_vma,
 				unsigned long dst_addr,
 				unsigned long src_addr,
 				struct page **pagep);
+#endif /* CONFIG_USERFAULTFD */
 bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
 						vm_flags_t vm_flags);
@@ -310,6 +312,7 @@ static inline void hugetlb_free_pgd_rang
 	BUG();
 }
 
+#ifdef CONFIG_USERFAULTFD
 static inline int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 						pte_t *dst_pte,
 						struct vm_area_struct *dst_vma,
@@ -320,6 +323,7 @@ static inline int hugetlb_mcopy_atomic_p
 	BUG();
 	return 0;
 }
+#endif /* CONFIG_USERFAULTFD */
 
 static inline pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
 					unsigned long sz)
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled
+++ a/mm/hugetlb.c
@@ -4855,6 +4855,7 @@ out_mutex:
 	return ret;
 }
 
+#ifdef CONFIG_USERFAULTFD
 /*
  * Used by userfaultfd UFFDIO_COPY.  Based on mcopy_atomic_pte with
  * modifications for huge pages.
@@ -4985,6 +4986,7 @@ out_release_nounlock:
 	put_page(page);
 	goto out;
 }
+#endif /* CONFIG_USERFAULTFD */
 
 static void record_subpages_vmas(struct page *page, struct vm_area_struct *vma,
 				 int refs, struct page **pages,
_
