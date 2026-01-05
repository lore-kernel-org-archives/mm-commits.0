Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996261F4168
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648268; cv=none; b=bX/aC5pVGMxe+KOX43Blw60LYT4MMw4+RnXtuIhwbc3Dsz7c+w3XH22uVL+rQhat3+PaAUZmH2jOt6okE3VwN6vkIlvfpDaPQvrRs/oEc86w/BglRTzzdehM0zp7iA4wGxs0CSVTprmyxzeHaXp+PJlBix0nEtrVCUxwxgRZEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648268; c=relaxed/simple;
	bh=mwIVC0PGpXtMGiGg66pr6mBbmjpPyw5JlgEZxUs7aSM=;
	h=Date:To:From:Subject:Message-Id; b=eN1RNOnTz4IXAIrwSGrFIqb4rRK9dHu9BOMr8YJi23VP6dCuTp0VqmwTv1k1gNy5DJY2h/QJTQd6niqXllfP5grHQ7EbEpm1m1zOWqG5OZPtqxDrj+rcMhLJvJKDCm8Gr4jstHFg1zvHQxCZlvOlh+LodNpb1YPTNLGceknS5EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLQ3EwrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLQ3EwrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F76AC116D0;
	Mon,  5 Jan 2026 21:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767648268;
	bh=mwIVC0PGpXtMGiGg66pr6mBbmjpPyw5JlgEZxUs7aSM=;
	h=Date:To:From:Subject:From;
	b=tLQ3EwrQDDF2yhOeYG999z14jFyIxZh7m8Irp0EZlErHfiZiRA/J7dKwPBUTshb3g
	 a/fUXdMvQNjG19xeV0ZHEDKM2gXwayOr264kJrtAz7ZgTIi6MvFTkVcJrggo3ENv3Q
	 cbNTsnGH8S4vh73HhJ4koDW+vkoOElSkzmZFM3MQ=
Date: Mon, 05 Jan 2026 13:24:27 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jasonmiu@google.com,graf@amazon.com,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-abi-add-memblock-abi-header.patch added to mm-nonmm-unstable branch
Message-Id: <20260105212428.1F76AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho/abi: add memblock ABI header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-abi-add-memblock-abi-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-abi-add-memblock-abi-header.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho/abi: add memblock ABI header
Date: Mon, 5 Jan 2026 18:58:39 +0200

Introduce KHO ABI header describing preservation ABI for memblock's
reserve_mem regions and link the relevant documentation to KHO docs.

Link: https://lkml.kernel.org/r/20260105165839.285270-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Miu <jasonmiu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kho/abi.rst                            |    6 
 Documentation/core-api/kho/bindings/memblock/memblock.yaml    |   39 -----
 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml |   40 -----
 include/linux/kho/abi/memblock.h                              |   72 ++++++++++
 mm/memblock.c                                                 |    4 
 5 files changed, 79 insertions(+), 82 deletions(-)

--- a/Documentation/core-api/kho/abi.rst~kho-abi-add-memblock-abi-header
+++ a/Documentation/core-api/kho/abi.rst
@@ -16,6 +16,12 @@ vmalloc preservation ABI
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
    :doc: Kexec Handover ABI for vmalloc Preservation
 
+memblock preservation ABI
+=========================
+
+.. kernel-doc:: include/linux/kho/abi/memblock.h
+   :doc: memblock kexec handover ABI
+
 See Also
 ========
 
diff --git a/Documentation/core-api/kho/bindings/memblock/memblock.yaml a/Documentation/core-api/kho/bindings/memblock/memblock.yaml
deleted file mode 100644
--- a/Documentation/core-api/kho/bindings/memblock/memblock.yaml
+++ /dev/null
@@ -1,39 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: Memblock reserved memory
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-
-description: |
-  Memblock can serialize its current memory reservations created with
-  reserve_mem command line option across kexec through KHO.
-  The post-KHO kernel can then consume these reservations and they are
-  guaranteed to have the same physical address.
-
-properties:
-  compatible:
-    enum:
-      - reserve-mem-v1
-
-patternProperties:
-  "$[0-9a-f_]+^":
-    $ref: reserve-mem.yaml#
-    description: reserved memory regions
-
-required:
-  - compatible
-
-additionalProperties: false
-
-examples:
-  - |
-    memblock {
-      compatible = "memblock-v1";
-      n1 {
-        compatible = "reserve-mem-v1";
-        start = <0xc06b 0x4000000>;
-        size = <0x04 0x00>;
-      };
-    };
diff --git a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
deleted file mode 100644
--- a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
+++ /dev/null
@@ -1,40 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: Memblock reserved memory regions
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-
-description: |
-  Memblock can serialize its current memory reservations created with
-  reserve_mem command line option across kexec through KHO.
-  This object describes each such region.
-
-properties:
-  compatible:
-    enum:
-      - reserve-mem-v1
-
-  start:
-    description: |
-      physical address (u64) of the reserved memory region.
-
-  size:
-    description: |
-      size (u64) of the reserved memory region.
-
-required:
-  - compatible
-  - start
-  - size
-
-additionalProperties: false
-
-examples:
-  - |
-    n1 {
-      compatible = "reserve-mem-v1";
-      start = <0xc06b 0x4000000>;
-      size = <0x04 0x00>;
-    };
diff --git a/include/linux/kho/abi/memblock.h a/include/linux/kho/abi/memblock.h
new file mode 100644
--- /dev/null
+++ a/include/linux/kho/abi/memblock.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_KHO_ABI_MEMBLOCK_H
+#define _LINUX_KHO_ABI_MEMBLOCK_H
+
+/**
+ * DOC: memblock kexec handover ABI
+ *
+ * Memblock can serialize its current memory reservations created with
+ * reserve_mem command line option across kexec through KHO.
+ * The post-KHO kernel can then consume these reservations and they are
+ * guaranteed to have the same physical address.
+ *
+ * The state is serialized using Flattened Device Tree (FDT) format. Any
+ * modification to the FDT structure, node properties, or the compatible
+ * strings constitutes a breaking change. Such changes require incrementing the
+ * version number in the relevant `_COMPATIBLE` string to prevent a new kernel
+ * from misinterpreting data from an old kernel.
+ *
+ * Changes are allowed provided the compatibility version is incremented.
+ * However, backward/forward compatibility is only guaranteed for kernels
+ * supporting the same ABI version.
+ *
+ * FDT Structure Overview:
+ *   The entire memblock state is encapsulated within a single KHO entry named
+ *   "memblock".
+ *   This entry contains an FDT with the following layout:
+ *
+ *   .. code-block:: none
+ *
+ *	/ {
+ *		compatible = "memblock-v1";
+ *
+ *		n1 {
+ *			compatible = "reserve-mem-v1";
+ *			start = <0xc06b 0x4000000>;
+ *			size = <0x04 0x00>;
+ *		};
+ *	};
+ *
+ * Main memblock node (/):
+ *
+ *   - compatible: "memblock-v1"
+
+ *     Identifies the overall memblock ABI version.
+ *
+ * reserved_mem node:
+ *   These nodes describe all reserve_mem regions.
+ *
+ *   - compatible: "reserve-mem-v1"
+ *
+ *     Identifies the ABI version of reserve_mem descriptions
+ *
+ *   - start: u64
+ *
+ *     Physical address of the reserved memory region.
+ *
+ *   - size: u64
+ *
+ *     size in bytes of the reserved memory region.
+ */
+
+/* Top level memblock FDT node name. */
+#define MEMBLOCK_KHO_FDT "memblock"
+
+/* The compatible string for the memblock FDT root node. */
+#define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
+
+/* The compatible string for the reserve_mem FDT nodes. */
+#define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
+
+#endif /* _LINUX_KHO_ABI_MEMBLOCK_H */
--- a/mm/memblock.c~kho-abi-add-memblock-abi-header
+++ a/mm/memblock.c
@@ -21,6 +21,7 @@
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/memblock.h>
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #include <asm/sections.h>
@@ -2442,9 +2443,6 @@ int reserve_mem_release_by_name(const ch
 }
 
 #ifdef CONFIG_KEXEC_HANDOVER
-#define MEMBLOCK_KHO_FDT "memblock"
-#define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
-#define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 
 static int __init reserved_mem_preserve(void)
 {
_

Patches currently in -mm which might be from rppt@kernel.org are

mips-fix-highmem-initialization.patch
alpha-introduce-arch_zone_limits_init.patch
arc-introduce-arch_zone_limits_init.patch
arm-introduce-arch_zone_limits_init.patch
arm64-introduce-arch_zone_limits_init.patch
csky-introduce-arch_zone_limits_init.patch
hexagon-introduce-arch_zone_limits_init.patch
loongarch-introduce-arch_zone_limits_init.patch
m68k-introduce-arch_zone_limits_init.patch
microblaze-introduce-arch_zone_limits_init.patch
mips-introduce-arch_zone_limits_init.patch
nios2-introduce-arch_zone_limits_init.patch
openrisc-introduce-arch_zone_limits_init.patch
parisc-introduce-arch_zone_limits_init.patch
powerpc-introduce-arch_zone_limits_init.patch
riscv-introduce-arch_zone_limits_init.patch
s390-introduce-arch_zone_limits_init.patch
sh-introduce-arch_zone_limits_init.patch
sparc-introduce-arch_zone_limits_init.patch
um-introduce-arch_zone_limits_init.patch
x86-introduce-arch_zone_limits_init.patch
xtensa-introduce-arch_zone_limits_init.patch
arch-mm-consolidate-initialization-of-nodes-zones-and-memory-map.patch
arch-mm-consolidate-initialization-of-sparse-memory-model.patch
mips-drop-paging_init.patch
x86-dont-reserve-hugetlb-memory-in-setup_arch.patch
mm-arch-consolidate-hugetlb-cma-reservation.patch
mm-hugetlb-drop-hugetlb_cma_check.patch
revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
kho-abi-luo-make-generated-documentation-more-coherent.patch
kho-abi-memfd-make-generated-documentation-more-coherent.patch
kho-docs-combine-concepts-and-fdt-documentation.patch
kho-abi-add-memblock-abi-header.patch

