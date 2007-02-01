From: akpm@osdl.org
Subject: - explicitly-set-pgid-sid-of-init.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:25:12 -0800
Message-ID: <200702010126.l111QA2n032676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35723 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXBAB0n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Explicitly set pgid/sid of init
has been removed from the -mm tree.  Its filename was
     explicitly-set-pgid-sid-of-init.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Explicitly set pgid/sid of init
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Explicitly set pgid and sid of init process to 1.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: <containers@lists.osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c   |    1 +
 kernel/exit.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN init/main.c~explicitly-set-pgid-sid-of-init init/main.c
--- a/init/main.c~explicitly-set-pgid-sid-of-init
+++ a/init/main.c
@@ -769,6 +769,7 @@ static int __init init(void * unused)
 	 */
 	init_pid_ns.child_reaper = current;
 
+	__set_special_pids(1, 1);
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
diff -puN kernel/exit.c~explicitly-set-pgid-sid-of-init kernel/exit.c
--- a/kernel/exit.c~explicitly-set-pgid-sid-of-init
+++ a/kernel/exit.c
@@ -297,12 +297,12 @@ void __set_special_pids(pid_t session, p
 {
 	struct task_struct *curr = current->group_leader;
 
-	if (process_session(curr) != session) {
+	if (pid_nr(task_session(curr)) != session) {
 		detach_pid(curr, PIDTYPE_SID);
 		set_signal_session(curr->signal, session);
 		attach_pid(curr, PIDTYPE_SID, find_pid(session));
 	}
-	if (process_group(curr) != pgrp) {
+	if (pid_nr(task_pgrp(curr)) != pgrp) {
 		detach_pid(curr, PIDTYPE_PGID);
 		curr->signal->pgrp = pgrp;
 		attach_pid(curr, PIDTYPE_PGID, find_pid(pgrp));
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

explicitly-set-pgid-sid-of-init.patch
