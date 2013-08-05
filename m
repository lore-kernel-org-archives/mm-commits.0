From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-binfmts-better-handling-of-binfmt-loops.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 13:33:38 -0700
Message-ID: <52000c22.9hLtqz+Y/i+8oOLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3HEUdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zach@zachsthings.com, viro@zeniv.linux.org.uk, zml@linux.vnet.ibm.com

Subject: [to-be-updated] fs-binfmts-better-handling-of-binfmt-loops.patch removed from -mm tree
To: zml@linux.vnet.ibm.com,viro@zeniv.linux.org.uk,zach@zachsthings.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:33:38 -0700


The patch titled
     Subject: fs/binfmts: better handling of binfmt loops
has been removed from the -mm tree.  Its filename was
     fs-binfmts-better-handling-of-binfmt-loops.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zach Levis <zml@linux.vnet.ibm.com>
Subject: fs/binfmts: better handling of binfmt loops

With these changes, when a binfmt loop is encountered, the ELOOP will
propagate back to the 0 depth.  At this point the argv and argc values
will be reset to what they were originally and an attempt is made to
continue with the following binfmt handlers.

Caveats:
- binfmt_misc is skipped as a whole. To allow for a more generic
  solution that works for any binfmt without a lot of duplicated code
  and added complexity, the error detection code is applied on the
  binfmt level.
- This is a fallback solution. It attempts to restore the state to allow
  executing most binaries without side effects, but it may not work for
  everything and should not be depended on for regular usage.

My (rough, but functional) test scripts for this issue are available at:
    https://gist.github.com/zml2008/6075418

Signed-off-by: Zach Levis <zach@zachsthings.com>
Signed-off-by: Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |   30 +++++++++++++++++++++++++++++-
 include/linux/binfmts.h |    5 ++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~fs-binfmts-better-handling-of-binfmt-loops fs/exec.c
--- a/fs/exec.c~fs-binfmts-better-handling-of-binfmt-loops
+++ a/fs/exec.c
@@ -1403,13 +1403,40 @@ int search_binary_handler(struct linux_b
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
+			bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
+			bprm->previous_binfmts[0] = fmt;
+
 			bprm->recursion_depth = depth + 1;
 			retval = fn(bprm);
 			bprm->recursion_depth = depth;
+			if (retval == -ELOOP && depth == 0) { /* cur, previous */
+				pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
+						bprm->previous_binfmts[0]->name,
+						bprm->previous_binfmts[1]->name,
+						bprm->filename,
+						fmt->name);
+
+				/* Put argv back in its place */
+				while (bprm->argc > 0) {
+					retval = remove_arg_zero(bprm);
+					if (retval)
+						return retval;
+				}
+
+				copy_strings(bprm->argc_orig, *((struct user_arg_ptr *) bprm->argv_orig), bprm);
+				bprm->argc = bprm->argc_orig;
+				retval = -ENOEXEC;
+				continue;
+			}
+
 			if (retval >= 0) {
 				if (depth == 0) {
 					trace_sched_process_exec(current, old_pid, bprm);
 					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
+					/* Successful execution, now null out the cached argv
+					 * (we don't want to access it later)
+					 * */
+					bprm->argv_orig = NULL;
 				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
@@ -1516,7 +1543,7 @@ static int do_execve_common(const char *
 	if (retval)
 		goto out_file;
 
-	bprm->argc = count(argv, MAX_ARG_STRINGS);
+	bprm->argc_orig = bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
 		goto out;
 
@@ -1540,6 +1567,7 @@ static int do_execve_common(const char *
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
+	bprm->argv_orig = &argv;
 
 	retval = search_binary_handler(bprm);
 	if (retval < 0)
diff -puN include/linux/binfmts.h~fs-binfmts-better-handling-of-binfmt-loops include/linux/binfmts.h
--- a/include/linux/binfmts.h~fs-binfmts-better-handling-of-binfmt-loops
+++ a/include/linux/binfmts.h
@@ -32,11 +32,14 @@ struct linux_binprm {
 	unsigned int taso:1;
 #endif
 	unsigned int recursion_depth;
+	/* current binfmt at 0 and previous binfmt at 1 */
+	struct linux_binfmt *previous_binfmts[2];
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
 	unsigned int per_clear;	/* bits to clear in current->personality */
-	int argc, envc;
+	int argc, argc_orig, envc;
+	void *argv_orig;
 	const char * filename;	/* Name of binary as seen by procps */
 	const char * interp;	/* Name of the binary really executed. Most
 				   of the time same as filename, but could be
_

Patches currently in -mm which might be from zml@linux.vnet.ibm.com are

fs-binfmts-better-handling-of-binfmt-loops-fix.patch
fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

