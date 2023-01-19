Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD19AC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjASBVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjASBTu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E203F69B00
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A104AB81FB9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C760C433EF;
        Thu, 19 Jan 2023 01:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090990;
        bh=KTgbZYrxEMXloYknp68XC/AzXIIJCZBmejDxXwU5acI=;
        h=Date:To:From:Subject:From;
        b=GcacczgzyO2b6KMEMFt1j1xtfUpwxLmCuGQQ4Dhc7f0ZeIl+dbyo4dZj5+4rnGmnO
         x/o9OEN/BLuZYcgJJpnWx9BSU7hFZebJFkDY7rtW/zt3zxNRSQibGUQLS2xOyeEPpC
         CsgHSXZvPoojfBlxbKzQqYa9u2DZmPDcmfaUCRMU=
Date:   Wed, 18 Jan 2023 17:16:29 -0800
To:     mm-commits@vger.kernel.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, axboe@kernel.dk,
        asml.silence@gmail.com, arnd@arndb.de, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch removed from -mm tree
Message-Id: <20230119011630.4C760C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/nommu: factor out check for NOMMU shared mappings into is_nommu_shared_mapping()
has been removed from the -mm tree.  Its filename was
     mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/nommu: factor out check for NOMMU shared mappings into is_nommu_shared_mapping()
Date: Mon, 2 Jan 2023 17:08:54 +0100

Patch series "mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings".

Trying to reduce the confusion around VM_SHARED and VM_MAYSHARE first
requires !CONFIG_MMU to stop using VM_MAYSHARE for MAP_PRIVATE mappings. 
CONFIG_MMU only sets VM_MAYSHARE for MAP_SHARED mappings.

This paves the way for further VM_MAYSHARE and VM_SHARED cleanups: for
example, renaming VM_MAYSHARED to VM_MAP_SHARED to make it cleaner what is
actually means.

Let's first get the weird case out of the way and not use VM_MAYSHARE in
MAP_PRIVATE mappings, using a new VM_MAYOVERLAY flag instead.


This patch (of 3):

We want to stop using VM_MAYSHARE in private mappings to pave the way for
clarifying the semantics of VM_MAYSHARE vs.  VM_SHARED and reduce the
confusion.  While CONFIG_MMU uses VM_MAYSHARE to represent MAP_SHARED,
!CONFIG_MMU also sets VM_MAYSHARE for selected R/O private file mappings
that are an effective overlay of a file mapping.

Let's factor out all relevant VM_MAYSHARE checks in !CONFIG_MMU code into
is_nommu_shared_mapping() first.

Note that whenever VM_SHARED is set, VM_MAYSHARE must be set as well
(unless there is a serious BUG).  So there is not need to test for
VM_SHARED manually.

No functional change intended.

Link: https://lkml.kernel.org/r/20230102160856.500584-1-david@redhat.com
Link: https://lkml.kernel.org/r/20230102160856.500584-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c    |    2 +-
 fs/cramfs/inode.c     |    2 +-
 fs/proc/task_nommu.c  |    2 +-
 fs/ramfs/file-nommu.c |    2 +-
 fs/romfs/mmap-nommu.c |    2 +-
 include/linux/mm.h    |   15 +++++++++++++++
 io_uring/io_uring.c   |    2 +-
 mm/nommu.c            |   11 ++++++-----
 8 files changed, 27 insertions(+), 11 deletions(-)

--- a/drivers/char/mem.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/drivers/char/mem.c
@@ -343,7 +343,7 @@ static unsigned zero_mmap_capabilities(s
 /* can't do an in-place private mapping if there's no MMU */
 static inline int private_mapping_ok(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_MAYSHARE;
+	return is_nommu_shared_mapping(vma->vm_flags);
 }
 #else
 
--- a/fs/cramfs/inode.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/fs/cramfs/inode.c
@@ -437,7 +437,7 @@ bailout:
 
 static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -ENOSYS;
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -ENOSYS;
 }
 
 static unsigned long cramfs_physmem_get_unmapped_area(struct file *file,
--- a/fs/proc/task_nommu.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/fs/proc/task_nommu.c
@@ -38,7 +38,7 @@ void task_mem(struct seq_file *m, struct
 		}
 
 		if (atomic_read(&mm->mm_count) > 1 ||
-		    vma->vm_flags & VM_MAYSHARE) {
+		    is_nommu_shared_mapping(vma->vm_flags)) {
 			sbytes += size;
 		} else {
 			bytes += size;
--- a/fs/ramfs/file-nommu.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/fs/ramfs/file-nommu.c
@@ -264,7 +264,7 @@ out:
  */
 static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (!(vma->vm_flags & (VM_SHARED | VM_MAYSHARE)))
+	if (!is_nommu_shared_mapping(vma->vm_flags))
 		return -ENOSYS;
 
 	file_accessed(file);
--- a/fs/romfs/mmap-nommu.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/fs/romfs/mmap-nommu.c
@@ -63,7 +63,7 @@ static unsigned long romfs_get_unmapped_
  */
 static int romfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -ENOSYS;
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -ENOSYS;
 }
 
 static unsigned romfs_mmap_capabilities(struct file *file)
--- a/include/linux/mm.h~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/include/linux/mm.h
@@ -1347,6 +1347,21 @@ static inline bool is_cow_mapping(vm_fla
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+#ifndef CONFIG_MMU
+static inline bool is_nommu_shared_mapping(vm_flags_t flags)
+{
+	/*
+	 * NOMMU shared mappings are ordinary MAP_SHARED mappings and selected
+	 * R/O MAP_PRIVATE file mappings that are an effective R/O overlay of
+	 * a file mapping. R/O MAP_PRIVATE mappings might still modify
+	 * underlying memory if ptrace is active, so this is only possible if
+	 * ptrace does not apply. Note that there is no mprotect() to upgrade
+	 * write permissions later.
+	 */
+	return flags & VM_MAYSHARE;
+}
+#endif
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
--- a/io_uring/io_uring.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/io_uring/io_uring.c
@@ -3206,7 +3206,7 @@ static __cold int io_uring_mmap(struct f
 
 static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -EINVAL;
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
 }
 
 static unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
--- a/mm/nommu.c~mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping
+++ a/mm/nommu.c
@@ -958,9 +958,10 @@ static int do_mmap_private(struct vm_are
 	 */
 	if (capabilities & NOMMU_MAP_DIRECT) {
 		ret = call_mmap(vma->vm_file, vma);
+		/* shouldn't return success if we're not sharing */
+		if (WARN_ON_ONCE(!is_nommu_shared_mapping(vma->vm_flags)))
+			ret = -ENOSYS;
 		if (ret == 0) {
-			/* shouldn't return success if we're not sharing */
-			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
 			vma->vm_region->vm_top = vma->vm_region->vm_end;
 			return 0;
 		}
@@ -1106,7 +1107,7 @@ unsigned long do_mmap(struct file *file,
 	 *   these cases, sharing is handled in the driver or filesystem rather
 	 *   than here
 	 */
-	if (vm_flags & VM_MAYSHARE) {
+	if (is_nommu_shared_mapping(vm_flags)) {
 		struct vm_region *pregion;
 		unsigned long pglen, rpglen, pgend, rpgend, start;
 
@@ -1116,7 +1117,7 @@ unsigned long do_mmap(struct file *file,
 		for (rb = rb_first(&nommu_region_tree); rb; rb = rb_next(rb)) {
 			pregion = rb_entry(rb, struct vm_region, vm_rb);
 
-			if (!(pregion->vm_flags & VM_MAYSHARE))
+			if (!is_nommu_shared_mapping(pregion->vm_flags))
 				continue;
 
 			/* search for overlapping mappings on the same file */
@@ -1600,7 +1601,7 @@ static unsigned long do_mremap(unsigned
 	if (vma->vm_end != vma->vm_start + old_len)
 		return (unsigned long) -EFAULT;
 
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (is_nommu_shared_mapping(vma->vm_flags))
 		return (unsigned long) -EPERM;
 
 	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
_

Patches currently in -mm which might be from david@redhat.com are

mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

