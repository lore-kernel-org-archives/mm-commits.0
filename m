From: akpm@linux-foundation.org
Subject: + vmcoreinfo-fix-the-configuration-dependencies.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:59:56 -0800
Message-ID: <200711260759.lAQ7xuPf023343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbXKZIAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 03:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com


The patch titled
     vmcoreinfo: fix the configuration dependencies
has been added to the -mm tree.  Its filename is
     vmcoreinfo-fix-the-configuration-dependencies.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmcoreinfo: fix the configuration dependencies
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

This patch fixes the configuration dependencies in the vmcoreinfo data.

i386's "node_data" is defined in arch/x86/mm/discontig_32.c,
and x86_64's one is defined in arch/x86/mm/numa_64.c.
They depend on CONFIG_NUMA:
  arch/x86/mm/Makefile_32:7
    obj-$(CONFIG_NUMA) += discontig_32.o
  arch/x86/mm/Makefile_64:7
    obj-$(CONFIG_NUMA) += numa_64.o

ia64's "pgdat_list" is defined in arch/ia64/mm/discontig.c,
and it depends on CONFIG_DISCONTIGMEM and CONFIG_SPARSEMEM:
  arch/ia64/mm/Makefile:9-10
    obj-$(CONFIG_DISCONTIGMEM) += discontig.o
    obj-$(CONFIG_SPARSEMEM)    += discontig.o

ia64's "node_memblk" is defined in arch/ia64/mm/numa.c,
and it depends on CONFIG_NUMA:
  arch/ia64/mm/Makefile:8
    obj-$(CONFIG_NUMA)         += numa.o

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/machine_kexec.c   |    5 +++--
 arch/x86/kernel/machine_kexec_32.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/machine_kexec.c~vmcoreinfo-fix-the-configuration-dependencies arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~vmcoreinfo-fix-the-configuration-dependencies
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -129,10 +129,11 @@ void machine_kexec(struct kimage *image)
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#if defined(CONFIG_ARCH_DISCONTIGMEM_ENABLE) && defined(CONFIG_NUMA)
+#if defined(CONFIG_DISCONTIGMEM) || defined(CONFIG_SPARSEMEM)
 	VMCOREINFO_SYMBOL(pgdat_list);
 	VMCOREINFO_LENGTH(pgdat_list, MAX_NUMNODES);
-
+#endif
+#ifdef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(node_memblk);
 	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
 	VMCOREINFO_STRUCT_SIZE(node_memblk_s);
diff -puN arch/x86/kernel/machine_kexec_32.c~vmcoreinfo-fix-the-configuration-dependencies arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~vmcoreinfo-fix-the-configuration-dependencies
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -151,7 +151,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+#ifdef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch
vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch
vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch
vmcoreinfo-fix-the-configuration-dependencies.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
