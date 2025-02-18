Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830771A8404;
	Tue, 18 Feb 2025 05:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739857551; cv=none; b=vADfaMWWYt5tkJgcVCuaNF6fGXe8kIHhUL8a8jvRZR9voIvtwNwwOZBY+HlGQSm1G9E1ipF1SBfmMKphf6XOxEdOAKawfytwqR56KSr/fF91NOiwfWLSAMnjFJ1m9LgTLPMdMhDz0qAnXm0w/hmehyE5d99im1QgFcg9DOW7Z9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739857551; c=relaxed/simple;
	bh=cV8vd0F67RnBQ7kN7mtYnybGILd+NAtSawbsYGsTjDE=;
	h=Date:To:From:Subject:Message-Id; b=R67wLrTMJ3Qps2NsFv9gXXpMbFQl9quP8YcUvb3T1bW4+8cgRk0hSpGUFu346wXYZVqIjjwRLhWN98OavlBsq1diRhWNoMAsdhiqPrvS9iuer+XSSwzoOyuhuLOb1hozcCKSxSn+ss5NW8P7gXHWFr8t0kbfYl+XLphucORnqhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0+ii5k+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0+ii5k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344E2C4CEE6;
	Tue, 18 Feb 2025 05:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739857551;
	bh=cV8vd0F67RnBQ7kN7mtYnybGILd+NAtSawbsYGsTjDE=;
	h=Date:To:From:Subject:From;
	b=b0+ii5k+JhyfGSIJ3F9rhVsBUqO2C9LiyJWzjoH7snhsPBmWFA1J5iIWLyMpwtIvi
	 a5jukpcpNOpRILEh23+e+gGjwzxjPCjDYFNbNY4FWI49bdfCEJ1YnYhvu+0QqN+F+q
	 aoSusOgc/tzwWDzRnM2lcxDMeeVTNss5bv2iun04=
Date: Mon, 17 Feb 2025 21:45:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,osalvador@suse.de,luto@kernel.org,dave.hansen@linux.intel.com,byungchul@sk.com,42.hyeyoo@gmail.com,gwan-gyeong.mun@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch added to mm-hotfixes-unstable branch
Message-Id: <20250218054551.344E2C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/vmemmap: use direct-mapped VA instead of vmemmap-based VA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Subject: x86/vmemmap: use direct-mapped VA instead of vmemmap-based VA
Date: Mon, 17 Feb 2025 13:41:33 +0200

Address an Oops issues when performing test of loading XE GPU driver
module after applying the GPU SVM and Xe SVM patch series[1] and the Dept
patch series[2].

The issue occurs when loading the xe driver via modprobe [3], which adds a
struct page for device memory via devm_memremap_pages().  When a process
leads the addition of a struct page to vmemmap (e.g.  hot-plug), the page
table update for the newly added vmemmap-based virtual address is updated
first in init_mm's page table and then synchronized later.

If the vmemmap-based virtual address is accessed through the process's
page table before this sync, a page fault will occur.  This patch
translates vmemmap-based virtual address to direct-mapped virtual address
and use it, if the current top-level page table is not init_mm's page
table when accessing a vmemmap-based virtual address before this sync.

[1] https://lore.kernel.org/dri-devel/20250213021112.1228481-1-matthew.brost@intel.com/
[2] https://lore.kernel.org/lkml/20240508094726.35754-1-byungchul@sk.com/
[3]
[   49.103630] xe 0000:00:04.0: [drm] Available VRAM: 0x0000000800000000, 0x00000002fb800000
[   49.116710] BUG: unable to handle page fault for address: ffffeb3ff1200000
[   49.117175] #PF: supervisor write access in kernel mode
[   49.117511] #PF: error_code(0x0002) - not-present page
[   49.117835] PGD 0 P4D 0 
[   49.118015] Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
[   49.118366] CPU: 3 UID: 0 PID: 302 Comm: modprobe Tainted: G        W          6.13.0-drm-tip-test+ #62
[   49.118976] Tainted: [W]=WARN
[   49.119179] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   49.119710] RIP: 0010:vmemmap_set_pmd+0xff/0x230
[   49.120011] Code: 77 22 02 a9 ff ff 1f 00 74 58 48 8b 3d 62 77 22 02 48 85 ff 0f 85 9a 00 00 00 48 8d 7d 08 48 89 e9 31 c0 48 89 ea 48 83 e7 f8 <48> c7 45 00 00 00 00 00 48 29 f9 48 c7 45 48 00 00 00 00 83 c1 50
[   49.121158] RSP: 0018:ffffc900016d37a8 EFLAGS: 00010282
[   49.121502] RAX: 0000000000000000 RBX: ffff888164000000 RCX: ffffeb3ff1200000
[   49.121966] RDX: ffffeb3ff1200000 RSI: 80000000000001e3 RDI: ffffeb3ff1200008
[   49.122499] RBP: ffffeb3ff1200000 R08: ffffeb3ff1280000 R09: 0000000000000000
[   49.123032] R10: ffff88817b94dc48 R11: 0000000000000003 R12: ffffeb3ff1280000
[   49.123566] R13: 0000000000000000 R14: ffff88817b94dc48 R15: 8000000163e001e3
[   49.124096] FS:  00007f53ae71d740(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
[   49.124698] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   49.125129] CR2: ffffeb3ff1200000 CR3: 000000017c7d2000 CR4: 0000000000750ef0
[   49.125662] PKRU: 55555554
[   49.125880] Call Trace:
[   49.126078]  <TASK>
[   49.126252]  ? __die_body.cold+0x19/0x26
[   49.126509]  ? page_fault_oops+0xa2/0x240
[   49.126736]  ? preempt_count_add+0x47/0xa0
[   49.126968]  ? search_module_extables+0x4a/0x80
[   49.127224]  ? exc_page_fault+0x206/0x230
[   49.127454]  ? asm_exc_page_fault+0x22/0x30
[   49.127691]  ? vmemmap_set_pmd+0xff/0x230
[   49.127919]  vmemmap_populate_hugepages+0x176/0x180
[   49.128194]  vmemmap_populate+0x34/0x80
[   49.128416]  __populate_section_memmap+0x41/0x90
[   49.128676]  sparse_add_section+0x121/0x3e0
[   49.128914]  __add_pages+0xba/0x150
[   49.129116]  add_pages+0x1d/0x70
[   49.129305]  memremap_pages+0x3dc/0x810
[   49.129529]  devm_memremap_pages+0x1c/0x60
[   49.129762]  xe_devm_add+0x8b/0x100 [xe]
[   49.130072]  xe_tile_init_noalloc+0x6a/0x70 [xe]
[   49.130408]  xe_device_probe+0x48c/0x740 [xe]
[   49.130714]  ? __pfx___drmm_mutex_release+0x10/0x10
[   49.130982]  ? __drmm_add_action+0x85/0xd0
[   49.131208]  ? __pfx___drmm_mutex_release+0x10/0x10
[   49.131478]  xe_pci_probe+0x7ef/0xd90 [xe]
[   49.131777]  ? _raw_spin_unlock_irqrestore+0x66/0x90
[   49.132049]  ? lockdep_hardirqs_on+0xba/0x140
[   49.132290]  pci_device_probe+0x99/0x110
[   49.132510]  really_probe+0xdb/0x340
[   49.132710]  ? pm_runtime_barrier+0x50/0x90
[   49.132941]  ? __pfx___driver_attach+0x10/0x10
[   49.133190]  __driver_probe_device+0x78/0x110
[   49.133433]  driver_probe_device+0x1f/0xa0
[   49.133661]  __driver_attach+0xba/0x1c0
[   49.133874]  bus_for_each_dev+0x7a/0xd0
[   49.134089]  bus_add_driver+0x114/0x200
[   49.134302]  driver_register+0x6e/0xc0
[   49.134515]  xe_init+0x1e/0x50 [xe]
[   49.134827]  ? __pfx_xe_init+0x10/0x10 [xe]
[   49.134926] xe 0000:00:04.0: [drm:process_one_work] GT1: GuC CT safe-mode canceled
[   49.135112]  do_one_initcall+0x5b/0x2b0
[   49.135734]  ? rcu_is_watching+0xd/0x40
[   49.135995]  ? __kmalloc_cache_noprof+0x231/0x310
[   49.136315]  do_init_module+0x60/0x210
[   49.136572]  init_module_from_file+0x86/0xc0
[   49.136863]  idempotent_init_module+0x12b/0x340
[   49.137156]  __x64_sys_finit_module+0x61/0xc0
[   49.137437]  do_syscall_64+0x69/0x140
[   49.137681]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   49.137953] RIP: 0033:0x7f53ae1261fd
[   49.138153] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e3 fa 0c 00 f7 d8 64 89 01 48
[   49.139117] RSP: 002b:00007ffd0e9021e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   49.139525] RAX: ffffffffffffffda RBX: 000055c02951ee50 RCX: 00007f53ae1261fd
[   49.139905] RDX: 0000000000000000 RSI: 000055bfff125478 RDI: 0000000000000010
[   49.140282] RBP: 000055bfff125478 R08: 00007f53ae1f6b20 R09: 00007ffd0e902230
[   49.140663] R10: 000055c029522000 R11: 0000000000000246 R12: 0000000000040000
[   49.141040] R13: 000055c02951ef80 R14: 0000000000000000 R15: 000055c029521fc0
[   49.141424]  </TASK>
[   49.141552] Modules linked in: xe(+) drm_ttm_helper gpu_sched drm_suballoc_helper drm_gpuvm drm_exec drm_gpusvm i2c_algo_bit drm_buddy video wmi ttm drm_display_helper drm_kms_helper crct10dif_pclmul crc32_pclmul i2c_piix4 e1000 ghash_clmulni_intel i2c_smbus fuse
[   49.142824] CR2: ffffeb3ff1200000
[   49.143010] ---[ end trace 0000000000000000 ]---
[   49.143268] RIP: 0010:vmemmap_set_pmd+0xff/0x230
[   49.143523] Code: 77 22 02 a9 ff ff 1f 00 74 58 48 8b 3d 62 77 22 02 48 85 ff 0f 85 9a 00 00 00 48 8d 7d 08 48 89 e9 31 c0 48 89 ea 48 83 e7 f8 <48> c7 45 00 00 00 00 00 48 29 f9 48 c7 45 48 00 00 00 00 83 c1 50
[   49.144489] RSP: 0018:ffffc900016d37a8 EFLAGS: 00010282
[   49.144775] RAX: 0000000000000000 RBX: ffff888164000000 RCX: ffffeb3ff1200000
[   49.145154] RDX: ffffeb3ff1200000 RSI: 80000000000001e3 RDI: ffffeb3ff1200008
[   49.145536] RBP: ffffeb3ff1200000 R08: ffffeb3ff1280000 R09: 0000000000000000
[   49.145914] R10: ffff88817b94dc48 R11: 0000000000000003 R12: ffffeb3ff1280000
[   49.146292] R13: 0000000000000000 R14: ffff88817b94dc48 R15: 8000000163e001e3
[   49.146671] FS:  00007f53ae71d740(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
[   49.147097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   49.147407] CR2: ffffeb3ff1200000 CR3: 000000017c7d2000 CR4: 0000000000750ef0
[   49.147786] PKRU: 55555554
[   49.147941] note: modprobe[302] exited with irqs disabled

When a process leads the addition of a struct page to vmemmap
(e.g. hot-plug), the page table update for the newly added vmemmap-based
virtual address is updated first in init_mm's page table and then
synchronized later.
If the vmemmap-based virtual address is accessed through the process's
page table before this sync, a page fault will occur.

This translates vmemmap-based virtual address to direct-mapped virtual
address and use it, if the current top-level page table is not init_mm's
page table when accessing a vmemmap-based virtual address before this sync.

Link: https://lkml.kernel.org/r/20250217114133.400063-2-gwan-gyeong.mun@intel.com
Fixes: faf1c0008a33 ("x86/vmemmap: optimize for consecutive sections in partial populated PMDs")
Signed-off-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va
+++ a/arch/x86/mm/init_64.c
@@ -844,6 +844,17 @@ void __init paging_init(void)
  */
 static unsigned long unused_pmd_start __meminitdata;
 
+static void * __meminit vmemmap_va_to_kaddr(unsigned long vmemmap_va)
+{
+	void *kaddr = (void *)vmemmap_va;
+	pgd_t *pgd = __va(read_cr3_pa());
+
+	if (init_mm.pgd != pgd)
+		kaddr = __va(slow_virt_to_phys(kaddr));
+
+	return kaddr;
+}
+
 static void __meminit vmemmap_flush_unused_pmd(void)
 {
 	if (!unused_pmd_start)
@@ -851,7 +862,7 @@ static void __meminit vmemmap_flush_unus
 	/*
 	 * Clears (unused_pmd_start, PMD_END]
 	 */
-	memset((void *)unused_pmd_start, PAGE_UNUSED,
+	memset(vmemmap_va_to_kaddr(unused_pmd_start), PAGE_UNUSED,
 	       ALIGN(unused_pmd_start, PMD_SIZE) - unused_pmd_start);
 	unused_pmd_start = 0;
 }
@@ -882,7 +893,7 @@ static void __meminit __vmemmap_use_sub_
 	 * case the first memmap never gets initialized e.g., because the memory
 	 * block never gets onlined).
 	 */
-	memset((void *)start, 0, sizeof(struct page));
+	memset(vmemmap_va_to_kaddr(start), 0, sizeof(struct page));
 }
 
 static void __meminit vmemmap_use_sub_pmd(unsigned long start, unsigned long end)
@@ -924,7 +935,7 @@ static void __meminit vmemmap_use_new_su
 	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
 	 */
 	if (!IS_ALIGNED(start, PMD_SIZE))
-		memset((void *)page, PAGE_UNUSED, start - page);
+		memset(vmemmap_va_to_kaddr(page), PAGE_UNUSED, start - page);
 
 	/*
 	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of
_

Patches currently in -mm which might be from gwan-gyeong.mun@intel.com are

x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch

