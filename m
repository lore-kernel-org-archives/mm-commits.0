From: akpm@linux-foundation.org
Subject: + cpwatchdog-build-fix.patch added to -mm tree
Date: Sun, 15 Jul 2007 23:28:13 -0700
Message-ID: <200707160632.l6G6WZ30013749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbXGPGcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 02:32:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net


The patch titled
     cpwatchdog build fix
has been added to the -mm tree.  Its filename is
     cpwatchdog-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpwatchdog build fix
From: Andrew Morton <akpm@linux-foundation.org>

sparc64:

drivers/sbus/char/cpwatchdog.c: In function `wd_toggleintr':
drivers/sbus/char/cpwatchdog.c:523: error: implicit declaration of function `readb'
drivers/sbus/char/cpwatchdog.c:533: error: implicit declaration of function `writeb'
drivers/sbus/char/cpwatchdog.c: In function `wd_pingtimer':
drivers/sbus/char/cpwatchdog.c:545: error: implicit declaration of function `readw'
drivers/sbus/char/cpwatchdog.c: In function `wd_starttimer':
drivers/sbus/char/cpwatchdog.c:584: error: implicit declaration of function `writew'
drivers/sbus/char/cpwatchdog.c: In function `wd_init':
drivers/sbus/char/cpwatchdog.c:767: error: implicit declaration of function `ioremap'
drivers/sbus/char/cpwatchdog.c:767: warning: assignment makes pointer from integer without a cast
drivers/sbus/char/cpwatchdog.c: In function `wd_cleanup':
drivers/sbus/char/cpwatchdog.c:849: error: implicit declaration of function `iounmap'

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/cpwatchdog.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/sbus/char/cpwatchdog.c~cpwatchdog-build-fix drivers/sbus/char/cpwatchdog.c
--- a/drivers/sbus/char/cpwatchdog.c~cpwatchdog-build-fix
+++ a/drivers/sbus/char/cpwatchdog.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/smp_lock.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/ebus.h>
 #include <asm/oplib.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
authgss-build-fix.patch
lib-add-idr_for_each.patch
change-zonelist-order-zonelist-order-selection-logic.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default.patch
fix-alpha-isa-support.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
fix-rmmod-read-write-races-in-proc-entries.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
vdso-print-fatal-signals.patch
o_cloexec-for-scm_rights.patch
atmel_serial-fix-break-handling.patch
ext3-ext4-orphan-list-check-on-destroy_inode.patch
taskstats-add-context-switch-counters.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
diskquota-32bit-quota-tools-on-64bit-architectures.patch
sys_time-speedup.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
hfs-refactor-ascii-to-unicode-conversion-routine.patch
sprint_symbol-cleanup.patch
replace-obscure-constructs-in-fs-block_devc.patch
bd_claim_by_disk-fix-warning.patch
uninline-check_signature.patch
cpwatchdog-build-fix.patch
