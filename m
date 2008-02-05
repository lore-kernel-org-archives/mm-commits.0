From: akpm@linux-foundation.org
Subject: - uml-tidy-pgtableh-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:08 -0800
Message-ID: <200802052235.m15MZnYi012645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762332AbYBEWlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     UML - Fix build in 2.6.24-rc2-mm1
has been removed from the -mm tree.  Its filename was
     uml-tidy-pgtableh-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UML - Fix build in 2.6.24-rc2-mm1
From: Jeff Dike <jdike@addtoit.com>

The earlier pgtable.h tidying patch made things a bit too tidy.  Add
back a header which is needed in VMALLOC_START and friend.  Also add
back a definition of pmd_page_vaddr, which is needed on x86_64.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-um/pgtable.h~uml-tidy-pgtableh-fix include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-tidy-pgtableh-fix
+++ a/include/asm-um/pgtable.h
@@ -9,6 +9,7 @@
 #define __UM_PGTABLE_H
 
 #include "linux/sched.h"
+#include <asm/fixmap.h>
 
 #define _PAGE_PRESENT	0x001
 #define _PAGE_NEWPAGE	0x002
@@ -308,6 +309,7 @@ static inline pte_t pte_modify(pte_t pte
  * this macro returns the index of the entry in the pmd page which would
  * control the given virtual address
  */
+#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
 /*
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
