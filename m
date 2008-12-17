From: akpm@linux-foundation.org
Subject: + pid-implement-ns_of_pid-update.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:46:14 -0800
Message-ID: <200812172246.mBHMkELQ021837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYLQWqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, sukadev@linux.vnet.ibm.com


The patch titled
     pid: Implement ns_of_pid (update)
has been added to the -mm tree.  Its filename is
     pid-implement-ns_of_pid-update.patch

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
Subject: pid: Implement ns_of_pid (update)
From: Eric Biederman <ebiederm@xmission.com>

- Add a note in function header of ns_of_pid() re: NULL pid.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/pid.h~pid-implement-ns_of_pid-update include/linux/pid.h
--- a/include/linux/pid.h~pid-implement-ns_of_pid-update
+++ a/include/linux/pid.h
@@ -122,8 +122,15 @@ int next_pidmap(struct pid_namespace *pi
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
 
-/* ns_of_pid returns the pid namespace in which the specified
- * pid was allocated.
+/*
+ * ns_of_pid() returns the pid namespace in which the specified pid was
+ * allocated.
+ *
+ * NOTE:
+ * 	ns_of_pid() is expected to be called for a process (task) that has
+ * 	an attached 'struct pid' (see attach_pid(), detach_pid()) i.e @pid
+ * 	is expected to be non-NULL. If @pid is NULL, caller should handle
+ * 	the resulting NULL pid-ns.
  */
 static inline struct pid_namespace *ns_of_pid(struct pid *pid)
 {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

linux-next.patch
pid-implement-ns_of_pid.patch
pid-implement-ns_of_pid-update.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch
vmcore-remove-saved_max_pfn-check.patch

