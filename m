From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-samples-coding-style-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:36:40 -0700
Message-ID: <200710190436.l9J4aenR015410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbXJSEg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers - Samples Coding Style Fix
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-samples-coding-style-fix.patch

This patch was dropped because it was folded into linux-kernel-markers-samples.patch

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

origin.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-samples-remove-asm.patch
linux-kernel-markers-documentation.patch
