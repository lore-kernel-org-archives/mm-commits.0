Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93006DDA9
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888220; cv=none; b=mf9DCaJZdS6t38IvAqmS4m4FD430Yrg7DG6tDlpYk0s6sOEDPOf+7WQro8z9pj9edMscmJUcf9o2cK2RR7z8Q0Kyq/VNW+iQuQuLXqJ8sortnxIKS6W7QthaDXABNEIbEAaMEhdOv7D60gJXHF+aJp+3cJNlDpypm7JDPSdqgSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888220; c=relaxed/simple;
	bh=J10kHFKTupPwUv9jFu1HVtHuno8S/AZdu3PU/dArRLg=;
	h=Date:To:From:Subject:Message-Id; b=Hz8e6QYDC09QZwsV62L87ntP2zMlOYX9LeP6PtIwNfIcH/YDoDRnx/t5FSq1/hG/E2bjgh7twJv/j8WGJ/aqd2tJcCzFay4omQAcBvJLKWtRDATREnv8TPiqUXtpk1zks88QVP4YrynzIfmFJeNeSbAmKdHH6YBgh8KQbzt0qvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TzstbJw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TzstbJw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEE4C4CEDD;
	Fri,  7 Feb 2025 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888220;
	bh=J10kHFKTupPwUv9jFu1HVtHuno8S/AZdu3PU/dArRLg=;
	h=Date:To:From:Subject:From;
	b=TzstbJw7j7Ah6pu1pZ0v+piXsKG+ipSnxSp7WWC6j4aHWIl/mP6cgXlnK8Gm/iK8Q
	 1c6Nowv3g8dahBdAacOKLbMHKmYq2trokHrliEOGd6z+qpUQuCP84CCurd0mBhg3lN
	 YP6FvVpMAZ2/BpVB2Q1LYsjo0e6TcW+ldnqRXOn4=
Date: Thu, 06 Feb 2025 16:30:19 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-add-kho-support.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003019.EFEE4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: add KHO support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-add-kho-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-add-kho-support.patch

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
Subject: x86: add KHO support
Date: Thu, 6 Feb 2025 15:27:52 +0200

We now have all bits in place to support KHO kexecs.  This patch adds
awareness of KHO in the kexec file as well as boot path for x86 and adds
the respective kconfig option to the architecture so that it can use KHO
successfully.

In addition, it enlightens it decompression code with KHO so that its
KASLR location finder only considers memory regions that are not already
occupied by KHO memory.

Link: https://lkml.kernel.org/r/20250206132754.2596694-13-rppt@kernel.org
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

 arch/x86/Kconfig                       |    3 +
 arch/x86/boot/compressed/kaslr.c       |   52 ++++++++++++++++++++++-
 arch/x86/include/asm/setup.h           |    4 +
 arch/x86/include/uapi/asm/setup_data.h |   13 +++++
 arch/x86/kernel/e820.c                 |   18 +++++++
 arch/x86/kernel/kexec-bzimage64.c      |   36 +++++++++++++++
 arch/x86/kernel/setup.c                |   25 +++++++++++
 arch/x86/realmode/init.c               |    2 
 8 files changed, 151 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/compressed/kaslr.c~x86-add-kho-support
+++ a/arch/x86/boot/compressed/kaslr.c
@@ -760,6 +760,55 @@ static void process_e820_entries(unsigne
 	}
 }
 
+/*
+ * If KHO is active, only process its scratch areas to ensure we are not
+ * stepping onto preserved memory.
+ */
+#ifdef CONFIG_KEXEC_HANDOVER
+static bool process_kho_entries(unsigned long minimum, unsigned long image_size)
+{
+	struct kho_mem *kho_scratch;
+	struct setup_data *ptr;
+	int i, nr_areas = 0;
+
+	ptr = (struct setup_data *)(unsigned long)boot_params_ptr->hdr.setup_data;
+	while (ptr) {
+		if (ptr->type == SETUP_KEXEC_KHO) {
+			struct kho_data *kho = (struct kho_data *)ptr->data;
+
+			kho_scratch = (void *)kho->scratch_addr;
+			nr_areas = kho->scratch_size / sizeof(*kho_scratch);
+
+			break;
+		}
+
+		ptr = (struct setup_data *)(unsigned long)ptr->next;
+	}
+
+	if (!nr_areas)
+		return false;
+
+	for (i = 0; i < nr_areas; i++) {
+		struct kho_mem *area = &kho_scratch[i];
+		struct mem_vector region = {
+			.start = area->addr,
+			.size = area->size,
+		};
+
+		if (process_mem_region(&region, minimum, image_size))
+			break;
+	}
+
+	return true;
+}
+#else
+static inline bool process_kho_entries(unsigned long minimum,
+				       unsigned long image_size)
+{
+	return false;
+}
+#endif
+
 static unsigned long find_random_phys_addr(unsigned long minimum,
 					   unsigned long image_size)
 {
@@ -775,7 +824,8 @@ static unsigned long find_random_phys_ad
 		return 0;
 	}
 
-	if (!process_efi_entries(minimum, image_size))
+	if (!process_kho_entries(minimum, image_size) &&
+	    !process_efi_entries(minimum, image_size))
 		process_e820_entries(minimum, image_size);
 
 	phys_addr = slots_fetch_random();
--- a/arch/x86/include/asm/setup.h~x86-add-kho-support
+++ a/arch/x86/include/asm/setup.h
@@ -66,6 +66,10 @@ extern void x86_ce4100_early_setup(void)
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
+#ifdef CONFIG_KEXEC_HANDOVER
+#include <linux/kexec_handover.h>
+#endif
+
 #ifndef _SETUP
 
 #include <asm/espfix.h>
--- a/arch/x86/include/uapi/asm/setup_data.h~x86-add-kho-support
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
+	__u64 dt_addr;
+	__u64 dt_size;
+	__u64 scratch_addr;
+	__u64 scratch_size;
+} __attribute__((packed));
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_X86_SETUP_DATA_H */
--- a/arch/x86/Kconfig~x86-add-kho-support
+++ a/arch/x86/Kconfig
@@ -2091,6 +2091,9 @@ config ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIF
 config ARCH_SUPPORTS_KEXEC_JUMP
 	def_bool y
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool y
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool X86_64 || (X86_32 && HIGHMEM)
 
--- a/arch/x86/kernel/e820.c~x86-add-kho-support
+++ a/arch/x86/kernel/e820.c
@@ -1329,6 +1329,24 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+	/*
+	 * At this point with KHO we only allocate from scratch memory.
+	 * At the same time, we configure memblock to only allow
+	 * allocations from memory below ISA_END_ADDRESS which is not
+	 * a natural scratch region, because Linux ignores memory below
+	 * ISA_END_ADDRESS at runtime. Beside very few (if any) early
+	 * allocations, we must allocate real-mode trapoline below
+	 * ISA_END_ADDRESS.
+	 *
+	 * To make sure that we can actually perform allocations during
+	 * this phase, let's mark memory below ISA_END_ADDRESS as scratch
+	 * so we can allocate from there in a scratch-only world.
+	 *
+	 * After real mode trampoline is allocated, we clear scratch
+	 * marking from the memory below ISA_END_ADDRESS
+	 */
+	memblock_mark_kho_scratch(0, ISA_END_ADDRESS);
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 
--- a/arch/x86/kernel/kexec-bzimage64.c~x86-add-kho-support
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -233,6 +233,31 @@ setup_ima_state(const struct kimage *ima
 #endif /* CONFIG_IMA_KEXEC */
 }
 
+static void setup_kho(const struct kimage *image, struct boot_params *params,
+		      unsigned long params_load_addr,
+		      unsigned int setup_data_offset)
+{
+#ifdef CONFIG_KEXEC_HANDOVER
+	struct setup_data *sd = (void *)params + setup_data_offset;
+	struct kho_data *kho = (void *)sd + sizeof(*sd);
+
+	sd->type = SETUP_KEXEC_KHO;
+	sd->len = sizeof(struct kho_data);
+
+	/* Only add if we have all KHO images in place */
+	if (!image->kho.dt.buffer || !image->kho.scratch.buffer)
+		return;
+
+	/* Add setup data */
+	kho->dt_addr = image->kho.dt.mem;
+	kho->dt_size = image->kho.dt.bufsz;
+	kho->scratch_addr = image->kho.scratch.mem;
+	kho->scratch_size = image->kho.scratch.bufsz;
+	sd->next = params->hdr.setup_data;
+	params->hdr.setup_data = params_load_addr + setup_data_offset;
+#endif /* CONFIG_KEXEC_HANDOVER */
+}
+
 static int
 setup_boot_parameters(struct kimage *image, struct boot_params *params,
 		      unsigned long params_load_addr,
@@ -312,6 +337,13 @@ setup_boot_parameters(struct kimage *ima
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
 
@@ -479,6 +511,10 @@ static void *bzImage64_load(struct kimag
 		kbuf.bufsz += sizeof(struct setup_data) +
 			      sizeof(struct ima_setup_data);
 
+	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER))
+		kbuf.bufsz += sizeof(struct setup_data) +
+			      sizeof(struct kho_data);
+
 	params = kzalloc(kbuf.bufsz, GFP_KERNEL);
 	if (!params)
 		return ERR_PTR(-ENOMEM);
--- a/arch/x86/kernel/setup.c~x86-add-kho-support
+++ a/arch/x86/kernel/setup.c
@@ -385,6 +385,28 @@ int __init ima_get_kexec_buffer(void **a
 }
 #endif
 
+static void __init add_kho(u64 phys_addr, u32 data_len)
+{
+#ifdef CONFIG_KEXEC_HANDOVER
+	struct kho_data *kho;
+	u64 addr = phys_addr + sizeof(struct setup_data);
+	u64 size = data_len - sizeof(struct setup_data);
+
+	kho = early_memremap(addr, size);
+	if (!kho) {
+		pr_warn("setup: failed to memremap kho data (0x%llx, 0x%llx)\n",
+			addr, size);
+		return;
+	}
+
+	kho_populate(kho->dt_addr, kho->scratch_addr, kho->scratch_size);
+
+	early_memunmap(kho, size);
+#else
+	pr_warn("Passed KHO data, but CONFIG_KEXEC_HANDOVER not set. Ignoring.\n");
+#endif
+}
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -413,6 +435,9 @@ static void __init parse_setup_data(void
 		case SETUP_IMA:
 			add_early_ima_buffer(pa_data);
 			break;
+		case SETUP_KEXEC_KHO:
+			add_kho(pa_data, data_len);
+			break;
 		case SETUP_RNG_SEED:
 			data = early_memremap(pa_data, data_len);
 			add_bootloader_randomness(data->data, data->len);
--- a/arch/x86/realmode/init.c~x86-add-kho-support
+++ a/arch/x86/realmode/init.c
@@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
 	 * setup_arch().
 	 */
 	memblock_reserve(0, SZ_1M);
+
+	memblock_clear_kho_scratch(0, SZ_1M);
 }
 
 static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
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

