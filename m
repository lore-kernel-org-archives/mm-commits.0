From: akpm@linux-foundation.org
Subject: [merged] thp-transparent-hugepage-config-choice.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:09 -0800
Message-ID: <201101142250.p0EMox61005457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901Ab1ANWvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: transparent hugepage config choice
has been removed from the -mm tree.  Its filename was
     thp-transparent-hugepage-config-choice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: transparent hugepage config choice
From: Andrea Arcangeli <aarcange@redhat.com>

Allow to choose between the always|madvise default for page faults and
khugepaged at config time.  madvise guarantees zero risk of higher memory
footprint for applications (applications using madvise(MADV_HUGEPAGE)
won't risk to use any more memory by backing their virtual regions with
hugepages).

Initially set the default to N and don't depend on EMBEDDED.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig       |   27 +++++++++++++++++++++++++--
 mm/huge_memory.c |    5 +++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~thp-transparent-hugepage-config-choice mm/Kconfig
--- a/mm/Kconfig~thp-transparent-hugepage-config-choice
+++ a/mm/Kconfig
@@ -303,9 +303,8 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  See Documentation/nommu-mmap.txt for more information.
 
 config TRANSPARENT_HUGEPAGE
-	bool "Transparent Hugepage Support" if EMBEDDED
+	bool "Transparent Hugepage Support"
 	depends on X86 && MMU
-	default y
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
 	  huge tlb transparently to the applications whenever possible.
@@ -316,6 +315,30 @@ config TRANSPARENT_HUGEPAGE
 
 	  If memory constrained on embedded, you may want to say N.
 
+choice
+	prompt "Transparent Hugepage Support sysfs defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_ALWAYS
+	help
+	  Selects the sysfs defaults for Transparent Hugepage Support.
+
+	config TRANSPARENT_HUGEPAGE_ALWAYS
+		bool "always"
+	help
+	  Enabling Transparent Hugepage always, can increase the
+	  memory footprint of applications without a guaranteed
+	  benefit but it will work automatically for all applications.
+
+	config TRANSPARENT_HUGEPAGE_MADVISE
+		bool "madvise"
+	help
+	  Enabling Transparent Hugepage madvise, will only provide a
+	  performance improvement benefit to the applications using
+	  madvise(MADV_HUGEPAGE) but it won't risk to increase the
+	  memory footprint of applications without a guaranteed
+	  benefit.
+endchoice
+
 #
 # UP and nommu archs use km based percpu allocator
 #
diff -puN mm/huge_memory.c~thp-transparent-hugepage-config-choice mm/huge_memory.c
--- a/mm/huge_memory.c~thp-transparent-hugepage-config-choice
+++ a/mm/huge_memory.c
@@ -27,7 +27,12 @@
  * allocations.
  */
 unsigned long transparent_hugepage_flags __read_mostly =
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
 	(1<<TRANSPARENT_HUGEPAGE_FLAG)|
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
+	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
+#endif
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

