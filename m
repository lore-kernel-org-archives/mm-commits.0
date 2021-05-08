Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42000C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1735261402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWnS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWnS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 910BC6100C;
        Sat,  8 May 2021 22:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513735;
        bh=dGUBPWtPu+7Aa4KLzGJmUqCp/yPb4lFYaX6ta0/VfRM=;
        h=Date:From:To:Subject:From;
        b=nxK3KnOxcS3FlI+/K9St+1Yx0o+VeJGSXKwTJMAKPAPhBKhMX1S5tzaPXyERjWNpk
         bXu5SeQ9/c5HUwBY5YpvuVOMl72uaj0mHP+DV8/7S+O4WjwOSDWqGYle/fwoSO6gxq
         nu7aclcOVou5JXB/qYuvY6m16VrGlQkTs+uJUgnk=
Date:   Sat, 08 May 2021 15:42:14 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, aarcange@redhat.com, alx.manpages@gmail.com,
        axelrasmussen@google.com, bgeffon@google.com, hughd@google.com,
        kirill@shutemov.name, lokeshgidra@google.com, luto@amacapital.net,
        minchan@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        mtk.manpages@gmail.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sonnyrao@google.com, vbabka@suse.cz
Subject:  [merged]
 revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio.patch
 removed from -mm tree
Message-ID: <20210508224214.zhS6M8Lc4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mremap: don't allow MREMAP_DONTUNMAP on special_mappings and aio"
has been removed from the -mm tree.  Its filename was
     revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: Revert "mremap: don't allow MREMAP_DONTUNMAP on special_mappings and aio"

This reverts commit cd544fd1dc9293c6702fab6effa63dac1cc67e99.

As discussed in [1] this commit was a no-op because the mapping type was
checked in vma_to_resize before move_vma is ever called.  This meant that
vm_ops->mremap() would never be called on such mappings.  Furthermore,
we've since expanded support of MREMAP_DONTUNMAP to non-anonymous
mappings, and these special mappings are still protected by the existing
check of !VM_DONTEXPAND and !VM_PFNMAP which will result in a -EINVAL.

1. https://lkml.org/lkml/2020/12/28/2340

Link: https://lkml.kernel.org/r/20210323182520.2712101-2-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Alejandro Colomar <alx.manpages@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |    2 +-
 fs/aio.c                                  |    5 +----
 include/linux/mm.h                        |    2 +-
 mm/mmap.c                                 |    6 +-----
 mm/mremap.c                               |    2 +-
 5 files changed, 5 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c~revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1458,7 +1458,7 @@ static int pseudo_lock_dev_release(struc
 	return 0;
 }
 
-static int pseudo_lock_dev_mremap(struct vm_area_struct *area, unsigned long flags)
+static int pseudo_lock_dev_mremap(struct vm_area_struct *area)
 {
 	/* Not supported */
 	return -EINVAL;
--- a/fs/aio.c~revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/fs/aio.c
@@ -323,16 +323,13 @@ static void aio_free_ring(struct kioctx
 	}
 }
 
-static int aio_ring_mremap(struct vm_area_struct *vma, unsigned long flags)
+static int aio_ring_mremap(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
 	struct kioctx_table *table;
 	int i, res = -EINVAL;
 
-	if (flags & MREMAP_DONTUNMAP)
-		return -EINVAL;
-
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
--- a/include/linux/mm.h~revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/include/linux/mm.h
@@ -580,7 +580,7 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	/* Called any time before splitting to check if it's allowed */
 	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
-	int (*mremap)(struct vm_area_struct *area, unsigned long flags);
+	int (*mremap)(struct vm_area_struct *area);
 	/*
 	 * Called by mprotect() to make driver-specific permission
 	 * checks before mprotect() is finalised.   The VMA must not
--- a/mm/mmap.c~revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/mm/mmap.c
@@ -3409,14 +3409,10 @@ static const char *special_mapping_name(
 	return ((struct vm_special_mapping *)vma->vm_private_data)->name;
 }
 
-static int special_mapping_mremap(struct vm_area_struct *new_vma,
-				  unsigned long flags)
+static int special_mapping_mremap(struct vm_area_struct *new_vma)
 {
 	struct vm_special_mapping *sm = new_vma->vm_private_data;
 
-	if (flags & MREMAP_DONTUNMAP)
-		return -EINVAL;
-
 	if (WARN_ON_ONCE(current->mm != new_vma->vm_mm))
 		return -EFAULT;
 
--- a/mm/mremap.c~revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
+++ a/mm/mremap.c
@@ -545,7 +545,7 @@ static unsigned long move_vma(struct vm_
 	if (moved_len < old_len) {
 		err = -ENOMEM;
 	} else if (vma->vm_ops && vma->vm_ops->mremap) {
-		err = vma->vm_ops->mremap(new_vma, flags);
+		err = vma->vm_ops->mremap(new_vma);
 	}
 
 	if (unlikely(err)) {
_

Patches currently in -mm which might be from bgeffon@google.com are


