From: akpm@linux-foundation.org
Subject: - ifdef-struct-task_structsecurity.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:11 -0700
Message-ID: <200710180705.l9I75BYN031628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762371AbXJRHRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, casey@schaufler-ca.com, jmorris@namei.org, sds@tycho.nsa.gov, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     ifdef struct task_struct::security
has been removed from the -mm tree.  Its filename was
     ifdef-struct-task_structsecurity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ifdef struct task_struct::security
From: Alexey Dobriyan <adobriyan@gmail.com>

For those who don't care about CONFIG_SECURITY.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ++-
 kernel/fork.c         |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~ifdef-struct-task_structsecurity include/linux/sched.h
--- a/include/linux/sched.h~ifdef-struct-task_structsecurity
+++ a/include/linux/sched.h
@@ -1044,8 +1044,9 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
-	
+#ifdef CONFIG_SECURITY
 	void *security;
+#endif
 	struct audit_context *audit_context;
 	seccomp_t seccomp;
 
diff -puN kernel/fork.c~ifdef-struct-task_structsecurity kernel/fork.c
--- a/kernel/fork.c~ifdef-struct-task_structsecurity
+++ a/kernel/fork.c
@@ -1079,7 +1079,9 @@ static struct task_struct *copy_process(
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
+#ifdef CONFIG_SECURITY
 	p->security = NULL;
+#endif
 	p->io_context = NULL;
 	p->io_wait = NULL;
 	p->audit_context = NULL;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
remove-struct-task_structio_wait.patch
