From: akpm@linux-foundation.org
Subject: [merged] nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:05 -0800
Message-ID: <20130222204305.A850531C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:44132 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab3BVUnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:06 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so104163vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, ebiederm@xmission.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/nsproxy.c: remove duplicate task_cred_xxx for user_ns
has been removed from the -mm tree.  Its filename was
     nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
fs-execc-make-bprm_mm_init-static.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

