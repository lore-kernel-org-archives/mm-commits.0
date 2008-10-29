From: akpm@linux-foundation.org
Subject: - x86_64-add-memory-hotremove-config-option.patch removed from -mm tree
Date: Wed, 29 Oct 2008 15:58:41 -0700
Message-ID: <200810292258.m9TMwfMN024363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758752AbYJ2W7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 18:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garyhade@us.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: add memory hotremove config option
has been removed from the -mm tree.  Its filename was
     x86_64-add-memory-hotremove-config-option.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: add memory hotremove config option
From: Gary Hade <garyhade@us.ibm.com>

Memory hotremove functionality can currently be configured into the ia64,
powerpc, and s390 kernels.  This patch makes it possible to configure the
memory hotremove functionality into the x86_64 kernel as well.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    3 +++
 arch/x86/mm/init_64.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff -puN arch/x86/Kconfig~x86_64-add-memory-hotremove-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86_64-add-memory-hotremove-config-option
+++ a/arch/x86/Kconfig
@@ -1528,6 +1528,9 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+
 config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
diff -puN arch/x86/mm/init_64.c~x86_64-add-memory-hotremove-config-option arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86_64-add-memory-hotremove-config-option
+++ a/arch/x86/mm/init_64.c
@@ -856,6 +856,24 @@ int memory_add_physaddr_to_nid(u64 start
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+	unsigned long timeout = 120 * HZ;
+	int ret;
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, timeout);
+	if (ret)
+		goto out;
+	/* Arch-specific calls go here */
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 /*
_

Patches currently in -mm which might be from garyhade@us.ibm.com are

x86_64-add-memory-hotremove-config-option.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch

