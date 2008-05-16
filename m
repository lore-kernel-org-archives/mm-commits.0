From: akpm@linux-foundation.org
Subject: + use-generic_access_phys-for-pci-mmap-on-x86.patch added to -mm tree
Date: Thu, 15 May 2008 17:22:15 -0700
Message-ID: <200805160022.m4G0MGQI018065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYEPAWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org


The patch titled
     use generic_access_phys for pci mmap on x86
has been added to the -mm tree.  Its filename is
     use-generic_access_phys-for-pci-mmap-on-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
make-mm-rmapc-anon_vma_cachep-static.patch

