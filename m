From: akpm@linux-foundation.org
Subject: [folded-merged]
 fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:17:16 -0700
Message-ID: <534323ec.inJT6VImBwtk60OB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:17:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, davej@redhat.com, davej@fedoraproject.org, akinobu.mita@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,akinobu.mita@gmail.com,davej@fedoraproject.org,davej@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:17:16 -0700


The patch titled
     Subject: fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix
has been removed from the -mm tree.  Its filename was
     fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch

This patch was dropped because it was folded into fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix

don't make make_it_fail unsigned

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dave Jones <davej@fedoraproject.org>
Cc: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix fs/proc/base.c
--- a/fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix
+++ a/fs/proc/base.c
@@ -1207,7 +1207,7 @@ static ssize_t proc_fault_inject_read(st
 	struct task_struct *task = get_proc_task(file_inode(file));
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	unsigned int make_it_fail;
+	int make_it_fail;
 
 	if (!task)
 		return -ESRCH;
@@ -1224,7 +1224,7 @@ static ssize_t proc_fault_inject_write(s
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
-	unsigned int make_it_fail;
+	int make_it_fail;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
@@ -1236,7 +1236,7 @@ static ssize_t proc_fault_inject_write(s
 	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
-	if (make_it_fail > 1)
+	if (make_it_fail < 0 || make_it_fail > 1)
 		return -EINVAL;
 
 	task = get_proc_task(file_inode(file));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

