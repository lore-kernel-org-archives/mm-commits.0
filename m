From: akpm@linux-foundation.org
Subject: - pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:51 -0700
Message-ID: <200807252302.m6PN2pgE003861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472AbYGYXD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     pidns: add the struct bsd_acct_struct pointer on pid_namespace struct
has been removed from the -mm tree.  Its filename was
     pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

