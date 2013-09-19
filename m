From: akpm@linux-foundation.org
Subject: + pidns-fix-free_pid-to-handle-the-first-fork-failure.patch added to -mm tree
Date: Thu, 19 Sep 2013 16:21:15 -0700
Message-ID: <523b86eb.RDJeAqzkglu7mzAJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3ISXVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge@hallyn.com, ebiederm@xmission.com, oleg@redhat.com

Subject: + pidns-fix-free_pid-to-handle-the-first-fork-failure.patch added to -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,serge@hallyn.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:21:15 -0700


The patch titled
     Subject: pidns: fix free_pid() to handle the first fork failure
has been added to the -mm tree.  Its filename is
     pidns-fix-free_pid-to-handle-the-first-fork-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pidns-fix-free_pid-to-handle-the-first-fork-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pidns-fix-free_pid-to-handle-the-first-fork-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pidns: fix free_pid() to handle the first fork failure

"case 0" in free_pid() assumes that disable_pid_allocation() should clear
PIDNS_HASH_ADDING before the last pid goes away.  However this doesn't
happen if the 1st fork() fails to create the child reaper which should
call disable_pid_allocation().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/pid.c~pidns-fix-free_pid-to-handle-the-first-fork-failure kernel/pid.c
--- a/kernel/pid.c~pidns-fix-free_pid-to-handle-the-first-fork-failure
+++ a/kernel/pid.c
@@ -273,6 +273,11 @@ void free_pid(struct pid *pid)
 			 */
 			wake_up_process(ns->child_reaper);
 			break;
+		case PIDNS_HASH_ADDING:
+			/* Handle a fork failure of the first process */
+			WARN_ON(ns->child_reaper);
+			ns->nr_hashed = 0;
+			/* fall through */
 		case 0:
 			schedule_work(&ns->proc_work);
 			break;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
pidns-fix-free_pid-to-handle-the-first-fork-failure.patch

