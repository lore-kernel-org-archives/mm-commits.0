Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5643EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905030; cv=none; b=olnjLsAw4XdQSr4fqVMttDAu8uCyuqISMeT3PJ/kpadVW8zVh87t2MmaR8FT5V2yrRvvxNTgWkYrnAet/o+1+8zY6kS/rhQV+iTiIP6dyZ9Kpzr3mnOpymzdhN9mXaMI5yMw9XKj5ynD3kZ1G6fj+Iuxnk4/3VBYR18kre9HHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905030; c=relaxed/simple;
	bh=xeeKk1tOIB+6QceCcaEeKGLG5S9scR43yOr2Fv0TxKE=;
	h=Date:To:From:Subject:Message-Id; b=OkPmYchMVMxTMdcp0z/GdO1M3sUHmbQFMen4wBn/ahAKLvHQxMq3dCSV3VjyUYASrUVOT/t6eaZ7asuQ6AUsd5b6hk8fIIR3HJXhfrpxo5kCnpPlaiAyyPGK6K7jKOb+1ED0+/ewzJTW4RV0ZfoyaIwWUN47ylnod8id4OfGWqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PSqQKbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PSqQKbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CE5C4CEF1;
	Sun,  1 Feb 2026 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905030;
	bh=xeeKk1tOIB+6QceCcaEeKGLG5S9scR43yOr2Fv0TxKE=;
	h=Date:To:From:Subject:From;
	b=0PSqQKbMDCF8x5P8Exm2S5X1Oqe0mSUOE+Sk8tXPP2mTBLPBusmq8TPdHaQAwqRcN
	 cpi0MGRVoVI0tmez9shW/5vUyStnnl3QFIdQlwjdPnmXgC5eqdL587crigcIhV2t1U
	 7VtkJFKgpX3xxCYhmegXEGRpyNmnu6p+aQGrTxIw=
Date: Sat, 31 Jan 2026 16:17:10 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,songshuaishuai@tinylab.org,samuel.holland@sifive.com,rppt@kernel.org,rdunlap@infradead.org,pawan.kumar.gupta@linux.intel.com,palmer@dabbelt.com,mingo@kernel.org,lirongqing@baidu.com,leitao@debian.org,kevin.brodsky@arm.com,kees@kernel.org,fvdl@google.com,elver@google.com,cuiyunhui@bytedance.com,corbet@lwn.net,bp@alien8.de,bjorn@rivosinc.com,bhelgaas@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alex@ghiti.fr,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-kexec-add-support-for-crashkernel-cma-reservation.patch removed from -mm tree
Message-Id: <20260201001710.A3CE5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: kexec: add support for crashkernel CMA reservation
has been removed from the -mm tree.  Its filename was
     riscv-kexec-add-support-for-crashkernel-cma-reservation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: riscv: kexec: add support for crashkernel CMA reservation
Date: Mon, 26 Jan 2026 16:07:38 +0800

Commit 35c18f2933c5 ("Add a new optional ",cma" suffix to the crashkernel=
command line option") and commit ab475510e042 ("kdump: implement
reserve_crashkernel_cma") added CMA support for kdump crashkernel
reservation.  This allows the kernel to dynamically allocate contiguous
memory for crash dumping when needed, rather than permanently reserving a
fixed region at boot time.

So extend crashkernel CMA reservation support to riscv.  The following
changes are made to enable CMA reservation:

- Parse and obtain the CMA reservation size along with other crashkernel
  parameters.
- Call reserve_crashkernel_cma() to allocate the CMA region for kdump.
- Include the CMA-reserved ranges for kdump kernel to use.
- Exclude the CMA-reserved ranges from the crash kernel memory to
  prevent them from being exported through /proc/vmcore.

Update kernel-parameters.txt to document CMA support for crashkernel on
riscv architecture.

Link: https://lkml.kernel.org/r/20260126080738.696723-1-ruanjinjie@huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Breno Leitao <leitao@debian.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Marco Elver <elver@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Song Shuai <songshuaishuai@tinylab.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 -
 arch/riscv/kernel/machine_kexec_file.c          |   17 ++++++++++++--
 arch/riscv/mm/init.c                            |    5 ++--
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/arch/riscv/kernel/machine_kexec_file.c~riscv-kexec-add-support-for-crashkernel-cma-reservation
+++ a/arch/riscv/kernel/machine_kexec_file.c
@@ -59,9 +59,9 @@ static int prepare_elf_headers(void **ad
 {
 	struct crash_mem *cmem;
 	unsigned int nr_ranges;
-	int ret;
+	int ret, i;
 
-	nr_ranges = 1; /* For exclusion of crashkernel region */
+	nr_ranges = 1 + crashk_cma_cnt; /* For exclusion of crashkernel region */
 	walk_system_ram_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
 
 	cmem = kmalloc(struct_size(cmem, ranges, nr_ranges), GFP_KERNEL);
@@ -74,11 +74,24 @@ static int prepare_elf_headers(void **ad
 	if (ret)
 		goto out;
 
+	for (i = 0; i < crashk_cma_cnt; i++) {
+		cmem->ranges[cmem->nr_ranges].start = crashk_cma_ranges[i].start;
+		cmem->ranges[cmem->nr_ranges].end = crashk_cma_ranges[i].end;
+		cmem->nr_ranges++;
+	}
+
 	/* Exclude crashkernel region */
 	ret = crash_exclude_mem_range(cmem, crashk_res.start, crashk_res.end);
 	if (!ret)
 		ret = crash_prepare_elf64_headers(cmem, true, addr, sz);
 
+	for (i = 0; i < crashk_cma_cnt; ++i) {
+		ret = crash_exclude_mem_range(cmem, crashk_cma_ranges[i].start,
+					      crashk_cma_ranges[i].end);
+		if (ret)
+			goto out;
+	}
+
 out:
 	kfree(cmem);
 	return ret;
--- a/arch/riscv/mm/init.c~riscv-kexec-add-support-for-crashkernel-cma-reservation
+++ a/arch/riscv/mm/init.c
@@ -1404,7 +1404,7 @@ static inline void setup_vm_final(void)
  */
 static void __init arch_reserve_crashkernel(void)
 {
-	unsigned long long low_size = 0;
+	unsigned long long low_size = 0, cma_size = 0;
 	unsigned long long crash_base, crash_size;
 	bool high = false;
 	int ret;
@@ -1414,11 +1414,12 @@ static void __init arch_reserve_crashker
 
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base,
-				&low_size, NULL, &high);
+				&low_size, &cma_size, &high);
 	if (ret)
 		return;
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
+	reserve_crashkernel_cma(cma_size);
 }
 
 void __init paging_init(void)
--- a/Documentation/admin-guide/kernel-parameters.txt~riscv-kexec-add-support-for-crashkernel-cma-reservation
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1119,7 +1119,7 @@ Kernel parameters
 			It will be ignored when crashkernel=X,high is not used
 			or memory reserved is below 4G.
 	crashkernel=size[KMG],cma
-			[KNL, X86, ppc] Reserve additional crash kernel memory from
+			[KNL, X86, RISCV, ppc] Reserve additional crash kernel memory from
 			CMA. This reservation is usable by the first system's
 			userspace memory and kernel movable allocations (memory
 			balloon, zswap). Pages allocated from this memory range
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are


