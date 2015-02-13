From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:19:15 -0800
Message-ID: <54de5c43.iu4ysjeFm5CWko2X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbBMUTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add p[te|md] protnone helpers for use by NUMA balancing
has been removed from the -mm tree.  Its filename was
     mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: add p[te|md] protnone helpers for use by NUMA balancing

This is a preparatory patch that introduces protnone helpers for automatic
NUMA balancing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |   16 ++++++++++++++++
 arch/x86/include/asm/pgtable.h     |   16 ++++++++++++++++
 include/asm-generic/pgtable.h      |   20 ++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff -puN arch/powerpc/include/asm/pgtable.h~mm-add-p-protnone-helpers-for-use-by-numa-balancing arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~mm-add-p-protnone-helpers-for-use-by-numa-balancing
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -40,6 +40,22 @@ static inline int pte_none(pte_t pte)		{
 static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
 
 #ifdef CONFIG_NUMA_BALANCING
+/*
+ * These work without NUMA balancing but the kernel does not care. See the
+ * comment in include/asm-generic/pgtable.h . On powerpc, this will only
+ * work for user pages and always return true for kernel pages.
+ */
+static inline int pte_protnone(pte_t pte)
+{
+	return (pte_val(pte) &
+		(_PAGE_PRESENT | _PAGE_USER)) == _PAGE_PRESENT;
+}
+
+static inline int pmd_protnone(pmd_t pmd)
+{
+	return pte_protnone(pmd_pte(pmd));
+}
+
 static inline int pte_present(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_NUMA_MASK;
diff -puN arch/x86/include/asm/pgtable.h~mm-add-p-protnone-helpers-for-use-by-numa-balancing arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-add-p-protnone-helpers-for-use-by-numa-balancing
+++ a/arch/x86/include/asm/pgtable.h
@@ -483,6 +483,22 @@ static inline int pmd_present(pmd_t pmd)
 				 _PAGE_NUMA);
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+/*
+ * These work without NUMA balancing but the kernel does not care. See the
+ * comment in include/asm-generic/pgtable.h
+ */
+static inline int pte_protnone(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_PROTNONE;
+}
+
+static inline int pmd_protnone(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_PROTNONE;
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
 static inline int pmd_none(pmd_t pmd)
 {
 	/* Only check low word on 32-bit platforms, since it might be
diff -puN include/asm-generic/pgtable.h~mm-add-p-protnone-helpers-for-use-by-numa-balancing include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-add-p-protnone-helpers-for-use-by-numa-balancing
+++ a/include/asm-generic/pgtable.h
@@ -673,6 +673,26 @@ static inline int pmd_trans_unstable(pmd
 #endif
 }
 
+#ifndef CONFIG_NUMA_BALANCING
+/*
+ * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
+ * the only case the kernel cares is for NUMA balancing and is only ever set
+ * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
+ * _PAGE_PROTNONE so by by default, implement the helper as "always no". It
+ * is the responsibility of the caller to distinguish between PROT_NONE
+ * protections and NUMA hinting fault protections.
+ */
+static inline int pte_protnone(pte_t pte)
+{
+	return 0;
+}
+
+static inline int pmd_protnone(pmd_t pmd)
+{
+	return 0;
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * _PAGE_NUMA distinguishes between an unmapped page table entry, an entry that
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

