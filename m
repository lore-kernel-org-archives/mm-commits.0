Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807C35C96
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888215; cv=none; b=olBicjbaVi7ERRgzyn/KlL7uDCGr+DpXf/5sHokpmGUFprvkSWyRJv17L8OAZwqe+Ct9Dc2AbhVi3sBrik8CObUqIUBy2RaroKGtySa2K1CZaJ6wteyMNsaVnJ57uIgz5dR04AXflXyxjK+7lfOeiqYt/v3SRoOudobUr24nMgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888215; c=relaxed/simple;
	bh=yBs5h++2l1H/zmzv2RKqOP+rv/qjFO9s16toZ7eikHk=;
	h=Date:To:From:Subject:Message-Id; b=t1x2+G8FJ1+YAgjMpdvO+JDv5kclO3Mqvb/mKCTctuf5MIebgph9szVlBxeM+Bn3nSKhh8BhIkCkPYNXdnjbfdxIVS9Ei/5cLtgSByKgAnbvaPze/J7MPYzRmaE56gG3UuhS4jxlU6P+ts5rE54BtgyFsFT6v8P//qsk1e7ldJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GieM+hkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GieM+hkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA59C4CEDD;
	Fri,  7 Feb 2025 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888215;
	bh=yBs5h++2l1H/zmzv2RKqOP+rv/qjFO9s16toZ7eikHk=;
	h=Date:To:From:Subject:From;
	b=GieM+hkccsbOKD58EpV03z1sp6190yGFfGisX/r56kaaaKnQvGvaEQ1EEpFRf+iMj
	 3Me8nFoSGHcL0F0IUHgIXgieuiqusb97xg1+Z7ApGZ9Og2z9PC0ke+UA9XkzCf8E52
	 dbc5IewHHge0QLU+6i0e380by/aMxEVD/nk6ZLc8=
Date: Thu, 06 Feb 2025 16:30:14 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-documentation-for-kho.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003014.DAA59C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add documentation for KHO
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-add-documentation-for-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-documentation-for-kho.patch

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
Subject: kexec: add documentation for KHO
Date: Thu, 6 Feb 2025 15:27:49 +0200

With KHO in place, let's add documentation that describes what it is and
how to use it.

Link: https://lkml.kernel.org/r/20250206132754.2596694-10-rppt@kernel.org
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

 Documentation/kho/concepts.rst   |   80 +++++++++++++++++++++++++++++
 Documentation/kho/index.rst      |   19 ++++++
 Documentation/kho/usage.rst      |   60 +++++++++++++++++++++
 Documentation/subsystem-apis.rst |    1 
 MAINTAINERS                      |    1 
 5 files changed, 161 insertions(+)

diff --git a/Documentation/kho/concepts.rst a/Documentation/kho/concepts.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/kho/concepts.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+=======================
+Kexec Handover Concepts
+=======================
+
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve state -
+arbitrary properties as well as memory locations - across kexec.
+
+It introduces multiple concepts:
+
+KHO Device Tree
+---------------
+
+Every KHO kexec carries a KHO specific flattened device tree blob that
+describes the state of the system. Device drivers can register to KHO to
+serialize their state before kexec. After KHO, device drivers can read
+the device tree and extract previous state.
+
+KHO only uses the fdt container format and libfdt library, but does not
+adhere to the same property semantics that normal device trees do: Properties
+are passed in native endianness and standardized properties like ``regs`` and
+``ranges`` do not exist, hence there are no ``#...-cells`` properties.
+
+KHO introduces a new concept to its device tree: ``mem`` properties. A
+``mem`` property can be inside any subnode in the device tree. When present,
+it contains an array of physical memory ranges that the new kernel must mark
+as reserved on boot. It is recommended, but not required, to make these ranges
+as physically contiguous as possible to reduce the number of array elements ::
+
+    struct kho_mem {
+            __u64 addr;
+            __u64 len;
+    };
+
+After boot, drivers can call the kho subsystem to transfer ownership of memory
+that was reserved via a ``mem`` property to themselves to continue using memory
+from the previous execution.
+
+The KHO device tree follows the in-Linux schema requirements. Any element in
+the device tree is documented via device tree schema yamls that explain what
+data gets transferred.
+
+Scratch Regions
+---------------
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
+requests that do not require particilar NUMA node assignment.
+By default, size of the scratch region is calculated based on amount of memory
+allocated during boot. The ``kho_scratch`` kernel command line option may be used to explicitly define size of the scratch regions.
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
+of that memory region may be reserved. These reservations are irrenevant for
+the next KHO, because kexec can overwrite even the original kernel.
+
+KHO active phase
+----------------
+
+To enable user space based kexec file loader, the kernel needs to be able to
+provide the device tree that describes the previous kernel's state before
+performing the actual kexec. The process of generating that device tree is
+called serialization. When the device tree is generated, some properties
+of the system may become immutable because they are already written down
+in the device tree. That state is called the KHO active phase.
diff --git a/Documentation/kho/index.rst a/Documentation/kho/index.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/kho/index.rst
@@ -0,0 +1,19 @@
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
+   usage
+
+.. only::  subproject and html
+
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/kho/usage.rst a/Documentation/kho/usage.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/kho/usage.rst
@@ -0,0 +1,60 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+====================
+Kexec Handover Usage
+====================
+
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve state -
+arbitrary properties as well as memory locations - across kexec.
+
+This document expects that you are familiar with the base KHO
+:ref:`Documentation/kho/concepts.rst <concepts>`. If you have not read
+them yet, please do so now.
+
+Prerequisites
+-------------
+
+KHO is available when the ``CONFIG_KEXEC_HANDOVER`` config option is set to y
+at compile time. Every KHO producer may have its own config option that you
+need to enable if you would like to preserve their respective state across
+kexec.
+
+To use KHO, please boot the kernel with the ``kho=on`` command line
+parameter. You may use ``kho_scratch`` parameter to define size of the
+scratch regions. For example ``kho_scratch=512M,512M`` will reserve a 512
+MiB for a global scratch region and 512 MiB per NUMA node scratch regions
+on boot.
+
+Perform a KHO kexec
+-------------------
+
+Before you can perform a KHO kexec, you need to move the system into the
+:ref:`Documentation/kho/concepts.rst <KHO active phase>` ::
+
+  $ echo 1 > /sys/kernel/kho/active
+
+After this command, the KHO device tree is available in ``/sys/kernel/kho/dt``.
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
+----------------
+
+You can move the system out of KHO active phase again by calling ::
+
+  $ echo 1 > /sys/kernel/kho/active
+
+After this command, the KHO device tree is no longer available in
+``/sys/kernel/kho/dt``.
--- a/Documentation/subsystem-apis.rst~kexec-add-documentation-for-kho
+++ a/Documentation/subsystem-apis.rst
@@ -90,3 +90,4 @@ Other subsystems
    peci/index
    wmi/index
    tee/index
+   kho/index
--- a/MAINTAINERS~kexec-add-documentation-for-kho
+++ a/MAINTAINERS
@@ -12822,6 +12822,7 @@ S:	Maintained
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 F:	Documentation/ABI/testing/sysfs-firmware-kho
 F:	Documentation/ABI/testing/sysfs-kernel-kho
+F:	Documentation/kho/
 F:	include/linux/kexec.h
 F:	include/uapi/linux/kexec.h
 F:	kernel/kexec*
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

