Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F0633FE05
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 20:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769891965; cv=none; b=VIGzSaiCBNP0WOchDPhv71rmgZ/zMEYXvXKEuSEPIysDN9RtaidPWJfU4fZfFo/vrAeRbZdzwXBDWZ97jxuukxwVEsN+tYBYA+lnBBOHYkdQWGfc8OJw8RrRO//WgWVrG9xMA/RH/yyPcsKcsnxOddH354zeV7FoVhQPjPevkco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769891965; c=relaxed/simple;
	bh=PzltjoJ/mAU609OhR+wGjHoaRuEKOE8wfuy2zcW0ry8=;
	h=Date:To:From:Subject:Message-Id; b=YHIheP3JzIqmdrnWYjWZPAbhAG9sP9jow8RANk/Epr3mruREgTDPcvFL9VKUjCdGYVShVZXXlp+lBRrVU1eZqKzC1VHXYrCVVcLwKInYtgEaRho75mFErOg3nlwyEgdtGhDcdxKoEHDM7L310L7W2lL9BtyrWmmgarzvlhRdfJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=15W9XLzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="15W9XLzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE5DC4CEF1;
	Sat, 31 Jan 2026 20:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769891965;
	bh=PzltjoJ/mAU609OhR+wGjHoaRuEKOE8wfuy2zcW0ry8=;
	h=Date:To:From:Subject:From;
	b=15W9XLzEBao7Oc7R/L4CSRkhz185giLcIZK34iafFzsFRWvzpnZuXgKFc7aUnfOL3
	 39QLswr0+y3i0xhOYPUTAnhx19uHIHzyFzPZnzX9Wk6A3UjVJkmJP2EyyI8JW2dcE8
	 PPUr/9SvgsUGlDz4Fk0bo8ashLCbHA+0L+D0uckY=
Date: Sat, 31 Jan 2026 12:39:24 -0800
To: mm-commits@vger.kernel.org,zengheng4@huawei.com,will@kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch added to mm-new branch
Message-Id: <20260131203925.6FE5DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: fix pass user prot to ioremap_prot in generic_access_phys
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: arm64: mm: fix pass user prot to ioremap_prot in generic_access_phys
Date: Fri, 30 Jan 2026 15:38:07 +0800

Here is a syzkaller error log:
  [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
                     pmd=080000007833c403, pte=01608000007fcfcf
  Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
  KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
  Mem abort info:
    ESR = 0x000000009600000f
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x0f: level 3 permission fault
  Data abort info:
    ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
  [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
		     pmd=100000010a453403, pte=01608000007fcfcf
  Internal error: Oops: 000000009600000f [#1] SMP
  Modules linked in: team
  CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : __memcpy_fromio+0x80/0xf8
  lr : generic_access_phys+0x20c/0x2b8
  sp : ffff8000a0507960
  x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
  x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
  x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
  x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
  x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
  x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
  x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
  x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
  x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
  Call trace:
    __memcpy_fromio+0x80/0xf8
    generic_access_phys+0x20c/0x2b8
    __access_remote_vm+0x46c/0x5b8
    access_remote_vm+0x18/0x30
    environ_read+0x238/0x3e8
    vfs_read+0xe4/0x2b0
    ksys_read+0xcc/0x178
    __arm64_sys_read+0x4c/0x68
    invoke_syscall+0x68/0x1a0
    el0_svc_common.constprop.0+0x11c/0x150
    do_el0_svc+0x38/0x50
    el0_svc+0x50/0x258
    el0t_64_sync_handler+0xc0/0xc8
    el0t_64_sync+0x1a4/0x1a8
  Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)

The local syzkaller first maps I/O address from /dev/mem to userspace,
overiding the stack vma with MAP_FIXED flag.  As a result, when reading
/proc/$pid/environ, generic_access_phys() is called to access the region,
which triggers a PAN permission-check fault and causes a kernel access
fault.

The root cause is that generic_access_phys() passes a user pte to
ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
any subsequent kernel-mode access to the remapped address raises a fault.

To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
so that a user prot is passed to ioremap_prot().

Catalin said "That's not urgent for 6.19, it's just misuse of /dev/mem
(aren't they all) but it's worth fixing."

Link: https://lkml.kernel.org/r/20260130073807.99474-1-tujinjiang@huawei.com
Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/io.h |    8 ++++++++
 mm/memory.c                 |   12 +++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/io.h~arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys
+++ a/arch/arm64/include/asm/io.h
@@ -267,6 +267,14 @@ int arm64_ioremap_prot_hook_register(con
 
 #define ioremap_prot ioremap_prot
 
+#define arch_mk_kernel_prot arch_mk_kernel_prot
+static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
+{
+	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
+
+	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
+}
+
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
 
 #define ioremap_wc(addr, size)	\
--- a/mm/memory.c~arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys
+++ a/mm/memory.c
@@ -6878,6 +6878,14 @@ void follow_pfnmap_end(struct follow_pfn
 EXPORT_SYMBOL_GPL(follow_pfnmap_end);
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
+#ifndef arch_mk_kernel_prot
+#define arch_mk_kernel_prot arch_mk_kernel_prot
+static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
+{
+	return user_prot;
+}
+#endif
+
 /**
  * generic_access_phys - generic implementation for iomem mmap access
  * @vma: the vma to access
@@ -6895,6 +6903,7 @@ int generic_access_phys(struct vm_area_s
 {
 	resource_size_t phys_addr;
 	pgprot_t prot = __pgprot(0);
+	pgprot_t kernel_prot;
 	void __iomem *maddr;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
@@ -6912,7 +6921,8 @@ retry:
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	kernel_prot = arch_mk_kernel_prot(prot);
+	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), kernel_prot);
 	if (!maddr)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch

