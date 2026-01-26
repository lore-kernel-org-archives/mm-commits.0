Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0629293D
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769457394; cv=none; b=LE16AIYFaihmpsY9JiaVGNmzGCcJSiWfK/EYTMVzpmzApZ5S+Sqlnn6oGfLtuVoMJCIuionmhZBEM+waLvMBAzKF4YLERFBpfYDfDDup0UIV6Gjpift0vy6wq1xwciXMY3oa1VMWDDuGFMku8mVvZlRr0GaPk9relm1kTuGPU+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769457394; c=relaxed/simple;
	bh=lLx4iA19EdAazLcGQT3b3S/9Yjv6bSjkfCvIsfLQ61w=;
	h=Date:To:From:Subject:Message-Id; b=IP8vM2cLeDK5JMrJkECvAgVoH7x0k3JtU8yeyaExA08yT66kcsTFTUooYu7gNo0lYlHko2UI9z7KD+cU5WmbtAL7qLcxYohRgc3dOxup2uJrfyFPasVWL499rVh+xI9ub1dyOijb+ElbTkuC7tAK+gaCPker9lN2WMLo/bNyvGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqRuRYDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqRuRYDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4A2C19425;
	Mon, 26 Jan 2026 19:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769457394;
	bh=lLx4iA19EdAazLcGQT3b3S/9Yjv6bSjkfCvIsfLQ61w=;
	h=Date:To:From:Subject:From;
	b=lqRuRYDIKj9LQte3qvmFJlbScqfRq4b7fiWs4rhDXUOerkyZwft9as71usAAhusGz
	 ymrcOU6WNO1sBpL/hSlUg6KWEnUcHOTJmwnRRWKdjz918dwR5uQDUa0A36c4BJHD/w
	 F4Zn+YnmFXvdVOD5PrItR8dU6Y3qNCs0LPI/8zFA=
Date: Mon, 26 Jan 2026 11:56:34 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,songshuaishuai@tinylab.org,samuel.holland@sifive.com,rppt@kernel.org,rdunlap@infradead.org,pawan.kumar.gupta@linux.intel.com,palmer@dabbelt.com,mingo@kernel.org,lirongqing@baidu.com,leitao@debian.org,kevin.brodsky@arm.com,kees@kernel.org,fvdl@google.com,elver@google.com,cuiyunhui@bytedance.com,corbet@lwn.net,bp@alien8.de,bjorn@rivosinc.com,bhelgaas@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alex@ghiti.fr,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-kexec-add-support-for-crashkernel-cma-reservation.patch added to mm-nonmm-unstable branch
Message-Id: <20260126195634.8C4A2C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: kexec: add support for crashkernel CMA reservation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-kexec-add-support-for-crashkernel-cma-reservation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-kexec-add-support-for-crashkernel-cma-reservation.patch

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
@@ -1398,7 +1398,7 @@ static inline void setup_vm_final(void)
  */
 static void __init arch_reserve_crashkernel(void)
 {
-	unsigned long long low_size = 0;
+	unsigned long long low_size = 0, cma_size = 0;
 	unsigned long long crash_base, crash_size;
 	bool high = false;
 	int ret;
@@ -1408,11 +1408,12 @@ static void __init arch_reserve_crashker
 
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

riscv-kexec-add-support-for-crashkernel-cma-reservation.patch

