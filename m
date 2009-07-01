From: akpm@linux-foundation.org
Subject: [merged] gcov-fix-__ctors_start-alignment.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:26:35 -0700
Message-ID: <200907011726.n61HQZOe001274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZGAR0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mingo@elte.hu, oberpar@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     gcov: fix __ctors_start alignment
has been removed from the -mm tree.  Its filename was
     gcov-fix-__ctors_start-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: fix __ctors_start alignment
From: Heiko Carstens <heiko.carstens@de.ibm.com>

The ctors section for each object file is eight byte aligned (on 64 bit). 
However the __ctors_start symbol starts at an arbitrary address dependent
on the size of the previous sections.

Therefore the linker may add some zeroes after __ctors_start to make sure
the ctors contents are properly aligned.  However the extra zeroes at the
beginning aren't expected by the code.  When walking the functions
pointers contained in there and extra zeroes are added this may result in
random jumps.  So make sure that the __ctors_start symbol is always
aligned as well.

Fixes this crash on an allyesconfig on s390:

[    0.582482] Kernel BUG at 0000000000000012 [verbose debug info unavailable]
[    0.582489] illegal operation: 0001 [#1] SMP DEBUG_PAGEALLOC
[    0.582496] Modules linked in:
[    0.582501] CPU: 0 Tainted: G        W  2.6.31-rc1-dirty #273
[    0.582506] Process swapper (pid: 1, task: 000000003f218000, ksp: 000000003f2238e8)
[    0.582510] Krnl PSW : 0704200180000000 0000000000000012 (0x12)
[    0.582518]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
[    0.582524] Krnl GPRS: 0000000000036727 0000000000000010 0000000000000001 0000000000000001
[    0.582529]            00000000001dfefa 0000000000000000 0000000000000000 0000000000000040
[    0.582534]            0000000001fff0f0 0000000001790628 0000000002296048 0000000002296048
[    0.582540]            00000000020c438e 0000000001786000 0000000002014a66 000000003f223e60
[    0.582553] Krnl Code:>0000000000000012: 0000                unknown
[    0.582559]            0000000000000014: 0000                unknown
[    0.582564]            0000000000000016: 0000                unknown
[    0.582570]            0000000000000018: 0000                unknown
[    0.582575]            000000000000001a: 0000                unknown
[    0.582580]            000000000000001c: 0000                unknown
[    0.582585]            000000000000001e: 0000                unknown
[    0.582591]            0000000000000020: 0000                unknown
[    0.582596] Call Trace:
[    0.582599] ([<0000000002014a46>] kernel_init+0x622/0x7a0)
[    0.582607]  [<0000000000113e22>] kernel_thread_starter+0x6/0xc
[    0.582615]  [<0000000000113e1c>] kernel_thread_starter+0x0/0xc
[    0.582621] INFO: lockdep is turned off.
[    0.582624] Last Breaking-Event-Address:
[    0.582627]  [<0000000002014a64>] kernel_init+0x640/0x7a0

Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~gcov-fix-__ctors_start-alignment include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~gcov-fix-__ctors_start-alignment
+++ a/include/asm-generic/vmlinux.lds.h
@@ -441,7 +441,8 @@
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
-#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
+#define KERNEL_CTORS()	. = ALIGN(8);			   \
+			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch

