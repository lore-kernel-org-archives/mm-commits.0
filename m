Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551E0481B1
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146636; cv=none; b=mXb1XgbGdjEDgoOCtnvEIQpZCnPk46n+WZVnVRgYHCv91RNgHdIo7fydp5/aIoMMX8CB3IiKwdOa/GOHgXrUIEmBxz+c0lEYdfTMYdvZ0Z4pq6hIKd3DVQ4MatNU9pvJvWOmFCzZ+o51wSq2vpLGH5lw0BO2M5LpXhhvVYdKIG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146636; c=relaxed/simple;
	bh=k/gfqZ6DCCmq5AyyldlGwx/k9ng4RopM0sGBAz/SJh0=;
	h=Date:To:From:Subject:Message-Id; b=I5WOtpyX56BduSo98PFlfjFOPYEw8lV2fd2SOip60YHmnbQYWucn7hHD2qfv7Xu3zfX289EOxFBhtoDxLI9oMBPy8jXOecqs5Ogb4CCZeXyoeUafa6bB4Tvy2jJUvYXl6CCQ321S3PJbBjNn7TjH84ZhPrTS7n4dOmHlI1aFmu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s9hGQP4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s9hGQP4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2709CC4CEE3;
	Fri,  2 May 2025 00:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146636;
	bh=k/gfqZ6DCCmq5AyyldlGwx/k9ng4RopM0sGBAz/SJh0=;
	h=Date:To:From:Subject:From;
	b=s9hGQP4Hlg9ULkeGsnAmMwvijme1gUxKjbmM9iYas7dCtqIQ6PrveVdkgH4u6nOwo
	 Zn/5B+zB/qXYKpkdt9anDTLvYtngEM+odxP3HKBQ3mlpZ/dLkIkiZrP8o93xwN+An8
	 b+fW69HmaBCmocv5Gs4zAqDiPtL2kBS/S/dbABFc=
Date: Thu, 01 May 2025 17:43:55 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-documentation-for-kho.patch added to mm-unstable branch
Message-Id: <20250502004356.2709CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: add documentation for KHO
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-add-documentation-for-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-documentation-for-kho.patch

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
Subject: Documentation: add documentation for KHO
Date: Thu, 1 May 2025 15:54:24 -0700

With KHO in place, let's add documentation that describes what it is and
how to use it.

Link: https://lkml.kernel.org/r/20250501225425.635167-18-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt  |   25 ++
 Documentation/admin-guide/mm/index.rst           |    1 
 Documentation/admin-guide/mm/kho.rst             |  120 +++++++++++++
 Documentation/core-api/index.rst                 |    1 
 Documentation/core-api/kho/bindings/kho.yaml     |   43 ++++
 Documentation/core-api/kho/bindings/sub-fdt.yaml |   27 ++
 Documentation/core-api/kho/concepts.rst          |   74 ++++++++
 Documentation/core-api/kho/fdt.rst               |   80 ++++++++
 Documentation/core-api/kho/index.rst             |   13 +
 MAINTAINERS                                      |    2 
 10 files changed, 386 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-add-documentation-for-kho
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2725,6 +2725,31 @@
 	kgdbwait	[KGDB,EARLY] Stop kernel execution and enter the
 			kernel debugger at the earliest opportunity.
 
+	kho=		[KEXEC,EARLY]
+			Format: { "0" | "1" | "off" | "on" | "y" | "n" }
+			Enables or disables Kexec HandOver.
+			"0" | "off" | "n" - kexec handover is disabled
+			"1" | "on" | "y" - kexec handover is enabled
+
+	kho_scratch=	[KEXEC,EARLY]
+			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
+			Defines the size of the KHO scratch region. The KHO
+			scratch regions are physically contiguous memory
+			ranges that can only be used for non-kernel
+			allocations. That way, even when memory is heavily
+			fragmented with handed over memory, the kexeced
+			kernel will always have enough contiguous ranges to
+			bootstrap itself.
+
+			It is possible to specify the exact amount of
+			memory in the form of "ll[KMG],mm[KMG],nn[KMG]"
+			where the first parameter defines the size of a low
+			memory scratch area, the second parameter defines
+			the size of a global scratch area and the third
+			parameter defines the size of additional per-node
+			scratch areas.  The form "nn%" defines scale factor
+			(in percents) of memory that was used during boot.
+
 	kmac=		[MIPS] Korina ethernet MAC address.
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
--- a/Documentation/admin-guide/mm/index.rst~documentation-add-documentation-for-kho
+++ a/Documentation/admin-guide/mm/index.rst
@@ -42,3 +42,4 @@ the Linux memory management.
    transhuge
    userfaultfd
    zswap
+   kho
diff --git a/Documentation/admin-guide/mm/kho.rst a/Documentation/admin-guide/mm/kho.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/admin-guide/mm/kho.rst
@@ -0,0 +1,120 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+====================
+Kexec Handover Usage
+====================
+
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
+regions, which could contain serialized system states, across kexec.
+
+This document expects that you are familiar with the base KHO
+:ref:`concepts <concepts>`. If you have not read
+them yet, please do so now.
+
+Prerequisites
+=============
+
+KHO is available when the ``CONFIG_KEXEC_HANDOVER`` config option is set to y
+at compile time. Every KHO producer may have its own config option that you
+need to enable if you would like to preserve their respective state across
+kexec.
+
+To use KHO, please boot the kernel with the ``kho=on`` command line
+parameter. You may use ``kho_scratch`` parameter to define size of the
+scratch regions. For example ``kho_scratch=16M,512M,256M`` will reserve a
+16 MiB low memory scratch area, a 512 MiB global scratch region, and 256 MiB
+per NUMA node scratch regions on boot.
+
+Perform a KHO kexec
+===================
+
+First, before you perform a KHO kexec, you need to move the system into
+the :ref:`KHO finalization phase <finalization_phase>` ::
+
+  $ echo 1 > /sys/kernel/debug/kho/out/finalize
+
+After this command, the KHO FDT is available in
+``/sys/kernel/debug/kho/out/fdt``. Other subsystems may also register
+their own preserved sub FDTs under
+``/sys/kernel/debug/kho/out/sub_fdts/``.
+
+Next, load the target payload and kexec into it. It is important that you
+use the ``-s`` parameter to use the in-kernel kexec file loader, as user
+space kexec tooling currently has no support for KHO with the user space
+based file loader ::
+
+  # kexec -l Image --initrd=initrd -s
+  # kexec -e
+
+The new kernel will boot up and contain some of the previous kernel's state.
+
+For example, if you used ``reserve_mem`` command line parameter to create
+an early memory reservation, the new kernel will have that memory at the
+same physical address as the old kernel.
+
+Abort a KHO exec
+================
+
+You can move the system out of KHO finalization phase again by calling ::
+
+  $ echo 0 > /sys/kernel/debug/kho/out/active
+
+After this command, the KHO FDT is no longer available in
+``/sys/kernel/debug/kho/out/fdt``.
+
+debugfs Interfaces
+==================
+
+Currently KHO creates the following debugfs interfaces. Notice that these
+interfaces may change in the future. They will be moved to sysfs once KHO is
+stabilized.
+
+``/sys/kernel/debug/kho/out/finalize``
+    Kexec HandOver (KHO) allows Linux to transition the state of
+    compatible drivers into the next kexec'ed kernel. To do so,
+    device drivers will instruct KHO to preserve memory regions,
+    which could contain serialized kernel state.
+    While the state is serialized, they are unable to perform
+    any modifications to state that was serialized, such as
+    handed over memory allocations.
+
+    When this file contains "1", the system is in the transition
+    state. When contains "0", it is not. To switch between the
+    two states, echo the respective number into this file.
+
+``/sys/kernel/debug/kho/out/fdt``
+    When KHO state tree is finalized, the kernel exposes the
+    flattened device tree blob that carries its current KHO
+    state in this file. Kexec user space tooling can use this
+    as input file for the KHO payload image.
+
+``/sys/kernel/debug/kho/out/scratch_len``
+    To support continuous KHO kexecs, we need to reserve
+    physically contiguous memory regions that will always stay
+    available for future kexec allocations. This file describes
+    the length of these memory regions. Kexec user space tooling
+    can use this to determine where it should place its payload
+    images.
+
+``/sys/kernel/debug/kho/out/scratch_phys``
+    To support continuous KHO kexecs, we need to reserve
+    physically contiguous memory regions that will always stay
+    available for future kexec allocations. This file describes
+    the physical location of these memory regions. Kexec user space
+    tooling can use this to determine where it should place its
+    payload images.
+
+``/sys/kernel/debug/kho/out/sub_fdts/``
+    In the KHO finalization phase, KHO producers register their own
+    FDT blob under this directory.
+
+``/sys/kernel/debug/kho/in/fdt``
+    When the kernel was booted with Kexec HandOver (KHO),
+    the state tree that carries metadata about the previous
+    kernel's state is in this file in the format of flattened
+    device tree. This file may disappear when all consumers of
+    it finished to interpret their metadata.
+
+``/sys/kernel/debug/kho/in/sub_fdts/``
+    Similar to ``kho/out/sub_fdts/``, but contains sub FDT blobs
+    of KHO producers passed from the old kernel.
--- a/Documentation/core-api/index.rst~documentation-add-documentation-for-kho
+++ a/Documentation/core-api/index.rst
@@ -115,6 +115,7 @@ more memory-management documentation in
    pin_user_pages
    boot-time-mm
    gfp_mask-from-fs-io
+   kho/index
 
 Interfaces for kernel debugging
 ===============================
diff --git a/Documentation/core-api/kho/bindings/kho.yaml a/Documentation/core-api/kho/bindings/kho.yaml
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/bindings/kho.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+title: Kexec HandOver (KHO) root tree
+
+maintainers:
+  - Mike Rapoport <rppt@kernel.org>
+  - Changyuan Lyu <changyuanl@google.com>
+
+description: |
+  System memory preserved by KHO across kexec.
+
+properties:
+  compatible:
+    enum:
+      - kho-v1
+
+  preserved-memory-map:
+    description: |
+      physical address (u64) of an in-memory structure describing all preserved
+      folios and memory ranges.
+
+patternProperties:
+  "$[0-9a-f_]+^":
+    $ref: sub-fdt.yaml#
+    description: physical address of a KHO user's own FDT.
+
+required:
+  - compatible
+  - preserved-memory-map
+
+additionalProperties: false
+
+examples:
+  - |
+    kho {
+        compatible = "kho-v1";
+        preserved-memory-map = <0xf0be16 0x1000000>;
+
+        memblock {
+                fdt = <0x80cc16 0x1000000>;
+        };
+    };
diff --git a/Documentation/core-api/kho/bindings/sub-fdt.yaml a/Documentation/core-api/kho/bindings/sub-fdt.yaml
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/bindings/sub-fdt.yaml
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+title: KHO users' FDT address
+
+maintainers:
+  - Mike Rapoport <rppt@kernel.org>
+  - Changyuan Lyu <changyuanl@google.com>
+
+description: |
+  Physical address of an FDT blob registered by a KHO user.
+
+properties:
+  fdt:
+    description: |
+      physical address (u64) of an FDT blob.
+
+required:
+  - fdt
+
+additionalProperties: false
+
+examples:
+  - |
+    memblock {
+            fdt = <0x80cc16 0x1000000>;
+    };
diff --git a/Documentation/core-api/kho/concepts.rst a/Documentation/core-api/kho/concepts.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/concepts.rst
@@ -0,0 +1,74 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+.. _concepts:
+
+=======================
+Kexec Handover Concepts
+=======================
+
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
+regions, which could contain serialized system states, across kexec.
+
+It introduces multiple concepts:
+
+KHO FDT
+=======
+
+Every KHO kexec carries a KHO specific flattened device tree (FDT) blob
+that describes preserved memory regions. These regions contain either
+serialized subsystem states, or in-memory data that shall not be touched
+across kexec. After KHO, subsystems can retrieve and restore preserved
+memory regions from KHO FDT.
+
+KHO only uses the FDT container format and libfdt library, but does not
+adhere to the same property semantics that normal device trees do: Properties
+are passed in native endianness and standardized properties like ``regs`` and
+``ranges`` do not exist, hence there are no ``#...-cells`` properties.
+
+KHO is still under development. The FDT schema is unstable and would change
+in the future.
+
+Scratch Regions
+===============
+
+To boot into kexec, we need to have a physically contiguous memory range that
+contains no handed over memory. Kexec then places the target kernel and initrd
+into that region. The new kernel exclusively uses this region for memory
+allocations before during boot up to the initialization of the page allocator.
+
+We guarantee that we always have such regions through the scratch regions: On
+first boot KHO allocates several physically contiguous memory regions. Since
+after kexec these regions will be used by early memory allocations, there is a
+scratch region per NUMA node plus a scratch region to satisfy allocations
+requests that do not require particular NUMA node assignment.
+By default, size of the scratch region is calculated based on amount of memory
+allocated during boot. The ``kho_scratch`` kernel command line option may be
+used to explicitly define size of the scratch regions.
+The scratch regions are declared as CMA when page allocator is initialized so
+that their memory can be used during system lifetime. CMA gives us the
+guarantee that no handover pages land in that region, because handover pages
+must be at a static physical memory location and CMA enforces that only
+movable pages can be located inside.
+
+After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
+instead reuse the exact same region that was originally allocated. This allows
+us to recursively execute any amount of KHO kexecs. Because we used this region
+for boot memory allocations and as target memory for kexec blobs, some parts
+of that memory region may be reserved. These reservations are irrelevant for
+the next KHO, because kexec can overwrite even the original kernel.
+
+.. _finalization_phase:
+
+KHO finalization phase
+======================
+
+To enable user space based kexec file loader, the kernel needs to be able to
+provide the FDT that describes the current kernel's state before
+performing the actual kexec. The process of generating that FDT is
+called serialization. When the FDT is generated, some properties
+of the system may become immutable because they are already written down
+in the FDT. That state is called the KHO finalization phase.
+
+Public API
+==========
+.. kernel-doc:: kernel/kexec_handover.c
+   :export:
diff --git a/Documentation/core-api/kho/fdt.rst a/Documentation/core-api/kho/fdt.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/fdt.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+=======
+KHO FDT
+=======
+
+KHO uses the flattened device tree (FDT) container format and libfdt
+library to create and parse the data that is passed between the
+kernels. The properties in KHO FDT are stored in native format.
+It includes the physical address of an in-memory structure describing
+all preserved memory regions, as well as physical addresses of KHO users'
+own FDTs. Interpreting those sub FDTs is the responsibility of KHO users.
+
+KHO nodes and properties
+========================
+
+Property ``preserved-memory-map``
+---------------------------------
+
+KHO saves a special property named ``preserved-memory-map`` under the root node.
+This node contains the physical address of an in-memory structure for KHO to
+preserve memory regions across kexec.
+
+Property ``compatible``
+-----------------------
+
+The ``compatible`` property determines compatibility between the kernel
+that created the KHO FDT and the kernel that attempts to load it.
+If the kernel that loads the KHO FDT is not compatible with it, the entire
+KHO process will be bypassed.
+
+Property ``fdt``
+----------------
+
+Generally, A KHO user serialize its state into its own FDT and instructs
+KHO to preserve the underlying memory, such that after kexec, the new kernel
+can recover its state from the preserved FDT.
+
+A KHO user thus can create a node in KHO root tree and save the physical address
+of its own FDT in that node's property ``fdt`` .
+
+Examples
+========
+
+The following example demonstrates KHO FDT that preserves two memory
+regions created with ``reserve_mem`` kernel command line parameter::
+
+  /dts-v1/;
+
+  / {
+  	compatible = "kho-v1";
+
+	preserved-memory-map = <0x40be16 0x1000000>;
+
+  	memblock {
+		fdt = <0x1517 0x1000000>;
+  	};
+  };
+
+where the ``memblock`` node contains an FDT that is requested by the
+subsystem memblock for preservation. The FDT contains the following
+serialized data::
+
+  /dts-v1/;
+
+  / {
+  	compatible = "memblock-v1";
+
+  	n1 {
+  		compatible = "reserve-mem-v1";
+  		start = <0xc06b 0x4000000>;
+  		size = <0x04 0x00>;
+  	};
+
+  	n2 {
+  		compatible = "reserve-mem-v1";
+  		start = <0xc067 0x4000000>;
+  		size = <0x04 0x00>;
+  	};
+  };
diff --git a/Documentation/core-api/kho/index.rst a/Documentation/core-api/kho/index.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/index.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+========================
+Kexec Handover Subsystem
+========================
+
+.. toctree::
+   :maxdepth: 1
+
+   concepts
+   fdt
+
+.. only::  subproject and html
--- a/MAINTAINERS~documentation-add-documentation-for-kho
+++ a/MAINTAINERS
@@ -13130,6 +13130,8 @@ M:	Mike Rapoport <rppt@kernel.org>
 M:	Changyuan Lyu <changyuanl@google.com>
 L:	kexec@lists.infradead.org
 S:	Maintained
+F:	Documentation/admin-guide/mm/kho.rst
+F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	kernel/kexec_handover.c
 
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

