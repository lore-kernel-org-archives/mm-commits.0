From: akpm@linux-foundation.org
Subject: + printk-flush-conflicting-continuation-line.patch added to -mm
 tree
Date: Thu, 02 Jan 2014 14:57:44 -0800
Message-ID: <52c5eee8./lCtbyQmZZs7X6yh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABW5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 17:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paul.gortmaker@windriver.com, joe@perches.com, getarunks@gmail.com, fweisbec@gmail.com, arun.ks@broadcom.com, arunks.linux@gmail.com

Subject: + printk-flush-conflicting-continuation-line.patch added to -mm tree
To: arunks.linux@gmail.com,arun.ks@broadcom.com,fweisbec@gmail.com,getarunks@gmail.com,joe@perches.com,paul.gortmaker@windriver.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 14:57:44 -0800


The patch titled
     Subject: printk: flush conflicting continuation line
has been added to the -mm tree.  Its filename is
     printk-flush-conflicting-continuation-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-flush-conflicting-continuation-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-flush-conflicting-continuation-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Arun KS <getarunks@gmail.com>
Signed-off-by: Arun KS <arun.ks@broadcom.com>
Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-flush-conflicting-continuation-line kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-flush-conflicting-continuation-line
+++ a/kernel/printk/printk.c
@@ -1600,7 +1600,10 @@ asmlinkage int vprintk_emit(int facility
 			if (!(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, text, text_len);
 			cont_flush(LOG_NEWLINE);
-		}
+		/* Flush conflicting buffer. An earlier newline was missing
+		* and current print is from different task */
+		} else if (cont.len && cont.owner != current)
+			cont_flush(LOG_NEWLINE);
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
_

Patches currently in -mm which might be from arunks.linux@gmail.com are

printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch

