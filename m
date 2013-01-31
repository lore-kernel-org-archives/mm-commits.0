From: akpm@linux-foundation.org
Subject: + nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch added to -mm tree
Date: Thu, 31 Jan 2013 12:51:37 -0800
Message-ID: <20130131205137.A336F5A4207@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49280 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3AaUvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 15:51:38 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so348367qcq.5
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 12:51:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, ebiederm@xmission.com, serge.hallyn@canonical.com


The patch titled
     Subject: kernel/nsproxy.c: remove duplicate task_cred_xxx for user_ns
has been added to the -mm tree.  Its filename is
     nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch

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
Subject: kernel/nsproxy.c: remove duplicate task_cred_xxx for user_ns

We can use user_ns, which is also assigned from task_cred_xxx(tsk,
user_ns), at the beginning of copy_namespaces().

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/nsproxy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/nsproxy.c~nsproxy-remove-duplicate-task_cred_xxx-for-user_ns kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-remove-duplicate-task_cred_xxx-for-user_ns
+++ a/kernel/nsproxy.c
@@ -153,8 +153,7 @@ int copy_namespaces(unsigned long flags,
 		goto out;
 	}
 
-	new_ns = create_new_namespaces(flags, tsk,
-				       task_cred_xxx(tsk, user_ns), tsk->fs);
+	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
 	if (IS_ERR(new_ns)) {
 		err = PTR_ERR(new_ns);
 		goto out;
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

mm-fix-wrong-comments-about-anon_vma-lock.patch
linux-next.patch
nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch
fs-execc-make-bprm_mm_init-static.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

