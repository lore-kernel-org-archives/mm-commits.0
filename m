From: akpm@linux-foundation.org
Subject: + bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch added to -mm tree
Date: Thu, 15 May 2008 19:45:03 -0700
Message-ID: <200805160245.m4G2j3gh022900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbYEPCpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com


The patch titled
     bsdacct: make check timer accept a bsd_acct_struct argument
has been added to the -mm tree.  Its filename is
     bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch

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
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

