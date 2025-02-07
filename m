Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6FB4C83
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888218; cv=none; b=dhr7+E6uM2pIGH+VFGdcSV6B2XNfowvTTEE/mu1mAkjoLPt0pNjBjnxUs6bLl79n0UMFHzNuBD8qopluS/N37Qun1Htf4Bg0kmSn2Ia6cSK1p41dzra9/UDs2foJhckjoZ1jYZ2BDsh8/jGBf84sjykKTB81RCNDjZc84dXm26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888218; c=relaxed/simple;
	bh=IFNdtuSWiWt6v/3Tr+cHjnln3+iK9k3lFC50uUJyPek=;
	h=Date:To:From:Subject:Message-Id; b=sgDzFNVTizC7Hlmzy8Tv+vk6A77LLsQPefNliLuRHmuFsFKCyJlBnFiOPG7jZmQq37rtnZbp/duN5NRSJgCCnn1ELS9rJv2qBHnAnpxqKiDSt7KZ2jmGDe17rOsY80rB8PjMnT+gNxZlAD7e+nnG+m5wRZSd0LJEsP01TBioEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CvL6IJI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CvL6IJI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E04C4CEDD;
	Fri,  7 Feb 2025 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888216;
	bh=IFNdtuSWiWt6v/3Tr+cHjnln3+iK9k3lFC50uUJyPek=;
	h=Date:To:From:Subject:From;
	b=CvL6IJI5afulzwGo0jGBrrTtouV9oNRv8MxnsC8f6CdxYDOtKN8XyGouC2LhZg3pd
	 gXGBT3qfoXwXqrPs9u63Zw5b8TuJcIWVPcb0lqKYIZ/m5mYINKq9K82KN6Ost35Yli
	 sp9w3XzMIFoO/HHoUijSA8tMykl3iTKw9JN/oEqk=
Date: Thu, 06 Feb 2025 16:30:16 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-add-kho-support.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003016.C7E04C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: add KHO support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-add-kho-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-add-kho-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Date: Thu, 6 Feb 2025 15:27:50 +0200

We now have all bits in place to support KHO kexecs.  This patch adds
awareness of KHO in the kexec file as well as boot path for arm64 and adds
the respective kconfig option to the architecture so that it can use KHO
successfully.

Link: https://lkml.kernel.org/r/20250206132754.2596694-11-rppt@kernel.org
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 drivers/of/fdt.c   |   36 ++++++++++++++++++++++++++++++++++++
 drivers/of/kexec.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

--- a/arch/arm64/Kconfig~arm64-add-kho-support
+++ a/arch/arm64/Kconfig
@@ -1590,6 +1590,9 @@ config ARCH_SUPPORTS_KEXEC_IMAGE_VERIFY_
 config ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_SIG
 	def_bool y
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool y
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
--- a/drivers/of/fdt.c~arm64-add-kho-support
+++ a/drivers/of/fdt.c
@@ -875,6 +875,39 @@ void __init early_init_dt_check_for_usab
 		memblock_add(rgn[i].base, rgn[i].size);
 }
 
+/**
+ * early_init_dt_check_kho - Decode info required for kexec handover from DT
+ */
+static void __init early_init_dt_check_kho(void)
+{
+	unsigned long node = chosen_node_offset;
+	u64 kho_start, scratch_start, scratch_size;
+	const __be32 *p;
+	int l;
+
+	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER) || (long)node < 0)
+		return;
+
+	p = of_get_flat_dt_prop(node, "linux,kho-dt", &l);
+	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+		return;
+
+	kho_start = dt_mem_next_cell(dt_root_addr_cells, &p);
+
+	p = of_get_flat_dt_prop(node, "linux,kho-scratch", &l);
+	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+		return;
+
+	scratch_start = dt_mem_next_cell(dt_root_addr_cells, &p);
+	scratch_size = dt_mem_next_cell(dt_root_addr_cells, &p);
+
+	p = of_get_flat_dt_prop(node, "linux,kho-mem", &l);
+	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+		return;
+
+	kho_populate(kho_start, scratch_start, scratch_size);
+}
+
 #ifdef CONFIG_SERIAL_EARLYCON
 
 int __init early_init_dt_scan_chosen_stdout(void)
@@ -1169,6 +1202,9 @@ void __init early_init_dt_scan_nodes(voi
 
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
+	void *dt = NULL;
+	phys_addr_t dt_mem = 0;
+	phys_addr_t dt_len = 0;
+	phys_addr_t scratch_mem = 0;
+	phys_addr_t scratch_len = 0;
+	int ret = 0;
+
+#ifdef CONFIG_KEXEC_HANDOVER
+	dt = image->kho.dt.buffer;
+	dt_mem = image->kho.dt.mem;
+	dt_len = image->kho.dt.bufsz;
+
+	scratch_mem = image->kho.scratch.mem;
+	scratch_len = image->kho.scratch.bufsz;
+#endif
+
+	if (!dt)
+		goto out;
+
+	pr_debug("Adding kho metadata to DT");
+
+	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-dt",
+				       dt_mem, dt_len);
+	if (ret)
+		goto out;
+
+	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-scratch",
+				       scratch_mem, scratch_len);
+	if (ret)
+		goto out;
+
+out:
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
kexec-add-documentation-for-kho.patch
arm64-add-kho-support.patch
x86-add-kho-support.patch
memblock-add-kho-support-for-reserve_mem.patch

