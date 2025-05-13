Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CB41D6DB4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119266; cv=none; b=FPMz83ctX4nYLcyMuAg13WwU720PKPfurblaIyk7SmUKc8tIkfSovu57Wd4pcwbmCgS+STyDVPLDRdiAkq5Q9a02mYbefa3ikCA9oNwd4SB515iFdu0+3n3d8oIkPp6rueeMoXKF52JAZ/BMhMPLrjLYpLH+9fu0qNXOfQov+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119266; c=relaxed/simple;
	bh=ew2hhlBeerpPKVg9wq33+IGDmB6+UcAvwTiW4h1EDdg=;
	h=Date:To:From:Subject:Message-Id; b=upSrBKF2ajLdgl7+FLoWlXVMVXEdpBHIXO4ScGhFButVN6W0nCDbpQv8LknierIrKnX7UR9HGV/49sh/Ty2GAtfYNQdss1cmsGfgU4NPKrn/BoNgLNk6QfoC99H4Ux4CzXA9of5ykygsIQN4UZJnY0B90tF+7XTIHA8JoOk6/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HmST88Qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HmST88Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13783C4CEE4;
	Tue, 13 May 2025 06:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119266;
	bh=ew2hhlBeerpPKVg9wq33+IGDmB6+UcAvwTiW4h1EDdg=;
	h=Date:To:From:Subject:From;
	b=HmST88Qt+ZDNU36R5RdxvebFYB/N+7FNr/XFMVwHnbu2WGTgJXf2926OIfAgQqI2G
	 rVw6QmBaApJuz0xsABarWnjIUwDCz4dbi9gHP4m6o3n+phblkp6bJQ6JzTKhbbsQPZ
	 hT5isG5gHip1rxB7DZZERu6S8hqAa0tzpkVA8k8g=
Date: Mon, 12 May 2025 23:54:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch removed from -mm tree
Message-Id: <20250513065426.13783C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kexec: add support for passing kexec handover (KHO) data
has been removed from the -mm tree.  Its filename was
     x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Graf <graf@amazon.com>
Subject: x86/kexec: add support for passing kexec handover (KHO) data
Date: Fri, 9 May 2025 00:46:29 -0700

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

Link: https://lkml.kernel.org/r/20250509074635.3187114-12-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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


