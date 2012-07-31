From: akpm@linux-foundation.org
Subject: [merged] coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:42 -0700
Message-ID: <20120731185343.1F4AC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:35472 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2GaSxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:44 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so293508bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bookjovi@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: fix wrong comments on core limits of pipe coredump case
has been removed from the -mm tree.  Its filename was
     coredump-fix-wrong-comments-on-core-limits-of-pipe-coredump-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from bookjovi@gmail.com are

origin.patch
linux-next.patch

