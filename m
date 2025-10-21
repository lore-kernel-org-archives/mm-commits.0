Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CF5281503
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 20:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761080030; cv=none; b=UuDeNXdOlHpCj/h2zMwcWEFaZBdQdVjRy1bY/X7ulvy4eVLN2+0vBc8gjdo1iirPk47COuj8x1rCJgz7pn+5nKxXRJm56E+h6XgiGRxtrHztOtMME6dHRWBfDKDK42x96r1vCjf+DlIeDQVU9NNrTtG1UKQeKCpZ1i8Vk2U1qYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761080030; c=relaxed/simple;
	bh=4iA03SKmxizNULInjgl2+xGGBFFoMxJX9+iNohe2Imo=;
	h=Date:To:From:Subject:Message-Id; b=Wp6BjimTnIXATtq9imeyTmD1ZGOkBewST2gL/yPQMQ92q+mojv4iF8r7MDIXcANoWaghkoyJK5ba0OdwlHaWtOS4MdeP48a9Izrj7h3DJVdSdi/NDFsXfafROCVVO17BLue8Iq/CuKSlLbdtBX3YDibkPvVGpcPimzFYENz1lWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NYi0kfuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NYi0kfuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F95C4CEF1;
	Tue, 21 Oct 2025 20:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761080029;
	bh=4iA03SKmxizNULInjgl2+xGGBFFoMxJX9+iNohe2Imo=;
	h=Date:To:From:Subject:From;
	b=NYi0kfuLquqFcCvKNdG7Tvc4bCg+LH6wVPHLyz7UNrK3n81cC5QPKXJwu2wx1W9f0
	 l4PW8shevOjuLApjTcAJUEeM/VTy84UcP8jkv1wtMRlVHGVRBtKiJQxxzWGUa68uJW
	 VdfFPUEHABkCL78R6gxjj/HGbNshgO+ZKB0GjUh4=
Date: Tue, 21 Oct 2025 13:53:49 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,skhawaja@google.com,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,graf@amazon.com,dmatlack@google.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch added to mm-new branch
Message-Id: <20251021205349.A9F95C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: warn and fail on metadata or preserved memory in scratch area
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: warn and fail on metadata or preserved memory in scratch area
Date: Mon, 20 Oct 2025 20:08:50 -0400

Patch series "KHO: kfence + KHO memory corruption fix", v3.

This series fixes a memory corruption bug in KHO that occurs when KFENCE
is enabled.

The root cause is that KHO metadata, allocated via kzalloc(), can be
randomly serviced by kfence_alloc().  When a kernel boots via KHO, the
early memblock allocator is restricted to a "scratch area".  This forces
the KFENCE pool to be allocated within this scratch area, creating a
conflict.  If KHO metadata is subsequently placed in this pool, it gets
corrupted during the next kexec operation.

Patch 1/3 introduces a debug-only feature (CONFIG_KEXEC_HANDOVER_DEBUG)
that adds checks to detect and fail any operation that attempts to place
KHO metadata or preserved memory within the scratch area.  This serves as
a validation and diagnostic tool to confirm the problem without affecting
production builds.

Patch 2/3 Increases bitmap to PAGE_SIZE, so buddy allocator can be used.

Patch 3/3 Provides the fix by modifying KHO to allocate its metadata
directly from the buddy allocator instead of slab.  This bypasses the
KFENCE interception entirely.


This patch (of 3):

It is invalid for KHO metadata or preserved memory regions to be located
within the KHO scratch area, as this area is overwritten when the next
kernel is loaded, and used early in boot by the next kernel.  This can
lead to memory corruption.

Add checks to kho_preserve_* and KHO's internal metadata allocators
(xa_load_or_alloc, new_chunk) to verify that the physical address of the
memory does not overlap with any defined scratch region.  If an overlap is
detected, the operation will fail and a WARN_ON is triggered.  To avoid
performance overhead in production kernels, these checks are enabled only
when CONFIG_KEXEC_HANDOVER_DEBUG is selected.

Link: https://lkml.kernel.org/r/20251021000852.2924827-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20251021000852.2924827-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec             |    9 ++++
 kernel/Makefile                  |    1 
 kernel/kexec_handover.c          |   53 +++++++++++++++++++----------
 kernel/kexec_handover_debug.c    |   25 +++++++++++++
 kernel/kexec_handover_internal.h |   16 ++++++++
 5 files changed, 87 insertions(+), 17 deletions(-)

--- a/kernel/Kconfig.kexec~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area
+++ a/kernel/Kconfig.kexec
@@ -109,6 +109,15 @@ config KEXEC_HANDOVER
 	  to keep data or state alive across the kexec. For this to work,
 	  both source and target kernels need to have this option enabled.
 
+config KEXEC_HANDOVER_DEBUG
+	bool "Enable Kexec Handover debug checks"
+	depends on KEXEC_HANDOVER_DEBUGFS
+	help
+	  This option enables extra sanity checks for the Kexec Handover
+	  subsystem. Since, KHO performance is crucial in live update
+	  scenarios and the extra code might be adding overhead it is
+	  only optionally enabled.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
--- a/kernel/kexec_handover.c~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area
+++ a/kernel/kexec_handover.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) "KHO: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/count_zeros.h>
 #include <linux/debugfs.h>
@@ -22,6 +23,7 @@
 
 #include <asm/early_ioremap.h>
 
+#include "kexec_handover_internal.h"
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
@@ -133,26 +135,26 @@ static struct kho_out kho_out = {
 
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
-	void *elm, *res;
+	void *res = xa_load(xa, index);
 
-	elm = xa_load(xa, index);
-	if (elm)
-		return elm;
+	if (res)
+		return res;
+
+	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
 
-	elm = kzalloc(sz, GFP_KERNEL);
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
+		return ERR_PTR(-EINVAL);
+
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
 	if (xa_is_err(res))
-		res = ERR_PTR(xa_err(res));
-
-	if (res) {
-		kfree(elm);
+		return ERR_PTR(xa_err(res));
+	else if (res)
 		return res;
-	}
 
-	return elm;
+	return no_free_ptr(elm);
 }
 
 static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
@@ -345,15 +347,19 @@ static_assert(sizeof(struct khoser_mem_c
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk;
+	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
 
 	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chunk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))
+		return ERR_PTR(-EINVAL);
+
 	chunk->hdr.order = order;
 	if (cur_chunk)
 		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return chunk;
+	return no_free_ptr(chunk);
 }
 
 static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
@@ -374,14 +380,17 @@ static int kho_mem_serialize(struct kho_
 	struct khoser_mem_chunk *chunk = NULL;
 	struct kho_mem_phys *physxa;
 	unsigned long order;
+	int err = -ENOMEM;
 
 	xa_for_each(&ser->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
 		chunk = new_chunk(chunk, order);
-		if (!chunk)
+		if (IS_ERR(chunk)) {
+			err = PTR_ERR(chunk);
 			goto err_free;
+		}
 
 		if (!first_chunk)
 			first_chunk = chunk;
@@ -391,8 +400,10 @@ static int kho_mem_serialize(struct kho_
 
 			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
 				chunk = new_chunk(chunk, order);
-				if (!chunk)
+				if (IS_ERR(chunk)) {
+					err = PTR_ERR(chunk);
 					goto err_free;
+				}
 			}
 
 			elm = &chunk->bitmaps[chunk->hdr.num_elms];
@@ -409,7 +420,7 @@ static int kho_mem_serialize(struct kho_
 
 err_free:
 	kho_mem_ser_free(first_chunk);
-	return -ENOMEM;
+	return err;
 }
 
 static void __init deserialize_bitmap(unsigned int order,
@@ -752,6 +763,9 @@ int kho_preserve_folio(struct folio *fol
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.ser.track;
 
+	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+		return -EINVAL;
+
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -775,6 +789,11 @@ int kho_preserve_pages(struct page *page
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
+	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
+					nr_pages << PAGE_SHIFT))) {
+		return -EINVAL;
+	}
+
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
diff --git a/kernel/kexec_handover_debug.c a/kernel/kexec_handover_debug.c
new file mode 100644
--- /dev/null
+++ a/kernel/kexec_handover_debug.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover_debug.c - kexec handover optional debug functionality
+ * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) "KHO: " fmt
+
+#include "kexec_handover_internal.h"
+
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (phys < scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
diff --git a/kernel/kexec_handover_internal.h a/kernel/kexec_handover_internal.h
new file mode 100644
--- /dev/null
+++ a/kernel/kexec_handover_internal.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
+#define LINUX_KEXEC_HANDOVER_INTERNAL_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+#else
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
+
+#endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
--- a/kernel/Makefile~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area
+++ a/kernel/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
 obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranes.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
kho-move-kho-debugfs-directory-to-liveupdate.patch

