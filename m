From: akpm@linux-foundation.org
Subject: - reduce-size-of-task_struct-on-64-bit-machines-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 13:27:51 -0800
Message-ID: <200702202129.l1KLTFGw020241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50123 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030447AbXBTV3Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 16:29:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wcohen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     reduce-size-of-task_struct-on-64-bit-machines-fix
has been removed from the -mm tree.  Its filename was
     reduce-size-of-task_struct-on-64-bit-machines-fix.patch

This patch was dropped because it was folded into reduce-size-of-task_struct-on-64-bit-machines.patch

------------------------------------------------------
Subject: reduce-size-of-task_struct-on-64-bit-machines-fix
From: Andrew Morton <akpm@linux-foundation.org>

am finding quite a few of these..

fs/proc/array.c: In function 'do_task_stat':
fs/proc/array.c:460: warning: format '%lu' expects type 'long unsigned int', but argument 11 has type 'unsigned int'
fs/proc/array.c:460: warning: format '%lu' expects type 'long unsigned int', but argument 41 has type 'unsigned int'
fs/proc/array.c:460: warning: format '%lu' expects type 'long unsigned int', but argument 42 has type 'unsigned int'

Cc: William Cohen <wcohen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~reduce-size-of-task_struct-on-64-bit-machines-fix fs/proc/array.c
--- a/fs/proc/array.c~reduce-size-of-task_struct-on-64-bit-machines-fix
+++ a/fs/proc/array.c
@@ -410,9 +410,9 @@ static int do_task_stat(struct task_stru
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %lu %lu \
+	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %lu %lu %llu\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu\n",
 		task->pid,
 		tcomm,
 		state,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
rework-reserved-major-handling.patch
mincore-warning-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
