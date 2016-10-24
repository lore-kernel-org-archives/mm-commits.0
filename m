From: akpm@linux-foundation.org
Subject: + debug-more-properly-delay-for-secondary-cpus.patch added to -mm tree
Date: Mon, 24 Oct 2016 13:02:41 -0700
Message-ID: <580e68e1.+tlf4HqAfEioxyNJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56933 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933409AbcJXUCm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 16:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dianders@chromium.org, briannorris@chromium.org, daniel.thompson@linaro.org, jason.wessel@windriver.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/debug/debug_core.c: more properly delay for secondary CPUs
has been added to the -mm tree.  Its filename is
     debug-more-properly-delay-for-secondary-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debug-more-properly-delay-for-secondary-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debug-more-properly-delay-for-secondary-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/1477091361-2039-1-git-send-email-dianders@chromium.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus
+++ a/kernel/debug/debug_core.c
@@ -61,6 +61,8 @@
 
 #include "debug_core.h"
 
+#define WAIT_CPUS_STOP_MS	1000
+
 static int kgdb_break_asap;
 
 struct debuggerinfo_struct kgdb_info[NR_CPUS];
@@ -598,11 +600,11 @@ return_normal:
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
-	time_left = loops_per_jiffy * HZ;
+	time_left = WAIT_CPUS_STOP_MS;
 	while (kgdb_do_roundup && --time_left &&
 	       (atomic_read(&masters_in_kgdb) + atomic_read(&slaves_in_kgdb)) !=
 		   online_cpus)
-		cpu_relax();
+		udelay(1000);
 	if (!time_left)
 		pr_crit("Timed out waiting for secondary CPUs.\n");
 
_

Patches currently in -mm which might be from dianders@chromium.org are

debug-more-properly-delay-for-secondary-cpus.patch

