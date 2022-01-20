Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD8FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347740AbiATVaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377922AbiATVaR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5E3C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AD5C617CF
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2736C340E0;
        Thu, 20 Jan 2022 21:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714215;
        bh=xT0LXGYvL/rGTJvsWzzczD64bFjMz3SkbDIBmfEGuSs=;
        h=Date:From:To:Subject:From;
        b=dKmlSU3kJbDuqwM+hPEB50shsWzDa9VANiPVEPSrtwyNSwBtZjQVpmiNNIbXur63B
         p2B0NdBfykDx3qT1ZaqmXjUzg4NRxV9cJtrXhhCdq9E7YxV/7Sp7LYyyQ7IMXi/cJ2
         E96YHMss6aKyXeoJDWq6CZdU9xa7585xkjfzvNJ4=
Date:   Thu, 20 Jan 2022 13:30:15 -0800
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org,
        oleg@redhat.com
Subject:  [merged]
 kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp.patch
 removed from -mm tree
Message-ID: <20220120213015.TGTHtRkkc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: only take tasklist_lock for get/setpriority(PRIO_PGRP)
has been removed from the -mm tree.  Its filename was
     kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: kernel/sys.c: only take tasklist_lock for get/setpriority(PRIO_PGRP)

PRIO_PGRP needs the tasklist_lock mainly to serialize vs setpgid(2), to
protect against any concurrent change_pid(PIDTYPE_PGID) that can move the
task from one hlist to another while iterating.

However, the remaining can only rely only on RCU:

PRIO_PROCESS only does the task lookup and never iterates over tasklist
and we already have an rcu-aware stable pointer.

PRIO_USER is already racy vs setuid(2) so with creds being rcu protected,
we can end up seeing stale data.  When removing the tasklist_lock there
can be a race with (i) fork but this is benign as the child's nice is
inherited and the new task is not observable by the user yet either, hence
the return semantics do not differ.  And (ii) a race with exit, which is a
small window and can cause us to miss a task which was removed from the
list and it had the highest nice.

Similarly change the buggy do_each_thread/while_each_thread combo in
PRIO_USER for the rcu-safe for_each_process_thread flavor, which doesn't
make use of next_thread/p->thread_group.

Link: https://lkml.kernel.org/r/20211210182250.43734-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/kernel/sys.c~kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp
+++ a/kernel/sys.c
@@ -220,7 +220,6 @@ SYSCALL_DEFINE3(setpriority, int, which,
 		niceval = MAX_NICE;
 
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	switch (which) {
 	case PRIO_PROCESS:
 		if (who)
@@ -235,9 +234,11 @@ SYSCALL_DEFINE3(setpriority, int, which,
 			pgrp = find_vpid(who);
 		else
 			pgrp = task_pgrp(current);
+		read_lock(&tasklist_lock);
 		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 			error = set_one_prio(p, niceval, error);
 		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		read_unlock(&tasklist_lock);
 		break;
 	case PRIO_USER:
 		uid = make_kuid(cred->user_ns, who);
@@ -249,16 +250,15 @@ SYSCALL_DEFINE3(setpriority, int, which,
 			if (!user)
 				goto out_unlock;	/* No processes for this user */
 		}
-		do_each_thread(g, p) {
+		for_each_process_thread(g, p) {
 			if (uid_eq(task_uid(p), uid) && task_pid_vnr(p))
 				error = set_one_prio(p, niceval, error);
-		} while_each_thread(g, p);
+		}
 		if (!uid_eq(uid, cred->uid))
 			free_uid(user);		/* For find_user() */
 		break;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 out:
 	return error;
@@ -283,7 +283,6 @@ SYSCALL_DEFINE2(getpriority, int, which,
 		return -EINVAL;
 
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	switch (which) {
 	case PRIO_PROCESS:
 		if (who)
@@ -301,11 +300,13 @@ SYSCALL_DEFINE2(getpriority, int, which,
 			pgrp = find_vpid(who);
 		else
 			pgrp = task_pgrp(current);
+		read_lock(&tasklist_lock);
 		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 			niceval = nice_to_rlimit(task_nice(p));
 			if (niceval > retval)
 				retval = niceval;
 		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		read_unlock(&tasklist_lock);
 		break;
 	case PRIO_USER:
 		uid = make_kuid(cred->user_ns, who);
@@ -317,19 +318,18 @@ SYSCALL_DEFINE2(getpriority, int, which,
 			if (!user)
 				goto out_unlock;	/* No processes for this user */
 		}
-		do_each_thread(g, p) {
+	        for_each_process_thread(g, p) {
 			if (uid_eq(task_uid(p), uid) && task_pid_vnr(p)) {
 				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
-		} while_each_thread(g, p);
+		}
 		if (!uid_eq(uid, cred->uid))
 			free_uid(user);		/* for find_user() */
 		break;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 
 	return retval;
_

Patches currently in -mm which might be from dave@stgolabs.net are


