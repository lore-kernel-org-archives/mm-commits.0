From: akpm@linux-foundation.org
Subject: + proc-do-translation-unlink-atomically-at-remove_proc_entry.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:56:31 -0800
Message-ID: <201001262156.o0QLuVUA022954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678Ab0AZV4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     proc: do translation + unlink atomically at remove_proc_entry()
has been added to the -mm tree.  Its filename is
     proc-do-translation-unlink-atomically-at-remove_proc_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
dnotify-move-dir_notify_enable-declaration.patch
mpt-fusion-convert-to-seq_file.patch
proc-do-translation-unlink-atomically-at-remove_proc_entry.patch
proc-warn-on-non-existing-proc-entries.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

