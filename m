Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26CFC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 777A461041
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhEGBG6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhEGBG5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D5FC610FA;
        Fri,  7 May 2021 01:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349558;
        bh=KbvfiafT1wKc1nat35bH9U7JiR1S8+EcJXyBKyTmfvo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DFDMZw3aEUdSUFoHF8FxFUGvGU3TZwilX/hb68uxe5dAiXBF+d6/LrYodyq3TY6TQ
         OWTYvWz+FSjvygSno35g7bw9/+RYyyPf4njIv1ac3b5YoWT/87ir5W62AmNr6EmGtV
         NNA3g93wK9j6o9JO3AsXfdJ0xQyvPBca3jpyPNhk=
Date:   Thu, 06 May 2021 18:05:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, andrey.zhizhikin@leica-geosystems.com,
        arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org,
        bigeasy@linutronix.de, borntraeger@de.ibm.com, chris@zankel.net,
        christophe.leroy@csgroup.eu, clabbe@baylibre.com, corbet@lwn.net,
        dalias@libc.org, davem@davemloft.net, david@redhat.com,
        deller@gmx.de, ebiederm@xmission.com, geert@linux-m68k.org,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        grandmaster@al2klimov.de, green.hu@gmail.com,
        gregkh@linuxfoundation.org, gregory.clement@bootlin.com,
        hca@linux.ibm.com, hdanton@sina.com, huang.ying.caritas@gmail.com,
        ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com,
        james.troup@canonical.com, jcmvbkbc@gmail.com,
        jiaxun.yang@flygoat.com, jonas@southpole.se, kasong@redhat.com,
        keescook@chromium.org, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, linux-mm@kvack.org,
        linux@armlinux.org.uk, liviu.dudau@arm.com,
        lorenzo.pieralisi@arm.com, luc.vanoostenryck@gmail.com,
        mattst88@gmail.com, mcgrof@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        mpatocka@redhat.com, mpe@ellerman.id.au, nixiaoming@huawei.com,
        oleksiy.avramchenko@sonymobile.com, palmerdabbelt@google.com,
        paulus@samba.org, pavel@denx.de, pavel@ucw.cz,
        peterz@infradead.org, pmorel@linux.ibm.com, rdunlap@infradead.org,
        robh@kernel.org, rostedt@goodmis.org, rppt@kernel.org,
        rric@kernel.org, rth@twiddle.net, sam@ravnborg.org,
        schnelle@linux.ibm.com, sebastian.hesselbarth@gmail.com,
        shorne@gmail.com, stefan.kristiansson@saunalahti.fi,
        sudeep.holla@arm.com, tblodt@icloud.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        viresh.kumar@linaro.org, viro@zeniv.linux.org.uk,
        wcohen@redhat.com, willy@infradead.org, ysato@users.sourceforge.jp
Subject:  [patch 74/91] drivers/char: remove /dev/kmem for good
Message-ID: <20210507010555.rMbheV4H-%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: drivers/char: remove /dev/kmem for good

Patch series "drivers/char: remove /dev/kmem for good".

Exploring /dev/kmem and /dev/mem in the context of memory hot(un)plug and
memory ballooning, I started questioning the existence of /dev/kmem.

Comparing it with the /proc/kcore implementation, it does not seem to be
able to deal with things like

a) Pages unmapped from the direct mapping (e.g., to be used by secretmem)
  -> kern_addr_valid(). virt_addr_valid() is not sufficient.

b) Special cases like gart aperture memory that is not to be touched
  -> mem_pfn_is_ram()

Unless I am missing something, it's at least broken in some cases and might
fault/crash the machine.

Looks like its existence has been questioned before in 2005 and 2010 [1],
after ~11 additional years, it might make sense to revive the discussion.

CONFIG_DEVKMEM is only enabled in a single defconfig (on purpose or by
mistake?).  All distributions disable it: in Ubuntu it has been disabled
for more than 10 years, in Debian since 2.6.31, in Fedora at least
starting with FC3, in RHEL starting with RHEL4, in SUSE starting from
15sp2, and OpenSUSE has it disabled as well.

1) /dev/kmem was popular for rootkits [2] before it got disabled
   basically everywhere. Ubuntu documents [3] "There is no modern user of
   /dev/kmem any more beyond attackers using it to load kernel rootkits.".
   RHEL documents in a BZ [5] "it served no practical purpose other than to
   serve as a potential security problem or to enable binary module drivers
   to access structures/functions they shouldn't be touching"

2) /proc/kcore is a decent interface to have a controlled way to read
   kernel memory for debugging puposes. (will need some extensions to
   deal with memory offlining/unplug, memory ballooning, and poisoned
   pages, though)

3) It might be useful for corner case debugging [1]. KDB/KGDB might be a
   better fit, especially, to write random memory; harder to shoot
   yourself into the foot.

4) "Kernel Memory Editor" [4] hasn't seen any updates since 2000 and seems
   to be incompatible with 64bit [1]. For educational purposes,
   /proc/kcore might be used to monitor value updates -- or older
   kernels can be used.

5) It's broken on arm64, and therefore, completely disabled there.

Looks like it's essentially unused and has been replaced by better
suited interfaces for individual tasks (/proc/kcore, KDB/KGDB). Let's
just remove it.

[1] https://lwn.net/Articles/147901/
[2] https://www.linuxjournal.com/article/10505
[3] https://wiki.ubuntu.com/Security/Features#A.2Fdev.2Fkmem_disabled
[4] https://sourceforge.net/projects/kme/
[5] https://bugzilla.redhat.com/show_bug.cgi?id=154796

Link: https://lkml.kernel.org/r/20210324102351.6932-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210324102351.6932-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Gregory Clement <gregory.clement@bootlin.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: James Troup <james.troup@canonical.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <kasong@redhat.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: openrisc@lists.librecores.org
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Pavel Machek (CIP)" <pavel@denx.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Robert Richter <rric@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: sparclinux@vger.kernel.org
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Theodore Dubois <tblodt@icloud.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: William Cohen <wcohen@redhat.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/devices.txt     |    2 
 arch/arm/configs/dove_defconfig           |    1 
 arch/arm/configs/magician_defconfig       |    1 
 arch/arm/configs/moxart_defconfig         |    1 
 arch/arm/configs/mps2_defconfig           |    1 
 arch/arm/configs/mvebu_v5_defconfig       |    1 
 arch/arm/configs/xcep_defconfig           |    1 
 arch/hexagon/configs/comet_defconfig      |    1 
 arch/m68k/configs/amcore_defconfig        |    1 
 arch/openrisc/configs/or1ksim_defconfig   |    1 
 arch/sh/configs/edosk7705_defconfig       |    1 
 arch/sh/configs/se7206_defconfig          |    1 
 arch/sh/configs/sh2007_defconfig          |    1 
 arch/sh/configs/sh7724_generic_defconfig  |    1 
 arch/sh/configs/sh7770_generic_defconfig  |    1 
 arch/sh/configs/sh7785lcr_32bit_defconfig |    1 
 arch/sparc/configs/sparc64_defconfig      |    1 
 arch/xtensa/configs/xip_kc705_defconfig   |    1 
 drivers/char/Kconfig                      |   10 
 drivers/char/mem.c                        |  231 --------------------
 include/linux/fs.h                        |    2 
 include/linux/vmalloc.h                   |    2 
 kernel/configs/android-base.config        |    1 
 mm/ksm.c                                  |    2 
 mm/vmalloc.c                              |    2 
 25 files changed, 5 insertions(+), 264 deletions(-)

--- a/arch/arm/configs/dove_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/arm/configs/dove_defconfig
@@ -63,7 +63,6 @@ CONFIG_INPUT_EVDEV=y
 # CONFIG_MOUSE_PS2 is not set
 # CONFIG_SERIO is not set
 CONFIG_LEGACY_PTY_COUNT=16
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_RUNTIME_UARTS=2
--- a/arch/arm/configs/magician_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/arm/configs/magician_defconfig
@@ -72,7 +72,6 @@ CONFIG_INPUT_TOUCHSCREEN=y
 CONFIG_INPUT_MISC=y
 CONFIG_INPUT_UINPUT=m
 # CONFIG_SERIO is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_PXA=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
--- a/arch/arm/configs/moxart_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/arm/configs/moxart_defconfig
@@ -79,7 +79,6 @@ CONFIG_INPUT_EVBUG=y
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_NR_UARTS=1
--- a/arch/arm/configs/mps2_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/arm/configs/mps2_defconfig
@@ -69,7 +69,6 @@ CONFIG_SMSC911X=y
 # CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_NONSTANDARD=y
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_MPS2_UART_CONSOLE=y
 CONFIG_SERIAL_MPS2_UART=y
 # CONFIG_HW_RANDOM is not set
--- a/arch/arm/configs/mvebu_v5_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/arm/configs/mvebu_v5_defconfig
@@ -100,7 +100,6 @@ CONFIG_INPUT_EVDEV=y
 CONFIG_KEYBOARD_GPIO=y
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_LEGACY_PTY_COUNT=16
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_RUNTIME_UARTS=2
--- a/arch/arm/configs/xcep_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/arm/configs/xcep_defconfig
@@ -53,7 +53,6 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_SERIO is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_PXA=y
 CONFIG_SERIAL_PXA_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
--- a/arch/hexagon/configs/comet_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/hexagon/configs/comet_defconfig
@@ -34,7 +34,6 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_SERIO is not set
 # CONFIG_CONSOLE_TRANSLATIONS is not set
 CONFIG_LEGACY_PTY_COUNT=64
-# CONFIG_DEVKMEM is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_DEBUG=y
--- a/arch/m68k/configs/amcore_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/m68k/configs/amcore_defconfig
@@ -60,7 +60,6 @@ CONFIG_DM9000=y
 # CONFIG_VT is not set
 # CONFIG_UNIX98_PTYS is not set
 # CONFIG_DEVMEM is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_MCF=y
 CONFIG_SERIAL_MCF_BAUDRATE=115200
 CONFIG_SERIAL_MCF_CONSOLE=y
--- a/arch/openrisc/configs/or1ksim_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/openrisc/configs/or1ksim_defconfig
@@ -43,7 +43,6 @@ CONFIG_MICREL_PHY=y
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
--- a/arch/sh/configs/edosk7705_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sh/configs/edosk7705_defconfig
@@ -23,7 +23,6 @@ CONFIG_SH_PCLK_FREQ=31250000
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
-# CONFIG_DEVKMEM is not set
 # CONFIG_UNIX98_PTYS is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
--- a/arch/sh/configs/se7206_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sh/configs/se7206_defconfig
@@ -71,7 +71,6 @@ CONFIG_SMC91X=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_NR_UARTS=4
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
--- a/arch/sh/configs/sh2007_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sh/configs/sh2007_defconfig
@@ -75,7 +75,6 @@ CONFIG_INPUT_FF_MEMLESS=y
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_SERIO is not set
 CONFIG_VT_HW_CONSOLE_BINDING=y
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
--- a/arch/sh/configs/sh7724_generic_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sh/configs/sh7724_generic_defconfig
@@ -18,7 +18,6 @@ CONFIG_CPU_IDLE=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_NR_UARTS=6
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
--- a/arch/sh/configs/sh7770_generic_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sh/configs/sh7770_generic_defconfig
@@ -20,7 +20,6 @@ CONFIG_CPU_IDLE=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_NR_UARTS=6
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -66,7 +66,6 @@ CONFIG_INPUT_FF_MEMLESS=m
 CONFIG_INPUT_EVDEV=y
 CONFIG_INPUT_EVBUG=m
 CONFIG_VT_HW_CONSOLE_BINDING=y
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_NR_UARTS=6
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
--- a/arch/sparc/configs/sparc64_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/sparc/configs/sparc64_defconfig
@@ -122,7 +122,6 @@ CONFIG_INPUT_SPARCSPKR=y
 # CONFIG_SERIO_SERPORT is not set
 CONFIG_SERIO_PCIPS2=m
 CONFIG_SERIO_RAW=m
-# CONFIG_DEVKMEM is not set
 CONFIG_SERIAL_SUNSU=y
 CONFIG_SERIAL_SUNSU_CONSOLE=y
 CONFIG_SERIAL_SUNSAB=y
--- a/arch/xtensa/configs/xip_kc705_defconfig~drivers-char-remove-dev-kmem-for-good
+++ a/arch/xtensa/configs/xip_kc705_defconfig
@@ -72,7 +72,6 @@ CONFIG_MARVELL_PHY=y
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_SERIO is not set
-CONFIG_DEVKMEM=y
 CONFIG_SERIAL_8250=y
 # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
 CONFIG_SERIAL_8250_CONSOLE=y
--- a/Documentation/admin-guide/devices.txt~drivers-char-remove-dev-kmem-for-good
+++ a/Documentation/admin-guide/devices.txt
@@ -4,7 +4,7 @@
 
    1 char	Memory devices
 		  1 = /dev/mem		Physical memory access
-		  2 = /dev/kmem		Kernel virtual memory access
+		  2 = /dev/kmem		OBSOLETE - replaced by /proc/kcore
 		  3 = /dev/null		Null device
 		  4 = /dev/port		I/O port access
 		  5 = /dev/zero		Null byte source
--- a/drivers/char/Kconfig~drivers-char-remove-dev-kmem-for-good
+++ a/drivers/char/Kconfig
@@ -334,16 +334,6 @@ config DEVMEM
 	  memory.
 	  When in doubt, say "Y".
 
-config DEVKMEM
-	bool "/dev/kmem virtual device support"
-	# On arm64, VMALLOC_START < PAGE_OFFSET, which confuses kmem read/write
-	depends on !ARM64
-	help
-	  Say Y here if you want to support the /dev/kmem device. The
-	  /dev/kmem device is rarely used, but can be used for certain
-	  kind of kernel debugging operations.
-	  When in doubt, say "N".
-
 config NVRAM
 	tristate "/dev/nvram support"
 	depends on X86 || HAVE_ARCH_NVRAM_OPS
--- a/drivers/char/mem.c~drivers-char-remove-dev-kmem-for-good
+++ a/drivers/char/mem.c
@@ -403,221 +403,6 @@ static int mmap_mem(struct file *file, s
 	return 0;
 }
 
-static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
-{
-	unsigned long pfn;
-
-	/* Turn a kernel-virtual address into a physical page frame */
-	pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;
-
-	/*
-	 * RED-PEN: on some architectures there is more mapped memory than
-	 * available in mem_map which pfn_valid checks for. Perhaps should add a
-	 * new macro here.
-	 *
-	 * RED-PEN: vmalloc is not supported right now.
-	 */
-	if (!pfn_valid(pfn))
-		return -EIO;
-
-	vma->vm_pgoff = pfn;
-	return mmap_mem(file, vma);
-}
-
-/*
- * This function reads the *virtual* memory as seen by the kernel.
- */
-static ssize_t read_kmem(struct file *file, char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	unsigned long p = *ppos;
-	ssize_t low_count, read, sz;
-	char *kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
-	int err = 0;
-
-	read = 0;
-	if (p < (unsigned long) high_memory) {
-		low_count = count;
-		if (count > (unsigned long)high_memory - p)
-			low_count = (unsigned long)high_memory - p;
-
-#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
-		/* we don't have page 0 mapped on sparc and m68k.. */
-		if (p < PAGE_SIZE && low_count > 0) {
-			sz = size_inside_page(p, low_count);
-			if (clear_user(buf, sz))
-				return -EFAULT;
-			buf += sz;
-			p += sz;
-			read += sz;
-			low_count -= sz;
-			count -= sz;
-		}
-#endif
-		while (low_count > 0) {
-			sz = size_inside_page(p, low_count);
-
-			/*
-			 * On ia64 if a page has been mapped somewhere as
-			 * uncached, then it must also be accessed uncached
-			 * by the kernel or data corruption may occur
-			 */
-			kbuf = xlate_dev_kmem_ptr((void *)p);
-			if (!virt_addr_valid(kbuf))
-				return -ENXIO;
-
-			if (copy_to_user(buf, kbuf, sz))
-				return -EFAULT;
-			buf += sz;
-			p += sz;
-			read += sz;
-			low_count -= sz;
-			count -= sz;
-			if (should_stop_iteration()) {
-				count = 0;
-				break;
-			}
-		}
-	}
-
-	if (count > 0) {
-		kbuf = (char *)__get_free_page(GFP_KERNEL);
-		if (!kbuf)
-			return -ENOMEM;
-		while (count > 0) {
-			sz = size_inside_page(p, count);
-			if (!is_vmalloc_or_module_addr((void *)p)) {
-				err = -ENXIO;
-				break;
-			}
-			sz = vread(kbuf, (char *)p, sz);
-			if (!sz)
-				break;
-			if (copy_to_user(buf, kbuf, sz)) {
-				err = -EFAULT;
-				break;
-			}
-			count -= sz;
-			buf += sz;
-			read += sz;
-			p += sz;
-			if (should_stop_iteration())
-				break;
-		}
-		free_page((unsigned long)kbuf);
-	}
-	*ppos = p;
-	return read ? read : err;
-}
-
-
-static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	ssize_t written, sz;
-	unsigned long copied;
-
-	written = 0;
-#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
-	/* we don't have page 0 mapped on sparc and m68k.. */
-	if (p < PAGE_SIZE) {
-		sz = size_inside_page(p, count);
-		/* Hmm. Do something? */
-		buf += sz;
-		p += sz;
-		count -= sz;
-		written += sz;
-	}
-#endif
-
-	while (count > 0) {
-		void *ptr;
-
-		sz = size_inside_page(p, count);
-
-		/*
-		 * On ia64 if a page has been mapped somewhere as uncached, then
-		 * it must also be accessed uncached by the kernel or data
-		 * corruption may occur.
-		 */
-		ptr = xlate_dev_kmem_ptr((void *)p);
-		if (!virt_addr_valid(ptr))
-			return -ENXIO;
-
-		copied = copy_from_user(ptr, buf, sz);
-		if (copied) {
-			written += sz - copied;
-			if (written)
-				break;
-			return -EFAULT;
-		}
-		buf += sz;
-		p += sz;
-		count -= sz;
-		written += sz;
-		if (should_stop_iteration())
-			break;
-	}
-
-	*ppos += written;
-	return written;
-}
-
-/*
- * This function writes to the *virtual* memory as seen by the kernel.
- */
-static ssize_t write_kmem(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
-{
-	unsigned long p = *ppos;
-	ssize_t wrote = 0;
-	ssize_t virtr = 0;
-	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
-	int err = 0;
-
-	if (p < (unsigned long) high_memory) {
-		unsigned long to_write = min_t(unsigned long, count,
-					       (unsigned long)high_memory - p);
-		wrote = do_write_kmem(p, buf, to_write, ppos);
-		if (wrote != to_write)
-			return wrote;
-		p += wrote;
-		buf += wrote;
-		count -= wrote;
-	}
-
-	if (count > 0) {
-		kbuf = (char *)__get_free_page(GFP_KERNEL);
-		if (!kbuf)
-			return wrote ? wrote : -ENOMEM;
-		while (count > 0) {
-			unsigned long sz = size_inside_page(p, count);
-			unsigned long n;
-
-			if (!is_vmalloc_or_module_addr((void *)p)) {
-				err = -ENXIO;
-				break;
-			}
-			n = copy_from_user(kbuf, buf, sz);
-			if (n) {
-				err = -EFAULT;
-				break;
-			}
-			vwrite(kbuf, (char *)p, sz);
-			count -= sz;
-			buf += sz;
-			virtr += sz;
-			p += sz;
-			if (should_stop_iteration())
-				break;
-		}
-		free_page((unsigned long)kbuf);
-	}
-
-	*ppos = p;
-	return virtr + wrote ? : err;
-}
-
 static ssize_t read_port(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -855,7 +640,6 @@ static int open_port(struct inode *inode
 #define write_zero	write_null
 #define write_iter_zero	write_iter_null
 #define open_mem	open_port
-#define open_kmem	open_mem
 
 static const struct file_operations __maybe_unused mem_fops = {
 	.llseek		= memory_lseek,
@@ -869,18 +653,6 @@ static const struct file_operations __ma
 #endif
 };
 
-static const struct file_operations __maybe_unused kmem_fops = {
-	.llseek		= memory_lseek,
-	.read		= read_kmem,
-	.write		= write_kmem,
-	.mmap		= mmap_kmem,
-	.open		= open_kmem,
-#ifndef CONFIG_MMU
-	.get_unmapped_area = get_unmapped_area_mem,
-	.mmap_capabilities = memory_mmap_capabilities,
-#endif
-};
-
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
 	.read		= read_null,
@@ -925,9 +697,6 @@ static const struct memdev {
 #ifdef CONFIG_DEVMEM
 	 [DEVMEM_MINOR] = { "mem", 0, &mem_fops, FMODE_UNSIGNED_OFFSET },
 #endif
-#ifdef CONFIG_DEVKMEM
-	 [2] = { "kmem", 0, &kmem_fops, FMODE_UNSIGNED_OFFSET },
-#endif
 	 [3] = { "null", 0666, &null_fops, 0 },
 #ifdef CONFIG_DEVPORT
 	 [4] = { "port", 0, &port_fops, 0 },
--- a/include/linux/fs.h~drivers-char-remove-dev-kmem-for-good
+++ a/include/linux/fs.h
@@ -145,7 +145,7 @@ typedef int (dio_iodone_t)(struct kiocb
 /* Expect random access pattern */
 #define FMODE_RANDOM		((__force fmode_t)0x1000)
 
-/* File is huge (eg. /dev/kmem): treat loff_t as unsigned */
+/* File is huge (eg. /dev/mem): treat loff_t as unsigned */
 #define FMODE_UNSIGNED_OFFSET	((__force fmode_t)0x2000)
 
 /* File is opened with O_PATH; almost nothing can be done with it */
--- a/include/linux/vmalloc.h~drivers-char-remove-dev-kmem-for-good
+++ a/include/linux/vmalloc.h
@@ -227,7 +227,7 @@ static inline void set_vm_flush_reset_pe
 }
 #endif
 
-/* for /dev/kmem */
+/* for /proc/kcore */
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
 
--- a/kernel/configs/android-base.config~drivers-char-remove-dev-kmem-for-good
+++ a/kernel/configs/android-base.config
@@ -1,5 +1,4 @@
 #  KEEP ALPHABETICALLY SORTED
-# CONFIG_DEVKMEM is not set
 # CONFIG_DEVMEM is not set
 # CONFIG_FHANDLE is not set
 # CONFIG_INET_LRO is not set
--- a/mm/ksm.c~drivers-char-remove-dev-kmem-for-good
+++ a/mm/ksm.c
@@ -459,7 +459,7 @@ static inline bool ksm_test_exit(struct
  * but taking great care only to touch a ksm page, in a VM_MERGEABLE vma,
  * in case the application has unmapped and remapped mm,addr meanwhile.
  * Could a ksm page appear anywhere else?  Actually yes, in a VM_PFNMAP
- * mmap of /dev/mem or /dev/kmem, where we would not want to touch it.
+ * mmap of /dev/mem, where we would not want to touch it.
  *
  * FAULT_FLAG/FOLL_REMOTE are because we do this outside the context
  * of the process that owns 'vma'.  We also do not want to enforce
--- a/mm/vmalloc.c~drivers-char-remove-dev-kmem-for-good
+++ a/mm/vmalloc.c
@@ -3219,7 +3219,7 @@ static int aligned_vwrite(char *buf, cha
  * Note: In usual ops, vread() is never necessary because the caller
  * should know vmalloc() area is valid and can use memcpy().
  * This is for routines which have to access vmalloc area without
- * any information, as /dev/kmem.
+ * any information, as /proc/kcore.
  *
  * Return: number of bytes for which addr and buf should be increased
  * (same number as @count) or %0 if [addr...addr+count) doesn't
_
