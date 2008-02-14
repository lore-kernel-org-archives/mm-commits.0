From: akpm@linux-foundation.org
Subject: + adfs-work-around-bogus-sparse-warning.patch added to -mm tree
Date: Wed, 13 Feb 2008 19:40:15 -0800
Message-ID: <200802140340.m1E3eFtq029201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761220AbYBNDkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 22:40:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, rmk@arm.linux.org.uk


The patch titled
     adfs: work around bogus sparse warning
has been added to the -mm tree.  Its filename is
     adfs-work-around-bogus-sparse-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adfs: work around bogus sparse warning
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/adfs/dir_f.c:126:4: warning: do-while statement is not a compound statement

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_f.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/adfs/dir_f.c~adfs-work-around-bogus-sparse-warning fs/adfs/dir_f.c
--- a/fs/adfs/dir_f.c~adfs-work-around-bogus-sparse-warning
+++ a/fs/adfs/dir_f.c
@@ -122,9 +122,9 @@ adfs_dir_checkbyte(const struct adfs_dir
 		ptr.ptr8 = bufoff(bh, i);
 		end.ptr8 = ptr.ptr8 + last - i;
 
-		do
+		do {
 			dircheck = *ptr.ptr8++ ^ ror13(dircheck);
-		while (ptr.ptr8 < end.ptr8);
+		} while (ptr.ptr8 < end.ptr8);
 	}
 
 	/*
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
inotify-make-variables-static-in-inotify_userc.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
