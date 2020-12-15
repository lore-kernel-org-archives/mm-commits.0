Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A6DC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855282246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgLOD1d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgLODI4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:56 -0500
Date:   Mon, 14 Dec 2020 19:08:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001695;
        bh=lVVw0He8RJWBqV3+ehAPPe7sH3QhSJtexexIpG7oiMY=;
        h=From:To:Subject:In-Reply-To:From;
        b=AVCOvbJq/V3lidLmIgI91yFUppDa2BxEVDwYDcg0hIc80BkqqlktSDbwCWBHjzCY6
         2NedJaFT/hf/AisnoCDGieBzL2Pol4fQsz/99WYNH8+Zu9v4WymqEyjvG6UxOGIb5d
         cLsOekeQ1CY5FQ6+ceXB8GhYcU6PyLpo5SyTq+7M=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgeffon@google.com,
        catalin.marinas@arm.com, dan.carpenter@oracle.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, dima@arista.com,
        hughd@google.com, jgg@ziepe.ca, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, vishal.l.verma@intel.com,
        will@kernel.org
Subject:  [patch 086/200] mremap: don't allow MREMAP_DONTUNMAP on
 special_mappings and aio
Message-ID: <20201215030813.I8VAWZGRf%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>
Subject: mremap: don't allow MREMAP_DONTUNMAP on special_mappings and aio

As kernel expect to see only one of such mappings, any further operations
on the VMA-copy may be unexpected by the kernel.  Maybe it's being on the
safe side, but there doesn't seem to be any expected use-case for this, so
restrict it now.

Link: https://lkml.kernel.org/r/20201013013416.390574-4-dima@arista.com
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

 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |    2 +-
 fs/aio.c                                  |    5 ++++-
 include/linux/mm.h                        |    2 +-
 mm/mmap.c                                 |    6 +++++-
 mm/mremap.c                               |    2 +-
 5 files changed, 12 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1458,7 +1458,7 @@ static int pseudo_lock_dev_release(struc
 	return 0;
 }
 
-static int pseudo_lock_dev_mremap(struct vm_area_struct *area)
+static int pseudo_lock_dev_mremap(struct vm_area_struct *area, unsigned long flags)
 {
 	/* Not supported */
 	return -EINVAL;
--- a/fs/aio.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/fs/aio.c
@@ -324,13 +324,16 @@ static void aio_free_ring(struct kioctx
 	}
 }
 
-static int aio_ring_mremap(struct vm_area_struct *vma)
+static int aio_ring_mremap(struct vm_area_struct *vma, unsigned long flags)
 {
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
 	struct kioctx_table *table;
 	int i, res = -EINVAL;
 
+	if (flags & MREMAP_DONTUNMAP)
+		return -EINVAL;
+
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
--- a/include/linux/mm.h~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/include/linux/mm.h
@@ -558,7 +558,7 @@ struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
-	int (*mremap)(struct vm_area_struct * area);
+	int (*mremap)(struct vm_area_struct *area, unsigned long flags);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
--- a/mm/mmap.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/mm/mmap.c
@@ -3405,10 +3405,14 @@ static const char *special_mapping_name(
 	return ((struct vm_special_mapping *)vma->vm_private_data)->name;
 }
 
-static int special_mapping_mremap(struct vm_area_struct *new_vma)
+static int special_mapping_mremap(struct vm_area_struct *new_vma,
+				  unsigned long flags)
 {
 	struct vm_special_mapping *sm = new_vma->vm_private_data;
 
+	if (flags & MREMAP_DONTUNMAP)
+		return -EINVAL;
+
 	if (WARN_ON_ONCE(current->mm != new_vma->vm_mm))
 		return -EFAULT;
 
--- a/mm/mremap.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/mm/mremap.c
@@ -534,7 +534,7 @@ static unsigned long move_vma(struct vm_
 	if (moved_len < old_len) {
 		err = -ENOMEM;
 	} else if (vma->vm_ops && vma->vm_ops->mremap) {
-		err = vma->vm_ops->mremap(new_vma);
+		err = vma->vm_ops->mremap(new_vma, flags);
 	}
 
 	if (unlikely(err)) {
_
