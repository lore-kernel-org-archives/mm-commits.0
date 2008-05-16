From: akpm@linux-foundation.org
Subject: + pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch added to -mm tree
Date: Thu, 15 May 2008 19:44:59 -0700
Message-ID: <200805160244.m4G2ixA7022888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620AbYEPCpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com


The patch titled
     pidns: add the struct bsd_acct_struct pointer on pid_namespace struct
has been added to the -mm tree.  Its filename is
     pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch

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
Subject: pidns: add the struct bsd_acct_struct pointer on pid_namespace struct
From: Pavel Emelyanov <xemul@openvz.org>

All the bsdacct-related info will be stored in the area, pointer by this
one.

It will be NULL automatically for all new namespaces.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/pid_namespace.h~pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct
+++ a/include/linux/pid_namespace.h
@@ -14,6 +14,8 @@ struct pidmap {
 
 #define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
 
+struct bsd_acct_struct;
+
 struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
@@ -25,6 +27,9 @@ struct pid_namespace {
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt;
 #endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+	struct bsd_acct_struct *bacct;
+#endif
 };
 
 extern struct pid_namespace init_pid_ns;
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

