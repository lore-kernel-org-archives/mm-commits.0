From: akpm@linux-foundation.org
Subject: [merged] proc-do-translation-unlink-atomically-at-remove_proc_entry.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:31 -0800
Message-ID: <201003091909.o29J9VB6031530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab0CITKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: do translation + unlink atomically at remove_proc_entry()
has been removed from the -mm tree.  Its filename was
     proc-do-translation-unlink-atomically-at-remove_proc_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: do translation + unlink atomically at remove_proc_entry()
From: Alexey Dobriyan <adobriyan@gmail.com>

remove_proc_entry() does

	lock
	lookup parent
	unlock
	lock
	unlink proc entry from lists
	unlock

which can be made bit more correct by doing parent translation + unlink
without dropping lock.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff -puN fs/proc/generic.c~proc-do-translation-unlink-atomically-at-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~proc-do-translation-unlink-atomically-at-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -291,19 +291,17 @@ static const struct inode_operations pro
  * returns the struct proc_dir_entry for "/proc/tty/driver", and
  * returns "serial" in residual.
  */
-static int xlate_proc_name(const char *name,
-			   struct proc_dir_entry **ret, const char **residual)
+static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
+			     const char **residual)
 {
 	const char     		*cp = name, *next;
 	struct proc_dir_entry	*de;
 	int			len;
-	int 			rtn = 0;
 
 	de = *ret;
 	if (!de)
 		de = &proc_root;
 
-	spin_lock(&proc_subdir_lock);
 	while (1) {
 		next = strchr(cp, '/');
 		if (!next)
@@ -314,17 +312,24 @@ static int xlate_proc_name(const char *n
 			if (proc_match(len, cp, de))
 				break;
 		}
-		if (!de) {
-			rtn = -ENOENT;
-			goto out;
-		}
+		if (!de)
+			return -ENOENT;
 		cp += len + 1;
 	}
 	*residual = cp;
 	*ret = de;
-out:
+	return 0;
+}
+
+static int xlate_proc_name(const char *name, struct proc_dir_entry **ret,
+			   const char **residual)
+{
+	int rv;
+
+	spin_lock(&proc_subdir_lock);
+	rv = __xlate_proc_name(name, ret, residual);
 	spin_unlock(&proc_subdir_lock);
-	return rtn;
+	return rv;
 }
 
 static DEFINE_IDA(proc_inum_ida);
@@ -797,11 +802,13 @@ void remove_proc_entry(const char *name,
 	const char *fn = name;
 	int len;
 
-	if (xlate_proc_name(name, &parent, &fn) != 0)
+	spin_lock(&proc_subdir_lock);
+	if (__xlate_proc_name(name, &parent, &fn) != 0) {
+		spin_unlock(&proc_subdir_lock);
 		return;
+	}
 	len = strlen(fn);
 
-	spin_lock(&proc_subdir_lock);
 	for (p = &parent->subdir; *p; p=&(*p)->next ) {
 		if (proc_match(len, fn, *p)) {
 			de = *p;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mpt-fusion-convert-to-seq_file.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-extern-cleanup-binfmts.patch
nsproxy-remove-init_nsproxy.patch

