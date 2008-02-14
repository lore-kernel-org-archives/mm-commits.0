From: akpm@linux-foundation.org
Subject: + inotify-make-variables-static-in-inotify_userc.patch added to -mm tree
Date: Wed, 13 Feb 2008 19:37:42 -0800
Message-ID: <200802140337.m1E3bghW029139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021AbYBNDhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 22:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     inotify: make variables static in inotify_user.c
has been added to the -mm tree.  Its filename is
     inotify-make-variables-static-in-inotify_userc.patch

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
Subject: inotify: make variables static in inotify_user.c
From: Harvey Harrison <harvey.harrison@gmail.com>

inotify_max_user_instances, inotify_max_user_watches,
inotify_max_queued_events can all be made static.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/inotify_user.c~inotify-make-variables-static-in-inotify_userc fs/inotify_user.c
--- a/fs/inotify_user.c~inotify-make-variables-static-in-inotify_userc
+++ a/fs/inotify_user.c
@@ -41,9 +41,9 @@ static struct kmem_cache *event_cachep _
 static struct vfsmount *inotify_mnt __read_mostly;
 
 /* these are configurable via /proc/sys/fs/inotify/ */
-int inotify_max_user_instances __read_mostly;
-int inotify_max_user_watches __read_mostly;
-int inotify_max_queued_events __read_mostly;
+static int inotify_max_user_instances __read_mostly;
+static int inotify_max_user_watches __read_mostly;
+static int inotify_max_queued_events __read_mostly;
 
 /*
  * Lock ordering:
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
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
