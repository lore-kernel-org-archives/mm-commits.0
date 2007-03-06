From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-documentation-update-flags.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:42:00 -0800
Message-ID: <200703060142.l261g0oL008112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45888 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811AbXCFBmI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-documentation-update-flags
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-documentation-update-flags.patch

This patch was dropped because it was folded into linux-kernel-markers-documentation.patch

------------------------------------------------------
Subject: linux-kernel-markers-documentation-update-flags
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

linux-kernel-markers-documentation-update-flags

Documents the flag usage.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-update-flags Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-update-flags
+++ a/Documentation/marker.txt
@@ -78,6 +78,21 @@ which saves a data cache hit, but also r
 order to support embedded systems which use read-only memory for their code, the
 optimization can be disabled through menu options.
 
+The MF_* flags can be used to control the type of marker. See the
+include/marker.h header for the list of flags. They can be specified as the
+first parameter of the _MARK() macro, such as the following example which is
+safe wrt lockdep.c (useful for marking lockdep.c functions).
+
+_MARK(_MF_DEFAULT | ~_MF_LOCKDEP, subsystem_eventb,
+  MARK_NOARGS);
+
+Another example is to specify that a specific marker must never call printk :
+_MARK(_MF_DEFAULT | ~_MF_PRINTK, subsystem_eventc,
+  "%d %s %p[struct task_struct]",
+  someint, somestring, current);
+
+Flag compatibility is checked before connecting the probe to the marker.
+
 
 * Probe example
 
@@ -122,6 +137,13 @@ void probe_subsystem_event(const char *f
 	va_end(ap);
 }
 
+#define SUBSYSTEM_EVENTB_FORMAT MARK_NOARGS
+void probe_subsystem_eventb(const char *format, ...)
+{
+	/* Increment counters, trace, ... but _never_ generate a call to
+	 * lockdep.c ! */
+}
+
 static int __init probe_init(void)
 {
 	int result;
@@ -130,16 +152,24 @@ static int __init probe_init(void)
 			probe_subsystem_event);
 	if (!result)
 		goto cleanup;
+	result = _marker_set_probe(_MF_DEFAULT & ~_MF_LOCKDEP,
+			"subsystem_eventb",
+			SUBSYSTEM_EVENTB_FORMAT,
+			probe_subsystem_eventb);
+	if (!result)
+		goto cleanup;
 	return 0;
 
 cleanup:
 	marker_remove_probe(probe_subsystem_event);
+	marker_remove_probe(probe_subsystem_eventb);
 	return -EPERM;
 }
 
 static void __exit probe_fini(void)
 {
 	marker_remove_probe(probe_subsystem_event);
+	marker_remove_probe(probe_subsystem_eventb);
 }
 
 module_init(probe_init);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update-flags.patch
