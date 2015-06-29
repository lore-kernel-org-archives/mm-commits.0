From: akpm@linux-foundation.org
Subject: [merged] security_syslog-should-be-called-once-only.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:30 -0700
Message-ID: <5591aee2.O8OzXQFT5cSQl0Oi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbbF2Urb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@virtuozzo.com, eparis@redhat.com, jwboyer@redhat.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: security_syslog() should be called once only
has been removed from the -mm tree.  Its filename was
     security_syslog-should-be-called-once-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: security_syslog() should be called once only

The final version of 637241a900cb ("kmsg: honor dmesg_restrict sysctl on
/dev/kmsg") lost few hooks, as result security_syslog() are processed
incorrectly:

- open of /dev/kmsg checks syslog access permissions by using
  check_syslog_permissions() where security_syslog() is not called if
  dmesg_restrict is set.

- syslog syscall and /proc/kmsg calls do_syslog() where security_syslog
  can be executed twice (inside check_syslog_permissions() and then
  directly in do_syslog())

With this patch security_syslog() is called once only in all
syslog-related operations regardless of dmesg_restrict value.

Fixes: 637241a900cb ("kmsg: honor dmesg_restrict sysctl on /dev/kmsg")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/printk/printk.c~security_syslog-should-be-called-once-only kernel/printk/printk.c
--- a/kernel/printk/printk.c~security_syslog-should-be-called-once-only
+++ a/kernel/printk/printk.c
@@ -496,11 +496,11 @@ int check_syslog_permissions(int type, b
 	 * already done the capabilities checks at open time.
 	 */
 	if (from_file && type != SYSLOG_ACTION_OPEN)
-		return 0;
+		goto ok;
 
 	if (syslog_action_restricted(type)) {
 		if (capable(CAP_SYSLOG))
-			return 0;
+			goto ok;
 		/*
 		 * For historical reasons, accept CAP_SYS_ADMIN too, with
 		 * a warning.
@@ -510,10 +510,11 @@ int check_syslog_permissions(int type, b
 				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
 				     "(deprecated).\n",
 				 current->comm, task_pid_nr(current));
-			return 0;
+			goto ok;
 		}
 		return -EPERM;
 	}
+ok:
 	return security_syslog(type);
 }
 
@@ -1299,10 +1300,6 @@ int do_syslog(int type, char __user *buf
 	if (error)
 		goto out;
 
-	error = security_syslog(type);
-	if (error)
-		return error;
