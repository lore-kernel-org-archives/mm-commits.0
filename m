From: akpm@linux-foundation.org
Subject: + setstream-param-for-psmouse.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:27:47 -0800
Message-ID: <200702070027.l170Rlw0001811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56543 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030374AbXBGA2B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:28:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea@suse.de, dtor@mail.ru, vojtech@suse.cz


The patch titled
     setstream param for psmouse
has been added to the -mm tree.  Its filename is
     setstream-param-for-psmouse.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: setstream param for psmouse
From: Andrea Arcangeli <andrea@suse.de>

I have an infrared keyboard that doesn't work well with Linux.  After a bit
of reverse engineering I figured out the command that makes the ps2 mouse
hang is the setstream.  This is certainly a bug in the mouse and not in
linux, but I wonder that if Windows works out of the box, perhaps it's not
sending setstream?

Anyway this patch should be a safe approach.  It would be nice if you could
merge this, so I won't have to forever patch my htpc kernel with it in
order to use the mouse integrated in the keyboard ;).

Signed-off-by: Andrea Arcangeli <andrea@suse.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/psmouse-base.c |   17 +++++++++++++++--
 drivers/input/mouse/psmouse.h      |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse
+++ a/drivers/input/mouse/psmouse-base.c
@@ -64,6 +64,14 @@ static unsigned int psmouse_resync_time;
 module_param_named(resync_time, psmouse_resync_time, uint, 0644);
 MODULE_PARM_DESC(resync_time, "How long can mouse stay idle before forcing resync (in seconds, 0 = never).");
 
+/*
+ * The setstream parameter is needed if you have an ACK 580 that stops
+ * streaming if you ever enable the streaming mode explicitly.
+ */
+static unsigned int psmouse_setstream = 1;
+module_param_named(setstream, psmouse_setstream, uint, 0644);
+MODULE_PARM_DESC(setstream, "Turn on streaming mode explicitly, 1 = enabled (default), 0 = disabled.");
+
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
 			NULL,
 			psmouse_attr_show_protocol, psmouse_attr_set_protocol);
@@ -79,6 +87,9 @@ PSMOUSE_DEFINE_ATTR(resetafter, S_IWUSR 
 PSMOUSE_DEFINE_ATTR(resync_time, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, resync_time),
 			psmouse_show_int_attr, psmouse_set_int_attr);
+PSMOUSE_DEFINE_ATTR(setstream, S_IWUSR | S_IRUGO,
+			(void *) offsetof(struct psmouse, setstream),
+			psmouse_show_int_attr, psmouse_set_int_attr);
 
 static struct attribute *psmouse_attributes[] = {
 	&psmouse_attr_protocol.dattr.attr,
@@ -86,6 +97,7 @@ static struct attribute *psmouse_attribu
 	&psmouse_attr_resolution.dattr.attr,
 	&psmouse_attr_resetafter.dattr.attr,
 	&psmouse_attr_resync_time.dattr.attr,
+	&psmouse_attr_setstream.dattr.attr,
 	NULL
 };
 
@@ -831,8 +843,8 @@ static void psmouse_initialize(struct ps
 /*
  * We set the mouse into streaming mode.
  */
-
-	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
+	if (psmouse->setstream)
+		ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
 
 /*
  * We set the mouse report rate, resolution and scaling.
@@ -1144,6 +1156,7 @@ static int psmouse_connect(struct serio 
 	psmouse->resetafter = psmouse_resetafter;
 	psmouse->resync_time = parent ? 0 : psmouse_resync_time;
 	psmouse->smartscroll = psmouse_smartscroll;
+	psmouse->setstream = psmouse_setstream;
 
 	psmouse_switch_protocol(psmouse, NULL);
 
diff -puN drivers/input/mouse/psmouse.h~setstream-param-for-psmouse drivers/input/mouse/psmouse.h
--- a/drivers/input/mouse/psmouse.h~setstream-param-for-psmouse
+++ a/drivers/input/mouse/psmouse.h
@@ -61,6 +61,7 @@ struct psmouse {
 	unsigned int resetafter;
 	unsigned int resync_time;
 	unsigned int smartscroll;	/* Logitech only */
+	unsigned int setstream;
 
 	psmouse_ret_t (*protocol_handler)(struct psmouse *psmouse);
 	void (*set_rate)(struct psmouse *psmouse, unsigned int rate);
_

Patches currently in -mm which might be from andrea@suse.de are

setstream-param-for-psmouse.patch
