From: akpm@linux-foundation.org
Subject: - allow-recursion-in-binfmt_script-and-binfmt_misc.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:27 -0700
Message-ID: <200810182314.m9INERDv028409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbYJRXOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, viro@zeniv.linux.org.uk, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Allow recursion in binfmt_script and binfmt_misc
has been removed from the -mm tree.  Its filename was
     allow-recursion-in-binfmt_script-and-binfmt_misc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Allow recursion in binfmt_script and binfmt_misc
From: "Kirill A. Shutemov" <kirill@shutemov.name>

binfmt_script and binfmt_misc disallow recursion to avoid stack overflow
using sh_bang and misc_bang.  It causes problem in some cases:

$ echo '#!/bin/ls' > /tmp/t0
$ echo '#!/tmp/t0' > /tmp/t1
$ echo '#!/tmp/t1' > /tmp/t2
$ chmod +x /tmp/t*
$ /tmp/t2
zsh: exec format error: /tmp/t2

Similar problem with binfmt_misc.

This patch introduces field 'recursion_depth' into struct linux_binprm to
track recursion level in binfmt_misc and binfmt_script.  If recursion
level more then BINPRM_MAX_RECURSION it generates -ENOEXEC.

[akpm@linux-foundation.org: make linux_binprm.recursion_depth a uint]
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c        |    2 +-
 fs/binfmt_misc.c        |    4 ++--
 fs/binfmt_script.c      |    5 +++--
 include/linux/binfmts.h |    2 ++
 4 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/binfmt_em86.c~allow-recursion-in-binfmt_script-and-binfmt_misc fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~allow-recursion-in-binfmt_script-and-binfmt_misc
+++ a/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
-	bprm->sh_bang = 1;	/* Well, the bang-shell is implicit... */
+	bprm->recursion_depth++; /* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN fs/binfmt_misc.c~allow-recursion-in-binfmt_script-and-binfmt_misc fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~allow-recursion-in-binfmt_script-and-binfmt_misc
+++ a/fs/binfmt_misc.c
@@ -117,7 +117,7 @@ static int load_misc_binary(struct linux
 		goto _ret;
 
 	retval = -ENOEXEC;
-	if (bprm->misc_bang)
+	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
 		goto _ret;
 
 	/* to keep locking time low, we copy the interpreter string */
@@ -197,7 +197,7 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
-	bprm->misc_bang = 1;
+	bprm->recursion_depth++;
 
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
diff -puN fs/binfmt_script.c~allow-recursion-in-binfmt_script-and-binfmt_misc fs/binfmt_script.c
--- a/fs/binfmt_script.c~allow-recursion-in-binfmt_script-and-binfmt_misc
+++ a/fs/binfmt_script.c
@@ -22,14 +22,15 @@ static int load_script(struct linux_binp
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
-	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') || (bprm->sh_bang)) 
+	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
+	    (bprm->recursion_depth > BINPRM_MAX_RECURSION))
 		return -ENOEXEC;
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->sh_bang = 1;
+	bprm->recursion_depth++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN include/linux/binfmts.h~allow-recursion-in-binfmt_script-and-binfmt_misc include/linux/binfmts.h
--- a/include/linux/binfmts.h~allow-recursion-in-binfmt_script-and-binfmt_misc
+++ a/include/linux/binfmts.h
@@ -39,6 +39,7 @@ struct linux_binprm{
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
+	unsigned int recursion_depth;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_post_exec_permitted;
@@ -61,6 +62,7 @@ struct linux_binprm{
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
+#define BINPRM_MAX_RECURSION 4
 
 /*
  * This structure defines the functions that are used to load the binary formats that
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

