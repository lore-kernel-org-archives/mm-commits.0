Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8097CD13DD
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjIRQJ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjIRQJQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:09:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E8349F5
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:08:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4B1C116A9;
        Mon, 18 Sep 2023 15:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695052331;
        bh=0nVG/kMWS2HTX8b7O59NZ7IMCg3S/aAleY0aW4rxoww=;
        h=Date:To:From:Subject:From;
        b=cypsgUThU+D7arnsRRs4Lm3D7E9BIbaJC63sfNKAYr1NPGDlavanQWDdhMTlwUUUq
         sd+J/VA37TRO/S3RAmZ0qpabxUrLUF19lLa3s3O9AwWjx1GRQYd9wnuOFVSwJaZZlY
         wOkLqciH0w1yF+1tU0MrUdCN21iE4I5ekaCXbUJg=
Date:   Mon, 18 Sep 2023 08:52:10 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tglx@linutronix.de, song@kernel.org,
        rostedt@goodmis.org, rick.p.edgecombe@intel.com,
        puranjay12@gmail.com, palmer@dabbelt.com,
        naveen.n.rao@linux.ibm.com, nadav.amit@gmail.com,
        mpe@ellerman.id.au, mcgrof@kernel.org, mark.rutland@arm.com,
        linux@armlinux.org.uk, kent.overstreet@linux.dev,
        hca@linux.ibm.com, dinguyen@kernel.org, deller@gmx.de,
        davem@davemloft.net, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bjorn@kernel.org,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-introduce-execmem_data_alloc.patch added to mm-unstable branch
Message-Id: <20230918155211.2B4B1C116A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/execmem: introduce execmem_data_alloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-execmem-introduce-execmem_data_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-introduce-execmem_data_alloc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/execmem: introduce execmem_data_alloc()
Date: Mon, 18 Sep 2023 10:29:48 +0300

Data related to code allocations, such as module data section, need to
comply with architecture constraints for its placement and its allocation
right now was done using execmem_text_alloc().

Create a dedicated API for allocating data related to code allocations and
allow architectures to define address ranges for data allocations.

Since currently this is only relevant for powerpc variants that use the
VMALLOC address space for module data allocations, automatically reuse
address ranges defined for text unless address range for data is
explicitly defined by an architecture.

With separation of code and data allocations, data sections of the modules
are now mapped as PAGE_KERNEL rather than PAGE_KERNEL_EXEC which was a
default on many architectures.

Link: https://lkml.kernel.org/r/20230918072955.2507221-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Puranjay Mohan <puranjay12@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/module.c |   12 ++++++++++++
 include/linux/execmem.h      |   19 +++++++++++++++++++
 kernel/module/main.c         |   15 +++------------
 mm/execmem.c                 |   17 ++++++++++++++++-
 4 files changed, 50 insertions(+), 13 deletions(-)

--- a/arch/powerpc/kernel/module.c~mm-execmem-introduce-execmem_data_alloc
+++ a/arch/powerpc/kernel/module.c
@@ -95,6 +95,9 @@ static struct execmem_params execmem_par
 		[EXECMEM_DEFAULT] = {
 			.alignment = 1,
 		},
+		[EXECMEM_MODULE_DATA] = {
+			.alignment = 1,
+		},
 	},
 };
 
@@ -103,7 +106,12 @@ struct execmem_params __init *execmem_ar
 	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
 	struct execmem_range *range = &execmem_params.ranges[EXECMEM_DEFAULT];
 
+	/*
+	 * BOOK3S_32 and 8xx define MODULES_VADDR for text allocations and
+	 * allow allocating data in the entire vmalloc space
+	 */
 #ifdef MODULES_VADDR
+	struct execmem_range *data = &execmem_params.ranges[EXECMEM_MODULE_DATA];
 	unsigned long limit = (unsigned long)_etext - SZ_32M;
 
 	/* First try within 32M limit from _etext to avoid branch trampolines */
@@ -116,6 +124,10 @@ struct execmem_params __init *execmem_ar
 		range->start = MODULES_VADDR;
 		range->end = MODULES_END;
 	}
+	data->start = VMALLOC_START;
+	data->end = VMALLOC_END;
+	data->pgprot = PAGE_KERNEL;
+	data->alignment = 1;
 #else
 	range->start = VMALLOC_START;
 	range->end = VMALLOC_END;
--- a/include/linux/execmem.h~mm-execmem-introduce-execmem_data_alloc
+++ a/include/linux/execmem.h
@@ -29,6 +29,7 @@
  * @EXECMEM_KPROBES: parameters for kprobes
  * @EXECMEM_FTRACE: parameters for ftrace
  * @EXECMEM_BPF: parameters for BPF
+ * @EXECMEM_MODULE_DATA: parameters for module data sections
  * @EXECMEM_TYPE_MAX:
  */
 enum execmem_type {
@@ -37,6 +38,7 @@ enum execmem_type {
 	EXECMEM_KPROBES,
 	EXECMEM_FTRACE,
 	EXECMEM_BPF,
+	EXECMEM_MODULE_DATA,
 	EXECMEM_TYPE_MAX,
 };
 
@@ -108,6 +110,23 @@ struct execmem_params *execmem_arch_para
 void *execmem_text_alloc(enum execmem_type type, size_t size);
 
 /**
+ * execmem_data_alloc - allocate memory for data coupled to code
+ * @type: type of the allocation
+ * @size: how many bytes of memory are required
+ *
+ * Allocates memory that will contain data coupled with executable code,
+ * like data sections in kernel modules.
+ *
+ * The memory will have protections defined by architecture.
+ *
+ * The allocated memory will reside in an area that does not impose
+ * restrictions on the addressing modes.
+ *
+ * Return: a pointer to the allocated memory or %NULL
+ */
+void *execmem_data_alloc(enum execmem_type type, size_t size);
+
+/**
  * execmem_free - free executable memory
  * @ptr: pointer to the memory that should be freed
  */
--- a/kernel/module/main.c~mm-execmem-introduce-execmem_data_alloc
+++ a/kernel/module/main.c
@@ -1188,25 +1188,16 @@ void __weak module_arch_freeing_init(str
 {
 }
 
-static bool mod_mem_use_vmalloc(enum mod_mem_type type)
-{
-	return IS_ENABLED(CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC) &&
-		mod_mem_type_is_core_data(type);
-}
-
 static void *module_memory_alloc(unsigned int size, enum mod_mem_type type)
 {
-	if (mod_mem_use_vmalloc(type))
-		return vzalloc(size);
+	if (mod_mem_type_is_data(type))
+		return execmem_data_alloc(EXECMEM_MODULE_DATA, size);
 	return execmem_text_alloc(EXECMEM_MODULE_TEXT, size);
 }
 
 static void module_memory_free(void *ptr, enum mod_mem_type type)
 {
-	if (mod_mem_use_vmalloc(type))
-		vfree(ptr);
-	else
-		execmem_free(ptr);
+	execmem_free(ptr);
 }
 
 static void free_mod_mem(struct module *mod)
--- a/mm/execmem.c~mm-execmem-introduce-execmem_data_alloc
+++ a/mm/execmem.c
@@ -53,11 +53,23 @@ static void *execmem_alloc(size_t size,
 	return kasan_reset_tag(p);
 }
 
+static inline bool execmem_range_is_data(enum execmem_type type)
+{
+	return type == EXECMEM_MODULE_DATA;
+}
+
 void *execmem_text_alloc(enum execmem_type type, size_t size)
 {
 	return execmem_alloc(size, &execmem_params.ranges[type]);
 }
 
+void *execmem_data_alloc(enum execmem_type type, size_t size)
+{
+	WARN_ON_ONCE(!execmem_range_is_data(type));
+
+	return execmem_alloc(size, &execmem_params.ranges[type]);
+}
+
 void execmem_free(void *ptr)
 {
 	/*
@@ -93,7 +105,10 @@ static void execmem_init_missing(struct
 		struct execmem_range *r = &p->ranges[i];
 
 		if (!r->start) {
-			r->pgprot = default_range->pgprot;
+			if (execmem_range_is_data(i))
+				r->pgprot = PAGE_KERNEL;
+			else
+				r->pgprot = default_range->pgprot;
 			r->alignment = default_range->alignment;
 			r->start = default_range->start;
 			r->end = default_range->end;
_

Patches currently in -mm which might be from rppt@kernel.org are

nios2-define-virtual-address-space-for-modules.patch
mm-introduce-execmem_text_alloc-and-execmem_free.patch
mm-execmem-arch-convert-simple-overrides-of-module_alloc-to-execmem.patch
mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch
modules-execmem-drop-module_alloc.patch
mm-execmem-introduce-execmem_data_alloc.patch
arm64-execmem-extend-execmem_params-for-generated-code-allocations.patch
riscv-extend-execmem_params-for-generated-code-allocations.patch
powerpc-extend-execmem_params-for-kprobes-allocations.patch
arch-make-execmem-setup-available-regardless-of-config_modules.patch
x86-ftrace-enable-dynamic-ftrace-without-config_modules.patch
kprobes-remove-dependency-on-config_modules.patch
bpf-remove-config_bpf_jit-dependency-on-config_modules-of.patch

