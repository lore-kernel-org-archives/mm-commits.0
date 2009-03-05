From: akpm@linux-foundation.org
Subject: [alternative-merged] psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch removed from -mm tree
Date: Wed, 04 Mar 2009 23:18:14 -0800
Message-ID: <200903050718.n257IE1b023769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbZCEHSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 02:18:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, arjan@infradead.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     psmouse/synaptics: ensure we reset the device on resume
has been removed from the -mm tree.  Its filename was
     psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: psmouse/synaptics: ensure we reset the device on resume
From: Andy Whitcroft <apw@canonical.com>

When resuming from suspend newer Synaptics touchpads do not recover
correctly.  Analysis of the resume sequence as applied in Linux was
compared to that of other operating systems.  This indicated that the
other OSs were resetting the mouse before attempting to detect it (for
all Synaptics touchpads, old and new).  Applying this same modification
fixes these newer Synaptics touchpads and brings the driver into line
with common OS reset behaviour.

This patch adds this reset by default providing a module option to
restore the previous non-reset behaviour:

	psmouse.synaptics_resume_reset=N

Also a message is emmitted on resume hinting as to how to fix a broken
touchpad.

[akpm@linux-foundation.org: make message more informative, fix 80-cols]
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/synaptics.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/input/mouse/synaptics.c~psmouse-synaptics-ensure-we-reset-the-device-on-resume drivers/input/mouse/synaptics.c
--- a/drivers/input/mouse/synaptics.c~psmouse-synaptics-ensure-we-reset-the-device-on-resume
+++ a/drivers/input/mouse/synaptics.c
@@ -60,11 +60,23 @@ static int synaptics_mode_cmd(struct psm
 	return 0;
 }
 
+static int synaptics_resume_reset = 1;
+module_param(synaptics_resume_reset, bool, 0);
+MODULE_PARM_DESC(synaptics_resume_reset,
+				"Enable reset on resume for Synaptics");
+
 int synaptics_detect(struct psmouse *psmouse, int set_properties)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[4];
 
+	if (synaptics_resume_reset) {
+		printk(KERN_CRIT "WARNING: synaptics was reset on resume. Try "
+				"using the synaptics_resume_reset module "
+				"parameter if you have trouble on resume\n");
+		psmouse_reset(psmouse);
+	}
+
 	param[0] = 0;
 
 	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
_

Patches currently in -mm which might be from apw@canonical.com are

linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch

