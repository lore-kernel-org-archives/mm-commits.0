From: akpm@linux-foundation.org
Subject: - ia64-ia32-nopage.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:35 -0800
Message-ID: <200712202337.lBKNbZoa018905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbXLTXrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: ia32 nopage
has been removed from the -mm tree.  Its filename was
     ia64-ia32-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: ia32 nopage
From: Nick Piggin <npiggin@suse.de>

Convert ia64's ia32 support from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/binfmt_elf32.c |   34 ++++++++++++++------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~ia64-ia32-nopage arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~ia64-ia32-nopage
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -52,33 +52,29 @@ extern struct page *ia32_shared_page[];
 extern unsigned long *ia32_gdt;
 extern struct page *ia32_gate_page;
 
-struct page *
-ia32_install_shared_page (struct vm_area_struct *vma, unsigned long address, int *type)
+int
+ia32_install_shared_page (struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct page *pg = ia32_shared_page[smp_processor_id()];
-	get_page(pg);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return pg;
-}
-
-struct page *
-ia32_install_gate_page (struct vm_area_struct *vma, unsigned long address, int *type)
-{
-	struct page *pg = ia32_gate_page;
-	get_page(pg);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return pg;
+	vmf->page = ia32_shared_page[smp_processor_id()];
+	get_page(vmf->page);
+	return 0;
+}
+
+int
+ia32_install_gate_page (struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	vmf->page = ia32_gate_page;
+	get_page(vmf->page);
+	return 0;
 }
 
 
 static struct vm_operations_struct ia32_shared_page_vm_ops = {
-	.nopage = ia32_install_shared_page
+	.fault = ia32_install_shared_page
 };
 
 static struct vm_operations_struct ia32_gate_page_vm_ops = {
-	.nopage = ia32_install_gate_page
+	.fault = ia32_install_gate_page
 };
 
 void
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
usb-mon-nopage.patch
git-x86.patch
slub-use-non-atomic-bit-unlock.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-radix_tree_preloading.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
