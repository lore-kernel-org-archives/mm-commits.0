Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ECDC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB95522B51
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgLODJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgLODJK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:09:10 -0500
Date:   Mon, 14 Dec 2020 19:08:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001699;
        bh=Bh2BujTZjt1h2NA+p0bHiGGzFzRcnCYmzov9OZWjyAM=;
        h=From:To:Subject:In-Reply-To:From;
        b=aNnbZ/jZimcRPwiJ1YEws1vB/YV0WbLe19bhaUkHt/DMmxIHLIOMP5aE/i3MGNUnN
         RHx81jsxyrOX3kRlqRuKV1zhbpddLDdq3GOk8Cgg+miXdinjKdGqvlpUxDA0eCBI/R
         //1gTjhRsnoP5u+e/cDZDHCq39uLiyPyRMXzqF3Y=
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
Subject:  [patch 087/200] vm_ops: rename .split() callback to
 .may_split()
Message-ID: <20201215030817.6PryQmza_%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>
Subject: vm_ops: rename .split() callback to .may_split()

Rename the callback to reflect that it's not called *on* or *after* split,
but rather some time before the splitting to check if it's possible.

Link: https://lkml.kernel.org/r/20201013013416.390574-5-dima@arista.com
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

 drivers/dax/device.c |    4 ++--
 include/linux/mm.h   |    3 ++-
 ipc/shm.c            |    8 ++++----
 mm/hugetlb.c         |    2 +-
 mm/mmap.c            |    4 ++--
 5 files changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/dax/device.c~vm_ops-rename-split-callback-to-may_split
+++ a/drivers/dax/device.c
@@ -256,7 +256,7 @@ static vm_fault_t dev_dax_fault(struct v
 	return dev_dax_huge_fault(vmf, PE_SIZE_PTE);
 }
 
-static int dev_dax_split(struct vm_area_struct *vma, unsigned long addr)
+static int dev_dax_may_split(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct file *filp = vma->vm_file;
 	struct dev_dax *dev_dax = filp->private_data;
@@ -277,7 +277,7 @@ static unsigned long dev_dax_pagesize(st
 static const struct vm_operations_struct dax_vm_ops = {
 	.fault = dev_dax_fault,
 	.huge_fault = dev_dax_huge_fault,
-	.split = dev_dax_split,
+	.may_split = dev_dax_may_split,
 	.pagesize = dev_dax_pagesize,
 };
 
--- a/include/linux/mm.h~vm_ops-rename-split-callback-to-may_split
+++ a/include/linux/mm.h
@@ -557,7 +557,8 @@ enum page_entry_size {
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
-	int (*split)(struct vm_area_struct * area, unsigned long addr);
+	/* Called any time before splitting to check if it's allowed */
+	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct *area, unsigned long flags);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
--- a/ipc/shm.c~vm_ops-rename-split-callback-to-may_split
+++ a/ipc/shm.c
@@ -434,13 +434,13 @@ static vm_fault_t shm_fault(struct vm_fa
 	return sfd->vm_ops->fault(vmf);
 }
 
-static int shm_split(struct vm_area_struct *vma, unsigned long addr)
+static int shm_may_split(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 
-	if (sfd->vm_ops->split)
-		return sfd->vm_ops->split(vma, addr);
+	if (sfd->vm_ops->may_split)
+		return sfd->vm_ops->may_split(vma, addr);
 
 	return 0;
 }
@@ -582,7 +582,7 @@ static const struct vm_operations_struct
 	.open	= shm_open,	/* callback for a new vm-area open */
 	.close	= shm_close,	/* callback for when the vm-area is released */
 	.fault	= shm_fault,
-	.split	= shm_split,
+	.may_split = shm_may_split,
 	.pagesize = shm_pagesize,
 #if defined(CONFIG_NUMA)
 	.set_policy = shm_set_policy,
--- a/mm/hugetlb.c~vm_ops-rename-split-callback-to-may_split
+++ a/mm/hugetlb.c
@@ -3673,7 +3673,7 @@ const struct vm_operations_struct hugetl
 	.fault = hugetlb_vm_op_fault,
 	.open = hugetlb_vm_op_open,
 	.close = hugetlb_vm_op_close,
-	.split = hugetlb_vm_op_split,
+	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
 };
 
--- a/mm/mmap.c~vm_ops-rename-split-callback-to-may_split
+++ a/mm/mmap.c
@@ -2731,8 +2731,8 @@ int __split_vma(struct mm_struct *mm, st
 	struct vm_area_struct *new;
 	int err;
 
-	if (vma->vm_ops && vma->vm_ops->split) {
-		err = vma->vm_ops->split(vma, addr);
+	if (vma->vm_ops && vma->vm_ops->may_split) {
+		err = vma->vm_ops->may_split(vma, addr);
 		if (err)
 			return err;
 	}
_
