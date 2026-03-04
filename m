Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530534F470
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772639548; cv=none; b=i1qupWJO+AAVhk/7U6mETfA6Qs2dqyktI/bqgHacDu3/HMXwP9QxmGW0PFXVkgnPPhnkiL2lHIkDxkMmsdFkhtp9CzC4ccC6XDJjC35QHrQc26mjSYofEItoplkmuNJPAILsBMbCUATTeajwC5mG8if3mSlG70GJd+i6H3qtDoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772639548; c=relaxed/simple;
	bh=VQfDZrMkqZ2LgnPRZpabMwq7YOkPwsUmitVrTDgXBm0=;
	h=Date:To:From:Subject:Message-Id; b=kV1gEt2ShPTrzffs5qbUfzCuAZ2BN4eeSIJJHzbbkOYeXc+GMgbxxcG2rJW32B0m4TVJl19lfXn/b/YnAswO+qEGAFTmu2K+FL+2fdrd7kPXAD6liPpzVqH+iRTtlY97OWPw2399KNLf/QySwCuMuIn1khxgxI/vMH4uV8Oqb88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lwHpSBC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lwHpSBC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98ADC19423;
	Wed,  4 Mar 2026 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772639548;
	bh=VQfDZrMkqZ2LgnPRZpabMwq7YOkPwsUmitVrTDgXBm0=;
	h=Date:To:From:Subject:From;
	b=lwHpSBC9KEKiUX4Adthmuek78tEvVeRaf7F3dTj4KGdT8h0npetABqK8Q8woLA9IH
	 zLWG0t9YWcc+IcS/EEtmnjfnjFQKAtIomnj8qZk+YfZtwM3vGCyK1wsJheU7qpZXB7
	 oCQKc1/ism1IkV3DwLzkqaRwPe7s/4US8EDjEFiE=
Date: Wed, 04 Mar 2026 07:52:27 -0800
To: mm-commits@vger.kernel.org,zengheng4@huawei.com,will@kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch removed from -mm tree
Message-Id: <20260304155227.E98ADC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: fix pass user prot to ioremap_prot in generic_access_phys
has been removed from the -mm tree.  Its filename was
     arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch

This patch was dropped because an alternative patch was or shall be merged

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

This issue can be reproduced too with:

1) open and mmap a device that implements generic_access_phys as
   vm_operations_struct.acess callback.

2) access the device by ptrace or /proc/$pid/mem.

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
@@ -6864,6 +6864,14 @@ void follow_pfnmap_end(struct follow_pfn
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
@@ -6881,6 +6889,7 @@ int generic_access_phys(struct vm_area_s
 {
 	resource_size_t phys_addr;
 	pgprot_t prot = __pgprot(0);
+	pgprot_t kernel_prot;
 	void __iomem *maddr;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
@@ -6898,7 +6907,8 @@ retry:
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	kernel_prot = arch_mk_kernel_prot(prot);
+	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), kernel_prot);
 	if (!maddr)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


