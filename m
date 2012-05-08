From: akpm@linux-foundation.org
Subject: + x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch added to -mm tree
Date: Tue, 08 May 2012 14:57:21 -0700
Message-ID: <20120508215721.677F9A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47269 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab2EHV5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 17:57:23 -0400
Received: by werf13 with SMTP id f13so36746wer.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 14:57:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86, NMI: add missing KERN_CONT to NMI selftest
has been added to the -mm tree.  Its filename is
     x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: x86, NMI: add missing KERN_CONT to NMI selftest

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-division-by-0-in-percpu_pagelist_fraction.patch
brlocks-lglocks-cleanups.patch
mm-add-missing-kern_cont-to-free_area_init_nodes.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch

