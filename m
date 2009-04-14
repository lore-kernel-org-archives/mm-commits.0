From: akpm@linux-foundation.org
Subject: [merged] namespaces-move-get_mq-inside-ifdef-config_sysctl.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:56 -0700
Message-ID: <200904141948.n3EJmu3a019311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbZDNTu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     namespaces: move get_mq() inside #ifdef CONFIG_SYSCTL
has been removed from the -mm tree.  Its filename was
     namespaces-move-get_mq-inside-ifdef-config_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: move get_mq() inside #ifdef CONFIG_SYSCTL
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

| ipc/mq_sysctl.c:26: warning: 'get_mq' defined but not used

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mq_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mq_sysctl.c~namespaces-move-get_mq-inside-ifdef-config_sysctl ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~namespaces-move-get_mq-inside-ifdef-config_sysctl
+++ a/ipc/mq_sysctl.c
@@ -22,6 +22,7 @@
 #define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
 #define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
 
+#ifdef CONFIG_PROC_SYSCTL
 static void *get_mq(ctl_table *table)
 {
 	char *which = table->data;
@@ -30,7 +31,6 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-#ifdef CONFIG_PROC_SYSCTL
 static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
linux-next.patch
fbdev-generated-logo-sources-depend-on-scripts-pnmtologo.patch
fbdev-move-logo-externs-to-header-file.patch

