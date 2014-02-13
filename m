From: akpm@linux-foundation.org
Subject: + mm-numa-bugfix-for-last_cpupid_not_in_page_flags.patch added to -mm tree
Date: Thu, 13 Feb 2014 15:20:30 -0800
Message-ID: <52fd533e.0xU6Tnl8rMBs/GMw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaBMXUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 18:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pingfank@linux.vnet.ibm.com, peterz@infradead.org, paulus@samba.org, mel@csn.ul.ie, benh@kernel.crashing.org, qemulist@gmail.com

Subject: + mm-numa-bugfix-for-last_cpupid_not_in_page_flags.patch added to -mm tree
To: qemulist@gmail.com,benh@kernel.crashing.org,mel@csn.ul.ie,paulus@samba.org,peterz@infradead.org,pingfank@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 15:20:30 -0800


The patch titled
     Subject: mm: numa: bugfix for LAST_CPUPID_NOT_IN_PAGE_FLAGS
has been added to the -mm tree.  Its filename is
     mm-numa-bugfix-for-last_cpupid_not_in_page_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-bugfix-for-last_cpupid_not_in_page_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-bugfix-for-last_cpupid_not_in_page_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Ping Fan <qemulist@gmail.com>
Subject: mm: numa: bugfix for LAST_CPUPID_NOT_IN_PAGE_FLAGS

When doing some numa tests on powerpc, I triggered an oops bug.  I find it
is caused by using page->_last_cpupid.  It should be initialized as "-1 &
LAST_CPUPID_MASK", but not "-1".  Otherwise, in task_numa_fault(), we will
miss the checking (last_cpupid == (-1 & LAST_CPUPID_MASK)).  And finally
cause an oops bug in task_numa_group(), since the online cpu is less than
possible cpu.

PPC needs the LAST_CPUPID_NOT_IN_PAGE_FLAGS case because ppc needs to
support a large physical address region, up to 2^46 but small section size
(2^24).  So when NR_CPUS grows up, it is easily to cause
not-in-page-flags.

Call trace:
[   55.978091] SMP NR_CPUS=64 NUMA PowerNV
[   55.978118] Modules linked in:
[   55.978145] CPU: 24 PID: 804 Comm: systemd-udevd Not tainted
3.13.0-rc1+ #32
[   55.978183] task: c000001e2746aa80 ti: c000001e32c50000 task.ti:
c000001e32c50000
[   55.978219] NIP: c0000000000f5ad0 LR: c0000000000f5ac8 CTR:
c000000000913cf0
[   55.978256] REGS: c000001e32c53510 TRAP: 0300   Not tainted
(3.13.0-rc1+)
[   55.978286] MSR: 9000000000009032 <SF,HV,EE,ME,IR,DR,RI>  CR:
28024424  XER: 20000000
[   55.978380] CFAR: c000000000009324 DAR: 7265717569726857 DSISR:
40000000 SOFTE: 1
GPR00: c0000000000f5ac8 c000001e32c53790 c000000001f34338
0000000000000021
GPR04: 0000000000000000 0000000000000031 c000000001f74338
0000ffffffffffff
GPR08: 0000000000000001 7265717569726573 0000000000000000
0000000000000000
GPR12: 0000000028024422 c00000000ffdd800 00000000296b2e64
0000000000000020
GPR16: 0000000000000002 0000000000000003 c000001e2f8e4658
c000001e25c1c1d8
GPR20: c000001e2f8e4000 c000000001f7a858 0000000000000658
0000000040000392
GPR24: 00000000000000a8 c000001e33c1a400 00000000000001d8
c000001e25c1c000
GPR28: c000001e33c37ff0 0007837840000392 000000000000003f
c000001e32c53790
[   55.978903] NIP [c0000000000f5ad0] .task_numa_fault+0x1470/0x2370
[   55.978934] LR [c0000000000f5ac8] .task_numa_fault+0x1468/0x2370
[   55.978964] Call Trace:
[   55.978978] [c000001e32c53790] [c0000000000f5ac8]
.task_numa_fault+0x1468/0x2370 (unreliable)
[   55.979036] [c000001e32c539e0] [c00000000020a820]
.do_numa_page+0x480/0x4a0
[   55.979072] [c000001e32c53b10] [c00000000020bfec]
.handle_mm_fault+0x4ec/0xc90
[   55.979123] [c000001e32c53c00] [c000000000e88c98]
.do_page_fault+0x3a8/0x890
[   55.979161] [c000001e32c53e30] [c000000000009568]
handle_page_fault+0x10/0x30
[   55.979197] Instruction dump:
[   55.979216] 3c82fefb 3884b138 48d9cff1 60000000 48000574 3c62fefb
3863af78 3c82fefb
[   55.979277] 3884b138 48d9cfd5 60000000 e93f0100 <812902e4> 7d2907b4
5529063e 7d2a07b4
[   55.979354] ---[ end trace 15f2510da5ae07cf ]---

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                |    2 +-
 include/linux/page-flags-layout.h |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~mm-numa-bugfix-for-last_cpupid_not_in_page_flags include/linux/mm.h
--- a/include/linux/mm.h~mm-numa-bugfix-for-last_cpupid_not_in_page_flags
+++ a/include/linux/mm.h
@@ -776,7 +776,7 @@ static inline int page_cpupid_last(struc
 }
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	page->_last_cpupid = -1;
+	page->_last_cpupid = -1 & LAST_CPUPID_MASK;
 }
 #else
 static inline int page_cpupid_last(struct page *page)
diff -puN include/linux/page-flags-layout.h~mm-numa-bugfix-for-last_cpupid_not_in_page_flags include/linux/page-flags-layout.h
--- a/include/linux/page-flags-layout.h~mm-numa-bugfix-for-last_cpupid_not_in_page_flags
+++ a/include/linux/page-flags-layout.h
@@ -69,15 +69,15 @@
 #define LAST__CPU_MASK  ((1 << LAST__CPU_SHIFT)-1)
 
 #define LAST_CPUPID_SHIFT (LAST__PID_SHIFT+LAST__CPU_SHIFT)
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT > BITS_PER_LONG - NR_PAGEFLAGS
+#define LAST_CPUPID_NOT_IN_PAGE_FLAGS
+#endif
 #else
 #define LAST_CPUPID_SHIFT 0
 #endif
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
 #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
-#else
-#define LAST_CPUPID_WIDTH 0
-#endif
 
 /*
  * We are going to use the flags for the page to node mapping if its in
@@ -87,8 +87,4 @@
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
-#if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
-#define LAST_CPUPID_NOT_IN_PAGE_FLAGS
-#endif
