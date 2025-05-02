Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D20233CFC
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146624; cv=none; b=HlbWqagv/thnD2puKTM7w9VagzZsHtDWTHXfB9k4oyoJKtm5aPNSyqz057pe1yRkvul4ynLt8L7tlP5k9lqBwdQhPQQ4DL8VtLEIKCG3KX43D36H5WF6qKeF62MgX5zVmAwAQ1+ldZcW+C9zVlx7kEd9JlDzpYKq+kzvYmIVhm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146624; c=relaxed/simple;
	bh=I7yS3/BPN/ls3jkzaTBBdzLGj+tGl2Voud97AmCtgqI=;
	h=Date:To:From:Subject:Message-Id; b=UMqMpUnv1WJN9neCC/HGTsMIX5N7V1x0Xsdo40Da2NW1mVYTFDdNlMB0NXdKRJIVLFx8LFENZk71vQCpwS+ALXyc2YWxxUrbU/kmyFe/o4FB2UHHNtCiS7mnOqtN4FUM5oYr6H/TpfAa9gkmkKSTmDa+24C5EpH2QjPkt6Ldp4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xnfb3jdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xnfb3jdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625C4C4CEE3;
	Fri,  2 May 2025 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146624;
	bh=I7yS3/BPN/ls3jkzaTBBdzLGj+tGl2Voud97AmCtgqI=;
	h=Date:To:From:Subject:From;
	b=xnfb3jdPGlkeT2Re0hiC3QNUXBs9Js5Kzy8Qjtg8kAAn0A0ppa1WIjTOEneWM9Tur
	 9HGftUUqApXt7yUcwPSx+fYv8KeqD1BHruAdVBefHcSh2IYZhDMWUxezR8QTl3IRoR
	 Xt0GowRy0Ht88hvMfokGV0Yy1N1QorRBOJo7/4n4=
Date: Thu, 01 May 2025 17:43:43 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch added to mm-unstable branch
Message-Id: <20250502004344.625C4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: add support for passing kexec handover (KHO) data
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch

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
Subject: x86/kexec: add support for passing kexec handover (KHO) data
Date: Thu, 1 May 2025 15:54:19 -0700

kexec handover (KHO) creates a metadata that the kernels pass between each
other during kexec.  This metadata is stored in memory and kexec image
contains a (physical) pointer to that memory.

In addition, KHO keeps "scratch regions" available for kexec: physically
contiguous memory regions that are guaranteed to not have any memory that
KHO would preserve.  The new kernel bootstraps itself using the scratch
regions and sets all handed over memory as in use.  When subsystems that
support KHO initialize, they introspect the KHO metadata, restore
preserved memory regions, and retrieve their state stored in the preserved
memory.

Enlighten x86 kexec-file and boot path about the KHO metadata and make
sure it gets passed along to the next kernel.

Link: https://lkml.kernel.org/r/20250501225425.635167-13-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/setup.h           |    2 +
 arch/x86/include/uapi/asm/setup_data.h |   13 +++++++-
 arch/x86/kernel/kexec-bzimage64.c      |   37 +++++++++++++++++++++++
 arch/x86/kernel/setup.c                |   26 ++++++++++++++++
 4 files changed, 77 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/setup.h~x86-kexec-add-support-for-passing-kexec-handover-kho-data
+++ a/arch/x86/include/asm/setup.h
@@ -67,6 +67,8 @@ extern void x86_ce4100_early_setup(void)
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
+#include <linux/kexec_handover.h>
+
 #ifndef _SETUP
 
 #include <asm/espfix.h>
--- a/arch/x86/include/uapi/asm/setup_data.h~x86-kexec-add-support-for-passing-kexec-handover-kho-data
+++ a/arch/x86/include/uapi/asm/setup_data.h
@@ -13,7 +13,8 @@
 #define SETUP_CC_BLOB			7
 #define SETUP_IMA			8
 #define SETUP_RNG_SEED			9
-#define SETUP_ENUM_MAX			SETUP_RNG_SEED
+#define SETUP_KEXEC_KHO			10
+#define SETUP_ENUM_MAX			SETUP_KEXEC_KHO
 
 #define SETUP_INDIRECT			(1<<31)
 #define SETUP_TYPE_MAX			(SETUP_ENUM_MAX | SETUP_INDIRECT)
@@ -78,6 +79,16 @@ struct ima_setup_data {
 	__u64 size;
 } __attribute__((packed));
 
+/*
+ * Locations of kexec handover metadata
+ */
+struct kho_data {
+	__u64 fdt_addr;
+	__u64 fdt_size;
+	__u64 scratch_addr;
+	__u64 scratch_size;
+} __attribute__((packed));
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_X86_SETUP_DATA_H */
--- a/arch/x86/kernel/kexec-bzimage64.c~x86-kexec-add-support-for-passing-kexec-handover-kho-data
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -233,6 +233,32 @@ setup_ima_state(const struct kimage *ima
 #endif /* CONFIG_IMA_KEXEC */
 }
 
+static void setup_kho(const struct kimage *image, struct boot_params *params,
+		      unsigned long params_load_addr,
+		      unsigned int setup_data_offset)
+{
+	struct setup_data *sd = (void *)params + setup_data_offset;
+	struct kho_data *kho = (void *)sd + sizeof(*sd);
+
+	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER))
+		return;
+
+	sd->type = SETUP_KEXEC_KHO;
+	sd->len = sizeof(struct kho_data);
+
+	/* Only add if we have all KHO images in place */
+	if (!image->kho.fdt || !image->kho.scratch)
+		return;
+
+	/* Add setup data */
+	kho->fdt_addr = image->kho.fdt;
+	kho->fdt_size = PAGE_SIZE;
+	kho->scratch_addr = image->kho.scratch->mem;
+	kho->scratch_size = image->kho.scratch->bufsz;
+	sd->next = params->hdr.setup_data;
+	params->hdr.setup_data = params_load_addr + setup_data_offset;
+}
+
 static int
 setup_boot_parameters(struct kimage *image, struct boot_params *params,
 		      unsigned long params_load_addr,
@@ -312,6 +338,13 @@ setup_boot_parameters(struct kimage *ima
 				     sizeof(struct ima_setup_data);
 	}
 
+	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER)) {
+		/* Setup space to store preservation metadata */
+		setup_kho(image, params, params_load_addr, setup_data_offset);
+		setup_data_offset += sizeof(struct setup_data) +
+				     sizeof(struct kho_data);
+	}
+
 	/* Setup RNG seed */
 	setup_rng_seed(params, params_load_addr, setup_data_offset);
 
@@ -479,6 +512,10 @@ static void *bzImage64_load(struct kimag
 		kbuf.bufsz += sizeof(struct setup_data) +
 			      sizeof(struct ima_setup_data);
 
+	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER))
+		kbuf.bufsz += sizeof(struct setup_data) +
+			      sizeof(struct kho_data);
+
 	params = kzalloc(kbuf.bufsz, GFP_KERNEL);
 	if (!params)
 		return ERR_PTR(-ENOMEM);
--- a/arch/x86/kernel/setup.c~x86-kexec-add-support-for-passing-kexec-handover-kho-data
+++ a/arch/x86/kernel/setup.c
@@ -451,6 +451,29 @@ int __init ima_get_kexec_buffer(void **a
 }
 #endif
 
+static void __init add_kho(u64 phys_addr, u32 data_len)
+{
+	struct kho_data *kho;
+	u64 addr = phys_addr + sizeof(struct setup_data);
+	u64 size = data_len - sizeof(struct setup_data);
+
+	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER)) {
+		pr_warn("Passed KHO data, but CONFIG_KEXEC_HANDOVER not set. Ignoring.\n");
+		return;
+	}
+
+	kho = early_memremap(addr, size);
+	if (!kho) {
+		pr_warn("setup: failed to memremap kho data (0x%llx, 0x%llx)\n",
+			addr, size);
+		return;
+	}
+
+	kho_populate(kho->fdt_addr, kho->fdt_size, kho->scratch_addr, kho->scratch_size);
+
+	early_memunmap(kho, size);
+}
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -479,6 +502,9 @@ static void __init parse_setup_data(void
 		case SETUP_IMA:
 			add_early_ima_buffer(pa_data);
 			break;
+		case SETUP_KEXEC_KHO:
+			add_kho(pa_data, data_len);
+			break;
 		case SETUP_RNG_SEED:
 			data = early_memremap(pa_data, data_len);
 			add_bootloader_randomness(data->data, data->len);
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

