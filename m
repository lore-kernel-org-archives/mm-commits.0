From: akpm@linux-foundation.org
Subject: - use-generic_access_phys-for-pci-mmap-on-x86.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:55:28 -0700
Message-ID: <200807232308.m6NN85Rk016732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYGWXIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     use generic_access_phys for pci mmap on x86
has been removed from the -mm tree.  Its filename was
     use-generic_access_phys-for-pci-mmap-on-x86.patch

This patch was dropped because it was folded into use-generic_access_phys-for-dev-mem-mappings.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use generic_access_phys for pci mmap on x86
From: Rik van Riel <riel@redhat.com>

Use generic_access_phys for ptrace and /proc/pid/mem access to PCI device
memory on x86.  This makes it possible to debug the X server.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrensmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/i386.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/pci/i386.c~use-generic_access_phys-for-pci-mmap-on-x86 arch/x86/pci/i386.c
--- a/arch/x86/pci/i386.c~use-generic_access_phys-for-pci-mmap-on-x86
+++ a/arch/x86/pci/i386.c
@@ -280,6 +280,7 @@ static void pci_track_mmap_page_range(st
 static struct vm_operations_struct pci_mmap_ops = {
 	.open  = pci_track_mmap_page_range,
 	.close = pci_unmap_page_range,
+	.access = generic_access_phys,
 };
 
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from riel@redhat.com are

access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch

