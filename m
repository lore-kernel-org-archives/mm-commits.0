From: akpm@linux-foundation.org
Subject: [obsolete] pid-delete-reserved_pids.patch removed from -mm tree
Date: Mon, 09 Oct 2017 16:30:43 -0700
Message-ID: <59dc06a3.FeeMeLdIJR/MPkg+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbdJIXap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2017 19:30:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid: delete RESERVED_PIDS
has been removed from the -mm tree.  Its filename was
     pid-delete-reserved_pids.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: pid: delete RESERVED_PIDS

RESERVED_PIDS had a noble goal: to protect root from PID exhaustion since
at least ~2.5.40 except it never did that because there was no capability
or uid checks.

Allow small pids to be allocated after rollover, there is nothing sacred
about them.

Resource exhaustion should be handled by rlimits and/or kernel memory
accounting.

Link: http://lkml.kernel.org/r/20170909202629.GA4791@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/pid.c~pid-delete-reserved_pids kernel/pid.c
--- a/kernel/pid.c~pid-delete-reserved_pids
+++ a/kernel/pid.c
@@ -48,9 +48,7 @@ struct pid init_struct_pid = INIT_STRUCT
 
 int pid_max = PID_MAX_DEFAULT;
 
-#define RESERVED_PIDS		300
-
-int pid_max_min = RESERVED_PIDS + 1;
+int pid_max_min = 301;
 int pid_max_max = PID_MAX_LIMIT;
 
 static inline int mk_pid(struct pid_namespace *pid_ns,
@@ -157,13 +155,13 @@ static int alloc_pidmap(struct pid_names
 
 	pid = last + 1;
 	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+		pid = 1;
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
 	/*
 	 * If last_pid points into the middle of the map->page we
 	 * want to scan this bitmap block twice, the second time
-	 * we start with offset == 0 (or RESERVED_PIDS).
+	 * we start with offset == 0.
 	 */
 	max_scan = DIV_ROUND_UP(pid_max, BITS_PER_PAGE) - !offset;
 	for (i = 0; i <= max_scan; ++i) {
@@ -203,7 +201,7 @@ static int alloc_pidmap(struct pid_names
 			offset = 0;
 		} else {
 			map = &pid_ns->pidmap[0];
-			offset = RESERVED_PIDS;
+			offset = 1;
 			if (unlikely(last == offset))
 				break;
 		}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-uninline-name_to_int.patch
proc-use-do-while-in-name_to_int.patch
seq_file-delete-small-value-optimization.patch
pid-delete-struct-pidmap-nr_free.patch

