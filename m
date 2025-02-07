Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D29E18027
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888201; cv=none; b=b/p9i+0z2UYiaQvmN2lQGgytThD1NfsBp9X7ma6dmHQ53V4ipnGrllbSX2COAEjMY7mDGA30RTfCg9UedM5dBNAhaa6X/KNUQV6kIAvm3sctrhXHztJtsJvsZ7m8T4BzyRnteoo9uz/tKSdTTFpLcuhRqUdAdjH++C7KMr2a370=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888201; c=relaxed/simple;
	bh=EOp/e3W5jYRHQbNmZaLRwAcPWIHo2DFhj97b6q3k6Ds=;
	h=Date:To:From:Subject:Message-Id; b=jaaHyq7zQ0XKf47k1uiuTrECAb9k3Ml3+Juz1uGOfaPvw6Nh+i1Do25ifXDXbOHeg4MEg7BL0BSiP66yOS2mYZjmW408LBMduabsgab0W7ln78pFIMpcUCmsC1HWhs/eMkqNvZo1DKVVrJ18iGQc++SpG+v7dHdjKnVq23ApfBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ito5BIfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ito5BIfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C232C4CEDD;
	Fri,  7 Feb 2025 00:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888200;
	bh=EOp/e3W5jYRHQbNmZaLRwAcPWIHo2DFhj97b6q3k6Ds=;
	h=Date:To:From:Subject:From;
	b=ito5BIfxebfB8ILitMyAsnkSDmYJK7ibPXrlD2DKoJ6M27YC1LIZ6d/dyTyeC8PfK
	 9kIqY1KeECfwYwEtzpRIcuIVfojxH5gFtGMQXG06bQL4E3zMyfEZxk5DN07DMwe4QV
	 iRNbQaXgfPy7Z6WtP4lFRmYAP5ciJ6Q5ac7kp6VQ=
Date: Thu, 06 Feb 2025 16:29:59 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,graf@amazon.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003000.9C232C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: rename init_reserved_page to init_deferred_page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/mm_init: rename init_reserved_page to init_deferred_page
Date: Thu, 6 Feb 2025 15:27:41 +0200

Patch series "kexec: introduce Kexec HandOver (KHO)", v4.

This a version of Alex's "kexec: Allow preservation of ftrace buffers"
series (https://lore.kernel.org/all/20240117144704.602-1-graf@amazon.com),

Kexec today considers itself purely a boot loader: When we enter the new
kernel, any state the previous kernel left behind is irrelevant and the
new kernel reinitializes the system.

However, there are use cases where this mode of operation is not what we
actually want.  In virtualization hosts for example, we want to use kexec
to update the host kernel while virtual machine memory stays untouched. 
When we add device assignment to the mix, we also need to ensure that
IOMMU and VFIO states are untouched.  If we add PCIe peer to peer DMA, we
need to do the same for the PCI subsystem.  If we want to kexec while an
SEV-SNP enabled virtual machine is running, we need to preserve the VM
context pages and physical memory.  See "pkernfs: Persisting guest memory
and kernel/device state safely across kexec" Linux Plumbers Conference
2023 presentation for details:

  https://lpc.events/event/17/contributions/1485/

To start us on the journey to support all the use cases above, this patch
implements basic infrastructure to allow hand over of kernel state across
kexec (Kexec HandOver, aka KHO).  As a really simple example target, we
use memblock's reserve_mem.

With this patchset applied, memory that was reserved using "reserve_mem"
command line options remains intact after kexec and it is guaranteed to
reside at the same physical address.

== Alternatives ==

There are alternative approaches to (parts of) the problems above:

  * Memory Pools [1] - preallocated persistent memory region + allocator
  * PRMEM [2] - resizable persistent memory regions with fixed metadata
                pointer on the kernel command line + allocator
  * Pkernfs [3] - preallocated file system for in-kernel data with fixed
                  address location on the kernel command line
  * PKRAM [4] - handover of user space pages using a fixed metadata page
                specified via command line

All of the approaches above fundamentally have the same problem: They
require the administrator to explicitly carve out a physical memory
location because they have no mechanism outside of the kernel command line
to pass data (including memory reservations) between kexec'ing kernels.

KHO provides that base foundation.  We will determine later whether we
still need any of the approaches above for fast bulk memory handover of
for example IOMMU page tables.  But IMHO they would all be users of KHO,
with KHO providing the foundational primitive to pass metadata and bulk
memory reservations as well as provide easy versioning for data.

== Overview ==

We introduce a metadata file that the kernels pass between each other. 
How they pass it is architecture specific.  The file's format is a
Flattened Device Tree (fdt) which has a generator and parser already
included in Linux.  When the root user enables KHO through
/sys/kernel/kho/active, the kernel invokes callbacks to every driver that
supports KHO to serialize its state.  When the actual kexec happens, the
fdt is part of the image set that we boot into.  In addition, we keep a
"scratch regions" available for kexec: A physically contiguous memory
regions that is guaranteed to not have any memory that KHO would preserve.
The new kernel bootstraps itself using the scratch regions and sets all
handed over memory as in use.  When drivers initialize that support KHO,
they introspect the fdt and recover their state from it.  This includes
memory reservations, where the driver can either discard or claim
reservations.

== Limitations ==

Currently KHO is only implemented for file based kexec.  The kernel
interfaces in the patch set are already in place to support user space
kexec as well, but it is still not implemented it yet inside kexec tools.

== How to Use ==

To use the code, please boot the kernel with the "kho=on" command line
parameter.

KHO will automatically create scratch regions.  If you want to set the
scratch size explicitly you can use "kho_scratch=" command line parameter.
For instance, "kho_scratch=512M,256M" will create a global scratch area
of 512Mib and per-node scrath areas of 256Mib.

Make sure to to have a reserved memory range requested with reserv_mem
command line option.  Then before you invoke file based "kexec -l",
activate KHO:

  # echo 1 > /sys/kernel/kho/active
  # kexec -l Image --initrd=initrd -s
  # kexec -e

The new kernel will boot up and contain the previous kernel's reserve_mem
contents at the same physical address as the first kernel.


This patch (of 14):

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, init_reserved_page()
function performs initialization of a struct page that would have been
deferred normally.

Rename it to init_deferred_page() to better reflect what the function does.

Link: https://lkml.kernel.org/r/20250206132754.2596694-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250206132754.2596694-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Graf <graf@amazon.com>
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
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>]
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-rename-init_reserved_page-to-init_deferred_page
+++ a/mm/mm_init.c
@@ -728,7 +728,7 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 
-static void __meminit init_reserved_page(unsigned long pfn, int nid)
+static void __meminit init_deferred_page(unsigned long pfn, int nid)
 {
 	if (early_page_initialised(pfn, nid))
 		return;
@@ -748,7 +748,7 @@ static inline bool defer_init(int nid, u
 	return false;
 }
 
-static inline void init_reserved_page(unsigned long pfn, int nid)
+static inline void init_deferred_page(unsigned long pfn, int nid)
 {
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
@@ -769,7 +769,7 @@ void __meminit reserve_bootmem_region(ph
 		if (pfn_valid(start_pfn)) {
 			struct page *page = pfn_to_page(start_pfn);
 
-			init_reserved_page(start_pfn, nid);
+			init_deferred_page(start_pfn, nid);
 
 			/*
 			 * no need for atomic set_bit because the struct
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch
memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch

