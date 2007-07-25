From: akpm@linux-foundation.org
Subject: + report-the-per-irq-statistics-on-allarches.patch added to -mm tree
Date: Tue, 24 Jul 2007 17:03:31 -0700
Message-ID: <200707250003.l6P03Vr2007789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758905AbXGYAED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 20:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, ak@suse.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, paulus@samba.org, rth@twiddle.net, tony.luck@intel.com, torvalds@linux-foundation.org


The patch titled
     report the per-irq statistics on all arches
has been added to the -mm tree.  Its filename is
     report-the-per-irq-statistics-on-allarches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: report the per-irq statistics on all arches
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Commit 4004c69ad68dd03733179277280ea2946990ba36 avoids too many remote cpu
references while reporting per-irq stats.  Since we will not have the same
performance penalty of bringing in remote cpu cachelines while reporting
per-irq stats anymore, we can now afford to be consistent and report this
statistic on all arches, all configs.

akpm: affects ia64, alpha and ppc64, mainly.

Kiran earlier said:

Read to /proc/stat takes:
Plain: 	2.622832
With speedup patch: 0.013194
With the per-irq stats commented out: 0.008124

So the performance problems which originally caused those architectures to
disable this statistic should now be fixed up.


Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/proc/proc_misc.c~report-the-per-irq-statistics-on-allarches fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~report-the-per-irq-statistics-on-allarches
+++ a/fs/proc/proc_misc.c
@@ -522,11 +522,8 @@ static int show_stat(struct seq_file *p,
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-#ifndef CONFIG_SMP
-	/* Touches too many cache lines on SMP setups */
 	for (i = 0; i < NR_IRQS; i++)
 		seq_printf(p, " %u", per_irq_sum[i]);
-#endif
 
 	seq_printf(p,
 		"\nctxt %llu\n"
_

Patches currently in -mm which might be from kiran@scalex86.org are

softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
report-the-per-irq-statistics-on-allarches.patch
slab-leaks3-default-y.patch
