From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-fix-samples-to-follow-format-string-standard.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:02 -0800
Message-ID: <200711152110.lAFLA2ow015518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507AbXKOVQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: fix samples to follow format string standard
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-fix-samples-to-follow-format-string-standard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Linux Kernel Markers: fix samples to follow format string standard
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Add the field names to marker example format string.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/markers/marker-example.c |    3 ++-
 samples/markers/probe-example.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN samples/markers/marker-example.c~linux-kernel-markers-fix-samples-to-follow-format-string-standard samples/markers/marker-example.c
--- a/samples/markers/marker-example.c~linux-kernel-markers-fix-samples-to-follow-format-string-standard
+++ a/samples/markers/marker-example.c
@@ -19,7 +19,8 @@ static int my_open(struct inode *inode, 
 {
 	int i;
 
-	trace_mark(subsystem_event, "%d %s", 123, "example string");
+	trace_mark(subsystem_event, "integer %d string %s", 123,
+		"example string");
 	for (i = 0; i < 10; i++)
 		trace_mark(subsystem_eventb, MARK_NOARGS);
 	return -EPERM;
diff -puN samples/markers/probe-example.c~linux-kernel-markers-fix-samples-to-follow-format-string-standard samples/markers/probe-example.c
--- a/samples/markers/probe-example.c~linux-kernel-markers-fix-samples-to-follow-format-string-standard
+++ a/samples/markers/probe-example.c
@@ -53,7 +53,7 @@ void probe_subsystem_eventb(const struct
 static struct probe_data probe_array[] =
 {
 	{	.name = "subsystem_event",
-		.format = "%d %s",
+		.format = "integer %d string %s",
 		.probe_func = probe_subsystem_event },
 	{	.name = "subsystem_eventb",
 		.format = MARK_NOARGS,
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
