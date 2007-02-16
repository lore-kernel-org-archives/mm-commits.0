From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 20:20:58 -0800
Message-ID: <200702160420.l1G4Kwb3019170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161745AbXBPEVI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 23:21:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, rdunlap@xenotime.net


The patch titled
     Linux Kernel Markers Documentation - fix
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers Documentation - fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Linux Kernel Markers Documentation - fix

Fixes from Randy's comments.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-fix Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-fix
+++ a/Documentation/marker.txt
@@ -18,7 +18,7 @@ code is reached.
 
 They can be used for tracing (LTTng, LKET over SystemTAP), overall performance
 accounting (SystemTAP). They could also be used to implement
-efficient hooks for SELinux or any other subsystem the would have this
+efficient hooks for SELinux or any other subsystem that would have this
 kind of need.
 
 Using the markers for system audit (SELinux) would require to pass a
@@ -30,8 +30,9 @@ variable by address that would be later 
 MARK(subsystem_event, "%d %s %p[struct task_struct]",
   someint, somestring, current);
 Where :
-- Subsystem is the name of your subsystem.
-- event is the name of the event to mark.
+- subsystem_event is an identifier unique to your event
+    - subsystem is the name of your subsystem.
+    - event is the name of the event to mark.
 - "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
 - someint is an integer.
 - somestring is a char pointer.
@@ -39,7 +40,7 @@ Where :
 
 The expression %p[struct task_struct] is a suggested marker definition
 standard that could eventually be used for pointer type checking in
-sparse. The brackets contain the type to which the pointer refer.
+sparse. The brackets contain the type to which the pointer refers.
 
 The marker mechanism supports multiple instances of the same marker.
 Markers can be put in inline functions, inlined static functions and
@@ -104,8 +105,8 @@ static int __init probe_init(void)
 {
 	int result;
 	result = marker_set_probe("subsystem_event",
-			FS_CLOSE_FORMAT,
-			probe_fs_close);
+			SUBSYSTEM_EVENT_FORMAT,
+			probe_subsystem_event);
 	if (!result)
 		goto cleanup;
 	return 0;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
git-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64_xchg-to-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
