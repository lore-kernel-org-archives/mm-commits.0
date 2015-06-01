From: akpm@linux-foundation.org
Subject: + check_syslog_permissions-cleanup.patch added to -mm tree
Date: Mon, 01 Jun 2015 14:19:03 -0700
Message-ID: <556ccc47.XqaSNCH+IG7MWoFL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbFAVTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 17:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@virtuozzo.com, eparis@redhat.com, jwboyer@redhat.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: check_syslog_permissions() cleanup
has been added to the -mm tree.  Its filename is
     check_syslog_permissions-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/check_syslog_permissions-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/check_syslog_permissions-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: check_syslog_permissions() cleanup

Patch fixes drawbacks in heck_syslog_permissions() noticed by AKPM:
"from_file handling makes me cry.

That's not a boolean - it's an enumerated value with two values
currently defined.

But the code in check_syslog_permissions() treats it as a boolean and
also hardwires the knowledge that SYSLOG_FROM_PROC == 1 (or == `true`).

And the name is wrong: it should be called from_proc to match
SYSLOG_FROM_PROC."

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syslog.h |    6 +++---
 kernel/printk/printk.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/syslog.h~check_syslog_permissions-cleanup include/linux/syslog.h
--- a/include/linux/syslog.h~check_syslog_permissions-cleanup
+++ a/include/linux/syslog.h
@@ -47,12 +47,12 @@
 #define SYSLOG_FROM_READER           0
 #define SYSLOG_FROM_PROC             1
 
-int do_syslog(int type, char __user *buf, int count, bool from_file);
+int do_syslog(int type, char __user *buf, int count, int source);
 
 #ifdef CONFIG_PRINTK
-int check_syslog_permissions(int type, bool from_file);
+int check_syslog_permissions(int type, int source);
 #else
-static inline int check_syslog_permissions(int type, bool from_file)
+static inline int check_syslog_permissions(int type, int source)
 {
 	return 0;
 }
diff -puN kernel/printk/printk.c~check_syslog_permissions-cleanup kernel/printk/printk.c
--- a/kernel/printk/printk.c~check_syslog_permissions-cleanup
+++ a/kernel/printk/printk.c
@@ -489,13 +489,13 @@ static int syslog_action_restricted(int
 	       type != SYSLOG_ACTION_SIZE_BUFFER;
 }
 
-int check_syslog_permissions(int type, bool from_file)
+int check_syslog_permissions(int type, int source)
 {
 	/*
 	 * If this is from /proc/kmsg and we've already opened it, then we've
 	 * already done the capabilities checks at open time.
 	 */
-	if (from_file && type != SYSLOG_ACTION_OPEN)
+	if (source == SYSLOG_FROM_PROC && type != SYSLOG_ACTION_OPEN)
 		goto ok;
 
 	if (syslog_action_restricted(type)) {
@@ -1290,13 +1290,13 @@ static int syslog_print_all(char __user
 	return len;
 }
 
-int do_syslog(int type, char __user *buf, int len, bool from_file)
+int do_syslog(int type, char __user *buf, int len, int source)
 {
 	bool clear = false;
 	static int saved_console_loglevel = LOGLEVEL_DEFAULT;
 	int error;
 
-	error = check_syslog_permissions(type, from_file);
+	error = check_syslog_permissions(type, source);
 	if (error)
 		goto out;
 
@@ -1379,7 +1379,7 @@ int do_syslog(int type, char __user *buf
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
-		if (from_file) {
+		if (source == SYSLOG_FROM_PROC) {
 			/*
 			 * Short-cut for poll(/"proc/kmsg") which simply checks
 			 * for pending data, not the size; return the count of
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

security_syslog-should-be-called-once-only.patch
check_syslog_permissions-cleanup.patch

