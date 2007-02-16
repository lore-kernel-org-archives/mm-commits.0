From: akpm@linux-foundation.org
Subject: + input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:44:56 -0800
Message-ID: <200702160044.l1G0iu1T014210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422920AbXBPApD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@debian.org, dtor@mail.ru


The patch titled
     input: psmouse: wrap protocol extensions (except synaptics) with ifdefs
has been added to the -mm tree.  Its filename is
     input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: psmouse: wrap protocol extensions (except synaptics) with ifdefs
From: Andres Salomon <dilinger@debian.org>

Allow ALPS, LOGIPS2PP, LIFEBOOK, and TRACKPOINT protocol extensions (in the
psmouse driver) to be disabled during compilation.  The synaptics stuff is
left alone for now, since it needs special handling for synaptic pass-through
ports.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/psmouse-base.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

diff -puN drivers/input/mouse/psmouse-base.c~input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs
+++ a/drivers/input/mouse/psmouse-base.c
@@ -567,6 +567,7 @@ static int psmouse_extensions(struct psm
 {
 	int synaptics_hardware = 0;
 
+#ifdef CONFIG_MOUSE_PS2_LIFEBOOK
 /*
  * We always check for lifebook because it does not disturb mouse
  * (it only checks DMI information).
@@ -577,6 +578,7 @@ static int psmouse_extensions(struct psm
 				return PSMOUSE_LIFEBOOK;
 		}
 	}
+#endif
 
 /*
  * Try Kensington ThinkingMouse (we try first, because synaptics probe
@@ -608,6 +610,7 @@ static int psmouse_extensions(struct psm
 		synaptics_reset(psmouse);
 	}
 
+#ifdef CONFIG_MOUSE_PS2_ALPS
 /*
  * Try ALPS TouchPad
  */
@@ -622,15 +625,20 @@ static int psmouse_extensions(struct psm
 			max_proto = PSMOUSE_IMEX;
 		}
 	}
+#endif
 
 	if (max_proto > PSMOUSE_IMEX && genius_detect(psmouse, set_properties) == 0)
 		return PSMOUSE_GENPS;
 
+#ifdef CONFIG_MOUSE_PS2_LOGIPS2PP
 	if (max_proto > PSMOUSE_IMEX && ps2pp_init(psmouse, set_properties) == 0)
 		return PSMOUSE_PS2PP;
+#endif
 
+#ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 	if (max_proto > PSMOUSE_IMEX && trackpoint_detect(psmouse, set_properties) == 0)
 		return PSMOUSE_TRACKPOINT;
+#endif
 
 /*
  * Reset to defaults in case the device got confused by extended
@@ -672,12 +680,14 @@ static const struct psmouse_protocol psm
 		.maxproto	= 1,
 		.detect		= ps2bare_detect,
 	},
+#ifdef CONFIG_MOUSE_PS2_LOGIPS2PP
 	{
 		.type		= PSMOUSE_PS2PP,
 		.name		= "PS2++",
 		.alias		= "logitech",
 		.detect		= ps2pp_init,
 	},
+#endif
 	{
 		.type		= PSMOUSE_THINKPS,
 		.name		= "ThinkPS/2",
@@ -711,6 +721,7 @@ static const struct psmouse_protocol psm
 		.detect		= synaptics_detect,
 		.init		= synaptics_init,
 	},
+#ifdef CONFIG_MOUSE_PS2_ALPS
 	{
 		.type		= PSMOUSE_ALPS,
 		.name		= "AlpsPS/2",
@@ -718,18 +729,23 @@ static const struct psmouse_protocol psm
 		.detect		= alps_detect,
 		.init		= alps_init,
 	},
+#endif
+#ifdef CONFIG_MOUSE_PS2_LIFEBOOK
 	{
 		.type		= PSMOUSE_LIFEBOOK,
 		.name		= "LBPS/2",
 		.alias		= "lifebook",
 		.init		= lifebook_init,
 	},
+#endif
+#ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 	{
 		.type		= PSMOUSE_TRACKPOINT,
 		.name		= "TPPS/2",
 		.alias		= "trackpoint",
 		.detect		= trackpoint_detect,
 	},
+#endif
 	{
 		.type		= PSMOUSE_AUTO,
 		.name		= "auto",
_

Patches currently in -mm which might be from dilinger@debian.org are

input-psmouse-create-ps-2-protocol-options-for-kconfig.patch
input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs.patch
input-psmouse-allow-disabling-of-synaptics-protocol-extension.patch
