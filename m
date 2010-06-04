From: akpm@linux-foundation.org
Subject: + printk-fix-delayed-messages-from-cpu-hotplug-events-fix.patch added to -mm tree
Date: Thu, 03 Jun 2010 22:59:03 -0700
Message-ID: <201006040559.o545wx34009961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab0FDF7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 01:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cernekee@gmail.com, lethal@linux-sh.org


The patch titled
     printk-fix-delayed-messages-from-cpu-hotplug-events-fix
has been added to the -mm tree.  Its filename is
     printk-fix-delayed-messages-from-cpu-hotplug-events-fix.patch

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
Subject: printk-fix-delayed-messages-from-cpu-hotplug-events-fix
From: Andrew Morton <akpm@linux-foundation.org>

use the hotcpu_notifier() helper

Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN kernel/printk.c~printk-fix-delayed-messages-from-cpu-hotplug-events-fix kernel/printk.c
--- a/kernel/printk.c~printk-fix-delayed-messages-from-cpu-hotplug-events-fix
+++ a/kernel/printk.c
@@ -1009,10 +1009,6 @@ static int __cpuinit console_cpu_notify(
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata console_nb = {
-	.notifier_call		= console_cpu_notify,
-};
-
 /**
  * acquire_console_sem - lock the console system for exclusive use.
  *
@@ -1411,7 +1407,7 @@ static int __init printk_late_init(void)
 			unregister_console(con);
 		}
 	}
-	register_hotcpu_notifier(&console_nb);
+	hotcpu_notifier(console_cpu_notify, 0);
 	return 0;
 }
 late_initcall(printk_late_init);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
printk-fix-delayed-messages-from-cpu-hotplug-events-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

