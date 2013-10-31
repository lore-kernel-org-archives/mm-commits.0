From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagewalkc-fix-walk_page_range-access-of-wrong-ptes.patch removed from
 -mm tree
Date: Thu, 31 Oct 2013 11:00:03 -0700
Message-ID: <52729aa3.Sq52OQOtI+AW2/Vb%akpm__16873.3704872013$1383242446$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab3JaSAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 14:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, shuox.liu@intel.com, n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, linx.z.chen@intel.com

Subject: [merged] mm-pagewalkc-fix-walk_page_range-access-of-wrong-ptes.patch removed from -mm tree
To: linx.z.chen@intel.com,kirill.shutemov@linux.intel.com,n-horiguchi@ah.jp.nec.com,shuox.liu@intel.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 11:00:03 -0700


The patch titled
     Subject: mm/pagewalk.c: fix walk_page_range() access of wrong PTEs
has been removed from the -mm tree.  Its filename was
     mm-pagewalkc-fix-walk_page_range-access-of-wrong-ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen LinX <linx.z.chen@intel.com>
Subject: mm/pagewalk.c: fix walk_page_range() access of wrong PTEs

When walk_page_range walk a memory map's page tables, it'll skip VM_PFNMAP
area, then variable 'next' will to assign to vma->vm_end, it maybe larger
than 'end'.  In next loop, 'addr' will be larger than 'next'.  Then in
/proc/XXXX/pagemap file reading procedure, the 'addr' will growing forever
in pagemap_pte_range, pte_to_pagemap_entry will access wrong pte.

[   93.387934] BUG: Bad page map in process procrank  pte:8437526f pmd:785de067
[   93.387936] addr:9108d000 vm_flags:00200073 anon_vma:f0d99020 mapping:  (null) index:9108d
[   93.387938] CPU: 1 PID: 4974 Comm: procrank Tainted: G    B   W  O 3.10.1+ #1
[   93.387942]  f0d983c8 f0d983c8 e8271e48 c281ef4b e8271e84 c20ee794 c2a3f150 9108d000
[   93.387946]  00200073 f0d99020 00000000 0009108d e8342d90 8437526f 0009108d 00000000
[   93.387950]  00000000 00084375 fffa4234 e8271e98 c20ef836 00000000 e8271f28 f0d983c8
[   93.387951] Call Trace:
[   93.387953]  [<c281ef4b>] dump_stack+0x16/0x18
[   93.387956]  [<c20ee794>] print_bad_pte+0x114/0x1b0
[   93.387959]  [<c20ef836>] vm_normal_page+0x56/0x60
[   93.387961]  [<c21594ba>] pagemap_pte_range+0x17a/0x1d0
[   93.387963]  [<c2159340>] ? m_next+0x70/0x70
[   93.387966]  [<c20fc60e>] walk_page_range+0x19e/0x2c0
[   93.387969]  [<c20432c4>] ? ptrace_may_access+0x24/0x40
[   93.387971]  [<c2159a4e>] pagemap_read+0x16e/0x200
[   93.387973]  [<c2159340>] ? m_next+0x70/0x70
[   93.387976]  [<c2158be0>] ? quota_send_warning+0x1f0/0x1f0
[   93.387979]  [<c2158c30>] ? pagemap_pte_hole+0x50/0x50
[   93.387981]  [<c21598e0>] ? clear_refs_pte_range+0xc0/0xc0
[   93.387984]  [<c210c534>] vfs_read+0x84/0x150
[   93.387986]  [<c21598e0>] ? clear_refs_pte_range+0xc0/0xc0
[   93.387988]  [<c210c77a>] SyS_read+0x4a/0x80
[   93.387991]  [<c28267c8>] syscall_call+0x7/0xb
[   93.387996]  [<c2820000>] ? e1000_regdump+0x6f/0x37c
[  102.866190]  [<c259fcd3>] ? cpuidle_idle_call+0x93/0x1b0
[  102.872124]  [<c28297fa>] ? atomic_notifier_call_chain+0x1a/0x20
[  102.878834]  [<c2008478>] ? arch_cpu_idle+0x8/0x20
[  102.884183]  [<c207950d>] ? cpu_startup_entry+0x4d/0x1b0
[  102.890116]  [<c280ecbd>] ? rest_init+0x5d/0x60
[  102.895174]  [<c2b989f8>] ? start_kernel+0x31b/0x321
[  102.900717]  [<c2b98512>] ? repair_env_string+0x51/0x51
[  102.906551]  [<c2b98356>] ? i386_start_kernel+0x12c/0x12f

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
Signed-off-by: Chen LinX <linx.z.chen@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[3.10.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/pagewalk.c~mm-pagewalkc-fix-walk_page_range-access-of-wrong-ptes mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalkc-fix-walk_page_range-access-of-wrong-ptes
+++ a/mm/pagewalk.c
@@ -242,7 +242,7 @@ int walk_page_range(unsigned long addr,
 		if (err)
 			break;
 		pgd++;
-	} while (addr = next, addr != end);
+	} while (addr = next, addr < end);
 
 	return err;
 }
_

Patches currently in -mm which might be from linx.z.chen@intel.com are

origin.patch

