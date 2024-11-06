Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7392715EFA1;
	Wed,  6 Nov 2024 01:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854839; cv=none; b=PjCTWjFAFcuedPt1s32q3xABBEAPG3g4/tLeWFy2T7R4DbIfFh1mDrg7GcVcD91gaOXKWG5m/5snpUAE5yZiPtRwPj/r5k6P/CCbLTXHkaH91OIqa2GD/JkoqcLg3QDODyTsLMG9Cx5JTdTdCLBTdyzGKFLjWsssQOfOYFjaQCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854839; c=relaxed/simple;
	bh=uOjnK5IYdbW1ozDQwmMj4AfgqkHD1ntDXmqI7P9nPmQ=;
	h=Date:To:From:Subject:Message-Id; b=uBQm6Z+Lwyf/XPXxslU22SGg1B/jtQmH9Z54BKCujWXoVlwBkLqvBL0QMPUkqsyCjC3I9bxN8qgvble1BBC3Njyw+R5d81VzFmFM+mgGCWBZ+pEwGjGCC+6Eje/b9ZJNmWzEpp+lMV2Kk9uSfKnUP1WkmoYvcpIbKPGx6V3DLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c/KdlNh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c/KdlNh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C14C4CECF;
	Wed,  6 Nov 2024 01:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854839;
	bh=uOjnK5IYdbW1ozDQwmMj4AfgqkHD1ntDXmqI7P9nPmQ=;
	h=Date:To:From:Subject:From;
	b=c/KdlNh1KJxzVLdDOCKr1NX+H5rGJGRPXkClMgDVqYxzr+wq/3GfnYYJdKfFzdvqN
	 HW4P4bxJEJRXWXt6ydcfDmfLvhY0OaxZSQY4gD2PzUMjKZubpV8z5+be51JBsBjxtA
	 r4j1lfBBeMyiSKhUGx4xk7uMqL/X8N5WSPdBwwFU=
Date: Tue, 05 Nov 2024 17:00:38 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,kdevops@lists.linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@lst.de,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch removed from -mm tree
Message-Id: <20241106010039.38C14C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: group declarations depending on CONFIG_MMU together
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: vmalloc: group declarations depending on CONFIG_MMU together
Date: Wed, 23 Oct 2024 19:27:04 +0300

Patch series "x86/module: use large ROX pages for text allocations", v7.

These patches add support for using large ROX pages for allocations of
executable memory on x86.

They address Andy's comments [1] about having executable mappings for code
that was not completely formed.

The approach taken is to allocate ROX memory along with writable but not
executable memory and use the writable copy to perform relocations and
alternatives patching.  After the module text gets into its final shape,
the contents of the writable memory is copied into the actual ROX location
using text poking.

The allocations of the ROX memory use vmalloc(VMAP_ALLOW_HUGE_MAP) to
allocate PMD aligned memory, fill that memory with invalid instructions
and in the end remap it as ROX.  Portions of these large pages are handed
out to execmem_alloc() callers without any changes to the permissions. 
When the memory is freed with execmem_free() it is invalidated again so
that it won't contain stale instructions.

The module memory allocation, x86 code dealing with relocations and
alternatives patching take into account the existence of the two copies,
the writable memory and the ROX memory at the actual allocated virtual
address.

[1] https://lore.kernel.org/all/a17c65c6-863f-4026-9c6f-a04b659e9ab4@app.fastmail.com


This patch (of 8):

There are a couple of declarations that depend on CONFIG_MMU in
include/linux/vmalloc.h spread all over the file.

Group them all together to improve code readability.

No functional changes.

Link: https://lkml.kernel.org/r/20241023162711.2579610-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20241023162711.2579610-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: kdevops <kdevops@lists.linux.dev>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |   60 +++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-group-declarations-depending-on-config_mmu-together
+++ a/include/linux/vmalloc.h
@@ -134,12 +134,6 @@ extern void vm_unmap_ram(const void *mem
 extern void *vm_map_ram(struct page **pages, unsigned int count, int node);
 extern void vm_unmap_aliases(void);
 
-#ifdef CONFIG_MMU
-extern unsigned long vmalloc_nr_pages(void);
-#else
-static inline unsigned long vmalloc_nr_pages(void) { return 0; }
-#endif
-
 extern void *vmalloc_noprof(unsigned long size) __alloc_size(1);
 #define vmalloc(...)		alloc_hooks(vmalloc_noprof(__VA_ARGS__))
 
@@ -266,12 +260,29 @@ static inline bool is_vm_area_hugepages(
 #endif
 }
 
+/* for /proc/kcore */
+long vread_iter(struct iov_iter *iter, const char *addr, size_t count);
+
+/*
+ *	Internals.  Don't use..
+ */
+__init void vm_area_add_early(struct vm_struct *vm);
+__init void vm_area_register_early(struct vm_struct *vm, size_t align);
+
+int register_vmap_purge_notifier(struct notifier_block *nb);
+int unregister_vmap_purge_notifier(struct notifier_block *nb);
+
 #ifdef CONFIG_MMU
+#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
+
+unsigned long vmalloc_nr_pages(void);
+
 int vm_area_map_pages(struct vm_struct *area, unsigned long start,
 		      unsigned long end, struct page **pages);
 void vm_area_unmap_pages(struct vm_struct *area, unsigned long start,
 			 unsigned long end);
 void vunmap_range(unsigned long addr, unsigned long end);
+
 static inline void set_vm_flush_reset_perms(void *addr)
 {
 	struct vm_struct *vm = find_vm_area(addr);
@@ -279,24 +290,14 @@ static inline void set_vm_flush_reset_pe
 	if (vm)
 		vm->flags |= VM_FLUSH_RESET_PERMS;
 }
+#else  /* !CONFIG_MMU */
+#define VMALLOC_TOTAL 0UL
 
-#else
-static inline void set_vm_flush_reset_perms(void *addr)
-{
-}
-#endif
-
-/* for /proc/kcore */
-extern long vread_iter(struct iov_iter *iter, const char *addr, size_t count);
-
-/*
- *	Internals.  Don't use..
- */
-extern __init void vm_area_add_early(struct vm_struct *vm);
-extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
+static inline unsigned long vmalloc_nr_pages(void) { return 0; }
+static inline void set_vm_flush_reset_perms(void *addr) {}
+#endif /* CONFIG_MMU */
 
-#ifdef CONFIG_SMP
-# ifdef CONFIG_MMU
+#if defined(CONFIG_MMU) && defined(CONFIG_SMP)
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
 				     size_t align);
@@ -311,22 +312,9 @@ pcpu_get_vm_areas(const unsigned long *o
 	return NULL;
 }
 
-static inline void
-pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
-{
-}
-# endif
-#endif
-
-#ifdef CONFIG_MMU
-#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
-#else
-#define VMALLOC_TOTAL 0UL
+static inline void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms) {}
 #endif
 
-int register_vmap_purge_notifier(struct notifier_block *nb);
-int unregister_vmap_purge_notifier(struct notifier_block *nb);
-
 #if defined(CONFIG_MMU) && defined(CONFIG_PRINTK)
 bool vmalloc_dump_obj(void *object);
 #else
_

Patches currently in -mm which might be from rppt@kernel.org are


