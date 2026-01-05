Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAA11F4168
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648264; cv=none; b=qPjtK+6UcfdTzbgR1MMBEsi+9+R4ryFojVt7pBuglFgAlR4eXVR0YiO79WJs9ikZ0k8/EMKnFgnvamjLRCa5dcxGHyFaJDclBHSpVz3imWvRg1CBMg3+INE1b4V8g2kLALUkTrlVvD2nMuq1LFZSN5Xhc4oaequ46P79C51t1Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648264; c=relaxed/simple;
	bh=XC4HAak/e2EGLQRuroLEBakUJs3WJ/N3YL3gKEyPeyU=;
	h=Date:To:From:Subject:Message-Id; b=jJL/cx0X+0onvaU0Kw5uDbhTMUAbKCJV9ip429rUgzMuIYckBOiiCeI2JqjoGVHJwmPSjpG/43gFQwie5yg0BY/aS2SKgZ8oRwyIsJue1ldYNbmY9MwfzR6cEEdX+/sqHUfIgesjjSg+Xtts5NO3nbjGpsHN0E45ERfCIbwXt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0iG3WEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0iG3WEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E6FC116D0;
	Mon,  5 Jan 2026 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767648263;
	bh=XC4HAak/e2EGLQRuroLEBakUJs3WJ/N3YL3gKEyPeyU=;
	h=Date:To:From:Subject:From;
	b=K0iG3WEJP5kAh95Qe+hWX2TskOd4wKDJLSFXgILSXWomzNyjpId3BIMNE+bAB6Spo
	 EtXTqwjTCB2OZnebjaC4GDmjJ1yHzbPNzLbAVT24T0LYSJjQFyufWGZGm2+a0vEkDb
	 xaiCiXuVUiWJs++woFUVmarRbQJrAnKZ2+iGmwOY=
Date: Mon, 05 Jan 2026 13:24:23 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,corbet@lwn.net,jasonmiu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-relocate-vmalloc-preservation-structure-to-kho-abi-header.patch added to mm-nonmm-unstable branch
Message-Id: <20260105212423.C8E6FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: relocate vmalloc preservation structure to KHO ABI header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-relocate-vmalloc-preservation-structure-to-kho-abi-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-relocate-vmalloc-preservation-structure-to-kho-abi-header.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jason Miu <jasonmiu@google.com>
Subject: kho: relocate vmalloc preservation structure to KHO ABI header
Date: Mon, 5 Jan 2026 18:58:38 +0200

The `struct kho_vmalloc` defines the in-memory layout for preserving
vmalloc regions across kexec.  This layout is a contract between kernels
and part of the KHO ABI.

To reflect this relationship, the related structs and helper macros are
relocated to the ABI header, `include/linux/kho/abi/kexec_handover.h`. 
This move places the structure's definition under the protection of the
KHO_FDT_COMPATIBLE version string.

The structure and its components are now also documented within the ABI
header to describe the contract and prevent ABI breaks.

Link: https://lkml.kernel.org/r/20260105165839.285270-6-rppt@kernel.org
Signed-off-by: Jason Miu <jasonmiu@google.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kho/abi.rst     |    6 +
 include/linux/kexec_handover.h         |   27 -------
 include/linux/kho/abi/kexec_handover.h |   78 +++++++++++++++++++++++
 include/linux/kho/abi/memfd.h          |    2 
 kernel/liveupdate/kexec_handover.c     |   15 ----
 lib/test_kho.c                         |    1 
 6 files changed, 88 insertions(+), 41 deletions(-)

--- a/Documentation/core-api/kho/abi.rst~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header
+++ a/Documentation/core-api/kho/abi.rst
@@ -10,6 +10,12 @@ Core Kexec Handover ABI
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
    :doc: Kexec Handover ABI
 
+vmalloc preservation ABI
+========================
+
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+   :doc: Kexec Handover ABI for vmalloc Preservation
+
 See Also
 ========
 
--- a/include/linux/kexec_handover.h~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header
+++ a/include/linux/kexec_handover.h
@@ -11,34 +11,11 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
+struct kho_vmalloc;
+
 struct folio;
 struct page;
 
-#define DECLARE_KHOSER_PTR(name, type) \
-	union {                        \
-		phys_addr_t phys;      \
-		type ptr;              \
-	} name
-#define KHOSER_STORE_PTR(dest, val)               \
-	({                                        \
-		typeof(val) v = val;              \
-		typecheck(typeof((dest).ptr), v); \
-		(dest).phys = virt_to_phys(v);    \
-	})
-#define KHOSER_LOAD_PTR(src)                                                 \
-	({                                                                   \
-		typeof(src) s = src;                                         \
-		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
-	})
-
-struct kho_vmalloc_chunk;
-struct kho_vmalloc {
-	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
-	unsigned int total_pages;
-	unsigned short flags;
-	unsigned short order;
-};
-
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 bool is_kho_boot(void);
--- a/include/linux/kho/abi/kexec_handover.h~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header
+++ a/include/linux/kho/abi/kexec_handover.h
@@ -10,6 +10,8 @@
 #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 
+#include <linux/types.h>
+
 /**
  * DOC: Kexec Handover ABI
  *
@@ -82,4 +84,80 @@
 /* The FDT property for sub-FDTs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
 
+/**
+ * DOC: Kexec Handover ABI for vmalloc Preservation
+ *
+ * The Kexec Handover ABI for preserving vmalloc'ed memory is defined by
+ * a set of structures and helper macros. The layout of these structures is a
+ * stable contract between kernels and is versioned by the KHO_FDT_COMPATIBLE
+ * string.
+ *
+ * The preservation is managed through a main descriptor &struct kho_vmalloc,
+ * which points to a linked list of &struct kho_vmalloc_chunk structures. These
+ * chunks contain the physical addresses of the preserved pages, allowing the
+ * next kernel to reconstruct the vmalloc area with the same content and layout.
+ * Helper macros are also defined for storing and loading pointers within
+ * these structures.
+ */
+
+/* Helper macro to define a union for a serializable pointer. */
+#define DECLARE_KHOSER_PTR(name, type)	\
+	union {                        \
+		u64 phys;              \
+		type ptr;              \
+	} name
+
+/* Stores the physical address of a serializable pointer. */
+#define KHOSER_STORE_PTR(dest, val)               \
+	({                                        \
+		typeof(val) v = val;              \
+		typecheck(typeof((dest).ptr), v); \
+		(dest).phys = virt_to_phys(v);    \
+	})
+
+/* Loads the stored physical address back to a pointer. */
+#define KHOSER_LOAD_PTR(src)						\
+	({                                                                   \
+		typeof(src) s = src;                                         \
+		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
+	})
+
+/*
+ * This header is embedded at the beginning of each `kho_vmalloc_chunk`
+ * and contains a pointer to the next chunk in the linked list,
+ * stored as a physical address for handover.
+ */
+struct kho_vmalloc_hdr {
+	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
+};
+
+#define KHO_VMALLOC_SIZE				\
+	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
+	 sizeof(u64))
+
+/*
+ * Each chunk is a single page and is part of a linked list that describes
+ * a preserved vmalloc area. It contains the header with the link to the next
+ * chunk and an array of physical addresses of the pages that make up the
+ * preserved vmalloc area.
+ */
+struct kho_vmalloc_chunk {
+	struct kho_vmalloc_hdr hdr;
+	u64 phys[KHO_VMALLOC_SIZE];
+};
+
+static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
+
+/*
+ * Describes a preserved vmalloc memory area, including the
+ * total number of pages, allocation flags, page order, and a pointer to the
+ * first chunk of physical page addresses.
+ */
+struct kho_vmalloc {
+	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
+	unsigned int total_pages;
+	unsigned short flags;
+	unsigned short order;
+};
+
 #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
--- a/include/linux/kho/abi/memfd.h~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header
+++ a/include/linux/kho/abi/memfd.h
@@ -12,7 +12,7 @@
 #define _LINUX_KHO_ABI_MEMFD_H
 
 #include <linux/types.h>
-#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
 
 /**
  * DOC: memfd Live Update ABI
--- a/kernel/liveupdate/kexec_handover.c~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header
+++ a/kernel/liveupdate/kexec_handover.c
@@ -889,21 +889,6 @@ void kho_unpreserve_pages(struct page *p
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
-struct kho_vmalloc_hdr {
-	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
-};
-
-#define KHO_VMALLOC_SIZE				\
-	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
-	 sizeof(phys_addr_t))
-
-struct kho_vmalloc_chunk {
-	struct kho_vmalloc_hdr hdr;
-	phys_addr_t phys[KHO_VMALLOC_SIZE];
-};
-
-static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
-
 /* vmalloc flags KHO supports */
 #define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
 
--- a/lib/test_kho.c~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header
+++ a/lib/test_kho.c
@@ -19,6 +19,7 @@
 #include <linux/printk.h>
 #include <linux/vmalloc.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
 
 #include <net/checksum.h>
 
_

Patches currently in -mm which might be from jasonmiu@google.com are

kho-introduce-kho-fdt-abi-header.patch
kho-relocate-vmalloc-preservation-structure-to-kho-abi-header.patch

