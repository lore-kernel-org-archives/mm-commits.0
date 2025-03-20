Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD51B85C5
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 01:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742434998; cv=none; b=QJ6rEBjsUKHD8omQtZ2IDkuLWdGIrEmUtMi+h0mAaeNhS3D0Ld9ZUIYPfqcUtozzkPDR8BwsYIVus+vIi2sPwve4GutldwphXLJ1CqRy3lMvxdHKhw+gAiPm/ZXxOm0Vr7En1RF7WpdOhu2IbtxwUT5wqZTeC0r1qk6lYGcC84Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742434998; c=relaxed/simple;
	bh=Bl9h+HYMGpJoTQX4CPJO6lxKs9SvOOh0ElQWLEfpI3c=;
	h=Date:To:From:Subject:Message-Id; b=ktJYwf2dE1Ix9AvAYf4D28QZZw3iw1YzzW1O9Nq/ALt1wH1DQIaI7Q/iys2USmwm5GvWfxgGo1KRoFvnF6f59N4n6Utvyo1UpW2foVeQ9imPnl8OOP13bzOYpJYmM8DR2MlMXktLwBDyOJqVtWBj/oZoJfSh6dk0u4M+76GDi0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GFN0aCkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GFN0aCkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B99EC4CEE4;
	Thu, 20 Mar 2025 01:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742434994;
	bh=Bl9h+HYMGpJoTQX4CPJO6lxKs9SvOOh0ElQWLEfpI3c=;
	h=Date:To:From:Subject:From;
	b=GFN0aCkENsw4xTn0dZKNoOigkGp0Qu9J0giDdIUsOdxnW0r66lAO/jlDbhZXATLHV
	 7oxkOL21GOM+uflJubqbAJqn1Bb5CT7lhEAkAJNaZG0Mxh0TtKWjugmr6ZZYn6978M
	 sP1pMWEzfCgTpn2to61BcpiwziUtuEpsMvV+n7WY=
Date: Wed, 19 Mar 2025 18:43:13 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,oliver.sang@intel.com,mingo@redhat.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-restore-early-initialization-of-high_memory-for-32-bits.patch added to mm-unstable branch
Message-Id: <20250320014314.7B99EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: restore early initialization of high_memory for 32-bits
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-restore-early-initialization-of-high_memory-for-32-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-restore-early-initialization-of-high_memory-for-32-bits.patch

This patch will later appear in the mm-unstable branch at
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
Subject: x86/mm: restore early initialization of high_memory for 32-bits
Date: Wed, 19 Mar 2025 14:23:37 +0200

Kernel test robot reports the following crash on 32-bit system with
HIGHMEM and DEBUG_VIRTUAL:

[    0.056128][    T0] kernel BUG at arch/x86/mm/physaddr.c:77!
PANIC: early exception 0x06 IP 60:c116539d error 0 cr2 0x0
[    0.056916][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.14.0-rc4-00010-ga4dbe5c71817 #1
[    0.057570][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 0.058299][ T0] EIP: __phys_addr (arch/x86/mm/physaddr.c:77)
[ 0.058633][ T0] Code: 00 74 33 89 f0 e8 d3 8b 2e 00 89 c3 0f b6 d0 b8 58 bb 4b c5 31 c9 6a 00 e8 70 f5 15 00 83 c4 04 84 db 74 25 ff 05 78 de 5d c5 <0f> 0b b8 c8 91 ea c4 e8 e7 6e ea ff b8 58 bb 4b c5 31 d2 31 c9 6a
All code
[    0.060017][    T0] EAX: 00000000 EBX: c61f7001 ECX: 00000000 EDX: 00000000
[    0.060519][    T0] ESI: c61f7000 EDI: 061f7000 EBP: c4e31f04 ESP: c61f7000
[    0.061016][    T0] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: cff4 EFLAGS: 00210002
[    0.061560][    T0] CR0: 80050033 CR2: 00000000 CR3: 059fc000 CR4: 00000090
[    0.062060][    T0] Call Trace:
[ 0.062288][ T0] ? show_regs (arch/x86/kernel/dumpstack.c:478)
[ 0.062588][ T0] ? early_fixup_exception (arch/x86/include/asm/nospec-branch.h:595)
[ 0.062968][ T0] ? early_idt_handler_common (arch/x86/kernel/head_32.S:352)
[ 0.063360][ T0] ? __phys_addr (arch/x86/mm/physaddr.c:77)
[ 0.063677][ T0] ? one_page_table_init (arch/x86/mm/init_32.c:100)
[ 0.064037][ T0] ? page_table_range_init (arch/x86/mm/init_32.c:227)
[ 0.064411][ T0] ? permanent_kmaps_init (include/linux/pgtable.h:191 include/linux/pgtable.h:196 arch/x86/mm/init_32.c:395)
[ 0.064814][ T0] ? paging_init (arch/x86/mm/init_32.c:677)
[ 0.065118][ T0] ? native_pagetable_init (arch/x86/mm/init_32.c:481)
[ 0.065503][ T0] ? setup_arch (arch/x86/kernel/setup.c:1131)
[ 0.065819][ T0] ? start_kernel (include/linux/jump_label.h:267 init/main.c:920)
[ 0.066143][ T0] ? i386_start_kernel (arch/x86/kernel/head32.c:79)
[ 0.066501][ T0] ? startup_32_smp (arch/x86/kernel/head_32.S:292)

The crash happens because commit e120d1bc12da ("arch, mm: set high_memory
in free_area_init()") moved initialization of high_memory after
__vmalloc_start_set and with high_memory still set to 0 any address passes
is_vmalloc_addr() check.

Restore early initialization of high_memory on 32-bit systems in
initmem_init().

Link: https://lkml.kernel.org/r/20250319122337.1538924-1-rppt@kernel.org
Fixes: e120d1bc12da ("arch, mm: set high_memory in free_area_init()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202503191442.112e954f-lkp@intel.com
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |    3 +++
 arch/x86/mm/numa_32.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/arch/x86/mm/init_32.c~x86-mm-restore-early-initialization-of-high_memory-for-32-bits
+++ a/arch/x86/mm/init_32.c
@@ -626,6 +626,9 @@ void __init initmem_init(void)
 		highstart_pfn = max_low_pfn;
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
+	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
+#else
+	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
 	memblock_set_node(0, PHYS_ADDR_MAX, &memblock.memory, 0);
--- a/arch/x86/mm/numa_32.c~x86-mm-restore-early-initialization-of-high_memory-for-32-bits
+++ a/arch/x86/mm/numa_32.c
@@ -41,6 +41,9 @@ void __init initmem_init(void)
 		highstart_pfn = max_low_pfn;
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 	       pages_to_mb(highend_pfn - highstart_pfn));
+	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
+#else
+	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
 	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
 			pages_to_mb(max_low_pfn));
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch
x86-mm-restore-early-initialization-of-high_memory-for-32-bits.patch

