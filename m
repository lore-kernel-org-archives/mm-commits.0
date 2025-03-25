Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF9A2641FB
	for <mm-commits@vger.kernel.org>; Tue, 25 Mar 2025 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742925635; cv=none; b=JrXrgEDKC4AKvndLDjk662K2QR4tMxcZGhLPiBdXycZGjhrpgmjeN76WcBkoIVgQmMi4chQU0wCrTwn8YB1dQddk8eWyw87tWmS1wyYMUg4UgTaRShAZ91nsWMAgZkwzDUTalf4CNSyn9UMwBRaYEwVXrmKxEtIgPKpXd13ZvGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742925635; c=relaxed/simple;
	bh=6eQWXA8O82HCQaWbZJG/JeqaHu5VuWRAlPGUzqcabFg=;
	h=Date:To:From:Subject:Message-Id; b=Sz6P1qAkracH+VkfGH+L4m+ZDYH/U8ehxYKLYi0xUROlWO9GkFfoJKIqej+7VM9NZc2Iu4fD8deKynM6wHcDDSC1w2nTYQjfVQULF58xJCN3cXXSX+p78XILnfLLJ9xGfS3v7rpkaaIvF0geCiFBqx5vQ+F2Uawg0t+2sd3FJXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gG+fWA7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gG+fWA7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A224AC4CEEE;
	Tue, 25 Mar 2025 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742925634;
	bh=6eQWXA8O82HCQaWbZJG/JeqaHu5VuWRAlPGUzqcabFg=;
	h=Date:To:From:Subject:From;
	b=gG+fWA7eqldgEkV/4li0Za7ZMr/l3MfrlFePqrQxDoAGDQu0PVSCpk6a6puEjWU5U
	 m/pHs5B2g5oNgp7wrQCkuBKISHgVWLGfpSFfpHFMt4d91d/6XvpLSyZSuQPeR/R1yR
	 y0YZM8Xf4leHRy/5qxFk8E6+UlWmnWmF+PzEzaI4=
Date: Tue, 25 Mar 2025 11:00:29 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,oliver.sang@intel.com,nathan@kernel.org,mingo@redhat.com,luto@kernel.org,jiaxun.yang@flygoat.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off.patch added to mm-unstable branch
Message-Id: <20250325180033.A224AC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: don't release high memory to page allocator when HIGHMEM is off
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off.patch

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
Subject: memblock: don't release high memory to page allocator when HIGHMEM is off
Date: Tue, 25 Mar 2025 13:49:28 +0200

Nathan Chancellor reports the following crash on a MIPS system with
CONFIG_HIGHMEM=n:

  Linux version 6.14.0-rc6-00359-g6faea3422e3b (nathan@ax162) (mips-linux-gcc (GCC) 14.2.0, GNU ld (GNU Binutils) 2.42) #1 SMP Fri Mar 21 08:12:02 MST 2025
  earlycon: uart8250 at I/O port 0x3f8 (options '38400n8')
  printk: legacy bootconsole [uart8250] enabled
  Config serial console: console=ttyS0,38400n8r
  CPU0 revision is: 00019300 (MIPS 24Kc)
  FPU revision is: 00739300
  MIPS: machine is mti,malta
  Software DMA cache coherency enabled
  Initial ramdisk at: 0x8fad0000 (5360128 bytes)
  OF: reserved mem: Reserved memory: No reserved-memory node in the DT
  Primary instruction cache 2kB, VIPT, 2-way, linesize 16 bytes.
  Primary data cache 2kB, 2-way, VIPT, no aliases, linesize 16 bytes
  Zone ranges:
    DMA      [mem 0x0000000000000000-0x0000000000ffffff]
    Normal   [mem 0x0000000001000000-0x000000001fffffff]
  Movable zone start for each node
  Early memory node ranges
    node   0: [mem 0x0000000000000000-0x000000000fffffff]
    node   0: [mem 0x0000000090000000-0x000000009fffffff]
  Initmem setup node 0 [mem 0x0000000000000000-0x000000009fffffff]
  On node 0, zone Normal: 16384 pages in unavailable ranges
  random: crng init done
  percpu: Embedded 3 pages/cpu s18832 r8192 d22128 u49152
  Kernel command line: rd_start=0xffffffff8fad0000 rd_size=5360128  console=ttyS0,38400n8r
  printk: log buffer data + meta data: 32768 + 102400 = 135168 bytes
  Dentry cache hash table entries: 65536 (order: 4, 262144 bytes, linear)
  Inode-cache hash table entries: 32768 (order: 3, 131072 bytes, linear)
  Writing ErrCtl register=00000000
  Readback ErrCtl register=00000000
  Built 1 zonelists, mobility grouping on.  Total pages: 16384
  mem auto-init: stack:all(zero), heap alloc:off, heap free:off
  Unhandled kernel unaligned access[#1]:
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.14.0-rc6-00359-g6faea3422e3b #1
  Hardware name: mti,malta
  $ 0   : 00000000 00000001 81cb0880 00129027
  $ 4   : 00000001 0000000a 00000002 00129026
  $ 8   : ffffdfff 80101e00 00000002 00000000
  $12   : 81c9c224 81c63e68 00000002 00000000
  $16   : 805b1e00 00025800 81cb0880 00000002
  $20   : 00000000 81c63e64 0000000a 81f10000
  $24   : 81c63e64 81c63e60
  $28   : 81c60000 81c63de0 00000001 81cc9d20
  Hi    : 00000000
  Lo    : 00000000
  epc   : 814a227c __free_pages_ok+0x144/0x3c0
  ra    : 81cc9d20 memblock_free_all+0x1d4/0x27c
  Status: 10000002        KERNEL EXL
  Cause : 00800410 (ExcCode 04)
  BadVA : 00129026
  PrId  : 00019300 (MIPS 24Kc)
  Modules linked in:
  Process swapper (pid: 0, threadinfo=(ptrval), task=(ptrval), tls=00000000)
  Stack : 81f10000 805a9e00 81c80000 00000000 00000002 814aa240 000003ff 00000400
          00000000 81f10000 81c9c224 00003b1f 81c80000 81c63e60 81ca0000 81c63e64
          81f10000 0000000a 0000001f 81cc9d20 81f10000 81cc96d8 00000000 81c80000
          81c9c224 81c63e60 81c63e64 00000000 81f10000 00024000 00028000 00025c00
          90000000 a0000000 00000002 00000017 00000000 00000000 81f10000 81f10000
          ...
  Call Trace:
  [<814a227c>] __free_pages_ok+0x144/0x3c0
  [<81cc9d20>] memblock_free_all+0x1d4/0x27c
  [<81cc6764>] mm_core_init+0x100/0x138
  [<81cb4ba4>] start_kernel+0x4a0/0x6e4

  Code: 1080ffd5  02003825  2467ffff <8ce30000> 7c630500  1060ffd4  00000000  8ce30000  7c630180

The crash happens because commit 6faea3422e3b ("arch, mm: streamline
HIGHMEM freeing") too eagerly frees high memory to the page allocator even
when HIGHMEM is disabled.

Make sure that when CONFIG_HIGHMEM=n the high memory is not released to the
page allocator.

Link: https://lore.kernel.org/all/20250323190647.GA1009914@ax162
Link: https://lkml.kernel.org/r/20250325114928.1791109-3-rppt@kernel.org
Reported-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memblock.c~memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off
+++ a/mm/memblock.c
@@ -2166,6 +2166,9 @@ static unsigned long __init __free_memor
 	unsigned long start_pfn = PFN_UP(start);
 	unsigned long end_pfn = PFN_DOWN(end);
 
+	if (!IS_ENABLED(CONFIG_HIGHMEM) && end_pfn > max_low_pfn)
+		end_pfn = max_low_pfn;
+
 	if (start_pfn >= end_pfn)
 		return 0;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-init-holes-in-the-end-of-the-memory-map-for-flatmem.patch
memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off.patch

