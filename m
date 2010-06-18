From: akpm@linux-foundation.org
Subject: + intel_agp-dont-oops-with-zero-stolen-memory.patch added to -mm tree
Date: Fri, 18 Jun 2010 14:59:23 -0700
Message-ID: <201006182159.o5ILxNut025694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab0FRV7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 17:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, airlied@linux.ie, daniel.vetter@ffwll.ch, eric@anholt.net


The patch titled
     intel_agp: don't oops with zero stolen memory
has been added to the -mm tree.  Its filename is
     intel_agp-dont-oops-with-zero-stolen-memory.patch

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
Subject: intel_agp: don't oops with zero stolen memory
From: Ondrej Zary <linux@rainbow-software.org>

When "onboard video memory" is set do "disabled" in BIOS on Asus P4P800-VM
board (i865G), kernel oopses with memory corruption:
https://bugs.freedesktop.org/show_bug.cgi?id=28430

Fix that by cleanly aborting the initialization.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-gtt.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/char/agp/intel-gtt.c~intel_agp-dont-oops-with-zero-stolen-memory drivers/char/agp/intel-gtt.c
--- a/drivers/char/agp/intel-gtt.c~intel_agp-dont-oops-with-zero-stolen-memory
+++ a/drivers/char/agp/intel-gtt.c
@@ -797,6 +797,10 @@ static int intel_i830_create_gatt_table(
 
 	/* we have to call this as early as possible after the MMIO base address is known */
 	intel_i830_init_gtt_entries();
+	if (intel_private.gtt_entries == 0) {
+		iounmap(intel_private.registers);
+		return -ENOMEM;
+	}
 
 	agp_bridge->gatt_table = NULL;
 
@@ -1279,6 +1283,11 @@ static int intel_i915_create_gatt_table(
 
 	/* we have to call this as early as possible after the MMIO base address is known */
 	intel_i830_init_gtt_entries();
+	if (intel_private.gtt_entries == 0) {
+		iounmap(intel_private.gtt);
+		iounmap(intel_private.registers);
+		return -ENOMEM;
+	}
 
 	agp_bridge->gatt_table = NULL;
 
@@ -1387,6 +1396,11 @@ static int intel_i965_create_gatt_table(
 
 	/* we have to call this as early as possible after the MMIO base address is known */
 	intel_i830_init_gtt_entries();
+	if (intel_private.gtt_entries == 0) {
+		iounmap(intel_private.gtt);
+		iounmap(intel_private.registers);
+		return -ENOMEM;
+	}
 
 	agp_bridge->gatt_table = NULL;
 
_

Patches currently in -mm which might be from linux@rainbow-software.org are

linux-next.patch
drm-radeon-kms-fix-hibernation-regression-related-to-radeon-pm.patch
intel_agp-dont-oops-with-zero-stolen-memory.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch

