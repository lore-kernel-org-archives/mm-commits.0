From: akpm@linux-foundation.org
Subject: + watchdog-documentation.patch added to -mm tree
Date: Thu, 10 May 2007 16:12:29 -0700
Message-ID: <200705102312.l4ANCTer001000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXEJXMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 19:12:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     watchdog: Documentation
has been added to the -mm tree.  Its filename is
     watchdog-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: watchdog: Documentation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Random sampling of some URLs in the Documentation tree to see how many were
stale found that one watchdog driver was now a porn site.  In fact if the
watchdogs document directory was any older it would be written in latin

Clean it up somewhat and add Last reviewed headers, something all the
Documentation could do with IMHO.

As an aside Wim the URLS for the BERKSHIRE watchdog are dead, do you know
where Kenji has gone or should that maintainers entry be deleted ?

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/watchdog/pcwd-watchdog.txt |    8 
 Documentation/watchdog/watchdog-api.txt  |  238 +--------------------
 Documentation/watchdog/watchdog.txt      |   94 --------
 Documentation/watchdog/wdt.txt           |   43 +++
 4 files changed, 61 insertions(+), 322 deletions(-)

diff -puN Documentation/watchdog/pcwd-watchdog.txt~watchdog-documentation Documentation/watchdog/pcwd-watchdog.txt
--- a/Documentation/watchdog/pcwd-watchdog.txt~watchdog-documentation
+++ a/Documentation/watchdog/pcwd-watchdog.txt
@@ -1,3 +1,5 @@
+Last reviewed: 10/05/2007
+
                      Berkshire Products PC Watchdog Card
                    Support for ISA Cards  Revision A and C
            Documentation and Driver by Ken Hollis <kenji@bitgate.com>
@@ -14,8 +16,8 @@
 
  The Watchdog Driver will automatically find your watchdog card, and will
  attach a running driver for use with that card.  After the watchdog
- drivers have initialized, you can then talk to the card using the PC
- Watchdog program, available from http://ftp.bitgate.com/pcwd/.
+ drivers have initialized, you can then talk to the card using a PC
+ Watchdog program.
 
  I suggest putting a "watchdog -d" before the beginning of an fsck, and
  a "watchdog -e -t 1" immediately after the end of an fsck.  (Remember
@@ -62,5 +64,3 @@
  -- Ken Hollis
     (kenji@bitgate.com)
 
-(This documentation may be out of date.  Check
- http://ftp.bitgate.com/pcwd/ for the absolute latest additions.)
diff -puN Documentation/watchdog/watchdog-api.txt~watchdog-documentation Documentation/watchdog/watchdog-api.txt
--- a/Documentation/watchdog/watchdog-api.txt~watchdog-documentation
+++ a/Documentation/watchdog/watchdog-api.txt
@@ -1,3 +1,6 @@
+Last reviewed: 10/05/2007
+
+
 The Linux Watchdog driver API.
 
 Copyright 2002 Christer Weingel <wingel@nano-system.com>
@@ -22,7 +25,7 @@ the system.  If userspace fails (RAM err
 notifications cease to occur, and the hardware watchdog will reset the
 system (causing a reboot) after the timeout occurs.
 
-The Linux watchdog API is a rather AD hoc construction and different
+The Linux watchdog API is a rather ad-hoc construction and different
 drivers implement different, and sometimes incompatible, parts of it.
 This file is an attempt to document the existing usage and allow
 future driver writers to use it as a reference.
@@ -46,14 +49,16 @@ some of the drivers support the configur
 shutdown on close", CONFIG_WATCHDOG_NOWAYOUT.  If it is set to Y when
 compiling the kernel, there is no way of disabling the watchdog once
 it has been started.  So, if the watchdog daemon crashes, the system
-will reboot after the timeout has passed.
-
-Some other drivers will not disable the watchdog, unless a specific
-magic character 'V' has been sent /dev/watchdog just before closing
-the file.  If the userspace daemon closes the file without sending
-this special character, the driver will assume that the daemon (and
-userspace in general) died, and will stop pinging the watchdog without
-disabling it first.  This will then cause a reboot.
+will reboot after the timeout has passed. Watchdog devices also usually
+support the nowayout module parameter so that this option can be controlled
+at runtime.
+
+Drivers will not disable the watchdog, unless a specific magic character 'V'
+has been sent /dev/watchdog just before closing the file.  If the userspace
+daemon closes the file without sending this special character, the driver
+will assume that the daemon (and userspace in general) died, and will stop
+pinging the watchdog without disabling it first.  This will then cause a
+reboot if the watchdog is not re-opened in sufficient time.
 
 The ioctl API:
 
@@ -227,218 +232,3 @@ The following options are available:
 
 [FIXME -- better explanations]
 
-Implementations in the current drivers in the kernel tree:
-
-Here I have tried to summarize what the different drivers support and
-where they do strange things compared to the other drivers.
-
-acquirewdt.c -- Acquire Single Board Computer
-
-	This driver has a hardcoded timeout of 1 minute
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns KEEPALIVEPING.  GETSTATUS will return 1 if
-	the device is open, 0 if not.  [FIXME -- isn't this rather
-	silly?  To be able to use the ioctl, the device must be open
-	and so GETSTATUS will always return 1].
-
-advantechwdt.c -- Advantech Single Board Computer
-
-	Timeout that defaults to 60 seconds, supports SETTIMEOUT.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
-	The GETSTATUS call returns if the device is open or not.
-	[FIXME -- silliness again?]
-	
-booke_wdt.c -- PowerPC BookE Watchdog Timer
-
-	Timeout default varies according to frequency, supports
-	SETTIMEOUT
-
-	Watchdog cannot be turned off, CONFIG_WATCHDOG_NOWAYOUT
-	does not make sense
-
-	GETSUPPORT returns the watchdog_info struct, and
-	GETSTATUS returns the supported options. GETBOOTSTATUS
-	returns a 1 if the last reset was caused by the
-	watchdog and a 0 otherwise. This watchdog cannot be
-	disabled once it has been started. The wdt_period kernel
-	parameter selects which bit of the time base changing
-	from 0->1 will trigger the watchdog exception. Changing
-	the timeout from the ioctl calls will change the
-	wdt_period as defined above. Finally if you would like to
-	replace the default Watchdog Handler you can implement the
-	WatchdogHandler() function in your own code.
-
-eurotechwdt.c -- Eurotech CPU-1220/1410
-
-	The timeout can be set using the SETTIMEOUT ioctl and defaults
-	to 60 seconds.
-
-	Also has a module parameter "ev", event type which controls
-	what should happen on a timeout, the string "int" or anything
-	else that causes a reboot.  [FIXME -- better description]
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns CARDRESET and WDIOF_SETTIMEOUT but
-	GETSTATUS is not supported and GETBOOTSTATUS just returns 0.
-
-i810-tco.c -- Intel 810 chipset
-
-	Also has support for a lot of other i8x0 stuff, but the
-	watchdog is one of the things.
-
-	The timeout is set using the module parameter "i810_margin",
-	which is in steps of 0.6 seconds where 2<i810_margin<64.  The
-	driver supports the SETTIMEOUT ioctl.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT.
-
-	GETSUPPORT returns WDIOF_SETTIMEOUT.  The GETSTATUS call
-	returns some kind of timer value which ist not compatible with
-	the other drivers.  GETBOOT status returns some kind of
-	hardware specific boot status.  [FIXME -- describe this]
-
-ib700wdt.c -- IB700 Single Board Computer
-
-	Default timeout of 30 seconds and the timeout is settable
-	using the SETTIMEOUT ioctl.  Note that only a few timeout
-	values are supported.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
-	The GETSTATUS call returns if the device is open or not.
-	[FIXME -- silliness again?]
-
-machzwd.c -- MachZ ZF-Logic
-
-	Hardcoded timeout of 10 seconds
-
-	Has a module parameter "action" that controls what happens
-	when the timeout runs out which can be 0 = RESET (default), 
-	1 = SMI, 2 = NMI, 3 = SCI.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT and the magic character
-	'V' close handling.
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING, and the GETSTATUS call
-	returns if the device is open or not.  [FIXME -- silliness
-	again?]
-
-mixcomwd.c -- MixCom Watchdog
-
-	[FIXME -- I'm unable to tell what the timeout is]
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING, GETSTATUS returns if
-	the device is opened or not [FIXME -- I'm not really sure how
-	this works, there seems to be some magic connected to
-	CONFIG_WATCHDOG_NOWAYOUT]
-
-pcwd.c -- Berkshire PC Watchdog
-
-	Hardcoded timeout of 1.5 seconds
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_OVERHEAT|WDIOF_CARDRESET and both
-	GETSTATUS and GETBOOTSTATUS return something useful.
-
-	The SETOPTIONS call can be used to enable and disable the card
-	and to ask the driver to call panic if the system overheats.
-
-sbc60xxwdt.c -- 60xx Single Board Computer
-
-	Hardcoded timeout of 10 seconds
-
-	Does not support CONFIG_WATCHDOG_NOWAYOUT, but has the magic
-	character 'V' close handling.
-
-	No bits set in GETSUPPORT
-
-scx200.c -- National SCx200 CPUs
-
-	Not in the kernel yet.
-
-	The timeout is set using a module parameter "margin" which
-	defaults to 60 seconds.  The timeout can also be set using
-	SETTIMEOUT and read using GETTIMEOUT.
-
-	Supports a module parameter "nowayout" that is initialized
-	with the value of CONFIG_WATCHDOG_NOWAYOUT.  Also supports the
-	magic character 'V' handling.
-
-shwdt.c -- SuperH 3/4 processors
-
-	[FIXME -- I'm unable to tell what the timeout is]
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING, and the GETSTATUS call
-	returns if the device is open or not.  [FIXME -- silliness
-	again?]
-
-softdog.c -- Software watchdog
-
-	The timeout is set with the module parameter "soft_margin"
-	which defaults to 60 seconds, the timeout is also settable
-	using the SETTIMEOUT ioctl.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	WDIOF_SETTIMEOUT bit set in GETSUPPORT
-
-w83877f_wdt.c -- W83877F Computer
-
-	Hardcoded timeout of 30 seconds
-
-	Does not support CONFIG_WATCHDOG_NOWAYOUT, but has the magic
-	character 'V' close handling.
-
-	No bits set in GETSUPPORT
-
-w83627hf_wdt.c -- w83627hf watchdog
-
-	Timeout that defaults to 60 seconds, supports SETTIMEOUT.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
-	The GETSTATUS call returns if the device is open or not.
-
-wdt.c -- ICS WDT500/501 ISA and
-wdt_pci.c -- ICS WDT500/501 PCI
-
-	Default timeout of 60 seconds.  The timeout is also settable
-        using the SETTIMEOUT ioctl.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns with bits set depending on the actual
-	card. The WDT501 supports a lot of external monitoring, the
-	WDT500 much less.
-
-wdt285.c -- Footbridge watchdog
-
-	The timeout is set with the module parameter "soft_margin"
-	which defaults to 60 seconds.  The timeout is also settable
-	using the SETTIMEOUT ioctl.
-
-	Does not support CONFIG_WATCHDOG_NOWAYOUT
-
-	WDIOF_SETTIMEOUT bit set in GETSUPPORT
-
-wdt977.c -- Netwinder W83977AF chip
-
-	Hardcoded timeout of 3 minutes
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	Does not support any ioctls at all.
-
diff -puN Documentation/watchdog/watchdog.txt~watchdog-documentation /dev/null
--- a/Documentation/watchdog/watchdog.txt
+++ /dev/null
@@ -1,94 +0,0 @@
-	Watchdog Timer Interfaces For The Linux Operating System
-
-		Alan Cox <alan@lxorguk.ukuu.org.uk>
-
-	     Custom Linux Driver And Program Development
-
-
-The following watchdog drivers are currently implemented:
-
-	ICS	WDT501-P
-	ICS	WDT501-P (no fan tachometer)
-	ICS	WDT500-P
-	Software Only
-	SA1100 Internal Watchdog
-	Berkshire Products PC Watchdog Revision A & C (by Ken Hollis)
-
-
-All six interfaces provide /dev/watchdog, which when open must be written
-to within a timeout or the machine will reboot. Each write delays the reboot
-time another timeout. In the case of the software watchdog the ability to 
-reboot will depend on the state of the machines and interrupts. The hardware
-boards physically pull the machine down off their own onboard timers and
-will reboot from almost anything.
-
-A second temperature monitoring interface is available on the WDT501P cards
-and some Berkshire cards. This provides /dev/temperature. This is the machine 
-internal temperature in degrees Fahrenheit. Each read returns a single byte 
-giving the temperature.
-
-The third interface logs kernel messages on additional alert events.
-
-Both software and hardware watchdog drivers are available in the standard
-kernel. If you are using the software watchdog, you probably also want
-to use "panic=60" as a boot argument as well.
-
-The wdt card cannot be safely probed for. Instead you need to pass
-wdt=ioaddr,irq as a boot parameter - eg "wdt=0x240,11".
-
-The SA1100 watchdog module can be configured with the "sa1100_margin"
-commandline argument which specifies timeout value in seconds.
-
-The i810 TCO watchdog modules can be configured with the "i810_margin"
-commandline argument which specifies the counter initial value. The counter
-is decremented every 0.6 seconds and default to 50 (30 seconds). Values can
-range between 3 and 63.
-
-The i810 TCO watchdog driver also implements the WDIOC_GETSTATUS and
-WDIOC_GETBOOTSTATUS ioctl()s. WDIOC_GETSTATUS returns the actual counter value
-and WDIOC_GETBOOTSTATUS returns the value of TCO2 Status Register (see Intel's
-documentation for the 82801AA and 82801AB datasheet). 
-
-Features
---------
-		WDT501P		WDT500P		Software	Berkshire	i810 TCO	SA1100WD
-Reboot Timer	   X               X                X		    X               X               X
-External Reboot	   X	           X                o		    o               o               X
-I/O Port Monitor   o		   o		    o		    X               o               o
-Temperature	   X		   o		    o               X               o               o
-Fan Speed          X		   o		    o               o               o               o
-Power Under	   X               o                o               o               o               o
-Power Over         X               o                o               o               o               o
-Overheat           X               o                o               o               o               o
-
-The external event interfaces on the WDT boards are not currently supported.
-Minor numbers are however allocated for it.
-
-
-Example Watchdog Driver:  see Documentation/watchdog/src/watchdog-simple.c
-
-
-Contact Information
-
-People keep asking about the WDT watchdog timer hardware: The phone contacts
-for Industrial Computer Source are:
- 
-Industrial Computer Source
-http://www.indcompsrc.com
-ICS Advent, San Diego
-6260 Sequence Dr.
-San Diego, CA 92121-4371
-Phone (858) 677-0877
-FAX: (858) 677-0895
->
-ICS Advent Europe, UK
-Oving Road
-Chichester,
-West Sussex,
-PO19 4ET, UK
-Phone: 00.44.1243.533900
-
-
-and please mention Linux when enquiring.
-
-For full information about the PCWD cards see the pcwd-watchdog.txt document.
diff -puN /dev/null Documentation/watchdog/wdt.txt
--- /dev/null
+++ a/Documentation/watchdog/wdt.txt
@@ -0,0 +1,43 @@
+Last Reviewed: 10/05/2007
+
+	WDT Watchdog Timer Interfaces For The Linux Operating System
+		Alan Cox <alan@lxorguk.ukuu.org.uk>
+
+	ICS	WDT501-P
+	ICS	WDT501-P (no fan tachometer)
+	ICS	WDT500-P
+
+All the interfaces provide /dev/watchdog, which when open must be written
+to within a timeout or the machine will reboot. Each write delays the reboot
+time another timeout. In the case of the software watchdog the ability to
+reboot will depend on the state of the machines and interrupts. The hardware
+boards physically pull the machine down off their own onboard timers and
+will reboot from almost anything.
+
+A second temperature monitoring interface is available on the WDT501P cards
+This provides /dev/temperature. This is the machine internal temperature in
+degrees Fahrenheit. Each read returns a single byte giving the temperature.
+
+The third interface logs kernel messages on additional alert events.
+
+The wdt card cannot be safely probed for. Instead you need to pass
+wdt=ioaddr,irq as a boot parameter - eg "wdt=0x240,11".
+
+Features
+--------
+		WDT501P		WDT500P
+Reboot Timer	   X               X
+External Reboot	   X	           X
+I/O Port Monitor   o		   o
+Temperature	   X		   o
+Fan Speed          X		   o
+Power Under	   X               o
+Power Over         X               o
+Overheat           X               o
+
+The external event interfaces on the WDT boards are not currently supported.
+Minor numbers are however allocated for it.
+
+
+Example Watchdog Driver:  see Documentation/watchdog/src/watchdog-simple.c
+
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
watchdog-documentation.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
tty-add-compat_ioctl.patch
