From: akpm@linux-foundation.org
Subject: [merged] x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch removed from -mm tree
Date: Fri, 25 May 2012 13:48:27 -0700
Message-ID: <20120525204827.6D5EEA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50560 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2EYUs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:48:28 -0400
Received: by vbnl22 with SMTP id l22so148947vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:48:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, NMI: add missing KERN_CONT to NMI selftest
has been removed from the -mm tree.  Its filename was
     x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: x86, NMI: add missing KERN_CONT to NMI selftest

Fix this behaviour:

----------------
| NMI testsuite:
--------------------
  remote IPI:
  ok  |

   local IPI:
  ok  |

Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/nmi_selftest.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/nmi_selftest.c~x86-nmi-add-missing-kern_cont-to-nmi-selftest arch/x86/kernel/nmi_selftest.c
--- a/arch/x86/kernel/nmi_selftest.c~x86-nmi-add-missing-kern_cont-to-nmi-selftest
+++ a/arch/x86/kernel/nmi_selftest.c
@@ -117,15 +117,15 @@ static void __init dotest(void (*testcas
 		unexpected_testcase_failures++;
 
 		if (nmi_fail == FAILURE)
-			printk("FAILED |");
+			printk(KERN_CONT "FAILED |");
 		else if (nmi_fail == TIMEOUT)
-			printk("TIMEOUT|");
+			printk(KERN_CONT "TIMEOUT|");
 		else
-			printk("ERROR  |");
+			printk(KERN_CONT "ERROR  |");
 		dump_stack();
 	} else {
 		testcase_successes++;
-		printk("  ok  |");
+		printk(KERN_CONT "  ok  |");
 	}
 	testcase_total++;
 
@@ -150,10 +150,10 @@ void __init nmi_selftest(void)
 
 	print_testname("remote IPI");
 	dotest(remote_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 	print_testname("local IPI");
 	dotest(local_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	cleanup_nmi_testsuite();
 
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch
mm-fix-null-ptr-deref-when-walking-hugepages.patch
locking-add-kern_cont-when-needed-to-self-test.patch
isdn-add-missing-kern_cont.patch
isdn-add-missing-kern_cont-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch

