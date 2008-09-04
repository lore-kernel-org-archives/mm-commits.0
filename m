From: akpm@linux-foundation.org
Subject: + x86_64-add-memory-hotremove-config-option.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:38:37 -0700
Message-ID: <200809042138.m84Lcbkm032473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbYIDVop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: garyhade@us.ibm.com


The patch titled
     x86_64: add memory hotremove config option
has been added to the -mm tree.  Its filename is
     x86_64-add-memory-hotremove-config-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: add memory hotremove config option
From: Gary Hade <garyhade@us.ibm.com>

Memory hotremove functionality can currently be configured into the ia64,
powerpc, and s390 kernels.  This patch makes it possible to configure the
memory hotremove functionality into the x86_64 kernel as well.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    3 +++
 arch/x86/mm/init_64.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff -puN arch/x86/Kconfig~x86_64-add-memory-hotremove-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86_64-add-memory-hotremove-config-option
+++ a/arch/x86/Kconfig
@@ -1456,6 +1456,9 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
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
@@ -740,6 +740,24 @@ int memory_add_physaddr_to_nid(u64 start
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

