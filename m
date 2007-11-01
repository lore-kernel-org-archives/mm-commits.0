From: akpm@linux-foundation.org
Subject: + make-kernel_shutdown_prepare-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:23:09 -0700
Message-ID: <200711010723.lA17N98C018010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbXKAHX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     make kernel_shutdown_prepare() static
has been added to the -mm tree.  Its filename is
     make-kernel_shutdown_prepare-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make kernel_shutdown_prepare() static
From: Adrian Bunk <bunk@kernel.org>

kernel_shutdown_prepare() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    2 --
 kernel/sys.c           |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/reboot.h~make-kernel_shutdown_prepare-static include/linux/reboot.h
--- a/include/linux/reboot.h~make-kernel_shutdown_prepare-static
+++ a/include/linux/reboot.h
@@ -59,8 +59,6 @@ extern void machine_crash_shutdown(struc
  * Architecture independent implemenations of sys_reboot commands.
  */
 
-extern void kernel_shutdown_prepare(enum system_states state);
-
 extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
diff -puN kernel/sys.c~make-kernel_shutdown_prepare-static kernel/sys.c
--- a/kernel/sys.c~make-kernel_shutdown_prepare-static
+++ a/kernel/sys.c
@@ -315,7 +315,7 @@ static void kernel_kexec(void)
 #endif
 }
 
-void kernel_shutdown_prepare(enum system_states state)
+static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
 		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
fs-ecryptfs-possible-cleanups.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
