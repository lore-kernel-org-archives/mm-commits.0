From: akpm@linux-foundation.org
Subject: + proc-make-proc-pid-limits-world-readable.patch added to -mm tree
Date: Mon, 27 Sep 2010 13:05:20 -0700
Message-ID: <201009272005.o8RK5Kx4013714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933544Ab0I0UFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 16:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jolsa@redhat.com, eugene@redhat.com, nhorman@tuxdriver.com


The patch titled
     proc: make /proc/pid/limits world readable
has been added to the -mm tree.  Its filename is
     proc-make-proc-pid-limits-world-readable.patch

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
Subject: proc: make /proc/pid/limits world readable
From: Jiri Olsa <jolsa@redhat.com>

Having the limits file world readable will ease the task of system
management on systems where root privileges might be restricted.

Having admin restricted with root priviledges, he/she could not check
other users process' limits.

Also it'd align with most of the /proc stat files.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Eugene Teo <eugene@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~proc-make-proc-pid-limits-world-readable fs/proc/base.c
--- a/fs/proc/base.c~proc-make-proc-pid-limits-world-readable
+++ a/fs/proc/base.c
@@ -2680,7 +2680,7 @@ static const struct pid_entry tgid_base_
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	INF("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -3017,7 +3017,7 @@ static const struct pid_entry tid_base_s
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	INF("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
_

Patches currently in -mm which might be from jolsa@redhat.com are

linux-next.patch
proc-make-proc-pid-limits-world-readable.patch

