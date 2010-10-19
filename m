From: akpm@linux-foundation.org
Subject: + hostfs-trivial-code-cleanup.patch added to -mm tree
Date: Tue, 19 Oct 2010 15:22:07 -0700
Message-ID: <201010192222.o9JMM7g4004694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab0JSWWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 18:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, jdike@addtoit.com


The patch titled
     hostfs: code cleanups
has been added to the -mm tree.  Its filename is
     hostfs-trivial-code-cleanup.patch

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
Subject: hostfs: code cleanups
From: Richard Weinberger <richard@nod.at>

Some code cleanups for hostfs.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_user.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/hostfs/hostfs_user.c~hostfs-trivial-code-cleanup fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~hostfs-trivial-code-cleanup
+++ a/fs/hostfs/hostfs_user.c
@@ -94,8 +94,7 @@ void *open_dir(char *path, int *err_out)
 
 	dir = opendir(path);
 	*err_out = errno;
-	if (dir == NULL)
-		return NULL;
+
 	return dir;
 }
 
@@ -205,7 +204,7 @@ int set_attr(const char *file, struct ho
 	if (attrs->ia_valid & HOSTFS_ATTR_MODE) {
 		if (fd >= 0) {
 			if (fchmod(fd, attrs->ia_mode) != 0)
-				return (-errno);
+				return -errno;
 		} else if (chmod(file, attrs->ia_mode) != 0) {
 			return -errno;
 		}
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
um-fix-global-timer-issue-when-using-config_no_hz.patch
um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault.patch
hostfs-fix-uml-crash-remove-f_spare-from-hostfs.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch
hostfs-trivial-code-cleanup.patch

