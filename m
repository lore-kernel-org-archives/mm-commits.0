From: akpm@linux-foundation.org
Subject: + reduce-size-of-task_struct-on-64-bit-machines.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:54:04 -0800
Message-ID: <200702090954.l199s4Pl010074@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946282AbXBIJyN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wcohen@redhat.com, linux-arch@vger.kernel.org


The patch titled
     reduce size of task_struct on 64-bit machines
has been added to the -mm tree.  Its filename is
     reduce-size-of-task_struct-on-64-bit-machines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reduce size of task_struct on 64-bit machines
From: William Cohen <wcohen@redhat.com>

This past week I was playing around with that pahole tool
(http://oops.ghostprotocols.net:81/acme/dwarves/) and looking at the size
of various struct in the kernel.  I was surprised by the size of the
task_struct on x86_64, approaching 4K.  I looked through the fields in
task_struct and found that a number of them were declared as "unsigned
long" rather than "unsigned int" despite them appearing okay as 32-bit
sized fields.  On x86_64 "unsigned long" ends up being 8 bytes in size and
forces 8 byte alignment.  Is there a reason there a reason they are
"unsigned long"?

The patch below drops the size of the struct from 3808 bytes (60 64-byte
cachelines) to 3760 bytes (59 64-byte cachelines).  A couple other fields
in the task struct take a signficant amount of space:

struct thread_struct       thread;               688
struct held_lock           held_locks[30];       1680

CONFIG_LOCKDEP is turned on in the .config

Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/sched.h~reduce-size-of-task_struct-on-64-bit-machines include/linux/sched.h
--- a/include/linux/sched.h~reduce-size-of-task_struct-on-64-bit-machines
+++ a/include/linux/sched.h
@@ -799,8 +799,8 @@ struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	struct thread_info *thread_info;
 	atomic_t usage;
-	unsigned long flags;	/* per process flags, defined below */
-	unsigned long ptrace;
+	unsigned int flags;	/* per process flags, defined below */
+	unsigned int ptrace;
 
 	int lock_depth;		/* BKL lock depth */
 
@@ -823,7 +823,7 @@ struct task_struct {
 	unsigned long long sched_time; /* sched_clock time spent running */
 	enum sleep_type sleep_type;
 
-	unsigned long policy;
+	unsigned int policy;
 	cpumask_t cpus_allowed;
 	unsigned int time_slice, first_time_slice;
 
@@ -843,11 +843,11 @@ struct task_struct {
 
 /* task state */
 	struct linux_binfmt *binfmt;
-	long exit_state;
+	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
-	unsigned long personality;
+	unsigned int personality;
 	unsigned did_exec:1;
 	pid_t pid;
 	pid_t tgid;
@@ -879,7 +879,7 @@ struct task_struct {
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	unsigned long rt_priority;
+	unsigned int rt_priority;
 	cputime_t utime, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;
_

Patches currently in -mm which might be from wcohen@redhat.com are

reduce-size-of-task_struct-on-64-bit-machines.patch
