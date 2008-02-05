From: akpm@linux-foundation.org
Subject: - uml-remove-unused-fields-from-mm_context.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:33 -0800
Message-ID: <200802052238.m15McEDA012933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762140AbYBEWlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove unused fields from mm_context
has been removed from the -mm tree.  Its filename was
     uml-remove-unused-fields-from-mm_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove unused fields from mm_context
From: Jeff Dike <jdike@addtoit.com>

The 3-level page table fixes forgot to remove a couple now-unused fields from
struct mm_context.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/um_mmu.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/um/include/um_mmu.h~uml-remove-unused-fields-from-mm_context arch/um/include/um_mmu.h
--- a/arch/um/include/um_mmu.h~uml-remove-unused-fields-from-mm_context
+++ a/arch/um/include/um_mmu.h
@@ -12,10 +12,6 @@
 
 typedef struct mm_context {
 	struct mm_id id;
-	unsigned long last_page_table;
-#ifdef CONFIG_3_LEVEL_PGTABLES
-	unsigned long last_pmd;
-#endif
 	struct uml_ldt ldt;
 } mm_context_t;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
