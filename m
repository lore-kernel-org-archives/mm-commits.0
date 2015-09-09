From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:30 -0700
Message-ID: <55f08c5a.CyGJLiCECOM9CyS9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbIITpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not panic for oom kills triggered from sysrq
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: do not panic for oom kills triggered from sysrq

Sysrq+f is used to kill a process either for debug or when the VM is
otherwise unresponsive.

It is not intended to trigger a panic when no process may be killed.

Avoid panicking the system for sysrq+f when no processes are killed.

Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    3 ++-
 mm/oom_kill.c           |    7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN Documentation/sysrq.txt~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq
+++ a/Documentation/sysrq.txt
@@ -75,7 +75,8 @@ On all -  write a character to /proc/sys
 
 'e'     - Send a SIGTERM to all processes, except for init.
 
-'f'	- Will call oom_kill to kill a memory hog process.
+'f'	- Will call the oom killer to kill a memory hog process, but do not
+	  panic if nothing can be killed.
 
 'g'	- Used by kgdb (kernel debugger)
 
diff -puN mm/oom_kill.c~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq
+++ a/mm/oom_kill.c
@@ -607,6 +607,9 @@ void check_panic_on_oom(struct oom_contr
 		if (constraint != CONSTRAINT_NONE)
 			return;
 	}
+	/* Do not panic for oom kills triggered by sysrq */
+	if (oc->order == -1)
+		return;
 	dump_header(oc, NULL, memcg);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
@@ -686,11 +689,11 @@ bool out_of_memory(struct oom_control *o
 
 	p = select_bad_process(oc, &points, totalpages);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
-	if (!p) {
+	if (!p && oc->order != -1) {
 		dump_header(oc, NULL, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
-	if (p != (void *)-1UL) {
+	if (p && p != (void *)-1UL) {
 		oom_kill_process(oc, p, points, totalpages, NULL,
 				 "Out of memory");
 		killed = 1;
_

Patches currently in -mm which might be from rientjes@google.com are


