From: akpm@linux-foundation.org
Subject: + mm-mprotect-add-a-cond_resched-inside-change_pmd_range.patch
 added to -mm tree
Date: Thu, 14 Dec 2017 12:40:40 -0800
Message-ID: <5a32e1c8.ZvhTdCo8DHMnWxbs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49058 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbdLNUkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:40:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mhocko@suse.com, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: add a cond_resched() inside change_pmd_range()
has been added to the -mm tree.  Its filename is
     mm-mprotect-add-a-cond_resched-inside-change_pmd_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mprotect-add-a-cond_resched-inside-change_pmd_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotect-add-a-cond_resched-inside-change_pmd_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/mprotect: add a cond_resched() inside change_pmd_range()

While testing on a large CPU system, detected the following RCU stall many
times over the span of the workload.  This problem is solved by adding a
cond_resched() in the change_pmd_range() function.

[  850.962530] INFO: rcu_sched detected stalls on CPUs/tasks:
[  850.962584]  154-....: (670 ticks this GP) idle=022/140000000000000/0 softirq=2825/2825 fqs=612
[  850.962605]  (detected by 955, t=6002 jiffies, g=4486, c=4485, q=90864)
[  850.962895] Sending NMI from CPU 955 to CPUs 154:
[  850.992667] NMI backtrace for cpu 154
[  850.993069] CPU: 154 PID: 147071 Comm: workload Not tainted 4.15.0-rc3+ #3
[  850.993258] NIP:  c0000000000b3f64 LR: c0000000000b33d4 CTR: 000000000000aa18
[  850.993503] REGS: 00000000a4b0fb44 TRAP: 0501   Not tainted  (4.15.0-rc3+)
[  850.993707] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 22422082  XER: 00000000
[  850.994386] CFAR: 00000000006cf8f0 SOFTE: 1
GPR00: 0010000000000000 c00003ef9b1cb8c0 c0000000010cc600 0000000000000000
GPR04: 8e0000018c32b200 40017b3858fd6e00 8e0000018c32b208 40017b3858fd6e00
GPR08: 8e0000018c32b210 40017b3858fd6e00 8e0000018c32b218 40017b3858fd6e00
GPR12: ffffffffffffffff c00000000fb25100
[  850.995976] NIP [c0000000000b3f64] plpar_hcall9+0x44/0x7c
[  850.996174] LR [c0000000000b33d4] pSeries_lpar_flush_hash_range+0x384/0x420
[  850.996401] Call Trace:
[  850.996600] [c00003ef9b1cb8c0] [c00003fa8fff7d40] 0xc00003fa8fff7d40 (unreliable)
[  850.996959] [c00003ef9b1cba40] [c0000000000688a8] flush_hash_range+0x48/0x100
[  850.997261] [c00003ef9b1cba90] [c000000000071b14] __flush_tlb_pending+0x44/0xd0
[  850.997600] [c00003ef9b1cbac0] [c000000000071fa8] hpte_need_flush+0x408/0x470
[  850.997958] [c00003ef9b1cbb30] [c0000000002c646c] change_protection_range+0xaac/0xf10
[  850.998180] [c00003ef9b1cbcb0] [c0000000002f2510] change_prot_numa+0x30/0xb0
[  850.998502] [c00003ef9b1cbce0] [c00000000013a950] task_numa_work+0x2d0/0x3e0
[  850.998816] [c00003ef9b1cbda0] [c00000000011ea30] task_work_run+0x130/0x190
[  850.999121] [c00003ef9b1cbe00] [c00000000001bcd8] do_notify_resume+0x118/0x120
[  850.999421] [c00003ef9b1cbe30] [c00000000000b744] ret_from_except_lite+0x70/0x74
[  850.999716] Instruction dump:
[  850.999959] 60000000 f8810028 7ca42b78 7cc53378 7ce63b78 7d074378 7d284b78 7d495378
[  851.000575] e9410060 e9610068 e9810070 44000022 <7d806378> e9810028 f88c0000 f8ac0008

Link: http://lkml.kernel.org/r/20171214140551.5794-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mprotect.c~mm-mprotect-add-a-cond_resched-inside-change_pmd_range mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotect-add-a-cond_resched-inside-change_pmd_range
+++ a/mm/mprotect.c
@@ -166,7 +166,7 @@ static inline unsigned long change_pmd_r
 		next = pmd_addr_end(addr, end);
 		if (!is_swap_pmd(*pmd) && !pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)
 				&& pmd_none_or_clear_bad(pmd))
-			continue;
+			goto next;
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!mni_start) {
@@ -188,7 +188,7 @@ static inline unsigned long change_pmd_r
 					}
 
 					/* huge pmd was handled */
-					continue;
+					goto next;
 				}
 			}
 			/* fall through, the trans huge pmd just split */
@@ -196,6 +196,8 @@ static inline unsigned long change_pmd_r
 		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa);
 		pages += this_pages;
+next:
+		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 
 	if (mni_start)
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-mprotect-add-a-cond_resched-inside-change_pmd_range.patch

