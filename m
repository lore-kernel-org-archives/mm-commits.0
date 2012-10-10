From: akpm@linux-foundation.org
Subject: + olpc-fix-olpc-xo1-scic-build-errors.patch added to -mm tree
Date: Wed, 10 Oct 2012 14:08:50 -0700
Message-ID: <20121010210851.4804D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62652 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2JJVIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 17:08:54 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so69401fae.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 14:08:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, cjb@laptop.org, dilinger@queued.net, dsd@laptop.org, hpa@zytor.com, jon.nettleton@gmail.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: olpc: fix olpc-xo1-sci.c build errors
has been added to the -mm tree.  Its filename is
     olpc-fix-olpc-xo1-scic-build-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2126,6 +2126,7 @@ config OLPC_XO1_RTC
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
 	depends on OLPC && OLPC_XO1_PM
+	depends on INPUT=y
 	select POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
memcg-kmem-fix-build-error-when-config_inet-is-disabled.patch
olpc-fix-olpc-xo1-scic-build-errors.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

