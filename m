From: akpm@linux-foundation.org
Subject: - setstream-param-for-psmouse.patch removed from -mm tree
Date: Thu, 26 Apr 2007 13:53:05 -0700
Message-ID: <200704262053.l3QKr5jA011248@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064AbXDZUxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 16:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@suse.de, dtor@mail.ru, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     setstream param for psmouse
has been removed from the -mm tree.  Its filename was
     setstream-param-for-psmouse.patch

This patch was dropped because it is obsolete

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

 drivers/input/mouse/psmouse-base.c |   16 +++++++++++++++-
 drivers/input/mouse/psmouse.h      |    1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse
+++ a/drivers/input/mouse/psmouse-base.c
@@ -65,6 +65,14 @@ static unsigned int psmouse_resync_time;
 module_param_named(resync_time, psmouse_resync_time, uint, 0644);
 MODULE_PARM_DESC(resync_time, "How long can mouse stay idle before forcing resync (in seconds, 0 = never).");
 
+/*
+ * The setstream parameter is needed if you have an ACK 580 that stops
+ * streaming if you ever enable the streaming mode explicitly.
+ */
+static unsigned int psmouse_setstream;
+module_param_named(setstream, psmouse_setstream, uint, 0644);
+MODULE_PARM_DESC(setstream, "Turn on streaming mode explicitly, 1 = enabled, 0 = disabled (default).");
+
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
 			NULL,
 			psmouse_attr_show_protocol, psmouse_attr_set_protocol);
@@ -80,6 +88,9 @@ PSMOUSE_DEFINE_ATTR(resetafter, S_IWUSR 
 PSMOUSE_DEFINE_ATTR(resync_time, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, resync_time),
 			psmouse_show_int_attr, psmouse_set_int_attr);
+PSMOUSE_DEFINE_ATTR(setstream, S_IWUSR | S_IRUGO,
+			(void *) offsetof(struct psmouse, setstream),
+			psmouse_show_int_attr, psmouse_set_int_attr);
 
 static struct attribute *psmouse_attributes[] = {
 	&psmouse_attr_protocol.dattr.attr,
@@ -87,6 +98,7 @@ static struct attribute *psmouse_attribu
 	&psmouse_attr_resolution.dattr.attr,
 	&psmouse_attr_resetafter.dattr.attr,
 	&psmouse_attr_resync_time.dattr.attr,
+	&psmouse_attr_setstream.dattr.attr,
 	NULL
 };
 
@@ -839,7 +851,8 @@ static void psmouse_set_rate(struct psmo
 
 	while (rates[i] > rate) i++;
 	r = rates[i];
-	ps2_command(&psmouse->ps2dev, &r, PSMOUSE_CMD_SETRATE);
+	if (psmouse->setstream)
+		ps2_command(&psmouse->ps2dev, &r, PSMOUSE_CMD_SETRATE);
 	psmouse->rate = r;
 }
 
@@ -1186,6 +1199,7 @@ static int psmouse_connect(struct serio 
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

git-alsa.patch
setstream-param-for-psmouse.patch
