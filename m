Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BDEC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjASBVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjASBTu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC826B981
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40BDBB81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD731C433D2;
        Thu, 19 Jan 2023 01:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090992;
        bh=n9qjt/KuPRcBIfSUlA1kuMwKJj+klrPrmLN6adJlkQo=;
        h=Date:To:From:Subject:From;
        b=wTNCBwIVjLx9XQNpCzKiUe377sRqJglnH6Lxc7EDMr/PO6wSt/PSqid9OZqVJ3k+N
         02kkHEdXMYrpFXlKyp3Ni6Ye9VwC6ZLFejD+nDO7NtQScG6izpdmVtX3QVbd2PDBkX
         5syepQxuCfeTpYRuKXOOsqntBwA/scz7tQ3NfTyE=
Date:   Wed, 18 Jan 2023 17:16:31 -0800
To:     mm-commits@vger.kernel.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, axboe@kernel.dk,
        asml.silence@gmail.com, arnd@arndb.de, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch removed from -mm tree
Message-Id: <20230119011631.DD731C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings
has been removed from the -mm tree.  Its filename was
     mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings
Date: Mon, 2 Jan 2023 17:08:55 +0100

Let's stop using VM_MAYSHARE for MAP_PRIVATE mappings and use
VM_MAYOVERLAY instead.  Rewrite determine_vm_flags() to make the whole
logic easier to digest, and to cleanly separate MAP_PRIVATE vs. 
MAP_SHARED.

No functional change intended.

Link: https://lkml.kernel.org/r/20230102160856.500584-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++
 mm/nommu.c         |   51 +++++++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-nommu-dont-use-vm_mayshare-for-map_private-mappings
+++ a/include/linux/mm.h
@@ -276,7 +276,12 @@ extern unsigned int kobjsize(const void
 #define VM_MAYSHARE	0x00000080
 
 #define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#ifdef CONFIG_MMU
 #define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
+#else /* CONFIG_MMU */
+#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+#define VM_UFFD_MISSING	0
+#endif /* CONFIG_MMU */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
@@ -1358,7 +1363,7 @@ static inline bool is_nommu_shared_mappi
 	 * ptrace does not apply. Note that there is no mprotect() to upgrade
 	 * write permissions later.
 	 */
-	return flags & VM_MAYSHARE;
+	return flags & (VM_MAYSHARE | VM_MAYOVERLAY);
 }
 #endif
 
--- a/mm/nommu.c~mm-nommu-dont-use-vm_mayshare-for-map_private-mappings
+++ a/mm/nommu.c
@@ -892,29 +892,36 @@ static unsigned long determine_vm_flags(
 	unsigned long vm_flags;
 
 	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(flags);
-	/* vm_flags |= mm->def_flags; */
 
-	if (!(capabilities & NOMMU_MAP_DIRECT)) {
-		/* attempt to share read-only copies of mapped file chunks */
+	if (!file) {
+		/*
+		 * MAP_ANONYMOUS. MAP_SHARED is mapped to MAP_PRIVATE, because
+		 * there is no fork().
+		 */
 		vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
-		if (file && !(prot & PROT_WRITE))
-			vm_flags |= VM_MAYSHARE;
+	} else if (flags & MAP_PRIVATE) {
+		/* MAP_PRIVATE file mapping */
+		if (capabilities & NOMMU_MAP_DIRECT)
+			vm_flags |= (capabilities & NOMMU_VMFLAGS);
+		else
+			vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
+
+		if (!(prot & PROT_WRITE) && !current->ptrace)
+			/*
+			 * R/O private file mapping which cannot be used to
+			 * modify memory, especially also not via active ptrace
+			 * (e.g., set breakpoints) or later by upgrading
+			 * permissions (no mprotect()). We can try overlaying
+			 * the file mapping, which will work e.g., on chardevs,
+			 * ramfs/tmpfs/shmfs and romfs/cramf.
+			 */
+			vm_flags |= VM_MAYOVERLAY;
 	} else {
-		/* overlay a shareable mapping on the backing device or inode
-		 * if possible - used for chardevs, ramfs/tmpfs/shmfs and
-		 * romfs/cramfs */
-		vm_flags |= VM_MAYSHARE | (capabilities & NOMMU_VMFLAGS);
-		if (flags & MAP_SHARED)
-			vm_flags |= VM_SHARED;
+		/* MAP_SHARED file mapping: NOMMU_MAP_DIRECT is set. */
+		vm_flags |= VM_SHARED | VM_MAYSHARE |
+			    (capabilities & NOMMU_VMFLAGS);
 	}
 
-	/* refuse to let anyone share private mappings with this process if
-	 * it's being traced - otherwise breakpoints set in it may interfere
-	 * with another untraced process
-	 */
-	if ((flags & MAP_PRIVATE) && current->ptrace)
-		vm_flags &= ~VM_MAYSHARE;
-
 	return vm_flags;
 }
 
@@ -952,9 +959,11 @@ static int do_mmap_private(struct vm_are
 	void *base;
 	int ret, order;
 
-	/* invoke the file's mapping function so that it can keep track of
-	 * shared mappings on devices or memory
-	 * - VM_MAYSHARE will be set if it may attempt to share
+	/*
+	 * Invoke the file's mapping function so that it can keep track of
+	 * shared mappings on devices or memory. VM_MAYOVERLAY will be set if
+	 * it may attempt to share, which will make is_nommu_shared_mapping()
+	 * happy.
 	 */
 	if (capabilities & NOMMU_MAP_DIRECT) {
 		ret = call_mmap(vma->vm_file, vma);
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

