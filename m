From: akpm@osdl.org
Subject: - make-fn_keys-work-again-on-power-macbooks.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:11 -0800
Message-ID: <200701020724.l027OBPI012927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777AbXABHYc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@nn7.de, benh@kernel.crashing.org, dtor@mail.ru, greg@kroah.com, jkosina@suse.cz, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     make fn_keys work again on power/macbooks
has been removed from the -mm tree.  Its filename was
     make-fn_keys-work-again-on-power-macbooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make fn_keys work again on power/macbooks
From: Soeren Sonnenburg <kernel@nn7.de>

The apple fn keys don't work anymore with 2.6.20-rc1.

The reason is that USB_HID_POWERBOOK appears in several files although
USB_HIDINPUT_POWERBOOK is the thing to be used.

The patch fixes this.

Cc: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/defconfig       |    2 +-
 arch/sparc64/defconfig    |    2 +-
 arch/x86_64/defconfig     |    2 +-
 drivers/usb/input/Kconfig |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/defconfig~make-fn_keys-work-again-on-power-macbooks arch/i386/defconfig
--- a/arch/i386/defconfig~make-fn_keys-work-again-on-power-macbooks
+++ a/arch/i386/defconfig
@@ -1167,7 +1167,7 @@ CONFIG_USB_STORAGE=y
 # USB Input Devices
 #
 CONFIG_USB_HID=y
-# CONFIG_USB_HID_POWERBOOK is not set
+# CONFIG_USB_HIDINPUT_POWERBOOK is not set
 # CONFIG_HID_FF is not set
 # CONFIG_USB_HIDDEV is not set
 # CONFIG_USB_AIPTEK is not set
diff -puN arch/sparc64/defconfig~make-fn_keys-work-again-on-power-macbooks arch/sparc64/defconfig
--- a/arch/sparc64/defconfig~make-fn_keys-work-again-on-power-macbooks
+++ a/arch/sparc64/defconfig
@@ -1103,7 +1103,7 @@ CONFIG_USB_UHCI_HCD=m
 # USB Input Devices
 #
 CONFIG_USB_HID=y
-# CONFIG_USB_HID_POWERBOOK is not set
+# CONFIG_USB_HIDINPUT_POWERBOOK is not set
 # CONFIG_HID_FF is not set
 CONFIG_USB_HIDDEV=y
 # CONFIG_USB_AIPTEK is not set
diff -puN arch/x86_64/defconfig~make-fn_keys-work-again-on-power-macbooks arch/x86_64/defconfig
--- a/arch/x86_64/defconfig~make-fn_keys-work-again-on-power-macbooks
+++ a/arch/x86_64/defconfig
@@ -1191,7 +1191,7 @@ CONFIG_USB_STORAGE=y
 # USB Input Devices
 #
 CONFIG_USB_HID=y
-# CONFIG_USB_HID_POWERBOOK is not set
+# CONFIG_USB_HIDINPUT_POWERBOOK is not set
 # CONFIG_HID_FF is not set
 # CONFIG_USB_HIDDEV is not set
 # CONFIG_USB_AIPTEK is not set
diff -puN drivers/usb/input/Kconfig~make-fn_keys-work-again-on-power-macbooks drivers/usb/input/Kconfig
--- a/drivers/usb/input/Kconfig~make-fn_keys-work-again-on-power-macbooks
+++ a/drivers/usb/input/Kconfig
@@ -29,7 +29,7 @@ config USB_HID
 comment "Input core support is needed for USB HID input layer or HIDBP support"
 	depends on USB_HID && INPUT=n
 
-config USB_HID_POWERBOOK
+config USB_HIDINPUT_POWERBOOK
 	bool "Enable support for iBook/PowerBook special keys"
 	default n
 	depends on USB_HID
_

Patches currently in -mm which might be from kernel@nn7.de are
