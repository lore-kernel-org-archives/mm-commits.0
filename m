From: akpm@linux-foundation.org
Subject: + lib-taint-kernel-in-common-report_bug-warn-path.patch added to -mm tree
Date: Mon, 19 May 2008 14:34:51 -0700
Message-ID: <200805192134.m4JLYpPD021630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340AbYESVfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:35:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, hskinnemoen@atmel.com, kyle@mcmartin.ca


The patch titled
     lib: taint kernel in common report_bug() WARN path.
has been added to the -mm tree.  Its filename is
     lib-taint-kernel-in-common-report_bug-warn-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: taint kernel in common report_bug() WARN path.
From: Paul Mundt <lethal@linux-sh.org>

Commit 95b570c9cef3b12356454c7112571b7e406b4b51 introduced a TAINT_WARN
that was implemented for all architectures using the generic
warn_on_slowpath(), which excluded any architecture that set
HAVE_ARCH_WARN_ON.

As all of the architectures that implement their own WARN_ON() all go
through the report_bug() path (specifically handling BUG_TRAP_TYPE_WARN),
taint the kernel there as well for consistency.

Tested on avr32 and sh. Also relevant for s390, parisc, and powerpc.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/bug.c~lib-taint-kernel-in-common-report_bug-warn-path lib/bug.c
--- a/lib/bug.c~lib-taint-kernel-in-common-report_bug-warn-path
+++ a/lib/bug.c
@@ -37,6 +37,7 @@
  */
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/sched.h>
 
@@ -149,6 +150,7 @@ enum bug_trap_type report_bug(unsigned l
 			       (void *)bugaddr);
 
 		show_regs(regs);
+		add_taint(TAINT_WARN);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

linux-next.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
git-block.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
lib-taint-kernel-in-common-report_bug-warn-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
sh-use-the-common-ascii-hex-helpers.patch

