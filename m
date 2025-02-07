Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1B18027
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888204; cv=none; b=i9mFlYpQAPMwuva4ZPe2DBlZkwEC8EAZxt1nbkQ6NpGBzPPeMgc90XXg75DQH5ILO+qtypo08HuWP5h8qh56j4KLOwsN2D8WElzL5rGpAkUveXN38BLx7CeyJGs2L+UZ0kLgOuVgx1ezv6tdYD7b3rrFlJ9A1pScAb7z6ppJox8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888204; c=relaxed/simple;
	bh=ih974+ugecqqa3kg4t61/k8lm6eje+ywL62gPM3BtF4=;
	h=Date:To:From:Subject:Message-Id; b=HYZ9MuU1MzYGgmoAyhh4OOznEmK1t0S815cYtfaULPwDbgsN/YG73rWOi0PZnKXY19/HEQhebtMwLOMUVrZL+YL1Q/dWh6ay2UmT+s0ZY97O+FPQJs9bOCSvufOPUOSg39jPVS8vB0KCcOazubA/jO1uoTywXnYiRgV8btiQLDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XVQPW8pD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVQPW8pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7900BC4CEDD;
	Fri,  7 Feb 2025 00:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888203;
	bh=ih974+ugecqqa3kg4t61/k8lm6eje+ywL62gPM3BtF4=;
	h=Date:To:From:Subject:From;
	b=XVQPW8pDDaP/+R5Tjlat47a5rN3tCTdNtSIG+kxyCmSj6htqymZR8Ktrz4kv+3Qcy
	 sXcT59CI9VzMB2UUtxxglcjYHM1fCBMwtLidWG1iWvPvV+vIIXu+oNGEwVuEZSE0hx
	 JibRt2FDALW7gyyhGAOszHjToKxX+Anw2PMIpmEs=
Date: Thu, 06 Feb 2025 16:30:02 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-add-support-for-scratch-memory.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003003.7900BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: add support for scratch memory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     memblock-add-support-for-scratch-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-add-support-for-scratch-memory.patch

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
Subject: memblock: add support for scratch memory
Date: Thu, 6 Feb 2025 15:27:43 +0200

With KHO (Kexec HandOver), we need a way to ensure that the new kernel
does not allocate memory on top of any memory regions that the previous
kernel was handing over.  But to know where those are, we need to include
them in the memblock.reserved array which may not be big enough to hold
all ranges that need to be persisted across kexec.  To resize the array,
we need to allocate memory.  That brings us into a catch 22 situation.

The solution to that is limit memblock allocations to the scratch regions:
safe regions to operate in the case when there is memory that should
remain intact across kexec.

KHO provides several "scratch regions" as part of its metadata.  These
scratch regions are contiguous memory blocks that known not to contain any
memory that should be persisted across kexec.  These regions should be
large enough to accommodate all memblock allocations done by the kexeced
kernel.

We introduce a new memblock_set_scratch_only() function that allows KHO to
indicate that any memblock allocation must happen from the scratch
regions.

Later, we may want to perform another KHO kexec.  For that, we reuse the
same scratch regions.  To ensure that no eventually handed over data gets
allocated inside a scratch region, we flip the semantics of the scratch
region with memblock_clear_scratch_only(): After that call, no allocations
may happen from scratch memblock regions.  We will lift that restriction
in the next patch.

Link: https://lkml.kernel.org/r/20250206132754.2596694-4-rppt@kernel.org
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

 include/linux/memblock.h |   20 ++++++++++++
 mm/Kconfig               |    4 ++
 mm/memblock.c            |   61 +++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

--- a/include/linux/memblock.h~memblock-add-support-for-scratch-memory
+++ a/include/linux/memblock.h
@@ -42,6 +42,11 @@ extern unsigned long long max_possible_p
  * kernel resource tree.
  * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
  * not initialized (only for reserved regions).
+ * @MEMBLOCK_KHO_SCRATCH: memory region that kexec can pass to the next
+ * kernel in handover mode. During early boot, we do not know about all
+ * memory reservations yet, so we get scratch memory from the previous
+ * kernel that we know is good to use. It is the only memory that
+ * allocations may happen from in this phase.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -51,6 +56,7 @@ enum memblock_flags {
 	MEMBLOCK_DRIVER_MANAGED = 0x8,	/* always detected via a driver */
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
+	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 };
 
 /**
@@ -145,6 +151,8 @@ int memblock_mark_mirror(phys_addr_t bas
 int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
+int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
 
 void memblock_free_all(void);
 void memblock_free(void *ptr, size_t size);
@@ -289,6 +297,11 @@ static inline bool memblock_is_driver_ma
 	return m->flags & MEMBLOCK_DRIVER_MANAGED;
 }
 
+static inline bool memblock_is_kho_scratch(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_KHO_SCRATCH;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
@@ -617,5 +630,12 @@ static inline void early_memtest(phys_ad
 static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+void memblock_set_kho_scratch_only(void);
+void memblock_clear_kho_scratch_only(void);
+#else
+static inline void memblock_set_kho_scratch_only(void) { }
+static inline void memblock_clear_kho_scratch_only(void) { }
+#endif
 
 #endif /* _LINUX_MEMBLOCK_H */
--- a/mm/Kconfig~memblock-add-support-for-scratch-memory
+++ a/mm/Kconfig
@@ -467,6 +467,10 @@ config HAVE_GUP_FAST
 	depends on MMU
 	bool
 
+# Enable memblock support for scratch memory which is needed for kexec handover
+config MEMBLOCK_KHO_SCRATCH
+	bool
+
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
--- a/mm/memblock.c~memblock-add-support-for-scratch-memory
+++ a/mm/memblock.c
@@ -106,6 +106,13 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+/* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
+static bool kho_scratch_only;
+#else
+#define kho_scratch_only false
+#endif
+
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_MEMORY_REGIONS] __initdata_memblock;
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_RESERVED_REGIONS] __initdata_memblock;
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
@@ -165,6 +172,10 @@ bool __init_memblock memblock_has_mirror
 
 static enum memblock_flags __init_memblock choose_memblock_flags(void)
 {
+	/* skip non-scratch memory for kho early boot allocations */
+	if (kho_scratch_only)
+		return MEMBLOCK_KHO_SCRATCH;
+
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
 
@@ -924,6 +935,18 @@ int __init_memblock memblock_physmem_add
 }
 #endif
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+__init_memblock void memblock_set_kho_scratch_only(void)
+{
+	kho_scratch_only = true;
+}
+
+__init_memblock void memblock_clear_kho_scratch_only(void)
+{
+	kho_scratch_only = false;
+}
+#endif
+
 /**
  * memblock_setclr_flag - set or clear flag for a memory region
  * @type: memblock type to set/clear flag for
@@ -1049,6 +1072,36 @@ int __init_memblock memblock_reserved_ma
 				    MEMBLOCK_RSRV_NOINIT);
 }
 
+/**
+ * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
+ * for allocations during early boot with kexec handover.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_KHO_SCRATCH);
+}
+
+/**
+ * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
+ * specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 0,
+				    MEMBLOCK_KHO_SCRATCH);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -1080,6 +1133,13 @@ static bool should_skip_region(struct me
 	if (!(flags & MEMBLOCK_DRIVER_MANAGED) && memblock_is_driver_managed(m))
 		return true;
 
+	/*
+	 * In early alloc during kexec handover, we can only consider
+	 * MEMBLOCK_KHO_SCRATCH regions for the allocations
+	 */
+	if ((flags & MEMBLOCK_KHO_SCRATCH) && !memblock_is_kho_scratch(m))
+		return true;
+
 	return false;
 }
 
@@ -2413,6 +2473,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
+	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
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

