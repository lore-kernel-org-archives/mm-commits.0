From: akpm@linux-foundation.org
Subject: + bsdacct-stir-up-comments-around-acct_process.patch added to -mm tree
Date: Mon, 19 May 2008 14:56:47 -0700
Message-ID: <200805192156.m4JLul9k022518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764257AbYESV5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, randy.dunlap@oracle.com


The patch titled
     bsdacct: fix and add comments around acct_process()
has been added to the -mm tree.  Its filename is
     bsdacct-stir-up-comments-around-acct_process.patch

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
Subject: bsdacct: fix and add comments around acct_process()
From: Pavel Emelyanov <xemul@openvz.org>

Fix the one describing what this function is and add one more - about
locking absence around pid namespaces loop.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~bsdacct-stir-up-comments-around-acct_process kernel/acct.c
--- a/kernel/acct.c~bsdacct-stir-up-comments-around-acct_process
+++ a/kernel/acct.c
@@ -657,7 +657,8 @@ static void acct_process_in_ns(struct pi
 }
 
 /**
- * acct_process - now just a wrapper around do_acct_process
+ * acct_process - now just a wrapper around acct_process_in_ns,
+ * which in turn is a wrapper around do_acct_process.
  *
  * handles process accounting for an exiting task
  */
@@ -665,6 +666,11 @@ void acct_process(void)
 {
 	struct pid_namespace *ns;
 
+	/*
+	 * This loop is safe lockless, since current is still
+	 * alive and holds its namespace, which in turn holds
+	 * its parent.
+	 */
 	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
 		acct_process_in_ns(ns);
 }
_

Patches currently in -mm which might be from xemul@openvz.org are

mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
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
bsdacct-stir-up-comments-around-acct_process.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

