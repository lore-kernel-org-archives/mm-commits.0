From: akpm@linux-foundation.org
Subject: + coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case.patch added to -mm tree
Date: Mon, 09 Jul 2012 14:47:30 -0700
Message-ID: <20120709214730.B262E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37472 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2GIVrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 17:47:31 -0400
Received: by ggeh3 with SMTP id h3so1245038gge.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 14:47:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bookjovi@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com


The patch titled
     Subject: coredump: fix wrong comments on core limits of pipe coredump case
has been added to the -mm tree.  Its filename is
     coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jovi Zhang <bookjovi@gmail.com>
Subject: coredump: fix wrong comments on core limits of pipe coredump case

In commit 898b374a ("exec: replace call_usermodehelper_pipe with use of
umh init function and resolve limit"), the core limits recursive check
value was changed from 0 to 1, but the corresponding comments were not
updated.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case fs/exec.c
--- a/fs/exec.c~coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case
+++ a/fs/exec.c
@@ -2174,15 +2174,16 @@ void do_coredump(long signr, int exit_co
 		}
 
 		if (cprm.limit == 1) {
-			/*
+			/* See umh_pipe_setup() which sets RLIMIT_CORE = 1.
+			 *
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * cprm.limit of 1 here as a speacial value. Any
-			 * non-1 limit gets set to RLIM_INFINITY below, but
-			 * a limit of 0 skips the dump.  This is a consistent
-			 * way to catch recursive crashes.  We can still crash
-			 * if the core_pattern binary sets RLIM_CORE =  !1
-			 * but it runs as root, and can do lots of stupid things
+			 * cprm.limit of 1 here as a speacial value, this is a
+			 * consistent way to catch recursive crashes.
+			 * We can still crash if the core_pattern binary sets
+			 * RLIM_CORE = !1, but it runs as root, and can do
+			 * lots of stupid things.
+			 *
 			 * Note that we use task_tgid_vnr here to grab the pid
 			 * of the process group leader.  That way we get the
 			 * right pid if a thread in a multi-threaded
_
Subject: Subject: coredump: fix wrong comments on core limits of pipe coredump case

Patches currently in -mm which might be from bookjovi@gmail.com are

linux-next.patch
coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case.patch

