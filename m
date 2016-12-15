From: akpm@linux-foundation.org
Subject: [merged] debug-more-properly-delay-for-secondary-cpus.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:46:19 -0800
Message-ID: <5852e4fb.lvB0MQqTUSsWuJ39%akpm__7563.27389176494$1481827676$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbcLOSqv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dianders@chromium.org, briannorris@chromium.org, daniel.thompson@linaro.org, jason.wessel@windriver.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/debug/debug_core.c: more properly delay for secondary CPUs
has been removed from the -mm tree.  Its filename was
     debug-more-properly-delay-for-secondary-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: kernel/debug/debug_core.c: more properly delay for secondary CPUs

We've got a delay loop waiting for secondary CPUs.  That loop uses
loops_per_jiffy.  However, loops_per_jiffy doesn't actually mean how many
tight loops make up a jiffy on all architectures.  It is quite common to
see things like this in the boot log:

  Calibrating delay loop (skipped), value calculated using timer
  frequency.. 48.00 BogoMIPS (lpj=24000)

In my case I was seeing lots of cases where other CPUs timed out entering
the debugger only to print their stack crawls shortly after the kdb>
prompt was written.

Elsewhere in kgdb we already use udelay(), so that should be safe enough
to use to implement our timeout.  We'll delay 1 ms for 1000 times, which
should give us a full second of delay (just like the old code wanted) but
allow us to notice that we're done every 1 ms.

[akpm@linux-foundation.org: simplifications, per Daniel]
Link: http://lkml.kernel.org/r/1477091361-2039-1-git-send-email-dianders@chromium.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus
+++ a/kernel/debug/debug_core.c
@@ -598,11 +598,11 @@ return_normal:
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
-	time_left = loops_per_jiffy * HZ;
+	time_left = MSEC_PER_SEC;
 	while (kgdb_do_roundup && --time_left &&
 	       (atomic_read(&masters_in_kgdb) + atomic_read(&slaves_in_kgdb)) !=
 		   online_cpus)
-		cpu_relax();
+		udelay(1000);
 	if (!time_left)
 		pr_crit("Timed out waiting for secondary CPUs.\n");
 
_

Patches currently in -mm which might be from dianders@chromium.org are


