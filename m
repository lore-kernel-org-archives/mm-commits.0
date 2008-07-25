From: akpm@linux-foundation.org
Subject: - bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:55 -0700
Message-ID: <200807252302.m6PN2tp4003867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbYGYXDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     bsdacct: make check timer accept a bsd_acct_struct argument
has been removed from the -mm tree.  Its filename was
     bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: make check timer accept a bsd_acct_struct argument
From: Pavel Emelyanov <xemul@openvz.org>

We're going to have many bsd_acct_struct instances, not just one, so the
timer (currently working with a global one) has to know which one to work
with.

Use a handy setup_timer macro for it (thanks to Oleg for one).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/acct.c~bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument kernel/acct.c
--- a/kernel/acct.c~bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument
+++ a/kernel/acct.c
@@ -97,9 +97,10 @@ static struct bsd_acct_struct acct_globa
 /*
  * Called whenever the timer says to check the free space.
  */
-static void acct_timeout(unsigned long unused)
+static void acct_timeout(unsigned long x)
 {
-	acct_globals.needcheck = 1;
+	struct bsd_acct_struct *acct = (struct bsd_acct_struct *)x;
+	acct->needcheck = 1;
 }
 
 /*
@@ -193,8 +194,8 @@ static void acct_file_reopen(struct file
 		acct_globals.needcheck = 0;
 		acct_globals.active = 1;
 		/* It's been deleted if it was used before so this is safe */
-		init_timer(&acct_globals.timer);
-		acct_globals.timer.function = acct_timeout;
+		setup_timer(&acct_globals.timer, acct_timeout,
+				(unsigned long)&acct_globals);
 		acct_globals.timer.expires = jiffies + ACCT_TIMEOUT*HZ;
 		add_timer(&acct_globals.timer);
 	}
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

