From: akpm@linux-foundation.org
Subject: + uml-tidy-pgtableh-fix.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:10:15 -0800
Message-ID: <200711160010.lAG0AFL5023012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbXKPAK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:10:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     UML - Fix build in 2.6.24-rc2-mm1
has been added to the -mm tree.  Its filename is
     uml-tidy-pgtableh-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
b.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
