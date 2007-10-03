From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-samples-coding-style-fix.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:21:29 -0700
Message-ID: <200710032121.l93LLTsG009320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686AbXJCVZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au


The patch titled
     Linux Kernel Markers - Samples Coding Style Fix
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-samples-coding-style-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers - Samples Coding Style Fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

- Change struct __mark_marker to struct marker.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN samples/markers/probe-example.c~linux-kernel-markers-samples-coding-style-fix samples/markers/probe-example.c
--- a/samples/markers/probe-example.c~linux-kernel-markers-samples-coding-style-fix
+++ a/samples/markers/probe-example.c
@@ -20,8 +20,8 @@ struct probe_data {
 	marker_probe_func *probe_func;
 };
 
-void probe_subsystem_event(const struct __mark_marker *mdata,
-		void *private, const char *format, ...)
+void probe_subsystem_event(const struct marker *mdata, void *private,
+	const char *format, ...)
 {
 	va_list ap;
 	/* Declare args */
@@ -43,8 +43,8 @@ void probe_subsystem_event(const struct 
 
 atomic_t eventb_count = ATOMIC_INIT(0);
 
-void probe_subsystem_eventb(const struct __mark_marker *mdata,
-	void *private, const char *format, ...)
+void probe_subsystem_eventb(const struct marker *mdata, void *private,
+	const char *format, ...)
 {
 	/* Increment counter */
 	atomic_inc(&eventb_count);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-documentation.patch
