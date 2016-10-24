From: akpm@linux-foundation.org
Subject: + debug-more-properly-delay-for-secondary-cpus-fix.patch added to -mm tree
Date: Mon, 24 Oct 2016 13:03:35 -0700
Message-ID: <580e6917.X5Vv11arPcNnDJwu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933409AbcJXUDg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 16:03:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, briannorris@chromium.org, daniel.thompson@linaro.org, dianders@chromium.org, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: debug-more-properly-delay-for-secondary-cpus-fix
has been added to the -mm tree.  Its filename is
     debug-more-properly-delay-for-secondary-cpus-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debug-more-properly-delay-for-secondary-cpus-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debug-more-properly-delay-for-secondary-cpus-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debug-more-properly-delay-for-secondary-cpus-fix

simplifications, per Daniel

Cc: Brian Norris <briannorris@chromium.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus-fix kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus-fix
+++ a/kernel/debug/debug_core.c
@@ -61,8 +61,6 @@
 
 #include "debug_core.h"
 
-#define WAIT_CPUS_STOP_MS	1000
-
 static int kgdb_break_asap;
 
 struct debuggerinfo_struct kgdb_info[NR_CPUS];
@@ -600,7 +598,7 @@ return_normal:
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
-	time_left = WAIT_CPUS_STOP_MS;
+	time_left = MSEC_PER_SEC;
 	while (kgdb_do_roundup && --time_left &&
 	       (atomic_read(&masters_in_kgdb) + atomic_read(&slaves_in_kgdb)) !=
 		   online_cpus)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

