From: akpm@linux-foundation.org
Subject: [obsolete] intelfb-fix-color-map-setting-with-an-lvds-display.patch removed from -mm tree
Date: Thu, 18 Jun 2009 12:21:56 -0700
Message-ID: <200906181942.n5IJg5dk028854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbZFRTmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 15:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, samanddeanus@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     intelfb: fix color map setting with an LVDS display
has been removed from the -mm tree.  Its filename was
     intelfb-fix-color-map-setting-with-an-lvds-display.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intelfb: fix color map setting with an LVDS display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13285

The intelfb driver sets color map depending on currently active pipe. 
However, if an LVDS display is attached (like in laptop) the active pipe
variable is never set.  The default value is PIPE_A and can be wrong.  Set
up the pipe variable during driver initialization after hardware state was
read.

I also found by experiment that if both pipes were enabled, the PIPE_B is
used (active).

The problem is visible in the 8 bpp mode if colors above 15 are used.  The
first 16 color entries are displayed correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Reported-by: Dean Menezes <samanddeanus@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbdrv.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/video/intelfb/intelfbdrv.c~intelfb-fix-color-map-setting-with-an-lvds-display drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~intelfb-fix-color-map-setting-with-an-lvds-display
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -871,6 +871,12 @@ static int __devinit intelfb_pci_registe
 
 	intelfbhw_print_hw_state(dinfo, &dinfo->save_state);
 
+	/* Check whether pipe A or pipe B is enabled. */
+	if (dinfo->save_state.pipe_a_conf & PIPECONF_ENABLE)
+		dinfo->pipe = PIPE_A;
+	if (dinfo->save_state.pipe_b_conf & PIPECONF_ENABLE)
+		dinfo->pipe = PIPE_B;
+
 	if (bailearly == 18)
 		bailout(dinfo);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

