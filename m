From: akpm@linux-foundation.org
Subject: + proc-make-struct-proc_dir_entry-namelen-unsigned-int.patch added to -mm tree
Date: Wed, 09 Mar 2011 15:03:19 -0800
Message-ID: <201103092303.p29N3JNJ000799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab1CIXDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 18:03:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: make struct proc_dir_entry::namelen unsigned int
has been added to the -mm tree.  Its filename is
     proc-make-struct-proc_dir_entry-namelen-unsigned-int.patch

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
Subject: proc: make struct proc_dir_entry::namelen unsigned int
From: Alexey Dobriyan <adobriyan@gmail.com>

Space is not really conserved, because of natural alignment for the next
field.  sizeof(struct proc_dir_entry) remains the same.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    8 ++++----
 include/linux/proc_fs.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/generic.c~proc-make-struct-proc_dir_entry-namelen-unsigned-int fs/proc/generic.c
--- a/fs/proc/generic.c~proc-make-struct-proc_dir_entry-namelen-unsigned-int
+++ a/fs/proc/generic.c
@@ -28,7 +28,7 @@
 
 DEFINE_SPINLOCK(proc_subdir_lock);
 
-static int proc_match(int len, const char *name, struct proc_dir_entry *de)
+static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
 	if (de->namelen != len)
 		return 0;
@@ -303,7 +303,7 @@ static int __xlate_proc_name(const char 
 {
 	const char     		*cp = name, *next;
 	struct proc_dir_entry	*de;
-	int			len;
+	unsigned int		len;
 
 	de = *ret;
 	if (!de)
@@ -602,7 +602,7 @@ static struct proc_dir_entry *__proc_cre
 {
 	struct proc_dir_entry *ent = NULL;
 	const char *fn = name;
-	int len;
+	unsigned int len;
 
 	/* make sure name is valid */
 	if (!name || !strlen(name)) goto out;
@@ -786,7 +786,7 @@ void remove_proc_entry(const char *name,
 	struct proc_dir_entry **p;
 	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
-	int len;
+	unsigned int len;
 
 	spin_lock(&proc_subdir_lock);
 	if (__xlate_proc_name(name, &parent, &fn) != 0) {
diff -puN include/linux/proc_fs.h~proc-make-struct-proc_dir_entry-namelen-unsigned-int include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-make-struct-proc_dir_entry-namelen-unsigned-int
+++ a/include/linux/proc_fs.h
@@ -50,7 +50,7 @@ typedef	int (write_proc_t)(struct file *
 
 struct proc_dir_entry {
 	unsigned int low_ino;
-	unsigned short namelen;
+	unsigned int namelen;
 	const char *name;
 	mode_t mode;
 	nlink_t nlink;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

sys_unshare-remove-the-dead-clone_thread-sighand-vm-code.patch
kstrto-converting-strings-to-integers-done-hopefully-right.patch
proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch
procfs-fix-some-wrong-error-code-usage.patch
proc-make-struct-proc_dir_entry-namelen-unsigned-int.patch
sysctl-add-proc_dointvec_bool-handler.patch
sysctl-add-some-missing-input-constraint-checks.patch
pid-remove-the-child_reaper-special-case-in-init-mainc.patch
pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch
procfs-kill-the-global-proc_mnt-variable.patch

