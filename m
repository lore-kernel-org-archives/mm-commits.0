From: akpm@linux-foundation.org
Subject: + powernow-k8-limit-pstate-transition-latency-check.patch added to -mm tree
Date: Thu, 08 Jul 2010 14:05:39 -0700
Message-ID: <201007082105.o68L5dCA029145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab0GHVGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 17:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, Mark.Langsdorf@amd.com, davej@redhat.com, trenn@suse.de


The patch titled
     powernow-k8: limit Pstate transition latency check
has been added to the -mm tree.  Its filename is
     powernow-k8-limit-pstate-transition-latency-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powernow-k8: limit Pstate transition latency check
From: Borislav Petkov <borislav.petkov@amd.com>

The Pstate transition latency check was added for broken F10h BIOSen which
wrongly contain a value of 0 for transition and bus master latency. 
Fam11h and later, however, (will) have similar transition latency so
extend that behavior for them too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Mark Langsdorf <Mark.Langsdorf@amd.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-limit-pstate-transition-latency-check arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-limit-pstate-transition-latency-check
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1025,13 +1025,12 @@ static int get_transition_latency(struct
 	}
 	if (max_latency == 0) {
 		/*
-		 * Fam 11h always returns 0 as transition latency.
-		 * This is intended and means "very fast". While cpufreq core
-		 * and governors currently can handle that gracefully, better
-		 * set it to 1 to avoid problems in the future.
-		 * For all others it's a BIOS bug.
+		 * Fam 11h and later may return 0 as transition latency. This
+		 * is intended and means "very fast". While cpufreq core and
+		 * governors currently can handle that gracefully, better set it
+		 * to 1 to avoid problems in the future.
 		 */
-		if (boot_cpu_data.x86 != 0x11)
+		if (boot_cpu_data.x86 < 0x11)
 			printk(KERN_ERR FW_WARN PFX "Invalid zero transition "
 				"latency\n");
 		max_latency = 1;
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

linux-next.patch
powernow-k8-limit-pstate-transition-latency-check.patch

