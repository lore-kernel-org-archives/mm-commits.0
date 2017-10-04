From: akpm@linux-foundation.org
Subject: [merged]
 exec-binfmt_misc-kill-the-onstack-iname-array.patch removed from -mm tree
Date: Wed, 04 Oct 2017 12:41:28 -0700
Message-ID: <20171004194128.Q75ZuJfU4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbdJDTl3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, mm-commits@vger.kernel.org, oleg@redhat.com, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com


The patch titled
     Subject: exec: binfmt_misc: kill the onstack iname[BINPRM_BUF_SIZE] array
has been removed from the -mm tree.  Its filename was
     exec-binfmt_misc-kill-the-onstack-iname-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: binfmt_misc: kill the onstack iname[BINPRM_BUF_SIZE] array

After the previous change "fmt" can't go away, we can kill iname/iname_addr
and use fmt->interpreter.

Link: http://lkml.kernel.org/r/20170922143653.GA17232@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ben Woodard <woodard@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jim Foraker <foraker1@llnl.gov>
Cc: <tdhooge@llnl.gov>
Cc: Travis Gummels <tgummels@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/binfmt_misc.c~exec-binfmt_misc-kill-the-onstack-iname-array fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-binfmt_misc-kill-the-onstack-iname-array
+++ a/fs/binfmt_misc.c
@@ -54,7 +54,7 @@ typedef struct {
 	int size;			/* size of magic/mask */
 	char *magic;			/* magic or filename extension */
 	char *mask;			/* mask, NULL for exact match */
-	char *interpreter;		/* filename of interpreter */
+	const char *interpreter;	/* filename of interpreter */
 	char *name;
 	struct dentry *dentry;
 	struct file *interp_file;
@@ -131,8 +131,6 @@ static int load_misc_binary(struct linux
 {
 	Node *fmt;
 	struct file *interp_file = NULL;
-	char iname[BINPRM_BUF_SIZE];
-	const char *iname_addr = iname;
 	int retval;
 	int fd_binary = -1;
 
@@ -143,10 +141,8 @@ static int load_misc_binary(struct linux
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
-	if (fmt) {
+	if (fmt)
 		dget(fmt->dentry);
-		strlcpy(iname, fmt->interpreter, BINPRM_BUF_SIZE);
-	}
 	read_unlock(&entries_lock);
 	if (!fmt)
 		return retval;
@@ -198,13 +194,13 @@ static int load_misc_binary(struct linux
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_strings_kernel(1, &iname_addr, bprm);
+	retval = copy_strings_kernel(1, &fmt->interpreter, bprm);
 	if (retval < 0)
 		goto error;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
-	retval = bprm_change_interp(iname, bprm);
+	retval = bprm_change_interp(fmt->interpreter, bprm);
 	if (retval < 0)
 		goto error;
 
@@ -213,7 +209,7 @@ static int load_misc_binary(struct linux
 		if (!IS_ERR(interp_file))
 			deny_write_access(interp_file);
 	} else {
-		interp_file = open_exec(iname);
+		interp_file = open_exec(fmt->interpreter);
 	}
 	retval = PTR_ERR(interp_file);
 	if (IS_ERR(interp_file))
_

Patches currently in -mm which might be from oleg@redhat.com are


