From: akpm@osdl.org
Subject: + user_ns-handle-file-sigio-fix.patch added to -mm tree
Date: Tue, 23 Jan 2007 12:20:51 -0800
Message-ID: <200701232020.l0NKKpdv030179@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53460 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097AbXAWU2o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 15:28:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     user_ns: handle file sigio (fix)
has been added to the -mm tree.  Its filename is
     user_ns-handle-file-sigio-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user_ns: handle file sigio (fix)
From: Cedric Le Goater <clg@fr.ibm.com>

get_user_ns() returns NULL when CONFIG_USER_NS=n and this breaks
sigio_perm() which does not expect NULL values for ->user_ns.

I would fix this with the following patch.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/user_namespace.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/user_namespace.h~user_ns-handle-file-sigio-fix include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user_ns-handle-file-sigio-fix
+++ a/include/linux/user_namespace.h
@@ -48,7 +48,7 @@ static inline int clone_mnt_userns_permi
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
-	return NULL;
+	return &init_user_ns;
 }
 
 static inline int copy_user_ns(int flags, struct task_struct *tsk)
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user_ns-handle-file-sigio-fix.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
