From: akpm@osdl.org
Subject: + nsproxy-externalizes-exit_task_namespaces.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:10:12 -0800
Message-ID: <200701042210.l04MAGjF000421@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:58228 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964820AbXADWLi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:11:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     nsproxy: externalizes exit_task_namespaces
has been added to the -mm tree.  Its filename is
     nsproxy-externalizes-exit_task_namespaces.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nsproxy: externalizes exit_task_namespaces
From: Cedric Le Goater <clg@fr.ibm.com>

This is required to remove a header dependency in sched.h which breaks next
patches.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/nsproxy.h |   15 ++++-----------
 kernel/nsproxy.c        |   11 +++++++++++
 2 files changed, 15 insertions(+), 11 deletions(-)

diff -puN include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces
+++ a/include/linux/nsproxy.h
@@ -2,7 +2,8 @@
 #define _LINUX_NSPROXY_H
 
 #include <linux/spinlock.h>
-#include <linux/sched.h>
+
+struct task_struct;
 
 struct mnt_namespace;
 struct uts_namespace;
@@ -43,14 +44,6 @@ static inline void put_nsproxy(struct ns
 	}
 }
 
-static inline void exit_task_namespaces(struct task_struct *p)
-{
-	struct nsproxy *ns = p->nsproxy;
-	if (ns) {
-		task_lock(p);
-		p->nsproxy = NULL;
-		task_unlock(p);
-		put_nsproxy(ns);
-	}
-}
+extern void exit_task_namespaces(struct task_struct *p);
+
 #endif
diff -puN kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces
+++ a/kernel/nsproxy.c
@@ -36,6 +36,17 @@ void get_task_namespaces(struct task_str
 	}
 }
 
+void exit_task_namespaces(struct task_struct *p)
+{
+	struct nsproxy *ns = p->nsproxy;
+	if (ns) {
+		task_lock(p);
+		p->nsproxy = NULL;
+		task_unlock(p);
+		put_nsproxy(ns);
+	}
+}
+
 /*
  * creates a copy of "orig" with refcount 1.
  * This does not grab references to the contained namespaces,
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
