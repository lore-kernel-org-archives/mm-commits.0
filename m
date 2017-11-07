From: akpm@linux-foundation.org
Subject: + pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix.patch added to -mm tree
Date: Mon, 06 Nov 2017 16:06:43 -0800
Message-ID: <5a00f913.ezvQDnzfTRlE7XsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932808AbdKGAGo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2017 19:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, gs051095@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid: restore the old behaviour of the ns_last_pid sysctl
has been added to the -mm tree.  Its filename is
     pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: pid: restore the old behaviour of the ns_last_pid sysctl

CRIU uses ns_last_pid to fork a process with a specified pid.  For
example, if we need to create a process with the pid of 10000, we write
9999 into /proc/sys/kernel/ns_last_pid

$ echo 9999 > /proc/sys/kernel/ns_last_pid; sh -c 'echo $$'
10000

This behaviour has been broken and now if we write 9999 to ns_last_pid,
a process will get the pid 9999. This patch restores the old behaviour.

v2: make code a bit more readable // Oleg

Link: http://lkml.kernel.org/r/20171106183144.16368-1-avagin@openvz.org
fixes: ("pid: replace pid bitmap implementation with IDR API")
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Gargi Sharma <gs051095@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix
+++ a/kernel/pid_namespace.c
@@ -287,6 +287,7 @@ static int pid_ns_ctl_handler(struct ctl
 {
 	struct pid_namespace *pid_ns = task_active_pid_ns(current);
 	struct ctl_table tmp = *table;
+	int ret, next;
 
 	if (write && !ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
@@ -297,8 +298,14 @@ static int pid_ns_ctl_handler(struct ctl
 	 * it should synchronize its usage with external means.
 	 */
 
-	tmp.data = &pid_ns->idr.idr_next;
-	return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	next = idr_get_cursor(&pid_ns->idr) - 1;
+
+	tmp.data = &next;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (!ret && write)
+		idr_set_cursor(&pid_ns->idr, next + 1);
+
+	return ret;
 }
 
 extern int pid_max;
_

Patches currently in -mm which might be from avagin@openvz.org are

pid-replace-pid-bitmap-implementation-with-idr-api-v6-fix.patch

