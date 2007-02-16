From: akpm@linux-foundation.org
Subject: - input-psmouse-create-ps-2-protocol-options-for-kconfig.patch removed from -mm tree
Date: Thu, 15 Feb 2007 23:52:00 -0800
Message-ID: <200702160752.l1G7q0RT023739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966169AbXBPHwK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:52:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: psmouse: create PS/2 protocol options for Kconfig
has been removed from the -mm tree.  Its filename was
     input-psmouse-create-ps-2-protocol-options-for-kconfig.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: input: psmouse: create PS/2 protocol options for Kconfig
From: Andres Salomon <dilinger@debian.org>

Initial framework for disabling PS/2 protocol extensions.  The current
protocols can only be disabled if CONFIG_EMBEDDED is selected.  No source
files are changed, merely build stuff.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/Kconfig  |   50 +++++++++++++++++++++++++++++++++
 drivers/input/mouse/Makefile |    7 +++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff -puN drivers/input/mouse/Kconfig~input-psmouse-create-ps-2-protocol-options-for-kconfig drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig~input-psmouse-create-ps-2-protocol-options-for-kconfig
+++ a/drivers/input/mouse/Kconfig
@@ -37,6 +37,56 @@ config MOUSE_PS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called psmouse.
 
+config MOUSE_PS2_ALPS
+	bool "ALPS PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an ALPS PS/2 touchpad connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_LOGIPS2PP
+	bool "Logictech PS/2++ mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Logictech PS/2++ mouse connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_SYNAPTICS
+	bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Synaptics PS/2 TouchPad connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_LIFEBOOK
+	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Fujitsu B-series Lifebook PS/2
+	  TouchScreen connected to your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_TRACKPOINT
+	bool "IBM Trackpoint PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an IBM Trackpoint PS/2 mouse connected
+	  to your system.
+
+	  If unsure, say Y.
+
 config MOUSE_SERIAL
 	tristate "Serial mouse"
 	select SERIO
diff -puN drivers/input/mouse/Makefile~input-psmouse-create-ps-2-protocol-options-for-kconfig drivers/input/mouse/Makefile
--- a/drivers/input/mouse/Makefile~input-psmouse-create-ps-2-protocol-options-for-kconfig
+++ a/drivers/input/mouse/Makefile
@@ -14,4 +14,9 @@ obj-$(CONFIG_MOUSE_SERIAL)	+= sermouse.o
 obj-$(CONFIG_MOUSE_HIL)		+= hil_ptr.o
 obj-$(CONFIG_MOUSE_VSXXXAA)	+= vsxxxaa.o
 
-psmouse-objs  := psmouse-base.o alps.o logips2pp.o synaptics.o lifebook.o trackpoint.o
+psmouse-objs := psmouse-base.o synaptics.o
+
+psmouse-$(CONFIG_MOUSE_PS2_ALPS)       += alps.o
+psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)  += logips2pp.o
+psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)   += lifebook.o
+psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT) += trackpoint.o
_

Patches currently in -mm which might be from dilinger@debian.org are

input-psmouse-create-ps-2-protocol-options-for-kconfig.patch
input-psmouse-wrap-protocol-extensions-except-synaptics-with-ifdefs.patch
input-psmouse-allow-disabling-of-synaptics-protocol-extension.patch
