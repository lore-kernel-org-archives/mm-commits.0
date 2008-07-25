From: akpm@linux-foundation.org
Subject: - proc-misplaced-export-of-find_get_pid.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:17 -0700
Message-ID: <200807252302.m6PN2HaJ003813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbYGYXCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsterba@suse.cz, mm-commits@vger.kernel.org


The patch titled
     proc: misplaced export of find_get_pid
has been removed from the -mm tree.  Its filename was
     proc-misplaced-export-of-find_get_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: misplaced export of find_get_pid
From: David Sterba <dsterba@suse.cz>

Move EXPORT_SYMBOL right after the func

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid.c~proc-misplaced-export-of-find_get_pid kernel/pid.c
--- a/kernel/pid.c~proc-misplaced-export-of-find_get_pid
+++ a/kernel/pid.c
@@ -435,6 +435,7 @@ struct pid *find_get_pid(pid_t nr)
 
 	return pid;
 }
+EXPORT_SYMBOL_GPL(find_get_pid);
 
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 {
@@ -497,7 +498,6 @@ struct pid *find_ge_pid(int nr, struct p
 
 	return pid;
 }
-EXPORT_SYMBOL_GPL(find_get_pid);
 
 /*
  * The pid hash table is scaled according to the amount of memory in the
_

Patches currently in -mm which might be from dsterba@suse.cz are

origin.patch

