From: akpm@linux-foundation.org
Subject: [merged] audit-dont-check-if-kauditd-is-valid-every-time.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:18 -0700
Message-ID: <20130430184318.7CA1A5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58795 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab3D3SnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:20 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86031qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaofeng@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: don't check if kauditd is valid every time
has been removed from the -mm tree.  Its filename was
     audit-dont-check-if-kauditd-is-valid-every-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
