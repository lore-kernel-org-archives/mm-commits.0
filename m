From: akpm@linux-foundation.org
Subject: + bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch added to -mm tree
Date: Thu, 15 May 2008 19:44:55 -0700
Message-ID: <200805160244.m4G2itOj022882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbYEPCpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com


The patch titled
     bsdacct: rename acct_gbls to bsd_acct_struct
has been added to the -mm tree.  Its filename is
     bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch

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
Subject: bsdacct: rename acct_gbls to bsd_acct_struct
From: Pavel Emelyanov <xemul@openvz.org>

After I fixed access to task->tgid in kernel/acct.c, Oleg pointed out some
bad side effects with this accounting vs pid namespaces interaction.  I.e.
 when some task in pid namespace sets this accounting up, this blocks all
the others from doing the same.  Restricting this to init namespace only
could help, but didn't look a graceful solution.

So here is the approach to make this accounting work with pid namespaces
properly.

The idea is simple - when a task dies it accounts itself in each namespace
it is visible from and which set the accounting up.  

For example here are the commands run and the output of lastcomm from init
and sub namespaces:

init_ns# accton pacct
 sub_ns# accton pacct (this is a different file - sub ns is run in
                       a chroot-ed environment)
init_ns# cat /dev/null
 sub_ns# ls /dev/null
init_ns# accton
 sub_ns# accton

 sub_ns#  lastcomm -f pacct
ls                      0        [136,0]    0.00 secs Thu May 15 10:30
accton                  0        [136,0]    0.00 secs Thu May 15 10:30

init_ns# lastcomm -f pacct
accton                  root     pts/0      0.00 secs Thu May 15 14:30 << got from sub
cat                     root     pts/1      0.00 secs Thu May 15 14:30
ls                      root     pts/0      0.00 secs Thu May 15 14:30 << got from sub
accton                  root     pts/1      0.00 secs Thu May 15 14:30

That was the summary, the details are in patches.



This patch:

It will be visible in pid_namespace.h file, so fix its name to look better
outside the acct.c file.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/acct.c~bsdacct-rename-acct_blbls-to-bsd_acct_struct kernel/acct.c
--- a/kernel/acct.c~bsdacct-rename-acct_blbls-to-bsd_acct_struct
+++ a/kernel/acct.c
@@ -82,7 +82,7 @@ static void do_acct_process(struct pid_n
  * can be placed in the same cache line as the lock.  This primes
  * the cache line to have the data after getting the lock.
  */
-struct acct_glbs {
+struct bsd_acct_struct {
 	spinlock_t		lock;
 	volatile int		active;
 	volatile int		needcheck;
@@ -91,7 +91,7 @@ struct acct_glbs {
 	struct timer_list	timer;
 };
 
-static struct acct_glbs acct_globals __cacheline_aligned =
+static struct bsd_acct_struct acct_globals __cacheline_aligned =
 	{__SPIN_LOCK_UNLOCKED(acct_globals.lock)};
 
 /*
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

