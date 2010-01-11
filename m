From: akpm@linux-foundation.org
Subject: [merged] fix-several-bogus-includes-on-mn10300-abs2305.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:27 -0800
Message-ID: <201001112019.o0BKJRKx025570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120Ab0AKUU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:20:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@zeniv.linux.org.uk, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: fix several bogus includes on abs2305
has been removed from the -mm tree.  Its filename was
     fix-several-bogus-includes-on-mn10300-abs2305.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: fix several bogus includes on abs2305
From: Al Viro <viro@zeniv.linux.org.uk>

asm/cpu never existed for mn10300; the files they are looking for are in
asm.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/include/unit/serial.h |    2 +-
 arch/mn10300/unit-asb2305/include/unit/timex.h  |    2 +-
 arch/mn10300/unit-asb2305/leds.c                |    4 ++--
 arch/mn10300/unit-asb2305/unit-init.c           |    5 ++---
 4 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/mn10300/unit-asb2305/include/unit/serial.h~fix-several-bogus-includes-on-mn10300-abs2305 arch/mn10300/unit-asb2305/include/unit/serial.h
--- a/arch/mn10300/unit-asb2305/include/unit/serial.h~fix-several-bogus-includes-on-mn10300-abs2305
+++ a/arch/mn10300/unit-asb2305/include/unit/serial.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_UNIT_SERIAL_H
 #define _ASM_UNIT_SERIAL_H
 
-#include <asm/cpu/cpu-regs.h>
+#include <asm/cpu-regs.h>
 #include <proc/irq.h>
 #include <linux/serial_reg.h>
 
diff -puN arch/mn10300/unit-asb2305/include/unit/timex.h~fix-several-bogus-includes-on-mn10300-abs2305 arch/mn10300/unit-asb2305/include/unit/timex.h
--- a/arch/mn10300/unit-asb2305/include/unit/timex.h~fix-several-bogus-includes-on-mn10300-abs2305
+++ a/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -15,7 +15,7 @@
 #include <linux/irq.h>
 #endif /* __ASSEMBLY__ */
 
-#include <asm/cpu/timer-regs.h>
+#include <asm/timer-regs.h>
 #include <unit/clock.h>
 
 /*
diff -puN arch/mn10300/unit-asb2305/leds.c~fix-several-bogus-includes-on-mn10300-abs2305 arch/mn10300/unit-asb2305/leds.c
--- a/arch/mn10300/unit-asb2305/leds.c~fix-several-bogus-includes-on-mn10300-abs2305
+++ a/arch/mn10300/unit-asb2305/leds.c
@@ -13,8 +13,8 @@
 #include <linux/init.h>
 #include <asm/io.h>
 #include <asm/processor.h>
-#include <asm/cpu/intctl-regs.h>
-#include <asm/cpu/rtc-regs.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc-regs.h>
 #include <unit/leds.h>
 
 static const u8 asb2305_led_hex_tbl[16] = {
diff -puN arch/mn10300/unit-asb2305/unit-init.c~fix-several-bogus-includes-on-mn10300-abs2305 arch/mn10300/unit-asb2305/unit-init.c
--- a/arch/mn10300/unit-asb2305/unit-init.c~fix-several-bogus-includes-on-mn10300-abs2305
+++ a/arch/mn10300/unit-asb2305/unit-init.c
@@ -15,9 +15,8 @@
 #include <asm/io.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
-#include <asm/cpu/intctl-regs.h>
-#include <asm/cpu/rtc-regs.h>
-#include <asm/cpu/serial-regs.h>
+#include <asm/intctl-regs.h>
+#include <asm/serial-regs.h>
 #include <unit/serial.h>
 
 /*
_

Patches currently in -mm which might be from viro@zeniv.linux.org.uk are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-improve-comment-describing-fget_light.patch
ecryptfs-another-lockdep-issue.patch
fs-improve-remountro-vs-buffercache-coherency.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
single_open-seq_release-leak-diagnostics.patch

