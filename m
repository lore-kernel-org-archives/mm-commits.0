Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BBF537E9
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837446; cv=none; b=QuVetvjlH0+l8u8kkBEQAsvS1WdnDCWKWud13KlmHGc1hG02js4jYWkR62rO2BJHKDz8GuO7bkRBZuw9/7qFa8+rGlr1xN3G76xvh/gsaF4IGX1WR17NlGJvy7zS/M/Ycdp0JUIOWh+QawMSV2jfhL4LKSQ1LmlsbzboEJ8jYKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837446; c=relaxed/simple;
	bh=TaV9ouZa+XxAvBvEB4ilXERkwWILFU3RZFjmoJrlP1Y=;
	h=Date:To:From:Subject:Message-Id; b=bOCu5s69HP0rOsg+BXtO+eGKv4tjcsQAKyG0S5GaIYsfQTs0PBgMthqH0Tw3MwJOvxVKyjJWA0fK2ZtyxRotia8aDLazD8K2BMt2aZmJticn/ir09XVs6QG/H1ZgpzcXdWt5bP6eJTHHde6ysfB/OAFTMXBFChTdewzA3wi+nOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=npw2K0ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="npw2K0ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C15C4CEE4;
	Sat, 10 May 2025 00:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837446;
	bh=TaV9ouZa+XxAvBvEB4ilXERkwWILFU3RZFjmoJrlP1Y=;
	h=Date:To:From:Subject:From;
	b=npw2K0ib8b9Ey6x4/x+4GjfCmCNIW8yXlknJDQRp/hRNsRgaaEExlpOKw/z3frOiN
	 g2zROrBRqtU0srzSYdrX9JYHTgR+Bo/gRbLjI94zZdJx6ZWatQMrqo6MDcIWWwQfBm
	 bOzZEjqYL4CCGRkSPhshmlNh8N+zfiVOT9qjTNPc=
Date: Fri, 09 May 2025 17:37:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-add-kho-support.patch added to mm-unstable branch
Message-Id: <20250510003726.24C15C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: add KHO support
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-add-kho-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-add-kho-support.patch

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
From: Alexander Graf <graf@amazon.com>
Subject: arm64: add KHO support
Date: Fri, 9 May 2025 00:46:27 -0700

We now have all bits in place to support KHO kexecs.  Add awareness of KHO
in the kexec file as well as boot path for arm64 and adds the respective
kconfig option to the architecture so that it can use KHO successfully.

Changes to the "chosen" node have been sent to
https://github.com/devicetree-org/dt-schema/pull/158.

Link: https://lkml.kernel.org/r/20250509074635.3187114-10-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 drivers/of/fdt.c   |   34 ++++++++++++++++++++++++++++++++++
 drivers/of/kexec.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

--- a/arch/arm64/Kconfig~arm64-add-kho-support
+++ a/arch/arm64/Kconfig
@@ -1602,6 +1602,9 @@ config ARCH_SUPPORTS_KEXEC_IMAGE_VERIFY_
 config ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_SIG
 	def_bool y
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool y
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
--- a/drivers/of/fdt.c~arm64-add-kho-support
+++ a/drivers/of/fdt.c
@@ -25,6 +25,7 @@
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
 #include <linux/random.h>
+#include <linux/kexec_handover.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -875,6 +876,36 @@ void __init early_init_dt_check_for_usab
 		memblock_add(rgn[i].base, rgn[i].size);
 }
 
+/**
+ * early_init_dt_check_kho - Decode info required for kexec handover from DT
+ */
+static void __init early_init_dt_check_kho(void)
+{
+	unsigned long node = chosen_node_offset;
+	u64 fdt_start, fdt_size, scratch_start, scratch_size;
+	const __be32 *p;
+	int l;
+
+	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER) || (long)node < 0)
+		return;
+
+	p = of_get_flat_dt_prop(node, "linux,kho-fdt", &l);
+	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+		return;
+
+	fdt_start = dt_mem_next_cell(dt_root_addr_cells, &p);
+	fdt_size = dt_mem_next_cell(dt_root_addr_cells, &p);
+
+	p = of_get_flat_dt_prop(node, "linux,kho-scratch", &l);
+	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+		return;
+
+	scratch_start = dt_mem_next_cell(dt_root_addr_cells, &p);
+	scratch_size = dt_mem_next_cell(dt_root_addr_cells, &p);
+
+	kho_populate(fdt_start, fdt_size, scratch_start, scratch_size);
+}
+
 #ifdef CONFIG_SERIAL_EARLYCON
 
 int __init early_init_dt_scan_chosen_stdout(void)
@@ -1169,6 +1200,9 @@ void __init early_init_dt_scan_nodes(voi
 
 	/* Handle linux,usable-memory-range property */
 	early_init_dt_check_for_usable_mem_range();
+
+	/* Handle kexec handover */
+	early_init_dt_check_kho();
 }
 
 bool __init early_init_dt_scan(void *dt_virt, phys_addr_t dt_phys)
--- a/drivers/of/kexec.c~arm64-add-kho-support
+++ a/drivers/of/kexec.c
@@ -264,6 +264,43 @@ static inline int setup_ima_buffer(const
 }
 #endif /* CONFIG_IMA_KEXEC */
 
+static int kho_add_chosen(const struct kimage *image, void *fdt, int chosen_node)
+{
+	int ret = 0;
+#ifdef CONFIG_KEXEC_HANDOVER
+	phys_addr_t fdt_mem = 0;
+	phys_addr_t fdt_len = 0;
+	phys_addr_t scratch_mem = 0;
+	phys_addr_t scratch_len = 0;
+
+	ret = fdt_delprop(fdt, chosen_node, "linux,kho-fdt");
+	if (ret && ret != -FDT_ERR_NOTFOUND)
+		return ret;
+	ret = fdt_delprop(fdt, chosen_node, "linux,kho-scratch");
+	if (ret && ret != -FDT_ERR_NOTFOUND)
+		return ret;
+
+	if (!image->kho.fdt || !image->kho.scratch)
+		return 0;
+
+	fdt_mem = image->kho.fdt;
+	fdt_len = PAGE_SIZE;
+	scratch_mem = image->kho.scratch->mem;
+	scratch_len = image->kho.scratch->bufsz;
+
+	pr_debug("Adding kho metadata to DT");
+
+	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-fdt",
+				       fdt_mem, fdt_len);
+	if (ret)
+		return ret;
+	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-scratch",
+				       scratch_mem, scratch_len);
+
+#endif /* CONFIG_KEXEC_HANDOVER */
+	return ret;
+}
+
 /*
  * of_kexec_alloc_and_setup_fdt - Alloc and setup a new Flattened Device Tree
  *
@@ -414,6 +451,11 @@ void *of_kexec_alloc_and_setup_fdt(const
 #endif
 	}
 
+	/* Add kho metadata if this is a KHO image */
+	ret = kho_add_chosen(image, fdt, chosen_node);
+	if (ret)
+		goto out;
+
 	/* add bootargs */
 	if (cmdline) {
 		ret = fdt_setprop_string(fdt, chosen_node, "bootargs", cmdline);
_

Patches currently in -mm which might be from graf@amazon.com are

memblock-add-support-for-scratch-memory.patch
kexec-add-kexec-handover-kho-generation-helpers.patch
kexec-add-kho-parsing-support.patch
kexec-add-kho-support-to-kexec-file-loads.patch
kexec-add-config-option-for-kho.patch
arm64-add-kho-support.patch
x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch
x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch
x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch
x86-kconfig-enable-kexec-handover-for-64-bits.patch
memblock-add-kho-support-for-reserve_mem.patch
documentation-add-documentation-for-kho.patch

