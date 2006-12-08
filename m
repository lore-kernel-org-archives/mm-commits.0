From: akpm@osdl.org
Subject: - use-current-nsproxy-pid_ns.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:02 -0800
Message-ID: <200612082006.kB8K62NE002353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946025AbWLHUHM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     use current->nsproxy->pid_ns
has been removed from the -mm tree.  Its filename was
     use-current-nsproxy-pid_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use current->nsproxy->pid_ns
From: Cedric Le Goater <clg@fr.ibm.com>

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_misc.c |    2 +-
 kernel/pid.c        |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/proc_misc.c~use-current-nsproxy-pid_ns fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~use-current-nsproxy-pid_ns
+++ a/fs/proc/proc_misc.c
@@ -92,7 +92,7 @@ static int loadavg_read_proc(char *page,
 		LOAD_INT(a), LOAD_FRAC(a),
 		LOAD_INT(b), LOAD_FRAC(b),
 		LOAD_INT(c), LOAD_FRAC(c),
-		nr_running(), nr_threads, init_pid_ns.last_pid);
+		nr_running(), nr_threads, current->nsproxy->pid_ns->last_pid);
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
diff -puN kernel/pid.c~use-current-nsproxy-pid_ns kernel/pid.c
--- a/kernel/pid.c~use-current-nsproxy-pid_ns
+++ a/kernel/pid.c
@@ -196,7 +196,7 @@ fastcall void free_pid(struct pid *pid)
 	hlist_del_rcu(&pid->pid_chain);
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
-	free_pidmap(&init_pid_ns, pid->nr);
+	free_pidmap(current->nsproxy->pid_ns, pid->nr);
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
@@ -210,7 +210,7 @@ struct pid *alloc_pid(void)
 	if (!pid)
 		goto out;
 
-	nr = alloc_pidmap(&init_pid_ns);
+	nr = alloc_pidmap(current->nsproxy->pid_ns);
 	if (nr < 0)
 		goto out_free;
 
@@ -352,7 +352,7 @@ struct pid *find_ge_pid(int nr)
 		pid = find_pid(nr);
 		if (pid)
 			break;
-		nr = next_pidmap(&init_pid_ns, nr);
+		nr = next_pidmap(current->nsproxy->pid_ns, nr);
 	} while (nr > 0);
 
 	return pid;
_

Patches currently in -mm which might be from clg@fr.ibm.com are

use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
mm-fix-pagecache-write-deadlocks-xip.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch

