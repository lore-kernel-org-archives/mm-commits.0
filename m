From: akpm@osdl.org
Subject: - fix-uml-on-non-standard-vm-split-hosts.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:30 -0800
Message-ID: <200701270132.l0R1WUud031935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXA0BeI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:34:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, shindepravin@gmail.com, stable@kernel.org, uml@flonatel.org, mm-commits@vger.kernel.org


The patch titled
     Fix UML on non-standard VM split hosts
has been removed from the -mm tree.  Its filename was
     fix-uml-on-non-standard-vm-split-hosts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix UML on non-standard VM split hosts
From: Jeff Dike <jdike@addtoit.com>

This fixes UML on hosts with non-standard VM splits.  We had changed the
config variable that controls UML behavior on such hosts, but not
propogated the change everywhere.  In particular, the values of STUB_CODE
and STUB_DATA relied on the old variable.

I also reformatted the HOST_VMSPLIT_3G help to make it more standard.

Spotted by uml@flonatel.org.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Blaisorblade <blaisorblade@yahoo.it>
Cc: Pravin <shindepravin@gmail.com>
Cc: <uml@flonatel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/Kconfig.i386 |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN arch/um/Kconfig.i386~fix-uml-on-non-standard-vm-split-hosts arch/um/Kconfig.i386
--- a/arch/um/Kconfig.i386~fix-uml-on-non-standard-vm-split-hosts
+++ a/arch/um/Kconfig.i386
@@ -19,22 +19,22 @@ config SEMAPHORE_SLEEPERS
 choice
 	prompt "Host memory split"
 	default HOST_VMSPLIT_3G
-	---help---
-	   This is needed when the host kernel on which you run has a non-default
-	   (like 2G/2G) memory split, instead of the customary 3G/1G. If you did
-	   not recompile your own kernel but use the default distro's one, you can
-	   safely accept the "Default split" option.
-
-	   It can be enabled on recent (>=2.6.16-rc2) vanilla kernels via
-	   CONFIG_VM_SPLIT_*, or on previous kernels with special patches (-ck
-	   patchset by Con Kolivas, or other ones) - option names match closely the
-	   host CONFIG_VM_SPLIT_* ones.
-
-	   A lower setting (where 1G/3G is lowest and 3G/1G is higher) will
-	   tolerate even more "normal" host kernels, but an higher setting will be
-	   stricter.
+	help
+        This is needed when the host kernel on which you run has a non-default
+	(like 2G/2G) memory split, instead of the customary 3G/1G. If you did
+	not recompile your own kernel but use the default distro's one, you can
+	safely accept the "Default split" option.
+
+	It can be enabled on recent (>=2.6.16-rc2) vanilla kernels via
+	CONFIG_VM_SPLIT_*, or on previous kernels with special patches (-ck
+	patchset by Con Kolivas, or other ones) - option names match closely the
+	host CONFIG_VM_SPLIT_* ones.
+
+	A lower setting (where 1G/3G is lowest and 3G/1G is higher) will
+	tolerate even more "normal" host kernels, but an higher setting will be
+	stricter.
 
-	   So, if you do not know what to do here, say 'Default split'.
+	So, if you do not know what to do here, say 'Default split'.
 
 	config HOST_VMSPLIT_3G
 		bool "Default split (3G/1G user/kernel host split)"
@@ -67,13 +67,13 @@ config 3_LEVEL_PGTABLES
 
 config STUB_CODE
 	hex
-	default 0xbfffe000 if !HOST_2G_2G
-	default 0x7fffe000 if HOST_2G_2G
+	default 0xbfffe000 if !HOST_VMSPLIT_2G
+	default 0x7fffe000 if HOST_VMSPLIT_2G
 
 config STUB_DATA
 	hex
-	default 0xbffff000 if !HOST_2G_2G
-	default 0x7ffff000 if HOST_2G_2G
+	default 0xbffff000 if !HOST_VMSPLIT_2G
+	default 0x7ffff000 if HOST_VMSPLIT_2G
 
 config STUB_START
 	hex
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-mknod.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
