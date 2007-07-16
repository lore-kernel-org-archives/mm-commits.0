From: akpm@linux-foundation.org
Subject: + authgss-build-fix.patch added to -mm tree
Date: Sun, 15 Jul 2007 21:59:44 -0700
Message-ID: <200707160504.l6G547bK008982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbXGPFEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 01:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     authgss build fix
has been added to the -mm tree.  Its filename is
     authgss-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: authgss build fix
From: Andrew Morton <akpm@linux-foundation.org>

Recent breakage..

net/sunrpc/auth_gss/auth_gss.c:1002: warning: implicit declaration of function 'lock_kernel'
net/sunrpc/auth_gss/auth_gss.c:1004: warning: implicit declaration of function 'unlock_kernel'

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/auth_gss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/sunrpc/auth_gss/auth_gss.c~authgss-build-fix net/sunrpc/auth_gss/auth_gss.c
--- a/net/sunrpc/auth_gss/auth_gss.c~authgss-build-fix
+++ a/net/sunrpc/auth_gss/auth_gss.c
@@ -43,6 +43,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/auth.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
authgss-build-fix.patch
