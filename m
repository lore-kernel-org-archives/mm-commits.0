From: akpm@linux-foundation.org
Subject: + mm-remove-x86-only-restriction-of-movable_node.patch added to
 -mm tree
Date: Mon, 14 Nov 2016 15:05:11 -0800
Message-ID: <582a4327.kE2i0QUPG6BgwHzv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939765AbcKNXFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 18:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, apopple@au1.ibm.com, benh@kernel.crashing.org, bharata@linux.vnet.ibm.com, bsingharora@gmail.com, frowand.list@gmail.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, nfont@linux.vnet.ibm.com, paulus@samba.org, robh+dt@kernel.org, stewart@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove x86-only restriction of movable_node
has been added to the -mm tree.  Its filename is
     mm-remove-x86-only-restriction-of-movable_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-x86-only-restriction-of-movable_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-x86-only-restriction-of-movable_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: mm: remove x86-only restriction of movable_node

In commit c5320926e370 ("mem-hotplug: introduce movable_node boot
option"), the memblock allocation direction is changed to bottom-up and
then back to top-down like this:

1. memblock_set_bottom_up(true), called by cmdline_parse_movable_node().
2. memblock_set_bottom_up(false), called by x86's numa_init().

Even though (1) occurs in generic mm code, it is wrapped by #ifdef
CONFIG_MOVABLE_NODE, which depends on X86_64.

This means that when we extend CONFIG_MOVABLE_NODE to non-x86 arches,
things will be unbalanced. (1) will happen for them, but (2) will not.

This toggle was added in the first place because x86 has a delay between
adding memblocks and marking them as hotpluggable. Since other arches do
this marking either immediately or not at all, they do not require the
bottom-up toggle.

So, resolve things by moving (1) from cmdline_parse_movable_node() to
x86's setup_arch(), immediately after the movable_node parameter has
been parsed.

Link: http://lkml.kernel.org/r/1479160961-25840-3-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alistair Popple <apopple@au1.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/kernel/setup.c             |   24 ++++++++++++++++++++++++
 mm/memory_hotplug.c                 |   20 --------------------
 3 files changed, 25 insertions(+), 21 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-remove-x86-only-restriction-of-movable_node Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-remove-x86-only-restriction-of-movable_node
+++ a/Documentation/kernel-parameters.txt
@@ -2401,7 +2401,7 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
-	movable_node	[KNL,X86] Boot-time switch to enable the effects
+	movable_node	[KNL] Boot-time switch to enable the effects
 			of CONFIG_MOVABLE_NODE=y. See mm/Kconfig for details.
 
 	MTD_Partition=	[MTD]
diff -puN arch/x86/kernel/setup.c~mm-remove-x86-only-restriction-of-movable_node arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~mm-remove-x86-only-restriction-of-movable_node
+++ a/arch/x86/kernel/setup.c
@@ -985,6 +985,30 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+	/*
+	 * Memory used by the kernel cannot be hot-removed because Linux
+	 * cannot migrate the kernel pages. When memory hotplug is
+	 * enabled, we should prevent memblock from allocating memory
+	 * for the kernel.
+	 *
+	 * ACPI SRAT records all hotpluggable memory ranges. But before
+	 * SRAT is parsed, we don't know about it.
+	 *
+	 * The kernel image is loaded into memory at very early time. We
+	 * cannot prevent this anyway. So on NUMA system, we set any
+	 * node the kernel resides in as un-hotpluggable.
+	 *
+	 * Since on modern servers, one node could have double-digit
+	 * gigabytes memory, we can assume the memory around the kernel
+	 * image is also un-hotpluggable. So before SRAT is parsed, just
+	 * allocate memory near the kernel image to try the best to keep
+	 * the kernel away from hotpluggable memory.
+	 */
+	if (movable_node_is_enabled())
+		memblock_set_bottom_up(true);
+#endif
+
 	x86_report_nx();
 
 	/* after early param, so could get panic from serial */
diff -puN mm/memory_hotplug.c~mm-remove-x86-only-restriction-of-movable_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-x86-only-restriction-of-movable_node
+++ a/mm/memory_hotplug.c
@@ -1727,26 +1727,6 @@ static bool can_offline_normal(struct zo
 static int __init cmdline_parse_movable_node(char *p)
 {
 #ifdef CONFIG_MOVABLE_NODE
-	/*
-	 * Memory used by the kernel cannot be hot-removed because Linux
-	 * cannot migrate the kernel pages. When memory hotplug is
-	 * enabled, we should prevent memblock from allocating memory
-	 * for the kernel.
-	 *
-	 * ACPI SRAT records all hotpluggable memory ranges. But before
-	 * SRAT is parsed, we don't know about it.
-	 *
-	 * The kernel image is loaded into memory at very early time. We
-	 * cannot prevent this anyway. So on NUMA system, we set any
-	 * node the kernel resides in as un-hotpluggable.
-	 *
-	 * Since on modern servers, one node could have double-digit
-	 * gigabytes memory, we can assume the memory around the kernel
-	 * image is also un-hotpluggable. So before SRAT is parsed, just
-	 * allocate memory near the kernel image to try the best to keep
-	 * the kernel away from hotpluggable memory.
-	 */
-	memblock_set_bottom_up(true);
 	movable_node_enabled = true;
 #else
 	pr_warn("movable_node option not supported\n");
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are

powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch
mm-remove-x86-only-restriction-of-movable_node.patch
mm-enable-config_movable_node-on-non-x86-arches.patch
of-fdt-mark-hotpluggable-memory.patch
dt-add-documentation-of-hotpluggable-memory-property.patch

