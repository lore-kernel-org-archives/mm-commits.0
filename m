From: akpm@linux-foundation.org
Subject: + sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch added to -mm tree
Date: Thu, 31 Jan 2013 12:49:48 -0800
Message-ID: <20130131204948.968F831C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:62641 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3AaUtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 15:49:49 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so113771vea.2
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 12:49:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, ebiederm@xmission.com


The patch titled
     Subject: kernel/utsname_sysctl.c: put get/get_uts() into CONFIG_PROC_SYSCTL code block
has been added to the -mm tree.  Its filename is
     sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-wrong-comments-about-anon_vma-lock.patch
linux-next.patch
fs-execc-make-bprm_mm_init-static.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

