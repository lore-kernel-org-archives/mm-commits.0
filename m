From: akpm@linux-foundation.org
Subject: + input-psmouse-allow-disabling-of-synaptics-protocol-extension.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:44:58 -0800
Message-ID: <200702160044.l1G0iwet014213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422949AbXBPApE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:45:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@debian.org, dtor@mail.ru


The patch titled
     input: psmouse: allow disabling of synaptics protocol extension
has been added to the -mm tree.  Its filename is
     input-psmouse-allow-disabling-of-synaptics-protocol-extension.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: psmouse: allow disabling of synaptics protocol extension
From: Andres Salomon <dilinger@debian.org>

Allow disabling of synaptics via CONFIG_MOUSE_PS2_SYNAPTICS; we leave
synaptic_detect and synaptic_reset (for synaptics hardware that emulates other
protocols), but get rid of synaptic_init.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/psmouse-base.c |    5 +++
 drivers/input/mouse/synaptics.c    |   34 +++++++++++++++++----------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff -puN drivers/input/mouse/psmouse-base.c~input-psmouse-allow-disabling-of-synaptics-protocol-extension drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~input-psmouse-allow-disabling-of-synaptics-protocol-extension
+++ a/drivers/input/mouse/psmouse-base.c
@@ -595,8 +595,11 @@ static int psmouse_extensions(struct psm
 		synaptics_hardware = 1;
 
 		if (max_proto > PSMOUSE_IMEX) {
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
 			if (!set_properties || synaptics_init(psmouse) == 0)
 				return PSMOUSE_SYNAPTICS;
+#endif
+
 /*
  * Some Synaptics touchpads can emulate extended protocols (like IMPS/2).
  * Unfortunately Logitech/Genius probes confuse some firmware versions so
@@ -714,6 +717,7 @@ static const struct psmouse_protocol psm
 		.maxproto	= 1,
 		.detect		= im_explorer_detect,
 	},
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
 	{
 		.type		= PSMOUSE_SYNAPTICS,
 		.name		= "SynPS/2",
@@ -721,6 +725,7 @@ static const struct psmouse_protocol psm
 		.detect		= synaptics_detect,
 		.init		= synaptics_init,
 	},
+#endif
 #ifdef CONFIG_MOUSE_PS2_ALPS
 	{
 		.type		= PSMOUSE_ALPS,
diff -puN drivers/input/mouse/synaptics.c~input-psmouse-allow-disabling-of-synaptics-protocol-extension drivers/input/mouse/synaptics.c
--- a/drivers/input/mouse/synaptics.c~input-psmouse-allow-disabling-of-synaptics-protocol-extension
+++ a/drivers/input/mouse/synaptics.c
@@ -45,28 +45,30 @@
  ****************************************************************************/
 
 /*
- * Send a command to the synpatics touchpad by special commands
+ * Set the synaptics touchpad mode byte by special commands
  */
-static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
+static int synaptics_mode_cmd(struct psmouse *psmouse, unsigned char mode)
 {
-	if (psmouse_sliced_command(psmouse, c))
+	unsigned char param[1];
+
+	if (psmouse_sliced_command(psmouse, mode))
 		return -1;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
+	param[0] = SYN_PS_SET_MODE2;
+	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_SETRATE))
 		return -1;
 	return 0;
 }
 
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
 /*
- * Set the synaptics touchpad mode byte by special commands
+ * Send a command to the synpatics touchpad by special commands
  */
-static int synaptics_mode_cmd(struct psmouse *psmouse, unsigned char mode)
+static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
 {
-	unsigned char param[1];
-
-	if (psmouse_sliced_command(psmouse, mode))
+	if (psmouse_sliced_command(psmouse, c))
 		return -1;
-	param[0] = SYN_PS_SET_MODE2;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_SETRATE))
+	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
 		return -1;
 	return 0;
 }
@@ -529,12 +531,16 @@ static void set_input_params(struct inpu
 	clear_bit(REL_Y, dev->relbit);
 }
 
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
+
 void synaptics_reset(struct psmouse *psmouse)
 {
 	/* reset touchpad back to relative mode, gestures enabled */
 	synaptics_mode_cmd(psmouse, 0);
 }
 
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
 static void synaptics_disconnect(struct psmouse *psmouse)
 {
 	synaptics_reset(psmouse);
@@ -569,6 +575,8 @@ static int synaptics_reconnect(struct ps
 	return 0;
 }
 
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
+
 int synaptics_detect(struct psmouse *psmouse, int set_properties)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
@@ -593,6 +601,8 @@ int synaptics_detect(struct psmouse *psm
 	return 0;
 }
 
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
 #if defined(__i386__)
 #include <linux/dmi.h>
 static struct dmi_system_id toshiba_dmi_table[] = {
@@ -679,4 +689,4 @@ int synaptics_init(struct psmouse *psmou
 	return -1;
 }
 
-
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
_

Patches currently in -mm which might be from dilinger@debian.org are

input-psmouse-create-ps-2-protocol-options-for-kconfig.patch
input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs.patch
input-psmouse-allow-disabling-of-synaptics-protocol-extension.patch
