From: akpm@linux-foundation.org
Subject: + make-kernel-power-maincsuspend_enter-static.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:09:36 -0700
Message-ID: <200708162109.l7GL9aU7006871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbXHPVJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     make kernel/power/main.c:suspend_enter() static
has been added to the -mm tree.  Its filename is
     make-kernel-power-maincsuspend_enter-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make kernel/power/main.c:suspend_enter() static
From: Adrian Bunk <bunk@kernel.org>

suspend_enter() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/main.c~make-kernel-power-maincsuspend_enter-static kernel/power/main.c
--- a/kernel/power/main.c~make-kernel-power-maincsuspend_enter-static
+++ a/kernel/power/main.c
@@ -128,7 +128,7 @@ void __attribute__ ((weak)) arch_suspend
  *
  *	This function should be called after devices have been suspended.
  */
-int suspend_enter(suspend_state_t state)
+static int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
if-0-v9fs_fid_lookup_remove.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
