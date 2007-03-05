From: akpm@linux-foundation.org
Subject: + div64_64-common-code-fix.patch added to -mm tree
Date: Sun, 04 Mar 2007 16:41:18 -0800
Message-ID: <200703050041.l250fI9u005204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54078 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbXCEAlU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Mar 2007 19:41:20 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l250fIq8001354
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 4 Mar 2007 16:41:19 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, shemminger@linux-foundation.org


The patch titled
     div64_64-common-code-fix
has been added to the -mm tree.  Its filename is
     div64_64-common-code-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: div64_64-common-code-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from lib/reciprocal_div.c:2:
include/asm/div64.h:49: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'div64_64'

Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/div64.h    |    1 +
 include/asm-i386/div64.h   |    2 ++
 include/asm-m68k/div64.h   |    2 ++
 include/asm-mips/div64.h   |    2 ++
 include/asm-xtensa/div64.h |    2 ++
 5 files changed, 9 insertions(+)

diff -puN include/asm-arm/div64.h~div64_64-common-code-fix include/asm-arm/div64.h
--- a/include/asm-arm/div64.h~div64_64-common-code-fix
+++ a/include/asm-arm/div64.h
@@ -2,6 +2,7 @@
 #define __ASM_ARM_DIV64
 
 #include <asm/system.h>
+#include <linux/types.h>
 
 /*
  * The semantics of do_div() are:
diff -puN include/asm-i386/div64.h~div64_64-common-code-fix include/asm-i386/div64.h
--- a/include/asm-i386/div64.h~div64_64-common-code-fix
+++ a/include/asm-i386/div64.h
@@ -1,6 +1,8 @@
 #ifndef __I386_DIV64
 #define __I386_DIV64
 
+#include <linux/types.h>
+
 /*
  * do_div() is NOT a C function. It wants to return
  * two values (the quotient and the remainder), but
diff -puN include/asm-m68k/div64.h~div64_64-common-code-fix include/asm-m68k/div64.h
--- a/include/asm-m68k/div64.h~div64_64-common-code-fix
+++ a/include/asm-m68k/div64.h
@@ -1,6 +1,8 @@
 #ifndef _M68K_DIV64_H
 #define _M68K_DIV64_H
 
+#include <linux/types.h>
+
 /* n = n / base; return rem; */
 
 #define do_div(n, base) ({					\
diff -puN include/asm-mips/div64.h~div64_64-common-code-fix include/asm-mips/div64.h
--- a/include/asm-mips/div64.h~div64_64-common-code-fix
+++ a/include/asm-mips/div64.h
@@ -9,6 +9,8 @@
 #ifndef _ASM_DIV64_H
 #define _ASM_DIV64_H
 
+#include <linux/types.h>
+
 #if (_MIPS_SZLONG == 32)
 
 #include <asm/compiler.h>
diff -puN include/asm-xtensa/div64.h~div64_64-common-code-fix include/asm-xtensa/div64.h
--- a/include/asm-xtensa/div64.h~div64_64-common-code-fix
+++ a/include/asm-xtensa/div64.h
@@ -11,6 +11,8 @@
 #ifndef _XTENSA_DIV64_H
 #define _XTENSA_DIV64_H
 
+#include <linux/types.h>
+
 #define do_div(n,base) ({ \
 	int __res = n % ((unsigned int) base); \
 	n /= (unsigned int) base; \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
md-fix-for-raid6-reshape-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
ide-ide-fix-pmac-breakage-fix.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
