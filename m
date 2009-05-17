From: akpm@linux-foundation.org
Subject: [merged] sysrq-intel_fb-fix-sysrq-g-collision.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:12 -0700
Message-ID: <200905171654.n4HGsCct016956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbZEQRCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 13:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysrq, intel_fb: fix sysrq g collision
has been removed from the -mm tree.  Its filename was
     sysrq-intel_fb-fix-sysrq-g-collision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq, intel_fb: fix sysrq g collision
From: Jason Wessel <jason.wessel@windriver.com>

Commit 79e539453b34e35f39299a899d263b0a1f1670bd ("i915: add mode setting
support") introduced a regression where you cannot use sysrq 'g' to enter
kgdb.  The solution is to move the intel fb sysrq over to V for video
instead of G for graphics.  The SMP VOYAGER code to register for the
sysrq-v is not anywhere to be found in the mainline kernel, so the
comments in the code were cleaned up as well.

This patch also cleans up the sysrq definitions for kgdb to make it
generic for the kernel debugger, such that the sysrq 'g' can be used in
the future to enter a gdbstub or another kernel debugger.

Signed-off-by: Jason Vessel <jason.wessel@windriver.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c            |    4 ++--
 drivers/gpu/drm/i915/intel_fb.c |    4 ++--
 kernel/kgdb.c                   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/sysrq.c~sysrq-intel_fb-fix-sysrq-g-collision drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-intel_fb-fix-sysrq-g-collision
+++ a/drivers/char/sysrq.c
@@ -406,7 +406,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_showlocks_op,		/* d */
 	&sysrq_term_op,			/* e */
 	&sysrq_moom_op,			/* f */
-	/* g: May be registered by ppc for kgdb */
+	/* g: May be registered for the kernel debugger */
 	NULL,				/* g */
 	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
@@ -431,7 +431,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
 	&sysrq_mountro_op,		/* u */
-	/* v: May be registered at init time by SMP VOYAGER */
+	/* v: May be registered for frame buffer video console restore */
 	NULL,				/* v */
 	&sysrq_showstate_blocked_op,	/* w */
 	/* x: May be registered on ppc/powerpc for xmon */
diff -puN drivers/gpu/drm/i915/intel_fb.c~sysrq-intel_fb-fix-sysrq-g-collision drivers/gpu/drm/i915/intel_fb.c
--- a/drivers/gpu/drm/i915/intel_fb.c~sysrq-intel_fb-fix-sysrq-g-collision
+++ a/drivers/gpu/drm/i915/intel_fb.c
@@ -864,7 +864,7 @@ static void intelfb_sysrq(int dummy1, st
 
 static struct sysrq_key_op sysrq_intelfb_restore_op = {
         .handler = intelfb_sysrq,
-        .help_msg = "force-fb(G)",
+        .help_msg = "force-fb(V)",
         .action_msg = "Restore framebuffer console",
 };
 
@@ -898,7 +898,7 @@ int intelfb_probe(struct drm_device *dev
 		ret = intelfb_single_fb_probe(dev);
 	}
 
-	register_sysrq_key('g', &sysrq_intelfb_restore_op);
+	register_sysrq_key('v', &sysrq_intelfb_restore_op);
 
 	return ret;
 }
diff -puN kernel/kgdb.c~sysrq-intel_fb-fix-sysrq-g-collision kernel/kgdb.c
--- a/kernel/kgdb.c~sysrq-intel_fb-fix-sysrq-g-collision
+++ a/kernel/kgdb.c
@@ -1583,8 +1583,8 @@ static void sysrq_handle_gdb(int key, st
 
 static struct sysrq_key_op sysrq_gdb_op = {
 	.handler	= sysrq_handle_gdb,
-	.help_msg	= "Gdb",
-	.action_msg	= "GDB",
+	.help_msg	= "debug(G)",
+	.action_msg	= "DEBUG",
 };
 #endif
 
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

linux-next.patch
frv-duplicate-output_buffer-of-e03.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch

