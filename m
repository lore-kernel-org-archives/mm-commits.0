From: akpm@linux-foundation.org
Subject: - proc-oom_score-oops-re-badness.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:04 -0700
Message-ID: <200705090247.l492l4jA008929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934528AbXEICrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     /proc/*/oom_score oops re badness
has been removed from the -mm tree.  Its filename was
     proc-oom_score-oops-re-badness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: /proc/*/oom_score oops re badness
From: Alexey Dobriyan <adobriyan@sw.ru>

Eternal quest to make

	while true; do cat /proc/fs/xfs/stat >/dev/null 2>/dev/null; done
	while true; do find /proc -type f 2>/dev/null | xargs cat >/dev/null 2>/dev/null; done
	while true; do modprobe xfs; rmmod xfs; done

work reliably continues and now kernel oopses in the following way:

BUG: unable to handle ... at virtual address 6b6b6b6b
EIP is at badness
process: cat
	proc_oom_score
	proc_info_read
	sys_fstat64
	vfs_read
	proc_info_read
	sys_read

Failing code is prefetch hidden in list_for_each_entry() in badness().
badness() is reachable from two points. One is proc_oom_score, another
is out_of_memory() => select_bad_process() => badness().

Second path grabs tasklist_lock, while first doesn't.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/base.c~proc-oom_score-oops-re-badness fs/proc/base.c
--- a/fs/proc/base.c~proc-oom_score-oops-re-badness
+++ a/fs/proc/base.c
@@ -314,7 +314,9 @@ static int proc_oom_score(struct task_st
 	struct timespec uptime;
 
 	do_posix_clock_monotonic_gettime(&uptime);
+	read_lock(&tasklist_lock);
 	points = badness(task, uptime.tv_sec);
+	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
