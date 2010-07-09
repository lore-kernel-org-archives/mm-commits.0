From: akpm@linux-foundation.org
Subject: + serial-mmio32-support-for-8250_earlyc-fix-fix.patch added to -mm tree
Date: Fri, 09 Jul 2010 15:47:10 -0700
Message-ID: <201007092247.o69MlAOX029882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755223Ab0GIWrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 18:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, _deepfire@feelingofgreen.ru, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com


The patch titled
     serial-mmio32-support-for-8250_earlyc-fix-fix
has been added to the -mm tree.  Its filename is
     serial-mmio32-support-for-8250_earlyc-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial-mmio32-support-for-8250_earlyc-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix printk args some more

Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_early.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/serial/8250_early.c~serial-mmio32-support-for-8250_earlyc-fix-fix drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-mmio32-support-for-8250_earlyc-fix-fix
+++ a/drivers/serial/8250_early.c
@@ -202,12 +202,16 @@ static int __init parse_options(struct e
 	}
 
 	if (mmio || mmio32)
-		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
-		       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
-		       device->options);
+		printk(KERN_INFO
+		       "Early serial console at MMIO%s 0x%llu (options '%s')\n",
+			mmio32 ? "32" : "",
+			(unsigned long long)port->mapbase,
+			device->options);
 	else
-		printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
-		       (void *) port->iobase, device->options);
+		printk(KERN_INFO
+		      "Early serial console at I/O port 0x%lu (options '%s')\n",
+			port->iobase,
+			device->options);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
x86-numa-fix-boot-without-ram-on-node0-again-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
acpi-fix-bogus-preemption-logic-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
serial-mmio32-support-for-8250_earlyc-fix-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

