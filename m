From: akpm@linux-foundation.org
Subject: + proc-oom_score-oops-re-badness.patch added to -mm tree
Date: Thu, 15 Mar 2007 20:12:25 -0800
Message-ID: <200703160412.l2G4CP8W002223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53424 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXCPENE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 00:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     /proc/*/oom_score oops re badness
has been added to the -mm tree.  Its filename is
     proc-oom_score-oops-re-badness.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -310,7 +310,9 @@ static int proc_oom_score(struct task_st
 	struct timespec uptime;
 
 	do_posix_clock_monotonic_gettime(&uptime);
+	read_lock(&tasklist_lock);
 	points = badness(task, uptime.tv_sec);
+	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
race-between-cat-proc-kallsyms-and-rmmod.patch
fix-rmmod-read-write-races-in-proc-entries.patch
proc-oom_score-oops-re-badness.patch
