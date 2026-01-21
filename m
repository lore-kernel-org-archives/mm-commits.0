Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE68E221723
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967387; cv=none; b=Yv1f7CAfHKdFOa//Ox9u0U0kyIHP2lf8PhUO0p2pWrhrQTde1J//Gs5xbzAV3kwK/Es3sJnsrrjAvOy3nxdaIRQ2J3sDMfKi2y5HvVfaBqKYh/FUvkNPSd1wvo36413zmM15rMZUy9Zygjxxz8B1lTCJ8hkl5CPG5LEjRFL56Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967387; c=relaxed/simple;
	bh=ABS/DGhfbjlZU73EECq7j8uL4sDLcd9WEa+O+9Towyk=;
	h=Date:To:From:Subject:Message-Id; b=hA7zxZJ/IXx3qeD4G9N0VdJ58Y1MWXUuD1UYtxCVBHrO1IyC4dE/qwdpn4aYx/hkssF5GSfsZH9wqK5S0TNLX1wPMD/Jkn6+xAIl/JcEhbQI9RrhCeO1N5AaXuURJQZOnFZRDQXoSdGaO65kvB2ytuYz1ldOeK+KAJV1YQlMmQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ki0rV4yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ki0rV4yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146D4C16AAE;
	Wed, 21 Jan 2026 03:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967385;
	bh=ABS/DGhfbjlZU73EECq7j8uL4sDLcd9WEa+O+9Towyk=;
	h=Date:To:From:Subject:From;
	b=Ki0rV4ywuFT3aPCHtd7TyYxn6cg4qkiEyiqdCZHfjuxA0PuqEwE7rqyd+uJjqhQR7
	 z/t7HL61uuiCjj0hlU+54bJFHiJPb6GfFGSoRZHz0vzsseHOWNEkAu5ZON13s4/s/0
	 gYrZSzRCbC0+xvWGe+eILM/OItAgRnW9YYsTBS+g=
Date: Tue, 20 Jan 2026 19:49:44 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,corbet@lwn.net,jasonmiu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-introduce-kho-fdt-abi-header.patch removed from -mm tree
Message-Id: <20260121034945.146D4C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: introduce KHO FDT ABI header
has been removed from the -mm tree.  Its filename was
     kho-introduce-kho-fdt-abi-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Miu <jasonmiu@google.com>
Subject: kho: introduce KHO FDT ABI header
Date: Mon, 5 Jan 2026 18:58:37 +0200

Introduce the `include/linux/kho/abi/kexec_handover.h` header file, which
defines the stable ABI for the KHO mechanism.  This header specifies how
preserved data is passed between kernels using an FDT.

The ABI contract includes the FDT structure, node properties, and the
"kho-v1" compatible string.  By centralizing these definitions, this
header serves as the foundational agreement for inter-kernel communication
of preserved states, ensuring forward compatibility and preventing
misinterpretation of data across kexec transitions.

Since the ABI definitions are now centralized in the header files, the
YAML files that previously described the FDT interfaces are redundant. 
These redundant files have therefore been removed.

Link: https://lkml.kernel.org/r/20260105165839.285270-5-rppt@kernel.org
Signed-off-by: Jason Miu <jasonmiu@google.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kho/abi.rst               |   16 ++
 Documentation/core-api/kho/bindings/kho.yaml     |   43 ------
 Documentation/core-api/kho/bindings/sub-fdt.yaml |   27 ----
 Documentation/core-api/kho/index.rst             |    9 +
 MAINTAINERS                                      |    1 
 include/linux/kho/abi/kexec_handover.h           |   85 +++++++++++++
 kernel/liveupdate/kexec_handover.c               |   19 +-
 7 files changed, 120 insertions(+), 80 deletions(-)

diff --git a/Documentation/core-api/kho/abi.rst a/Documentation/core-api/kho/abi.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/abi.rst
@@ -0,0 +1,16 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+==================
+Kexec Handover ABI
+==================
+
+Core Kexec Handover ABI
+========================
+
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+   :doc: Kexec Handover ABI
+
+See Also
+========
+
+- :doc:`/admin-guide/mm/kho`
diff --git a/Documentation/core-api/kho/bindings/kho.yaml a/Documentation/core-api/kho/bindings/kho.yaml
deleted file mode 100644
--- a/Documentation/core-api/kho/bindings/kho.yaml
+++ /dev/null
@@ -1,43 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: Kexec HandOver (KHO) root tree
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-  - Changyuan Lyu <changyuanl@google.com>
-
-description: |
-  System memory preserved by KHO across kexec.
-
-properties:
-  compatible:
-    enum:
-      - kho-v1
-
-  preserved-memory-map:
-    description: |
-      physical address (u64) of an in-memory structure describing all preserved
-      folios and memory ranges.
-
-patternProperties:
-  "$[0-9a-f_]+^":
-    $ref: sub-fdt.yaml#
-    description: physical address of a KHO user's own FDT.
-
-required:
-  - compatible
-  - preserved-memory-map
-
-additionalProperties: false
-
-examples:
-  - |
-    kho {
-        compatible = "kho-v1";
-        preserved-memory-map = <0xf0be16 0x1000000>;
-
-        memblock {
-                fdt = <0x80cc16 0x1000000>;
-        };
-    };
diff --git a/Documentation/core-api/kho/bindings/sub-fdt.yaml a/Documentation/core-api/kho/bindings/sub-fdt.yaml
deleted file mode 100644
--- a/Documentation/core-api/kho/bindings/sub-fdt.yaml
+++ /dev/null
@@ -1,27 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: KHO users' FDT address
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-  - Changyuan Lyu <changyuanl@google.com>
-
-description: |
-  Physical address of an FDT blob registered by a KHO user.
-
-properties:
-  fdt:
-    description: |
-      physical address (u64) of an FDT blob.
-
-required:
-  - fdt
-
-additionalProperties: false
-
-examples:
-  - |
-    memblock {
-            fdt = <0x80cc16 0x1000000>;
-    };
--- a/Documentation/core-api/kho/index.rst~kho-introduce-kho-fdt-abi-header
+++ a/Documentation/core-api/kho/index.rst
@@ -31,6 +31,15 @@ can retrieve and restore the preserved s
 Subsystems participating in KHO can define their own format for state
 serialization and preservation.
 
+KHO FDT and structures defined by the subsystems form an ABI between pre-kexec
+and post-kexec kernels. This ABI is defined by header files in
+``include/linux/kho/abi`` directory.
+
+.. toctree::
+   :maxdepth: 1
+
+   abi.rst
+
 .. _kho_scratch:
 
 Scratch Regions
diff --git a/include/linux/kho/abi/kexec_handover.h a/include/linux/kho/abi/kexec_handover.h
new file mode 100644
--- /dev/null
+++ a/include/linux/kho/abi/kexec_handover.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/*
+ * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
+#define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
+
+/**
+ * DOC: Kexec Handover ABI
+ *
+ * Kexec Handover uses the ABI defined below for passing preserved data from
+ * one kernel to the next.
+ * The ABI uses Flattened Device Tree (FDT) format. The first kernel creates an
+ * FDT which is then passed to the next kernel during a kexec handover.
+ *
+ * This interface is a contract. Any modification to the FDT structure, node
+ * properties, compatible string, or the layout of the data structures
+ * referenced here constitutes a breaking change. Such changes require
+ * incrementing the version number in KHO_FDT_COMPATIBLE to prevent a new kernel
+ * from misinterpreting data from an older kernel. Changes are allowed provided
+ * the compatibility version is incremented. However, backward/forward
+ * compatibility is only guaranteed for kernels supporting the same ABI version.
+ *
+ * FDT Structure Overview:
+ *   The FDT serves as a central registry for physical
+ *   addresses of preserved data structures and sub-FDTs. The first kernel
+ *   populates this FDT with references to memory regions and other FDTs that
+ *   need to persist across the kexec transition. The subsequent kernel then
+ *   parses this FDT to locate and restore the preserved data.::
+ *
+ *     / {
+ *         compatible = "kho-v1";
+ *
+ *         preserved-memory-map = <0x...>;
+ *
+ *         <subnode-name-1> {
+ *             fdt = <0x...>;
+ *         };
+ *
+ *         <subnode-name-2> {
+ *             fdt = <0x...>;
+ *         };
+ *               ... ...
+ *         <subnode-name-N> {
+ *             fdt = <0x...>;
+ *         };
+ *     };
+ *
+ *   Root KHO Node (/):
+ *     - compatible: "kho-v1"
+ *
+ *       Indentifies the overall KHO ABI version.
+ *
+ *     - preserved-memory-map: u64
+ *
+ *       Physical memory address pointing to the root of the
+ *       preserved memory map data structure.
+ *
+ *   Subnodes (<subnode-name-N>):
+ *     Subnodes can also be added to the root node to
+ *     describe other preserved data blobs. The <subnode-name-N>
+ *     is provided by the subsystem that uses KHO for preserving its
+ *     data.
+ *
+ *     - fdt: u64
+ *
+ *       Physical address pointing to a subnode FDT blob that is also
+ *       being preserved.
+ */
+
+/* The compatible string for the KHO FDT root node. */
+#define KHO_FDT_COMPATIBLE "kho-v1"
+
+/* The FDT property for the preserved memory map. */
+#define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
+
+/* The FDT property for sub-FDTs. */
+#define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
+
+#endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
--- a/kernel/liveupdate/kexec_handover.c~kho-introduce-kho-fdt-abi-header
+++ a/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
@@ -33,10 +34,7 @@
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
-#define KHO_FDT_COMPATIBLE "kho-v1"
-#define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
-#define PROP_SUB_FDT "fdt"
-
+/* The magic token for preserved pages */
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
 /*
@@ -378,7 +376,7 @@ static void kho_update_memory_map(struct
 	void *ptr;
 	u64 phys;
 
-	ptr = fdt_getprop_w(kho_out.fdt, 0, PROP_PRESERVED_MEMORY_MAP, NULL);
+	ptr = fdt_getprop_w(kho_out.fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, NULL);
 
 	/* Check and discard previous memory map */
 	phys = get_unaligned((u64 *)ptr);
@@ -466,7 +464,7 @@ static phys_addr_t __init kho_get_mem_ma
 	const void *mem_ptr;
 	int len;
 
-	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
 		return 0;
@@ -727,7 +725,8 @@ int kho_add_subtree(const char *name, vo
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
+	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
+			  &phys, sizeof(phys));
 	if (err < 0)
 		goto out_pack;
 
@@ -758,7 +757,7 @@ void kho_remove_subtree(void *fdt)
 		const u64 *val;
 		int len;
 
-		val = fdt_getprop(root_fdt, off, PROP_SUB_FDT, &len);
+		val = fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 		if (!val || len != sizeof(phys_addr_t))
 			continue;
 
@@ -1305,7 +1304,7 @@ int kho_retrieve_subtree(const char *nam
 	if (offset < 0)
 		return -ENOENT;
 
-	val = fdt_getprop(fdt, offset, PROP_SUB_FDT, &len);
+	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 	if (!val || len != sizeof(*val))
 		return -EINVAL;
 
@@ -1325,7 +1324,7 @@ static __init int kho_out_fdt_setup(void
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_mem_map,
 			    sizeof(empty_mem_map));
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
--- a/MAINTAINERS~kho-introduce-kho-fdt-abi-header
+++ a/MAINTAINERS
@@ -13968,6 +13968,7 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
+F:	include/linux/kho/abi/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
_

Patches currently in -mm which might be from jasonmiu@google.com are


