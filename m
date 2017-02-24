From: akpm@linux-foundation.org
Subject: [folded-merged] mmfsdax-change-pmd_fault-to-huge_fault-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:31:58 -0800
Message-ID: <58b0b45e.zJL6bVd0fAXvhtfZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdBXWb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:31:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: clear PMD or PUD size flags when in fall through path
has been removed from the -mm tree.  Its filename was
     mmfsdax-change-pmd_fault-to-huge_fault-fix.patch

This patch was dropped because it was folded into mmfsdax-change-pmd_fault-to-huge_fault.patch

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: mm, dax: clear PMD or PUD size flags when in fall through path

Ross reported that:
Running xfstests generic/030 with XFS + DAX gives me the following kernel BUG,
which I bisected to this commit: mm,fs,dax: Change ->pmd_fault to ->huge_fault

[  370.086205] ------------[ cut here ]------------
[  370.087182] kernel BUG at arch/x86/mm/fault.c:1038!
[  370.088336] invalid opcode: 0000 [#3] PREEMPT SMP
[  370.089073] Modules linked in: dax_pmem nd_pmem dax nd_btt nd_e820 libnvdimm
[  370.090212] CPU: 0 PID: 12415 Comm: xfs_io Tainted: G      D         4.10.0-rc5-mm1-00202-g7e90fc0 #10
[  370.091648] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[  370.092946] task: ffff8800ac4f8000 task.stack: ffffc9001148c000
[  370.093769] RIP: 0010:mm_fault_error+0x15e/0x190
[  370.094410] RSP: 0000:ffffc9001148fe60 EFLAGS: 00010246
[  370.095135] RAX: 0000000000000000 RBX: 0000000000000006 RCX: ffff8800ac4f8000
[  370.096107] RDX: 00007f111c8e6400 RSI: 0000000000000006 RDI: ffffc9001148ff58
[  370.097087] RBP: ffffc9001148fe88 R08: 0000000000000000 R09: ffff880510bd3300
[  370.098072] R10: ffff8800ac4f8000 R11: 0000000000000000 R12: 00007f111c8e6400
[  370.099057] R13: 00007f111c8e6400 R14: ffff880510bd3300 R15: 0000000000000055
[  370.100135] FS:  00007f111d95e700(0000) GS:ffff880514800000(0000) knlGS:0000000000000000
[  370.101238] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  370.102021] CR2: 00007f111c8e6400 CR3: 00000000add00000 CR4: 00000000001406f0
[  370.103189] Call Trace:
[  370.103537]  __do_page_fault+0x54e/0x590
[  370.104090]  trace_do_page_fault+0x58/0x2c0
[  370.104675]  do_async_page_fault+0x2c/0x90
[  370.105342]  async_page_fault+0x28/0x30
[  370.106044] RIP: 0033:0x405e9a
[  370.106470] RSP: 002b:00007fffb7f30590 EFLAGS: 00010287
[  370.107185] RAX: 00000000004e6400 RBX: 0000000000000057 RCX: 00000000004e7000
[  370.108155] RDX: 00007f111c400000 RSI: 00000000004e7000 RDI: 0000000001c35080
[  370.109157] RBP: 00000000004e6400 R08: 0000000000000014 R09: 1999999999999999
[  370.110158] R10: 00007f111d2dc200 R11: 0000000000000000 R12: 0000000001c32fc0
[  370.111165] R13: 0000000000000000 R14: 0000000000000c00 R15: 0000000000000005
[  370.112171] Code: 07 00 00 00 e8 a4 ee ff ff e9 11 ff ff ff 4c 89 ea 48 89 de 45 31 c0 31 c9 e8 8f f7 ff ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 5d c3 <0f> 0b 41 8b 94 24 80 04 00 00 49 8d b4 24 b0 06 00 00 4c 89 e9
[  370.114823] RIP: mm_fault_error+0x15e/0x190 RSP: ffffc9001148fe60
[  370.115722] ---[ end trace 2ce10d930638254d ]---

It appears that there are 2 issues. First, the size bits used for vm_fault
needs to be shifted over. Otherwise, FAULT_FLAG_SIZE_PMD is clobbering
FAULT_FLAG_INSTRUCTION. Second issue, after create_huge_pmd() is being
called and is falling back to the pte fault handler, the FAULT_FLAG_SIZE_PMD
flag remains and that causes the dax fault handler to go towards the pmd
fault handler instead of the pte fault handler. Fixes are made for the pud
and pmd fall through paths.

Link: http://lkml.kernel.org/r/148589842696.5820.16078080610311444794.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/memory.c        |    4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mmfsdax-change-pmd_fault-to-huge_fault-fix include/linux/mm.h
--- a/include/linux/mm.h~mmfsdax-change-pmd_fault-to-huge_fault-fix
+++ a/include/linux/mm.h
@@ -285,10 +285,10 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
 #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
 
-#define FAULT_FLAG_SIZE_MASK	0x700	/* Support up to 8-level page tables */
-#define FAULT_FLAG_SIZE_PTE	0x000	/* First level (eg 4k) */
-#define FAULT_FLAG_SIZE_PMD	0x100	/* Second level (eg 2MB) */
-#define FAULT_FLAG_SIZE_PUD	0x200	/* Third level (eg 1GB) */
+#define FAULT_FLAG_SIZE_MASK	0x7000	/* Support up to 8-level page tables */
+#define FAULT_FLAG_SIZE_PTE	0x0000	/* First level (eg 4k) */
+#define FAULT_FLAG_SIZE_PMD	0x1000	/* Second level (eg 2MB) */
+#define FAULT_FLAG_SIZE_PUD	0x2000	/* Third level (eg 1GB) */
 
 #define FAULT_FLAG_TRACE \
 	{ FAULT_FLAG_WRITE,		"WRITE" }, \
diff -puN mm/memory.c~mmfsdax-change-pmd_fault-to-huge_fault-fix mm/memory.c
--- a/mm/memory.c~mmfsdax-change-pmd_fault-to-huge_fault-fix
+++ a/mm/memory.c
@@ -3620,6 +3620,8 @@ static int __handle_mm_fault(struct vm_a
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
+		/* fall through path, remove PMD flag */
+		vmf.flags &= ~FAULT_FLAG_SIZE_PMD;
 	} else {
 		pmd_t orig_pmd = *vmf.pmd;
 
@@ -3634,6 +3636,8 @@ static int __handle_mm_fault(struct vm_a
 				ret = wp_huge_pmd(&vmf, orig_pmd);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
+				/* fall through path, remove PUD flag */
+				vmf.flags &= ~FAULT_FLAG_SIZE_PUD;
 			} else {
 				huge_pmd_set_accessed(&vmf, orig_pmd);
 				return 0;
_

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages-fix.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch
dax-support-for-transparent-pud-pages-for-device-dax.patch
mm-replace-fault_flag_size-with-parameter-to-huge_fault.patch

