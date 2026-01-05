Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B0221FCA
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648254; cv=none; b=f5ur/yP5ItmKGA41ycFzeB3ual7/8kAvrZk75uoBXBU/Gq8i8zA+8m+7poqkTKStnkO9NRbarmhDux7RbH0bcJfgDMiWKHZZz7LDzt2Egx4FDR1GeXptxSowEwwQAerG4ckC2hHDa6nszXQgf0PV6KPiJF22Q1qGSEK1ttCJsYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648254; c=relaxed/simple;
	bh=jfyR8npZB9kCQYdVJ7NBqIJ36mza/H4J+1Ixtche7KY=;
	h=Date:To:From:Subject:Message-Id; b=DuKmUZUTdJYES+9GJyd5BhRjdymLbkYjMnfn2m1l9F3SDhAhUCXxcMcG7zJyOVu0Dn6AnU1esqyCisnMDgDKCNn/M+p3z31oVZ/aHAVTVnusp5WuprmKboT/ZT/7NF/83rB9hElNwHuih9F0eEhpAuSlqdMVs3usvBt9fJd4/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bKG+xZbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bKG+xZbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E008C116D0;
	Mon,  5 Jan 2026 21:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767648254;
	bh=jfyR8npZB9kCQYdVJ7NBqIJ36mza/H4J+1Ixtche7KY=;
	h=Date:To:From:Subject:From;
	b=bKG+xZbEhhVU8CiUKOBdKLyc3TIHxO+ioWmGa+yTvR9X05Fbd0gi0ladXBVwTAIyl
	 t5GVhvvdpzSVFJv3UzX0jkXogHDKB/uZjzYZFwMATVEuP3sKWQBuI9ffENZWy+3b4w
	 0t145m5LHbPmPXOZtylxCZxzHoRFtvloMTffEHPk=
Date: Mon, 05 Jan 2026 13:24:13 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jasonmiu@google.com,graf@amazon.com,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-docs-combine-concepts-and-fdt-documentation.patch added to mm-nonmm-unstable branch
Message-Id: <20260105212414.2E008C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: docs: combine concepts and FDT documentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-docs-combine-concepts-and-fdt-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-docs-combine-concepts-and-fdt-documentation.patch

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
Subject: kho: docs: combine concepts and FDT documentation
Date: Mon, 5 Jan 2026 18:58:36 +0200

Currently index.rst in KHO documentation looks empty and sad as it only
contains links to "Kexec Handover Concepts" and "KHO FDT" chapters.

Inline contents of these chapters into index.rst to provide a single
coherent chapter describing KHO.

While on it, drop parts of the KHO FDT description that will be superseded
by addition of KHO ABI documentation.

Link: https://lkml.kernel.org/r/20260105165839.285270-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Miu <jasonmiu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kho/concepts.rst |   74 --------------------
 Documentation/core-api/kho/fdt.rst      |   80 ----------------------
 Documentation/core-api/kho/index.rst    |   73 ++++++++++++++++++--
 Documentation/core-api/liveupdate.rst   |    2 
 Documentation/mm/memfd_preservation.rst |    2 
 5 files changed, 70 insertions(+), 161 deletions(-)

diff --git a/Documentation/core-api/kho/concepts.rst a/Documentation/core-api/kho/concepts.rst
deleted file mode 100644
--- a/Documentation/core-api/kho/concepts.rst
+++ /dev/null
@@ -1,74 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0-or-later
-.. _kho-concepts:
-
-=======================
-Kexec Handover Concepts
-=======================
-
-Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
-regions, which could contain serialized system states, across kexec.
-
-It introduces multiple concepts:
-
-KHO FDT
-=======
-
-Every KHO kexec carries a KHO specific flattened device tree (FDT) blob
-that describes preserved memory regions. These regions contain either
-serialized subsystem states, or in-memory data that shall not be touched
-across kexec. After KHO, subsystems can retrieve and restore preserved
-memory regions from KHO FDT.
-
-KHO only uses the FDT container format and libfdt library, but does not
-adhere to the same property semantics that normal device trees do: Properties
-are passed in native endianness and standardized properties like ``regs`` and
-``ranges`` do not exist, hence there are no ``#...-cells`` properties.
-
-KHO is still under development. The FDT schema is unstable and would change
-in the future.
-
-Scratch Regions
-===============
-
-To boot into kexec, we need to have a physically contiguous memory range that
-contains no handed over memory. Kexec then places the target kernel and initrd
-into that region. The new kernel exclusively uses this region for memory
-allocations before during boot up to the initialization of the page allocator.
-
-We guarantee that we always have such regions through the scratch regions: On
-first boot KHO allocates several physically contiguous memory regions. Since
-after kexec these regions will be used by early memory allocations, there is a
-scratch region per NUMA node plus a scratch region to satisfy allocations
-requests that do not require particular NUMA node assignment.
-By default, size of the scratch region is calculated based on amount of memory
-allocated during boot. The ``kho_scratch`` kernel command line option may be
-used to explicitly define size of the scratch regions.
-The scratch regions are declared as CMA when page allocator is initialized so
-that their memory can be used during system lifetime. CMA gives us the
-guarantee that no handover pages land in that region, because handover pages
-must be at a static physical memory location and CMA enforces that only
-movable pages can be located inside.
-
-After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
-instead reuse the exact same region that was originally allocated. This allows
-us to recursively execute any amount of KHO kexecs. Because we used this region
-for boot memory allocations and as target memory for kexec blobs, some parts
-of that memory region may be reserved. These reservations are irrelevant for
-the next KHO, because kexec can overwrite even the original kernel.
-
-.. _kho-finalization-phase:
-
-KHO finalization phase
-======================
-
-To enable user space based kexec file loader, the kernel needs to be able to
-provide the FDT that describes the current kernel's state before
-performing the actual kexec. The process of generating that FDT is
-called serialization. When the FDT is generated, some properties
-of the system may become immutable because they are already written down
-in the FDT. That state is called the KHO finalization phase.
-
-Public API
-==========
-.. kernel-doc:: kernel/liveupdate/kexec_handover.c
-   :export:
diff --git a/Documentation/core-api/kho/fdt.rst a/Documentation/core-api/kho/fdt.rst
deleted file mode 100644
--- a/Documentation/core-api/kho/fdt.rst
+++ /dev/null
@@ -1,80 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0-or-later
-
-=======
-KHO FDT
-=======
-
-KHO uses the flattened device tree (FDT) container format and libfdt
-library to create and parse the data that is passed between the
-kernels. The properties in KHO FDT are stored in native format.
-It includes the physical address of an in-memory structure describing
-all preserved memory regions, as well as physical addresses of KHO users'
-own FDTs. Interpreting those sub FDTs is the responsibility of KHO users.
-
-KHO nodes and properties
-========================
-
-Property ``preserved-memory-map``
----------------------------------
-
-KHO saves a special property named ``preserved-memory-map`` under the root node.
-This node contains the physical address of an in-memory structure for KHO to
-preserve memory regions across kexec.
-
-Property ``compatible``
------------------------
-
-The ``compatible`` property determines compatibility between the kernel
-that created the KHO FDT and the kernel that attempts to load it.
-If the kernel that loads the KHO FDT is not compatible with it, the entire
-KHO process will be bypassed.
-
-Property ``fdt``
-----------------
-
-Generally, a KHO user serialize its state into its own FDT and instructs
-KHO to preserve the underlying memory, such that after kexec, the new kernel
-can recover its state from the preserved FDT.
-
-A KHO user thus can create a node in KHO root tree and save the physical address
-of its own FDT in that node's property ``fdt`` .
-
-Examples
-========
-
-The following example demonstrates KHO FDT that preserves two memory
-regions created with ``reserve_mem`` kernel command line parameter::
-
-  /dts-v1/;
-
-  / {
-  	compatible = "kho-v1";
-
-	preserved-memory-map = <0x40be16 0x1000000>;
-
-  	memblock {
-		fdt = <0x1517 0x1000000>;
-  	};
-  };
-
-where the ``memblock`` node contains an FDT that is requested by the
-subsystem memblock for preservation. The FDT contains the following
-serialized data::
-
-  /dts-v1/;
-
-  / {
-  	compatible = "memblock-v1";
-
-  	n1 {
-  		compatible = "reserve-mem-v1";
-  		start = <0xc06b 0x4000000>;
-  		size = <0x04 0x00>;
-  	};
-
-  	n2 {
-  		compatible = "reserve-mem-v1";
-  		start = <0xc067 0x4000000>;
-  		size = <0x04 0x00>;
-  	};
-  };
--- a/Documentation/core-api/kho/index.rst~kho-docs-combine-concepts-and-fdt-documentation
+++ a/Documentation/core-api/kho/index.rst
@@ -4,10 +4,73 @@
 Kexec Handover Subsystem
 ========================
 
-.. toctree::
-   :maxdepth: 1
+Overview
+========
 
-   concepts
-   fdt
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
+regions, which could contain serialized system states, across kexec.
 
-.. only::  subproject and html
+KHO uses :ref:`flattened device tree (FDT) <kho_fdt>` to pass information about
+the preserved state from pre-exec kernel to post-kexec kernel and :ref:`scratch
+memory regions <kho_scratch>` to ensure integrity of the preserved memory.
+
+.. _kho_fdt:
+
+KHO FDT
+=======
+Every KHO kexec carries a KHO specific flattened device tree (FDT) blob that
+describes the preserved state. The FDT includes properties describing preserved
+memory regions and nodes that hold subsystem specific state.
+
+The preserved memory regions contain either serialized subsystem states, or
+in-memory data that shall not be touched across kexec. After KHO, subsystems
+can retrieve and restore the preserved state from KHO FDT.
+
+Subsystems participating in KHO can define their own format for state
+serialization and preservation.
+
+.. _kho_scratch:
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
+See Also
+========
+
+- :doc:`/admin-guide/mm/kho`
--- a/Documentation/core-api/liveupdate.rst~kho-docs-combine-concepts-and-fdt-documentation
+++ a/Documentation/core-api/liveupdate.rst
@@ -69,4 +69,4 @@ See Also
 ========
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
-- :doc:`/core-api/kho/concepts`
+- :doc:`/core-api/kho/index`
--- a/Documentation/mm/memfd_preservation.rst~kho-docs-combine-concepts-and-fdt-documentation
+++ a/Documentation/mm/memfd_preservation.rst
@@ -20,4 +20,4 @@ See Also
 ========
 
 - :doc:`/core-api/liveupdate`
-- :doc:`/core-api/kho/concepts`
+- :doc:`/core-api/kho/index`
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

