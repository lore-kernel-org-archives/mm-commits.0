From: akpm@linux-foundation.org
Subject: [merged] input-fix-build-failures-caused-by-kconfig-winbond-wpcd376i-consumer-ir-hardware-driver-kconfig-entry.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:33:19 -0700
Message-ID: <200909241933.n8OJXJSZ028605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbZIXTd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, david@hardeman.nu, dtor@mail.ru, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     input: fix build failures caused by Kconfig Winbond WPCD376I Consu=
mer IR hardware driver Kconfig entry
has been removed from the -mm tree.  Its filename was
     input-fix-build-failures-caused-by-kconfig-winbond-wpcd376i-consum=
er-ir-hardware-driver-kconfig-entry.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: fix build failures caused by Kconfig Winbond WPCD376I C=
onsumer IR hardware driver Kconfig entry
=46rom: Ingo Molnar <mingo@elte.hu>

drivers/built-in.o: In function `apanel_remove':
apanel.c:(.text+0x56e852): undefined reference to `led_classdev_unregis=
ter'
drivers/built-in.o: In function `apanel_probe':
apanel.c:(.text+0x56eae3): undefined reference to `led_classdev_registe=
r'
drivers/built-in.o: In function `acpi_fujitsu_hotkey_add':
fujitsu-laptop.c:(.text+0x5d7647): undefined reference to `led_classdev=
_register'
fujitsu-laptop.c:(.text+0x5d76b5): undefined reference to `led_classdev=
_register'
drivers/built-in.o: In function `wbcir_probe':
winbond-cir.c:(.devinit.text+0x5f375): undefined reference to `led_clas=
sdev_register'
winbond-cir.c:(.devinit.text+0x5f663): undefined reference to `led_clas=
sdev_unregister'
drivers/built-in.o: In function `wbcir_remove':
winbond-cir.c:(.devexit.text+0x7f23): undefined reference to `led_class=
dev_unregister'
drivers/built-in.o: In function `fujitsu_cleanup':
fujitsu-laptop.c:(.exit.text+0xbe37): undefined reference to `led_class=
dev_unregister'
fujitsu-laptop.c:(.exit.text+0xbe53): undefined reference to `led_class=
dev_unregister'

It happens because the new INPUT_WINBOND_CIR driver relies on new-leds
infrastructure - but does not select it in drivers/input/misc/Kconfig.=20
But it selects LEDS_CLASS, which confuses a number of other drivers int=
o
thinking that all the leds infrastructure is in place.

=46ix this by selecting NEW_LEDS as well, like similar drivers do.

Eventually, this whole leds infrastructure complexity should be
cleaned up, it's been going on for years.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: David H=E4rdeman <david@hardeman.nu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/misc/Kconfig~input-fix-build-failures-caused-by=
-kconfig-winbond-wpcd376i-consumer-ir-hardware-driver-kconfig-entry dri=
vers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~input-fix-build-failures-caused-by-kco=
nfig-winbond-wpcd376i-consumer-ir-hardware-driver-kconfig-entry
+++ a/drivers/input/misc/Kconfig
@@ -225,6 +225,7 @@ config INPUT_SGI_BTNS
 config INPUT_WINBOND_CIR
 	tristate "Winbond IR remote control"
 	depends on X86 && PNP
+	select NEW_LEDS
 	select LEDS_CLASS
 	select BITREVERSE
 	help
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by=
-using-smp_call_function_any.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
x86-_end-symbol-missing-from-symbolmap.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-l=
ist.patch
make-frame_pointer-default=3Dy.patch
mutex-subsystem-synchro-test-module.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
