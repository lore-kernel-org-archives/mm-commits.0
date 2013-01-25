From: akpm@linux-foundation.org
Subject: [merged] olpc-fix-olpc-xo1-scic-build-errors.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:37:47 -0800
Message-ID: <20130125213747.8A80C31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:61084 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3AYVht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:37:49 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so80591vch.2
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:37:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, cjb@laptop.org, dilinger@queued.net, dsd@laptop.org, hpa@zytor.com, jon.nettleton@gmail.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: olpc: fix olpc-xo1-sci.c build errors
has been removed from the -mm tree.  Its filename was
     olpc-fix-olpc-xo1-scic-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: olpc: fix olpc-xo1-sci.c build errors

Fix build errors when CONFIG_INPUT=m.  This is not pretty, but all of the
OLPC kconfig options are bool instead of tristate.

arch/x86/built-in.o: In function `send_lid_state':
olpc-xo1-sci.c:(.text+0x1d323): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d338): undefined reference to `input_event'
arch/x86/built-in.o: In function `free_ebook_switch':
olpc-xo1-sci.c:(.text+0x1d529): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1d533): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `free_power_button':
olpc-xo1-sci.c:(.text+0x1d549): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1d553): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `send_ebook_state':
olpc-xo1-sci.c:(.text+0x1d632): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d647): undefined reference to `input_event'
arch/x86/built-in.o: In function `xo1_sci_intr':
olpc-xo1-sci.c:(.text+0x1d78e): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d7a3): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d7be): undefined reference to `input_event'
arch/x86/built-in.o:olpc-xo1-sci.c:(.text+0x1d7d3): more undefined references to `input_event' follow
arch/x86/built-in.o: In function `free_lid_switch':
olpc-xo1-sci.c:(.text+0x1d7fd): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1d807): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `setup_lid_switch':
olpc-xo1-sci.c:(.devinit.text+0x155): undefined reference to `input_allocate_device'
olpc-xo1-sci.c:(.devinit.text+0x1a4): undefined reference to `input_register_device'
olpc-xo1-sci.c:(.devinit.text+0x1ce): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.devinit.text+0x1d8): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `xo1_sci_probe':
olpc-xo1-sci.c:(.devinit.text+0x235): undefined reference to `input_allocate_device'
olpc-xo1-sci.c:(.devinit.text+0x285): undefined reference to `input_register_device'
olpc-xo1-sci.c:(.devinit.text+0x299): undefined reference to `input_free_device'
olpc-xo1-sci.c:(.devinit.text+0x2e1): undefined reference to `input_register_device'
olpc-xo1-sci.c:(.devinit.text+0x2f5): undefined reference to `input_free_device'
olpc-xo1-sci.c:(.devinit.text+0x54c): undefined reference to `input_allocate_device'

In the long run, fixing this driver kconfig to be tristate instead of bool
would be a very good change.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~olpc-fix-olpc-xo1-scic-build-errors arch/x86/Kconfig
--- a/arch/x86/Kconfig~olpc-fix-olpc-xo1-scic-build-errors
+++ a/arch/x86/Kconfig
@@ -2171,6 +2171,7 @@ config OLPC_XO1_RTC
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
 	depends on OLPC && OLPC_XO1_PM
+	depends on INPUT=y
 	select POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

linux-next.patch
mutex-subsystem-synchro-test-module.patch

