From: akpm@osdl.org
Subject: + explicitly-set-pgid-sid-of-init.patch added to -mm tree
Date: Wed, 24 Jan 2007 19:51:52 -0800
Message-ID: <200701250351.l0P3pqXt005083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbXAYD5W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 22:57:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     Explicitly set pgid/sid of init
has been added to the -mm tree.  Its filename is
     explicitly-set-pgid-sid-of-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
