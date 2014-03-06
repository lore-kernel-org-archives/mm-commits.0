From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-bugfix-for-last_cpupid_not_in_page_flags-v3.patch removed from -mm
 tree
Date: Thu, 06 Mar 2014 12:37:55 -0800
Message-ID: <5318dca3.8zCzEOnrdnkPGI4x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaCFUh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, paulus@samba.org, mel@csn.ul.ie, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, pingfank@linux.vnet.ibm.com

Subject: [merged] mm-numa-bugfix-for-last_cpupid_not_in_page_flags-v3.patch removed from -mm tree
To: pingfank@linux.vnet.ibm.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mel@csn.ul.ie,paulus@samba.org,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:55 -0800


The patch titled
     Subject: mm: numa: bugfix for LAST_CPUPID_NOT_IN_PAGE_FLAGS
has been removed from the -mm tree.  Its filename was
     mm-numa-bugfix-for-last_cpupid_not_in_page_flags-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Subject: mm: numa: bugfix for LAST_CPUPID_NOT_IN_PAGE_FLAGS

When doing some numa tests on powerpc, I triggered an oops bug.  I find it
is caused by using page->_last_cpupid.  It should be initialized as "-1 &
LAST_CPUPID_MASK", but not "-1".  Otherwise, in task_numa_fault(), we will
miss the checking (last_cpupid == (-1 & LAST_CPUPID_MASK)).  And finally
cause an oops bug in task_numa_group(), since the online cpu is less than
possible cpu.  This happen with CONFIG_SPARSE_VMEMMAP disabled

Call trace:
[   55.978091] SMP NR_CPUS=64 NUMA PowerNV
[   55.978118] Modules linked in:
[   55.978145] CPU: 24 PID: 804 Comm: systemd-udevd Not tainted3.13.0-rc1+ #32
[   55.978183] task: c000001e2746aa80 ti: c000001e32c50000 task.ti:c000001e32c50000
[   55.978219] NIP: c0000000000f5ad0 LR: c0000000000f5ac8 CTR:c000000000913cf0
[   55.978256] REGS: c000001e32c53510 TRAP: 0300   Not tainted(3.13.0-rc1+)
[   55.978286] MSR: 9000000000009032 <SF,HV,EE,ME,IR,DR,RI>  CR:28024424  XER: 20000000
[   55.978380] CFAR: c000000000009324 DAR: 7265717569726857 DSISR:40000000 SOFTE: 1
GPR00: c0000000000f5ac8 c000001e32c53790 c000000001f343380000000000000021
GPR04: 0000000000000000 0000000000000031 c000000001f743380000ffffffffffff
GPR08: 0000000000000001 7265717569726573 00000000000000000000000000000000
GPR12: 0000000028024422 c00000000ffdd800 00000000296b2e640000000000000020
GPR16: 0000000000000002 0000000000000003 c000001e2f8e4658c000001e25c1c1d8
GPR20: c000001e2f8e4000 c000000001f7a858 00000000000006580000000040000392
GPR24: 00000000000000a8 c000001e33c1a400 00000000000001d8c000001e25c1c000
GPR28: c000001e33c37ff0 0007837840000392 000000000000003fc000001e32c53790
[   55.978903] NIP [c0000000000f5ad0] .task_numa_fault+0x1470/0x2370
[   55.978934] LR [c0000000000f5ac8] .task_numa_fault+0x1468/0x2370
[   55.978964] Call Trace:
[   55.978978] [c000001e32c53790] [c0000000000f5ac8].task_numa_fault+0x1468/0x2370 (unreliable)
[   55.979036] [c000001e32c539e0] [c00000000020a820].do_numa_page+0x480/0x4a0
[   55.979072] [c000001e32c53b10] [c00000000020bfec].handle_mm_fault+0x4ec/0xc90
[   55.979123] [c000001e32c53c00] [c000000000e88c98].do_page_fault+0x3a8/0x890
[   55.979161] [c000001e32c53e30] [c000000000009568]handle_page_fault+0x10/0x30
[   55.979197] Instruction dump:
[   55.979216] 3c82fefb 3884b138 48d9cff1 60000000 48000574 3c62fefb3863af78 3c82fefb
[   55.979277] 3884b138 48d9cfd5 60000000 e93f0100 <812902e4> 7d2907b45529063e 7d2a07b4
[   55.979354] ---[ end trace 15f2510da5ae07cf ]---

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-numa-bugfix-for-last_cpupid_not_in_page_flags-v3 include/linux/mm.h
--- a/include/linux/mm.h~mm-numa-bugfix-for-last_cpupid_not_in_page_flags-v3
+++ a/include/linux/mm.h
@@ -767,7 +767,7 @@ static inline bool __cpupid_match_pid(pi
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
 {
-	return xchg(&page->_last_cpupid, cpupid);
+	return xchg(&page->_last_cpupid, cpupid & LAST_CPUPID_MASK);
 }
 
 static inline int page_cpupid_last(struct page *page)
@@ -776,7 +776,7 @@ static inline int page_cpupid_last(struc
 }
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	page->_last_cpupid = -1;
+	page->_last_cpupid = -1 & LAST_CPUPID_MASK;
 }
 #else
 static inline int page_cpupid_last(struct page *page)
_

Patches currently in -mm which might be from pingfank@linux.vnet.ibm.com are

origin.patch

