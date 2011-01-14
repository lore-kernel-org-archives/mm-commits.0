From: akpm@linux-foundation.org
Subject: [merged] thp-dont-allow-transparent-hugepage-support-without-pse.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:17 -0800
Message-ID: <201101142251.p0EMp7V1005475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: don't allow transparent hugepage support without PSE
has been removed from the -mm tree.  Its filename was
     thp-dont-allow-transparent-hugepage-support-without-pse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: don't allow transparent hugepage support without PSE
From: Andrea Arcangeli <aarcange@redhat.com>

Archs implementing Transparent Hugepage Support must implement a function
called has_transparent_hugepage to be sure the virtual or physical CPU
supports Transparent Hugepages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 mm/huge_memory.c               |    8 ++++++++
 2 files changed, 13 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~thp-dont-allow-transparent-hugepage-support-without-pse arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~thp-dont-allow-transparent-hugepage-support-without-pse
+++ a/arch/x86/include/asm/pgtable.h
@@ -160,6 +160,11 @@ static inline int pmd_trans_huge(pmd_t p
 {
 	return pmd_val(pmd) & _PAGE_PSE;
 }
+
+static inline int has_transparent_hugepage(void)
+{
+	return cpu_has_pse;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
diff -puN mm/huge_memory.c~thp-dont-allow-transparent-hugepage-support-without-pse mm/huge_memory.c
--- a/mm/huge_memory.c~thp-dont-allow-transparent-hugepage-support-without-pse
+++ a/mm/huge_memory.c
@@ -487,7 +487,15 @@ static int __init hugepage_init(void)
 	int err;
 #ifdef CONFIG_SYSFS
 	static struct kobject *hugepage_kobj;
+#endif
 
+	err = -EINVAL;
+	if (!has_transparent_hugepage()) {
+		transparent_hugepage_flags = 0;
+		goto out;
+	}
+
+#ifdef CONFIG_SYSFS
 	err = -ENOMEM;
 	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
 	if (unlikely(!hugepage_kobj)) {
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

