From: akpm@linux-foundation.org
Subject: [merged] coredump-suppress-uid-comparison-test-if-core-output-files-are-pipes.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:05 -0800
Message-ID: <201003091910.o29JA5Ur031570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082Ab0CITXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:23:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mingo@elte.hu, oleg@redhat.com, torvalds@woody.linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     coredump: suppress uid comparison test if core output files are pipes
has been removed from the -mm tree.  Its filename was
     coredump-suppress-uid-comparison-test-if-core-output-files-are-pipes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: suppress uid comparison test if core output files are pipes
From: Neil Horman <nhorman@tuxdriver.com>

Modify uid check in do_coredump so as to not apply it in the case of
pipes.

This just got noticed in testing.  The end of do_coredump validates the
uid of the inode for the created file against the uid of the crashing
process to ensure that no one can pre-create a core file with different
ownership and grab the information contained in the core when they
shouldn' tbe able to.  This causes failures when using pipes for a core
dumps if the crashing process is not root, which is the uid of the pipe
when it is created.

The fix is simple.  Since the check for matching uid's isn't relevant for
pipes (a process can't create a pipe that the uermodehelper code will open
anyway), we can just just skip it in the event ispipe is non-zero

Reverts a pipe-affecting change which was accidentally made in

: commit c46f739dd39db3b07ab5deb4e3ec81e1c04a91af
: Author:     Ingo Molnar <mingo@elte.hu>
: AuthorDate: Wed Nov 28 13:59:18 2007 +0100
: Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
: CommitDate: Wed Nov 28 10:58:01 2007 -0800
: 
:     vfs: coredumping fix

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~coredump-suppress-uid-comparison-test-if-core-output-files-are-pipes fs/exec.c
--- a/fs/exec.c~coredump-suppress-uid-comparison-test-if-core-output-files-are-pipes
+++ a/fs/exec.c
@@ -1936,8 +1936,9 @@ void do_coredump(long signr, int exit_co
 	/*
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
+	 * Note, this is not relevant for pipes
 	 */
-	if (inode->i_uid != current_fsuid())
+	if (!ispipe && (inode->i_uid != current_fsuid()))
 		goto close_fail;
 	if (!cprm.file->f_op)
 		goto close_fail;
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch

