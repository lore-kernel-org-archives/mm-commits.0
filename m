From: akpm@linux-foundation.org
Subject: [merged] printk-flush-conflicting-continuation-line.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:59 -0800
Message-ID: <52e2b86b.DSrkDYSQitd2tU3k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paul.gortmaker@windriver.com, kay@vrfy.org, joe@perches.com, getarunks@gmail.com, fweisbec@gmail.com, arun.ks@broadcom.com, arunks.linux@gmail.com

Subject: [merged] printk-flush-conflicting-continuation-line.patch removed from -mm tree
To: arunks.linux@gmail.com,arun.ks@broadcom.com,fweisbec@gmail.com,getarunks@gmail.com,joe@perches.com,kay@vrfy.org,paul.gortmaker@windriver.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:59 -0800


The patch titled
     Subject: printk: flush conflicting continuation line
has been removed from the -mm tree.  Its filename was
     printk-flush-conflicting-continuation-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arun KS <arunks.linux@gmail.com>
Subject: printk: flush conflicting continuation line

An earlier newline was missing and current print is from different task. 
In this scenario flush the continuation line and store this line
seperatly.

This patch fix the below scenario of timestamp interleaving,
<6>[   28.154370 ] read_word_reg : reg[0x 3], reg[0x 4]  data [0x 642]
<6>[   28.155428 ] uart disconnect
<6>[   31.947341 ] dvfs[cpufreq.c<275>]:plug-in cpu<1> done
<4>[   28.155445 ] UART detached : send switch state 201
<6>[   32.014112 ] read_reg : reg[0x 3] data[0x21]

[akpm@linux-foundation.org: simplify and condense the code]
Signed-off-by: Arun KS <getarunks@gmail.com>
Signed-off-by: Arun KS <arun.ks@broadcom.com>
Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~printk-flush-conflicting-continuation-line kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-flush-conflicting-continuation-line
+++ a/kernel/printk/printk.c
@@ -1595,10 +1595,13 @@ asmlinkage int vprintk_emit(int facility
 		 * either merge it with the current buffer and flush, or if
 		 * there was a race with interrupts (prefix == true) then just
 		 * flush it out and store this line separately.
+		 * If the preceding printk was from a different task and missed
+		 * a newline, flush and append the newline.
 		 */
-		if (cont.len && cont.owner == current) {
-			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
+		if (cont.len) {
+			if (cont.owner == current && !(lflags & LOG_PREFIX))
+				stored = cont_add(facility, level, text,
+						  text_len);
 			cont_flush(LOG_NEWLINE);
 		}
 
_

Patches currently in -mm which might be from arunks.linux@gmail.com are

origin.patch

