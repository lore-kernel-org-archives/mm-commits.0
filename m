From: akpm@linux-foundation.org
Subject: + audit-dont-check-if-kauditd-is-valid-every-time.patch added to -mm tree
Date: Thu, 11 Apr 2013 15:16:05 -0700
Message-ID: <20130411221605.783DD5A4228@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:43465 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab3DKWQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 18:16:07 -0400
Received: by mail-vb0-f73.google.com with SMTP id q12so193013vbe.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 15:16:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaofeng@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: audit: don't check if kauditd is valid every time
has been added to the -mm tree.  Its filename is
     audit-dont-check-if-kauditd-is-valid-every-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: audit: don't check if kauditd is valid every time

We only need to check if kauditd is valid after we start it, if kauditd is
invalid, we will set kauditd_task to NULL.  So next time, we will start
kauditd again.

It means if kauditd_task is not NULL,it must be valid.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/audit.c~audit-dont-check-if-kauditd-is-valid-every-time kernel/audit.c
--- a/kernel/audit.c~audit-dont-check-if-kauditd-is-valid-every-time
+++ a/kernel/audit.c
@@ -660,14 +660,14 @@ static int audit_receive_msg(struct sk_b
 
 	/* As soon as there's any sign of userspace auditd,
 	 * start kauditd to talk to it */
-	if (!kauditd_task)
+	if (!kauditd_task) {
 		kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
-	if (IS_ERR(kauditd_task)) {
-		err = PTR_ERR(kauditd_task);
-		kauditd_task = NULL;
-		return err;
+		if (IS_ERR(kauditd_task)) {
+			err = PTR_ERR(kauditd_task);
+			kauditd_task = NULL;
+			return err;
+		}
 	}
