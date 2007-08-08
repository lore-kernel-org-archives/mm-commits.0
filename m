From: akpm@linux-foundation.org
Subject: + ifdef-struct-task_structsecurity.patch added to -mm tree
Date: Tue, 07 Aug 2007 17:35:27 -0700
Message-ID: <200708080035.l780ZRJw012611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055AbXHHAfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 20:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, casey@schaufler-ca.com, jmorris@namei.org, sds@tycho.nsa.gov, serge@hallyn.com


The patch titled
     ifdef struct task_struct::security
has been added to the -mm tree.  Its filename is
     ifdef-struct-task_structsecurity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1086,8 +1086,9 @@ struct task_struct {
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
@@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(
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

blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch
remove-unused-struct-proc_dir_entryset.patch
off-by-one-in-sys-module-refcnt.patch
ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
revert-faster-ext2_clear_inode.patch
