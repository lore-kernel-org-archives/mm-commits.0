From: akpm@linux-foundation.org
Subject: +
 fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch added
 to -mm tree
Date: Wed, 05 Aug 2015 15:05:14 -0700
Message-ID: <55c2889a.kyCPjMgexY/AwuSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbbHEWFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 18:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: Don't dump core if the corefile would become world-readable.
has been added to the -mm tree.  Its filename is
     fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: fs: Don't dump core if the corefile would become world-readable.

On a filesystem like vfat, all files are created with the same owner
and mode independent of who created the file. When a vfat filesystem
is mounted with root as owner of all files and read access for everyone,
root's processes left world-readable coredumps on it (but other
users' processes only left empty corefiles when given write access
because of the uid mismatch).

Given that the old behavior was inconsistent and insecure, I don't see
a problem with changing it. Now, all processes refuse to dump core unless
the resulting corefile will only be readable by their owner.

Signed-off-by: Jann Horn <jann@thejh.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/coredump.c~fs-dont-dump-core-if-the-corefile-would-become-world-readable fs/coredump.c
--- a/fs/coredump.c~fs-dont-dump-core-if-the-corefile-would-become-world-readable
+++ a/fs/coredump.c
@@ -685,11 +685,15 @@ void do_coredump(const siginfo_t *siginf
 		if (!S_ISREG(inode->i_mode))
 			goto close_fail;
 		/*
-		 * Dont allow local users get cute and trick others to coredump
-		 * into their pre-created files.
+		 * Don't dump core if the filesystem changed owner or mode
+		 * of the file during file creation. This is an issue when
+		 * a process dumps core while its cwd is e.g. on a vfat
+		 * filesystem.
 		 */
 		if (!uid_eq(inode->i_uid, current_fsuid()))
 			goto close_fail;
+		if ((inode->i_mode & 0677) != 0600)
+			goto close_fail;
 		if (!(cprm.file->f_mode & FMODE_CAN_WRITE))
 			goto close_fail;
 		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
_

Patches currently in -mm which might be from jann@thejh.net are

fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch
fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch

