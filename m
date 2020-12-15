Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0240AC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C1522D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgLOX65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgLOXUs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:48 -0500
Date:   Tue, 15 Dec 2020 15:19:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074373;
        bh=uio9lleo6lTtdEuphnAufBpt1brRqE403fuK7u8gI54=;
        h=From:To:Subject:From;
        b=OPTJ6U/+PScnyfAl2Svk8zRDqLZ07b9VTL20apMgUxUIQTeurA0kNuXPtDAgGf1pN
         /NYuTDboAOj41zXPHaSQw/Hwpn86nk5fj8wmR2AYVllf2OwU5wfbSKqAxjAOClGGO5
         qQhEXz2vP5VS2hqTDgSCC1XZ2AGC5vrptaL4DIDo=
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, catalin.marinas@arm.com,
        dan.carpenter@oracle.com, dan.j.williams@intel.com,
        dave.jiang@intel.com, dima@arista.com, hughd@google.com,
        jgg@ziepe.ca, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  [merged]
 mm-mremap-for-mremap_dontunmap-check-security_vm_enough_memory_mm.patch
 removed from -mm tree
Message-ID: <20201215231932.qPrrIwhKu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: for MREMAP_DONTUNMAP check security_vm_enough_memory_mm()
has been removed from the -mm tree.  Its filename was
     mm-mremap-for-mremap_dontunmap-check-security_vm_enough_memory_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: mm/mremap: for MREMAP_DONTUNMAP check security_vm_enough_memory_mm()

Currently memory is accounted post-mremap() with MREMAP_DONTUNMAP, which
may break overcommit policy.  So, check if there's enough memory before
doing actual VMA copy.

Don't unset VM_ACCOUNT on MREMAP_DONTUNMAP.  By semantics, such mremap()
is actually a memory allocation.  That also simplifies the error-path a
little.

Also, as it's memory allocation on success don't reset hiwater_vm value.

Link: https://lkml.kernel.org/r/20201013013416.390574-3-dima@arista.com
Fixes: commit e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/mremap.c~mm-mremap-for-mremap_dontunmap-check-security_vm_enough_memory_mm
+++ a/mm/mremap.c
@@ -515,11 +515,19 @@ static unsigned long move_vma(struct vm_
 	if (err)
 		return err;
 
+	if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT)) {
+		if (security_vm_enough_memory_mm(mm, new_len >> PAGE_SHIFT))
+			return -ENOMEM;
+	}
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
 			   &need_rmap_locks);
-	if (!new_vma)
+	if (!new_vma) {
+		if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT))
+			vm_unacct_memory(new_len >> PAGE_SHIFT);
 		return -ENOMEM;
+	}
 
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len,
 				     need_rmap_locks);
@@ -548,7 +556,7 @@ static unsigned long move_vma(struct vm_
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
-	if (vm_flags & VM_ACCOUNT) {
+	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
 		vma->vm_flags &= ~VM_ACCOUNT;
 		excess = vma->vm_end - vma->vm_start - old_len;
 		if (old_addr > vma->vm_start &&
@@ -573,34 +581,16 @@ static unsigned long move_vma(struct vm_
 		untrack_pfn_moved(vma);
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
-		if (vm_flags & VM_ACCOUNT) {
-			/* Always put back VM_ACCOUNT since we won't unmap */
-			vma->vm_flags |= VM_ACCOUNT;
-
-			vm_acct_memory(new_len >> PAGE_SHIFT);
-		}
-
-		/*
-		 * VMAs can actually be merged back together in copy_vma
-		 * calling merge_vma. This can happen with anonymous vmas
-		 * which have not yet been faulted, so if we were to consider
-		 * this VMA split we'll end up adding VM_ACCOUNT on the
-		 * next VMA, which is completely unrelated if this VMA
-		 * was re-merged.
-		 */
-		if (split && new_vma == vma)
-			split = 0;
-
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
 		/* Because we won't unmap we don't need to touch locked_vm */
-		goto out;
+		return new_addr;
 	}
 
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
-		if (vm_flags & VM_ACCOUNT)
+		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
 			vm_acct_memory(new_len >> PAGE_SHIFT);
 		excess = 0;
 	}
@@ -609,7 +599,7 @@ static unsigned long move_vma(struct vm_
 		mm->locked_vm += new_len >> PAGE_SHIFT;
 		*locked = true;
 	}
-out:
+
 	mm->hiwater_vm = hiwater_vm;
 
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
_

Patches currently in -mm which might be from dima@arista.com are


