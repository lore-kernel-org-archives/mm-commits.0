From: akpm@linux-foundation.org
Subject: + cris-tlb-handling-turn-local_save_flags-local_irq_disable.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:01:44 -0800
Message-ID: <200702092301.l19N1i98028681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53078 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbXBIXBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, starvik@axis.com


The patch titled
     CRIS: TLB handling: turn local_save_flags() + local_irq_disable() into local_irq_save()
has been added to the -mm tree.  Its filename is
     cris-tlb-handling-turn-local_save_flags-local_irq_disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS: TLB handling: turn local_save_flags() + local_irq_disable() into local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

TLB handling for CRIS contains local_irq_disable() after local_save_flags().
Turn this into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/mm/tlb.c |    9 +++------
 arch/cris/arch-v32/mm/tlb.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -puN arch/cris/arch-v10/mm/tlb.c~cris-tlb-handling-turn-local_save_flags-local_irq_disable arch/cris/arch-v10/mm/tlb.c
--- a/arch/cris/arch-v10/mm/tlb.c~cris-tlb-handling-turn-local_save_flags-local_irq_disable
+++ a/arch/cris/arch-v10/mm/tlb.c
@@ -42,8 +42,7 @@ flush_tlb_all(void)
 	 * in the same 4-way entry group. details.. 
 	 */
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		*R_TLB_SELECT = ( IO_FIELD(R_TLB_SELECT, index, i) );
 		*R_TLB_HI = ( IO_FIELD(R_TLB_HI, page_id, INVALID_PAGEID ) |
@@ -78,8 +77,7 @@ flush_tlb_mm(struct mm_struct *mm)
 	 * global pages. is it worth the extra I/O ? 
 	 */
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		*R_TLB_SELECT = IO_FIELD(R_TLB_SELECT, index, i);
 		if (IO_EXTRACT(R_TLB_HI, page_id, *R_TLB_HI) == page_id) {
@@ -118,8 +116,7 @@ flush_tlb_page(struct vm_area_struct *vm
 	 * and the virtual address requested 
 	 */
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		unsigned long tlb_hi;
 		*R_TLB_SELECT = IO_FIELD(R_TLB_SELECT, index, i);
diff -puN arch/cris/arch-v32/mm/tlb.c~cris-tlb-handling-turn-local_save_flags-local_irq_disable arch/cris/arch-v32/mm/tlb.c
--- a/arch/cris/arch-v32/mm/tlb.c~cris-tlb-handling-turn-local_save_flags-local_irq_disable
+++ a/arch/cris/arch-v32/mm/tlb.c
@@ -54,8 +54,7 @@ __flush_tlb_all(void)
 	 * Mask with 0xf so similar TLB entries aren't written in the same 4-way
 	 * entry group.
 	 */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 
 	for (mmu = 1; mmu <= 2; mmu++) {
 		SUPP_BANK_SEL(mmu); /* Select the MMU */
@@ -92,8 +91,7 @@ __flush_tlb_mm(struct mm_struct *mm)
 		return;
 
 	/* Mark the TLB entries that match the page_id as invalid. */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 
 	for (mmu = 1; mmu <= 2; mmu++) {
 		SUPP_BANK_SEL(mmu);
@@ -140,8 +138,7 @@ __flush_tlb_page(struct vm_area_struct *
 	 * Invalidate those TLB entries that match both the mm context and the
 	 * requested virtual address.
 	 */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 
 	for (mmu = 1; mmu <= 2; mmu++) {
 		SUPP_BANK_SEL(mmu);
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-scsi-misc.patch
git-ipwireless_cs.patch
cris-local_irq_disable-is-redundant-after-local_irq_save.patch
cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch
cris-tlb-handling-turn-local_save_flags-local_irq_disable.patch
char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
