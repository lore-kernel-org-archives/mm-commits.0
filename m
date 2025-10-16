Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8237122068F;
	Thu, 16 Oct 2025 19:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760644243; cv=none; b=lxknIdCAWYLgEHJw+dU1uJFrn1AZfUeus4TFPl6l+an6qsdH8ofrWFeQsjTbAy7Wr/YdqRqf8hccq8YVTGNejVrg6FgHqXlazFyMqLC5QkO6ceRzhqbAvG9DS3z1sqcXRS+UXPqqt0hVHrDbEZveVq3XyBuQOyorDnhW9QwA4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760644243; c=relaxed/simple;
	bh=s7MRa8SnQhHaovIEnm45dmVqXqvKwWXBoEs4BFtplHM=;
	h=Date:To:From:Subject:Message-Id; b=uCnp/Cuo8EK7cL+egR+lbrji6afIBSajq1UWikdiOoLkL0a3zUgmt/krcLCs4fx4nsjQlNs6Jv1SML/7iA5AVHMRXhPm75Bicrq6qo+fOVSHUfBViuB+Zcj8N7pzzwdphyHwepRC7EVg5dnRDGUkXjQeImlq2Ttuc2WTUS0lLKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WU6PGBAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WU6PGBAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8570C4CEF9;
	Thu, 16 Oct 2025 19:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760644242;
	bh=s7MRa8SnQhHaovIEnm45dmVqXqvKwWXBoEs4BFtplHM=;
	h=Date:To:From:Subject:From;
	b=WU6PGBAhGF2Qlf7MLcQkzJvsd1jY88NYHKDq0wHXvsIovgD4/FmmWl0o1VrCaqQw8
	 5Z4sUysQucUzZdy+NQF5+mil4n/x3kTsa+jvemitCrQgLiIf+AnOECxgu6Y89Iw7kO
	 yv1889ttK7GDex+sHnAdUPMyTUcFnuVxpTxKhQDw=
Date: Thu, 16 Oct 2025 12:50:42 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,venkat88@linux.ibm.com,stable@vger.kernel.org,rppt@kernel.org,ritesh.list@gmail.com,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch added to mm-nonmm-unstable branch
Message-Id: <20251016195042.D8570C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: let architecture decide crash memory export to iomem_resource
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch

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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: crash: let architecture decide crash memory export to iomem_resource
Date: Thu, 16 Oct 2025 19:58:31 +0530

With the generic crashkernel reservation, the kernel emits the following
warning on powerpc:

WARNING: CPU: 0 PID: 1 at arch/powerpc/mm/mem.c:341 add_system_ram_resources+0xfc/0x180
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-auto-12607-g5472d60c129f #1 VOLUNTARY
Hardware name: IBM,9080-HEX Power11 (architected) 0x820200 0xf000007 of:IBM,FW1110.01 (NH1110_069) hv:phyp pSeries
NIP:  c00000000201de3c LR: c00000000201de34 CTR: 0000000000000000
REGS: c000000127cef8a0 TRAP: 0700   Not tainted (6.17.0-auto-12607-g5472d60c129f)
MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 84000840  XER: 20040010
CFAR: c00000000017eed0 IRQMASK: 0
GPR00: c00000000201de34 c000000127cefb40 c0000000016a8100 0000000000000001
GPR04: c00000012005aa00 0000000020000000 c000000002b705c8 0000000000000000
GPR08: 000000007fffffff fffffffffffffff0 c000000002db8100 000000011fffffff
GPR12: c00000000201dd40 c000000002ff0000 c0000000000112bc 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 c0000000015a3808
GPR24: c00000000200468c c000000001699888 0000000000000106 c0000000020d1950
GPR28: c0000000014683f8 0000000081000200 c0000000015c1868 c000000002b9f710
NIP [c00000000201de3c] add_system_ram_resources+0xfc/0x180
LR [c00000000201de34] add_system_ram_resources+0xf4/0x180
Call Trace:
add_system_ram_resources+0xf4/0x180 (unreliable)
do_one_initcall+0x60/0x36c
do_initcalls+0x120/0x220
kernel_init_freeable+0x23c/0x390
kernel_init+0x34/0x26c
ret_from_kernel_user_thread+0x14/0x1c

This warning occurs due to a conflict between crashkernel and System RAM
iomem resources.

The generic crashkernel reservation adds the crashkernel memory range to
/proc/iomem during early initialization. Later, all memblock ranges are
added to /proc/iomem as System RAM. If the crashkernel region overlaps
with any memblock range, it causes a conflict while adding those memblock
regions as iomem resources, triggering the above warning. The conflicting
memblock regions are then omitted from /proc/iomem.

For example, if the following crashkernel region is added to /proc/iomem:
20000000-11fffffff : Crash kernel

then the following memblock regions System RAM regions fail to be inserted:
00000000-7fffffff : System RAM
80000000-257fffffff : System RAM

Fix this by not adding the crashkernel memory to /proc/iomem on powerpc.
Introduce an architecture hook to let each architecture decide whether to
export the crashkernel region to /proc/iomem.

For more info checkout commit c40dd2f766440 ("powerpc: Add System RAM
to /proc/iomem") and commit bce074bdbc36 ("powerpc: insert System RAM
resource to prevent crashkernel conflict")

Note: Before switching to the generic crashkernel reservation, powerpc
never exported the crashkernel region to /proc/iomem.

Link: https://lkml.kernel.org/r/20251016142831.144515-1-sourabhjain@linux.ibm.com
Fixes: e3185ee438c2 ("powerpc/crash: use generic crashkernel reservation").
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/90937fe0-2e76-4c82-b27e-7b8a7fe3ac69@linux.ibm.com/
Cc: Baoquan he <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/crash_reserve.h |    8 ++++++++
 include/linux/crash_reserve.h            |    6 ++++++
 kernel/crash_reserve.c                   |    3 +++
 3 files changed, 17 insertions(+)

--- a/arch/powerpc/include/asm/crash_reserve.h~crash-let-architecture-decide-crash-memory-export-to-iomem_resource
+++ a/arch/powerpc/include/asm/crash_reserve.h
@@ -5,4 +5,12 @@
 /* crash kernel regions are Page size agliged */
 #define CRASH_ALIGN             PAGE_SIZE
 
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+static inline bool arch_add_crash_res_to_iomem(void)
+{
+	return false;
+}
+#define arch_add_crash_res_to_iomem arch_add_crash_res_to_iomem
+#endif
+
 #endif /* _ASM_POWERPC_CRASH_RESERVE_H */
--- a/include/linux/crash_reserve.h~crash-let-architecture-decide-crash-memory-export-to-iomem_resource
+++ a/include/linux/crash_reserve.h
@@ -32,6 +32,12 @@ int __init parse_crashkernel(char *cmdli
 void __init reserve_crashkernel_cma(unsigned long long cma_size);
 
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+#ifndef arch_add_crash_res_to_iomem
+static inline bool arch_add_crash_res_to_iomem(void)
+{
+	return true;
+}
+#endif
 #ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
 #define DEFAULT_CRASH_KERNEL_LOW_SIZE	(128UL << 20)
 #endif
--- a/kernel/crash_reserve.c~crash-let-architecture-decide-crash-memory-export-to-iomem_resource
+++ a/kernel/crash_reserve.c
@@ -524,6 +524,9 @@ void __init reserve_crashkernel_cma(unsi
 #ifndef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
 static __init int insert_crashkernel_resources(void)
 {
+	if (!arch_add_crash_res_to_iomem())
+		return 0;
+
 	if (crashk_res.start < crashk_res.end)
 		insert_resource(&iomem_resource, &crashk_res);
 
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch

