From: akpm@linux-foundation.org
Subject: [merged] proc-make-struct-proc_dir_entry-namelen-unsigned-int.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:43 -0700
Message-ID: <201103250725.p2P7PbZE026061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933834Ab1CYHZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: make struct proc_dir_entry::namelen unsigned int
has been removed from the -mm tree.  Its filename was
     proc-make-struct-proc_dir_entry-namelen-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: make struct proc_dir_entry::namelen unsigned int
From: Alexey Dobriyan <adobriyan@gmail.com>

1. namelen is declared "unsigned short" which hints for "maybe space savings".
   Indeed in 2.4 struct proc_dir_entry looked like:

        struct proc_dir_entry {
                unsigned short low_ino;
                unsigned short namelen;

   Now, low_ino is "unsigned int", all savings were gone for a long time.
   "struct proc_dir_entry" is not that countless to worry about it's size,
   anyway.

2. converting from unsigned short to int/unsigned int can only create
   problems, we better play it safe.


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

origin.patch
sysctl-add-proc_dointvec_bool-handler.patch

