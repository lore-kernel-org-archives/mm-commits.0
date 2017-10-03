From: akpm@linux-foundation.org
Subject: [patch 32/51] exec: binfmt_misc: fix race between
 load_misc_binary() and kill_node()
Date: Tue, 03 Oct 2017 16:15:55 -0700
Message-ID: <59d41a2b.rJeFY+Plcq6F4qWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXP4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com, foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com

From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: binfmt_misc: fix race between load_misc_binary() and kill_node()

load_misc_binary() makes a local copy of fmt->interpreter under
entries_lock to avoid the race with kill_node() but this is not enough;
the whole Node can be freed after we drop entries_lock, not only the
->interpreter string.

Add dget/dput(fmt->dentry) to ensure bm_evict_inode() can't destroy/free
this Node.

Link: http://lkml.kernel.org/r/20170922143650.GA17227@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ben Woodard <woodard@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jim Foraker <foraker1@llnl.gov>
Cc: Travis Gummels <tgummels@redhat.com>
Cc: <tdhooge@llnl.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_misc.c~exec-binfmt_misc-fix-race-between-load_misc_binary-and-kill_node fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-binfmt_misc-fix-race-between-load_misc_binary-and-kill_node
+++ a/fs/binfmt_misc.c
@@ -138,20 +138,23 @@ static int load_misc_binary(struct linux
 
 	retval = -ENOEXEC;
 	if (!enabled)
-		goto ret;
+		return retval;
 
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
-	if (fmt)
+	if (fmt) {
+		dget(fmt->dentry);
 		strlcpy(iname, fmt->interpreter, BINPRM_BUF_SIZE);
+	}
 	read_unlock(&entries_lock);
 	if (!fmt)
-		goto ret;
+		return retval;
 
 	/* Need to be able to load the file after exec */
+	retval = -ENOENT;
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		return -ENOENT;
+		goto ret;
 
 	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
 		retval = remove_arg_zero(bprm);
@@ -238,6 +241,7 @@ static int load_misc_binary(struct linux
 		goto error;
 
 ret:
+	dput(fmt->dentry);
 	return retval;
 error:
 	if (fd_binary > 0)
_
