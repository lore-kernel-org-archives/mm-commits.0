From: akpm@linux-foundation.org
Subject: + reduce-size-of-task_struct-on-64-bit-machines-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 01:25:11 -0800
Message-ID: <200702150925.l1F9PBlt025876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40997 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965274AbXBOJZU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 04:25:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, wcohen@redhat.com


The patch titled
     reduce-size-of-task_struct-on-64-bit-machines-fix
has been added to the -mm tree.  Its filename is
     reduce-size-of-task_struct-on-64-bit-machines-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
git-block-vs-ext4-ext4-delayed-allocation.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
