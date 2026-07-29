Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F20624DCF9;
	Wed, 29 Jul 2026 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285487; cv=none; b=tpPo7D0vhB9pfqbz9qlanaHMhzSwzzFucV8uS9EB9t7cnbH/Dc2JnBbUvgcM0PjWKfDe6w8hGWGIOmrBMV1ZcEMpkWVMvMKojrZMJANK2/4dAITvc+B3zurIF7xSGQleWVikg1YG0U3Qf7BwaEBIrjrzCR/MajXYAwWU3O6Nduw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285487; c=relaxed/simple;
	bh=lNu7Pua1df29/nthO56RPNRvE4mW0b4PnDNuzLyRKLI=;
	h=Date:To:From:Subject:Message-Id; b=mlaWShdHkP8zpbO0vGljjQdQqz9lZ47D1noWLd1qUquzBcvIxHALPQI2Ue2avFIkTY+XcxFBsBcdqxwv+gw0oJCbe7pW6EGkiIO22YbjlhFDDDZ1axixtzZVuOW6WL0RJMP9ih2BggiYLMXJ0sbvipkCA/yCdbjREILPErxMNKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SktPj98b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SktPj98b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CA71F000E9;
	Wed, 29 Jul 2026 00:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285485;
	bh=hvw0Gwz4P9u/vuFg/StzYhCt1oSEAbybC18c28IFFPQ=;
	h=Date:To:From:Subject;
	b=SktPj98bHV6ZrOqTwOsPc8yukZAl0NA2Oxhh3yRAQ5uOXsDM4FlhA1nhV6NlhqjNt
	 LI4mOcg8ijO8TK73AYQJq3drJydUxwDgoqIsJIPCywQAhuQAlJ0X+QlISdPEHIcTwe
	 1UmU62ghhSjw7zyp7M4cngn7vLAB640fhEAjlD3E=
Date: Tue, 28 Jul 2026 17:38:04 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,rppt@kernel.org,palmer@dabbelt.com,namcao@linutronix.de,muchun.song@linux.dev,kas@kernel.org,guoren@kernel.org,david@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,xujiakai2025@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-mm-use-physical-alignment-for-vmemmap_start_pfn.patch removed from -mm tree
Message-Id: <20260729003805.44CA71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv/mm: use physical alignment for vmemmap_start_pfn
has been removed from the -mm tree.  Its filename was
     riscv-mm-use-physical-alignment-for-vmemmap_start_pfn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: riscv/mm: use physical alignment for vmemmap_start_pfn
Date: Thu, 16 Jul 2026 11:53:25 +0000

RISC-V computes vmemmap_start_pfn by rounding phys_ram_base down to
VMEMMAP_ADDR_ALIGN.  That alignment must therefore be expressed in the
physical-address domain.

Commit 476849b0fba4 ("riscv/mm: align vmemmap to maximal folio size")
attempted to account for the maximal folio alignment by feeding
MAX_FOLIO_VMEMMAP_ALIGN directly into VMEMMAP_ADDR_ALIGN.  However,
MAX_FOLIO_VMEMMAP_ALIGN is measured in bytes of struct page storage,
whereas VMEMMAP_ADDR_ALIGN is used to align a physical address.

The mask-based compound_info encoding requires pfn_to_page(0) to be
naturally aligned to MAX_FOLIO_VMEMMAP_ALIGN.  Commit 9f94db4c7eaa
("mm/sparse: check memmap alignment for compound_info_has_mask()") added a
check for that requirement and exposed the unit mismatch on systems such
as QEMU virt, where the DRAM base is not aligned to MAX_FOLIO_NR_PAGES *
PAGE_SIZE.

Here is the log:
[    0.000000][    C0] ------------[ cut here ]------------
[    0.000000][    C0] WARNING: mm/sparse.c:365 at sparse_init+0x58a/0x6fe, CPU#0: swapper/0
[    0.000000][    C0] Modules linked in:
[    0.000000][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.2.0-rc3-g1d8304bdd65f #2 PREEMPT 
[    0.000000][    C0] Hardware name: riscv-virtio,qemu (DT)
[    0.000000][    C0] epc : sparse_init+0x58a/0x6fe
[    0.000000][    C0]  ra : sparse_init+0x58a/0x6fe
[    0.000000][    C0] epc : ffffffff86851c88 ra : ffffffff86851c88 sp : ffffffff88807a30
[    0.000000][    C0]  gp : ffffffff8a3bf240 tp : ffffffff88842080 t0 : ff600000ffab6000
[    0.000000][    C0]  t1 : 000000017fab6000 t2 : 65203a6573726363 s0 : ffffffff88807bc0
[    0.000000][    C0]  s1 : 000000000e000000 a0 : 0000000000000007 a1 : 0000000000000000
[    0.000000][    C0]  a2 : 0000000000000002 a3 : ffffffff86851c88 a4 : 0000000000000000
[    0.000000][    C0]  a5 : ffffffff88843080 a6 : 0000000000000003 a7 : 0000000000000000
[    0.000000][    C0]  s2 : ff60000000000000 s3 : 0040000000000000 s4 : 0004000000000000
[    0.000000][    C0]  s5 : ffffffff8a4d92e0 s6 : ff600000ffab55e0 s7 : ffffffff88384d00
[    0.000000][    C0]  s8 : 0000000000000003 s9 : ffffffff88384cc1 s10: ffffffff88384cc0
[    0.000000][    C0]  s11: ffffffff8a4daae0 t3 : ffffffff915e8b20 t4 : ffffffff915e8b20
[    0.000000][    C0]  t5 : ffffffff915e8b20 t6 : ffffffff915e8bc8 ssp : 0000000000000000
[    0.000000][    C0] status: 0000000200000100 badaddr: ffffffff86851c88 cause: 0000000000000003
[    0.000000][    C0] [<ffffffff86851c88>] sparse_init+0x58a/0x6fe
[    0.000000][    C0] [<ffffffff8683d396>] mm_core_init_early+0x116/0x1e30
[    0.000000][    C0] [<ffffffff86801edc>] start_kernel+0xd2/0x848

Convert MAX_FOLIO_VMEMMAP_ALIGN to the equivalent physical alignment
before using it in VMEMMAP_ADDR_ALIGN.  This keeps the existing
round_down() logic while making the resulting vmemmap base satisfy the
mask-alignment requirement.

Link: https://lore.kernel.org/20260716115326.3466926-1-xujiakai2025@iscas.ac.cn
Fixes: 476849b0fba4 ("riscv/mm: align vmemmap to maximal folio size")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand <david@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Assisted-by: YuanSheng:DeepSeek-V4-Flash
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c~riscv-mm-use-physical-alignment-for-vmemmap_start_pfn
+++ a/arch/riscv/mm/init.c
@@ -63,7 +63,8 @@ EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 #define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
-				    MAX_FOLIO_VMEMMAP_ALIGN)
+				    PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / \
+					     sizeof(struct page)))
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);
_

Patches currently in -mm which might be from xujiakai2025@iscas.ac.cn are


