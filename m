From: akpm@linux-foundation.org
Subject: - make-the-dummy-touchkit_ps2_detect-static.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:35 -0700
Message-ID: <200708310634.l7V6YZNt027708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354AbXHaGep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     make the dummy touchkit_ps2_detect() static
has been removed from the -mm tree.  Its filename was
     make-the-dummy-touchkit_ps2_detect-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make the dummy touchkit_ps2_detect() static
From: Adrian Bunk <bunk@kernel.org>

The dummy touchkit_ps2_detect() for the CONFIG_MOUSE_PS2_TOUCHKIT=n case
shouldn't be a global function.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/touchkit_ps2.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/input/mouse/touchkit_ps2.h~make-the-dummy-touchkit_ps2_detect-static drivers/input/mouse/touchkit_ps2.h
--- a/drivers/input/mouse/touchkit_ps2.h~make-the-dummy-touchkit_ps2_detect-static
+++ a/drivers/input/mouse/touchkit_ps2.h
@@ -15,7 +15,8 @@
 #ifdef CONFIG_MOUSE_PS2_TOUCHKIT
 int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties);
 #else
-inline int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties)
+static inline int touchkit_ps2_detect(struct psmouse *psmouse,
+				      int set_properties)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
arm-extern-inline-static-inline.patch
ppc-remove-apus-support.patch
git-dvb.patch
ivtv-fbc-bugfix.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
