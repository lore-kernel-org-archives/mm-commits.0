From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?powerpc-fadump-reuse-crashkernel-parameter-for-fadump-memo?=
 =?US-ASCII?Q?ry-reservation.patch?= removed from -mm tree
Date: Tue, 09 May 2017 11:01:50 -0700
Message-ID: <20170509180150.FIDxZ-lOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754423AbdEISBv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, ebiederm@xmission.com, fenghua.yu@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, tony.luck@intel.com, vgoyal@redhat.com


The patch titled
     Subject: powerpc/fadump: reuse crashkernel parameter for fadump memory reservation
has been removed from the -mm tree.  Its filename was
     powerpc-fadump-reuse-crashkernel-parameter-for-fadump-memory-reservation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hari Bathini <hbathini@linux.vnet.ibm.com>
Subject: powerpc/fadump: reuse crashkernel parameter for fadump memory reservation

fadump supports specifying memory to reserve for fadump's crash kernel
with fadump_reserve_mem kernel parameter.  This parameter currently
supports passing a fixed memory size, like fadump_reserve_mem=<size> only.
This patch aims to add support for other syntaxes like range-based memory
size <range1>:<size1>[,<range2>:<size2>,<range3>:<size3>,...] which allows
using the same parameter to boot the kernel with different system RAM
sizes.

As crashkernel parameter already supports the above mentioned syntaxes,
this patch deprecates fadump_reserve_mem parameter and reuses crashkernel
parameter instead, to specify memory for fadump's crash kernel memory
reservation as well.  If any offset is provided in crashkernel parameter,
it will be ignored in case of fadump, as fadump reserves memory at end of
RAM.

Advantages using crashkernel parameter instead of fadump_reserve_mem
parameter are one less kernel parameter overall, code reuse and support
for multiple syntaxes to specify memory.

Suggested-by: Dave Young <dyoung@redhat.com>
Link: http://lkml.kernel.org/r/149035346749.6881.911095631212975718.stgit@hbathini.in.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.vnet.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/fadump.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN arch/powerpc/kernel/fadump.c~powerpc-fadump-reuse-crashkernel-parameter-for-fadump-memory-reservation arch/powerpc/kernel/fadump.c
--- a/arch/powerpc/kernel/fadump.c~powerpc-fadump-reuse-crashkernel-parameter-for-fadump-memory-reservation
+++ a/arch/powerpc/kernel/fadump.c
@@ -209,14 +209,20 @@ static unsigned long init_fadump_mem_str
  */
 static inline unsigned long fadump_calculate_reserve_size(void)
 {
-	unsigned long size;
+	int ret;
+	unsigned long long base, size;
 
 	/*
-	 * Check if the size is specified through fadump_reserve_mem= cmdline
-	 * option. If yes, then use that.
+	 * Check if the size is specified through crashkernel= cmdline
+	 * option. If yes, then use that but ignore base as fadump
+	 * reserves memory at end of RAM.
 	 */
-	if (fw_dump.reserve_bootvar)
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
+				&size, &base);
+	if (ret == 0 && size > 0) {
+		fw_dump.reserve_bootvar = (unsigned long)size;
 		return fw_dump.reserve_bootvar;
+	}
 
 	/* divide by 20 to get 5% of value */
 	size = memblock_end_of_DRAM() / 20;
@@ -371,15 +377,6 @@ static int __init early_fadump_param(cha
 }
 early_param("fadump", early_fadump_param);
 
-/* Look for fadump_reserve_mem= cmdline option */
-static int __init early_fadump_reserve_mem(char *p)
-{
-	if (p)
-		fw_dump.reserve_bootvar = memparse(p, &p);
-	return 0;
-}
-early_param("fadump_reserve_mem", early_fadump_reserve_mem);
