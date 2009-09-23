From: akpm@linux-foundation.org
Subject: + input-fix-build-failures-caused-by-kconfig-winbond-wpcd376i-consumer-ir-hardware-driver-kconfig-entry.patch added to -mm tree
Date: Wed, 23 Sep 2009 00:44:15 -0700
Message-ID: <200909230744.n8N7iFPV016469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbZIWHpK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 03:45:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, david@hardeman.nu, dtor@mail.ru, jbarnes@virtuousgeek.org


The patch titled
     input: fix build failures caused by Kconfig Winbond WPCD376I Consu=
mer IR hardware driver Kconfig entry
has been added to the -mm tree.  Its filename is
     input-fix-build-failures-caused-by-kconfig-winbond-wpcd376i-consum=
er-ir-hardware-driver-kconfig-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kprobes-use-do_irq-in-lkdtm.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.pa=
tch
generic-ipi-make-struct-call_function_data-lockless.patch
getrusage-fill-ru_maxrss-value.patch
kallsyms-fix-segfault-in-prefix_underscores_count.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.pa=
tch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
procfs-provide-stack-information-for-threads-v08.patch
input-fix-build-failures-caused-by-kconfig-winbond-wpcd376i-consumer-ir=
-hardware-driver-kconfig-entry.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by=
-using-smp_call_function_any.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
x86-_end-symbol-missing-from-symbolmap.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time=
-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time=
=2Epatch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time=
-fix.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_chil=
d-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wak=
eup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wak=
eup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.=
patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-l=
ist.patch
wait_consider_task-kill-parent-argument.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.=
patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch
edac-i3200-memory-controller-driver.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels=
=2Epatch
make-frame_pointer-default=3Dy.patch
mutex-subsystem-synchro-test-module.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
