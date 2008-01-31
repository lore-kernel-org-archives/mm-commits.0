From: akpm@linux-foundation.org
Subject: + add-remove_memory-for-ppc64-3.patch added to -mm tree
Date: Wed, 30 Jan 2008 17:16:37 -0800
Message-ID: <200801310116.m0V1Gb11001855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbYAaBRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 20:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org, y-goto@jp.fujitsu.com


The patch titled
     ppc64: add remove_memory()
has been added to the -mm tree.  Its filename is
     add-remove_memory-for-ppc64-3.patch

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
Subject: ppc64: add remove_memory()
From: Badari Pulavarty <pbadari@us.ibm.com>

Supply ppc64 remove_memory() function.  Arch specific is still being
reviewed by Paul Mackerras.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/powerpc/mm/mem.c~add-remove_memory-for-ppc64-3 arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~add-remove_memory-for-ppc64-3
+++ a/arch/powerpc/mm/mem.c
@@ -129,6 +129,22 @@ int __devinit arch_add_memory(int nid, u
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+	int ret;
+
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, 120 * HZ);
+	if (ret)
+		goto out;
+	/* Arch-specific calls go here - next patch */
+out:
+	return ret;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 void show_mem(void)
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-3.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mem-controller-gfp-mask-fix.patch
mount-options-fix-hugetlbfs.patch
