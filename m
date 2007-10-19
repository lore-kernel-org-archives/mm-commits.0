From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-alignment-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:35:26 -0700
Message-ID: <200710190435.l9J4ZQwX015385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966680AbXJSEgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, fche@redhat.com, hch@infradead.org, mmlnx@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers - Alignment Fix
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-alignment-fix.patch

This patch was dropped because it was folded into linux-kernel-markers.patch

------------------------------------------------------
Subject: Linux Kernel Markers - Alignment Fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Fix the alignment of the struct marker declaration in the trace_mark()
macro.  Otherwise, we run into problems on 64 bits architectures where the
struct marker structure is bigger than 32 bytes : gcc becomes
alignment-happy and align these structures on 32 bytes while the iteration
on the markers is itself only aligned on 8 bytes, as specified by the type
attribute.  Specifying the alignmentof the type only is not enough to
restrain gcc happiness; we must specify a variable alignment attribute too.

This bug causes NULL pointer dereference at module load time on x86_64 when
we load marker-example.ko.

Thanks to Mike Mason for reporting this.

It applies to 2.6.23-rc8-mm2, after the linux kernel markers coding style
fixes. This is an important bugfix that should be merged with the
markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Mason <mmlnx@us.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/marker.h~linux-kernel-markers-alignment-fix include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-alignment-fix
+++ a/include/linux/marker.h
@@ -58,7 +58,7 @@ struct marker {
 		__attribute__((section("__markers_strings")))		\
 		= format;						\
 		static struct marker __mark_##name			\
-		__attribute__((section("__markers"))) =			\
+		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
 		asm volatile("" : : "i" (&__mark_##name));		\
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-samples-remove-asm.patch
linux-kernel-markers-documentation.patch
