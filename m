From: akpm@linux-foundation.org
Subject: + taskstats-fix-the-structure-members-alignment-issue.patch added to -mm tree
Date: Fri, 20 Apr 2007 12:16:37 -0700
Message-ID: <200704201916.l3KJGcjP022008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbXDTTSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 15:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@in.ibm.com, balbir@linux.vnet.ibm.com, jlan@engr.sgi.com, nagar@watson.ibm.com, stable@kernel.org


The patch titled
     Taskstats fix the structure members alignment issue
has been added to the -mm tree.  Its filename is
     taskstats-fix-the-structure-members-alignment-issue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Taskstats fix the structure members alignment issue
From: Balbir Singh <balbir@in.ibm.com>

We broke the the alignment of members of taskstats to the 8 byte boundary
with the CSA patches.  In the current kernel, the taskstats structure is
not suitable for use by 32 bit applications in a 64 bit kernel.

On x86_64

Offsets of taskstats' members (64 bit kernel, 64 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        16,     # cpu_count
        24,     # cpu_delay_total
        32,     # blkio_count
        40,     # blkio_delay_total
        48,     # swapin_count
        56,     # swapin_delay_total
        64,     # cpu_run_real_total
        72,     # cpu_run_virtual_total
        80,     # ac_comm
        112,    # ac_sched
        113,    # ac_pad
        116,    # ac_uid
        120,    # ac_gid
        124,    # ac_pid
        128,    # ac_ppid
        132,    # ac_btime
        136,    # ac_etime
        144,    # ac_utime
        152,    # ac_stime
        160,    # ac_minflt
        168,    # ac_majflt
        176,    # coremem
        184,    # virtmem
        192,    # hiwater_rss
        200,    # hiwater_vm
        208,    # read_char
        216,    # write_char
        224,    # read_syscalls
        232,    # write_syscalls
        240,    # read_bytes
        248,    # write_bytes
        256,    # cancelled_write_bytes
    );

Offsets of taskstats' members (64 bit kernel, 32 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        12,     # cpu_count
        20,     # cpu_delay_total
        28,     # blkio_count
        36,     # blkio_delay_total
        44,     # swapin_count
        52,     # swapin_delay_total
        60,     # cpu_run_real_total
        68,     # cpu_run_virtual_total
        76,     # ac_comm
        108,    # ac_sched
        109,    # ac_pad
        112,    # ac_uid
        116,    # ac_gid
        120,    # ac_pid
        124,    # ac_ppid
        128,    # ac_btime
        132,    # ac_etime
        140,    # ac_utime
        148,    # ac_stime
        156,    # ac_minflt
        164,    # ac_majflt
        172,    # coremem
        180,    # virtmem
        188,    # hiwater_rss
        196,    # hiwater_vm
        204,    # read_char
        212,    # write_char
        220,    # read_syscalls
        228,    # write_syscalls
        236,    # read_bytes
        244,    # write_bytes
        252,    # cancelled_write_bytes
    );

This is one way to solve the problem without re-arranging structure members
is to pack the structure.  The patch adds an __attribute__((aligned(8))) to
the taskstats structure members so that 32 bit applications using taskstats
can work with a 64 bit kernel.

Using __attribute__((packed)) would break the 64 bit alignment of members.

The fix was tested on x86_64. After the fix, we got

Offsets of taskstats' members (64 bit kernel, 64 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        16,     # cpu_count
        24,     # cpu_delay_total
        32,     # blkio_count
        40,     # blkio_delay_total
        48,     # swapin_count
        56,     # swapin_delay_total
        64,     # cpu_run_real_total
        72,     # cpu_run_virtual_total
        80,     # ac_comm
        112,    # ac_sched
        113,    # ac_pad
        120,    # ac_uid
        124,    # ac_gid
        128,    # ac_pid
        132,    # ac_ppid
        136,    # ac_btime
        144,    # ac_etime
        152,    # ac_utime
        160,    # ac_stime
        168,    # ac_minflt
        176,    # ac_majflt
        184,    # coremem
        192,    # virtmem
        200,    # hiwater_rss
        208,    # hiwater_vm
        216,    # read_char
        224,    # write_char
        232,    # read_syscalls
        240,    # write_syscalls
        248,    # read_bytes
        256,    # write_bytes
        264,    # cancelled_write_bytes
    );

Offsets of taskstats' members (64 bit kernel, 32 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        16,     # cpu_count
        24,     # cpu_delay_total
        32,     # blkio_count
        40,     # blkio_delay_total
        48,     # swapin_count
        56,     # swapin_delay_total
        64,     # cpu_run_real_total
        72,     # cpu_run_virtual_total
        80,     # ac_comm
        112,    # ac_sched
        113,    # ac_pad
        120,    # ac_uid
        124,    # ac_gid
        128,    # ac_pid
        132,    # ac_ppid
        136,    # ac_btime
        144,    # ac_etime
        152,    # ac_utime
        160,    # ac_stime
        168,    # ac_minflt
        176,    # ac_majflt
        184,    # coremem
        192,    # virtmem
        200,    # hiwater_rss
        208,    # hiwater_vm
        216,    # read_char
        224,    # write_char
        232,    # read_syscalls
        240,    # write_syscalls
        248,    # read_bytes
        256,    # write_bytes
        264,    # cancelled_write_bytes
    );

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/taskstats.h |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/taskstats.h~taskstats-fix-the-structure-members-alignment-issue include/linux/taskstats.h
--- a/include/linux/taskstats.h~taskstats-fix-the-structure-members-alignment-issue
+++ a/include/linux/taskstats.h
@@ -66,7 +66,7 @@ struct taskstats {
 	/* Delay waiting for cpu, while runnable
 	 * count, delay_total NOT updated atomically
 	 */
-	__u64	cpu_count;
+	__u64	cpu_count __attribute__((aligned(8)));
 	__u64	cpu_delay_total;
 
 	/* Following four fields atomically updated using task->delays->lock */
@@ -101,14 +101,17 @@ struct taskstats {
 
 	/* Basic Accounting Fields start */
 	char	ac_comm[TS_COMM_LEN];	/* Command name */
-	__u8	ac_sched;		/* Scheduling discipline */
+	__u8	ac_sched __attribute__((aligned(8)));
+					/* Scheduling discipline */
 	__u8	ac_pad[3];
-	__u32	ac_uid;			/* User ID */
+	__u32	ac_uid __attribute__((aligned(8)));
+					/* User ID */
 	__u32	ac_gid;			/* Group ID */
 	__u32	ac_pid;			/* Process ID */
 	__u32	ac_ppid;		/* Parent process ID */
 	__u32	ac_btime;		/* Begin time [sec since 1970] */
-	__u64	ac_etime;		/* Elapsed time [usec] */
+	__u64	ac_etime __attribute__((aligned(8)));
+					/* Elapsed time [usec] */
 	__u64	ac_utime;		/* User CPU time [usec] */
 	__u64	ac_stime;		/* SYstem CPU time [usec] */
 	__u64	ac_minflt;		/* Minor Page Fault Count */
_

Patches currently in -mm which might be from balbir@in.ibm.com are

taskstats-fix-the-structure-members-alignment-issue.patch
fix-race-between-attach_task-and-cpuset_exit.patch
taskstats-fix-getdelays-usage-information.patch
