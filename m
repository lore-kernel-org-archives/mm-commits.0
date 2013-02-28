From: akpm@linux-foundation.org
Subject: [merged] sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:53 -0800
Message-ID: <20130228201653.BE2A15A42AB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:42042 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab3B1UQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:54 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245408yen.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/utsname_sysctl.c: put get/get_uts() into CONFIG_PROC_SYSCTL code block
has been removed from the -mm tree.  Its filename was
     sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: kernel/utsname_sysctl.c: put get/get_uts() into CONFIG_PROC_SYSCTL code block

Put get/get_uts() into CONFIG_PROC_SYSCTL code block as they are used
only when CONFIG_PROC_SYSCTL is enabled.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utsname_sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/utsname_sysctl.c~sysctl-put-get-get_uts-into-config_proc_sysctl-code-block kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-put-get-get_uts-into-config_proc_sysctl-code-block
+++ a/kernel/utsname_sysctl.c
@@ -15,6 +15,8 @@
 #include <linux/sysctl.h>
 #include <linux/wait.h>
 
+#ifdef CONFIG_PROC_SYSCTL
+
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
@@ -38,7 +40,6 @@ static void put_uts(ctl_table *table, in
 		up_write(&uts_sem);
 }
 
-#ifdef CONFIG_PROC_SYSCTL
 /*
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

origin.patch

