Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D8313C9A3
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744412794; cv=none; b=tnd7E4kAK6Brty2oI91UygWHLVyC+4NqRwliHVIG15h3+bsV6pWIyaZd66fBGLk2rPzaGSQ/7SggREFrA0TYD+oHs4ndSGnVzd5pLeBH9JExdpbiR/alz76PPCS/w61KnCFN6WUh0GNvq822FOK2uBSZo8pPQaBC25gv4dMnkqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744412794; c=relaxed/simple;
	bh=j0ha1nMAWlyhM9UGKSye/gcE4NoK8BYAn7onlHQcGJo=;
	h=Date:To:From:Subject:Message-Id; b=MrBsQe93Ladoi1j7q2xviChxXmEYoIt1zSJFHyTAQp1dA7a97IP4LVkDmp+z5Bv2bQWeQgGwnK23f2sO0rEvPXm8RFVUvlSuXlRKA9i1Daa/pyZplr5EYH7/YKU+li99ZiUpBc3WuRpFKrCRPPrJ7OXrcThD71lkrDVPLByNOhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HvRXZ4PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HvRXZ4PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335DFC4CEE2;
	Fri, 11 Apr 2025 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744412794;
	bh=j0ha1nMAWlyhM9UGKSye/gcE4NoK8BYAn7onlHQcGJo=;
	h=Date:To:From:Subject:From;
	b=HvRXZ4PLtf+qKDWKFk0AIh3Xb5czG2obcp7B7PznOHnm7kzFaaGNGPA29HF3K9ohR
	 eZzoMhd7TUcsPZXqqjA+dqGmI8n38YvbznJy/IYiuSpWsbzhmoGFDyapaWzIzTM1ft
	 7SQugeq4JpYUhJ9w8AUgoLZVkBbdzOlJwcdP+FB4=
Date: Fri, 11 Apr 2025 16:06:33 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-add-support-for-scratch-memory.patch added to mm-new branch
Message-Id: <20250411230634.335DFC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: add support for scratch memory
has been added to the -mm mm-new branch.  Its filename is
     memblock-add-support-for-scratch-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-add-support-for-scratch-memory.patch

This patch will later appear in the mm-new branch at
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
Date: Thu, 10 Apr 2025 22:37:33 -0700

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

Link: https://lkml.kernel.org/r/20250411053745.1817356-3-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>
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

 include/linux/memblock.h |   20 ++++++++++++
 mm/Kconfig               |    4 ++
 mm/memblock.c            |   61 +++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

--- a/include/linux/memblock.h~memblock-add-support-for-scratch-memory
+++ a/include/linux/memblock.h
@@ -45,6 +45,11 @@ extern unsigned long long max_possible_p
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
+ * @MEMBLOCK_KHO_SCRATCH: memory region that kexec can pass to the next
+ * kernel in handover mode. During early boot, we do not know about all
+ * memory reservations yet, so we get scratch memory from the previous
+ * kernel that we know is good to use. It is the only memory that
+ * allocations may happen from in this phase.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -54,6 +59,7 @@ enum memblock_flags {
 	MEMBLOCK_DRIVER_MANAGED = 0x8,	/* always detected via a driver */
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
+	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 };
 
 /**
@@ -148,6 +154,8 @@ int memblock_mark_mirror(phys_addr_t bas
 int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
+int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 void reset_all_zones_managed_pages(void);
@@ -291,6 +299,11 @@ static inline bool memblock_is_driver_ma
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
@@ -619,5 +632,12 @@ static inline void early_memtest(phys_ad
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
@@ -469,6 +469,10 @@ config HAVE_GUP_FAST
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
@@ -107,6 +107,13 @@ unsigned long min_low_pfn;
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
@@ -166,6 +173,10 @@ bool __init_memblock memblock_has_mirror
 
 static enum memblock_flags __init_memblock choose_memblock_flags(void)
 {
+	/* skip non-scratch memory for kho early boot allocations */
+	if (kho_scratch_only)
+		return MEMBLOCK_KHO_SCRATCH;
+
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
 
@@ -925,6 +936,18 @@ int __init_memblock memblock_physmem_add
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
@@ -1050,6 +1073,36 @@ int __init_memblock memblock_reserved_ma
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
@@ -1081,6 +1134,13 @@ static bool should_skip_region(struct me
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
 
@@ -2465,6 +2525,7 @@ static const char * const flagname[] = {
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
arm64-add-kho-support.patch
x86-add-kho-support.patch
memblock-add-kho-support-for-reserve_mem.patch
documentation-add-documentation-for-kho.patch

