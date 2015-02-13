From: akpm@linux-foundation.org
Subject: [merged]
 ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:19:21 -0800
Message-ID: <54de5c49.Elq2LLdohwCUp6yT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbBMUTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ppc64: add paranoid warnings for unexpected DSISR_PROTFAULT
has been removed from the -mm tree.  Its filename was
     ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: ppc64: add paranoid warnings for unexpected DSISR_PROTFAULT

ppc64 should not be depending on DSISR_PROTFAULT and it's unexpected if
they are triggered.  This patch adds warnings just in case they are being
accidentally depended upon.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/copro_fault.c |    8 ++++++--
 arch/powerpc/mm/fault.c       |   20 +++++++++-----------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff -puN arch/powerpc/mm/copro_fault.c~ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault arch/powerpc/mm/copro_fault.c
--- a/arch/powerpc/mm/copro_fault.c~ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault
+++ a/arch/powerpc/mm/copro_fault.c
@@ -64,10 +64,14 @@ int copro_handle_mm_fault(struct mm_stru
 		if (!(vma->vm_flags & VM_WRITE))
 			goto out_unlock;
 	} else {
-		if (dsisr & DSISR_PROTFAULT)
-			goto out_unlock;
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
 			goto out_unlock;
+		/*
+		 * protfault should only happen due to us
+		 * mapping a region readonly temporarily. PROT_NONE
+		 * is also covered by the VMA check above.
+		 */
+		WARN_ON_ONCE(dsisr & DSISR_PROTFAULT);
 	}
 
 	ret = 0;
diff -puN arch/powerpc/mm/fault.c~ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault
+++ a/arch/powerpc/mm/fault.c
@@ -389,17 +389,6 @@ good_area:
 #endif /* CONFIG_8xx */
 
 	if (is_exec) {
-#ifdef CONFIG_PPC_STD_MMU
-		/* Protection fault on exec go straight to failure on
-		 * Hash based MMUs as they either don't support per-page
-		 * execute permission, or if they do, it's handled already
-		 * at the hash level. This test would probably have to
-		 * be removed if we change the way this works to make hash
-		 * processors use the same I/D cache coherency mechanism
-		 * as embedded.
-		 */
-#endif /* CONFIG_PPC_STD_MMU */
-
 		/*
 		 * Allow execution from readable areas if the MMU does not
 		 * provide separate controls over reading and executing.
@@ -414,6 +403,14 @@ good_area:
 		    (cpu_has_feature(CPU_FTR_NOEXECUTE) ||
 		     !(vma->vm_flags & (VM_READ | VM_WRITE))))
 			goto bad_area;
+#ifdef CONFIG_PPC_STD_MMU
+		/*
+		 * protfault should only happen due to us
+		 * mapping a region readonly temporarily. PROT_NONE
+		 * is also covered by the VMA check above.
+		 */
+		WARN_ON_ONCE(error_code & DSISR_PROTFAULT);
+#endif /* CONFIG_PPC_STD_MMU */
 	/* a write */
 	} else if (is_write) {
 		if (!(vma->vm_flags & VM_WRITE))
@@ -423,6 +420,7 @@ good_area:
 	} else {
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
 			goto bad_area;
+		WARN_ON_ONCE(error_code & DSISR_PROTFAULT);
 	}
 
 	/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

