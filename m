From: akpm@osdl.org
Subject: - add-an-identifier-to-nsproxy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:53 -0800
Message-ID: <200612082005.kB8K5rX8002341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946380AbWLHUKB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     identifier to nsproxy
has been removed from the -mm tree.  Its filename was
     add-an-identifier-to-nsproxy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: identifier to nsproxy
From: Cedric Le Goater <clg@fr.ibm.com>

Add an identifier to nsproxy.  The default init_ns_proxy has identifier 0 and
allocated nsproxies are given -1.

This identifier will be used by a new syscall sys_bind_ns.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/init_task.h |    1 +
 include/linux/nsproxy.h   |    1 +
 kernel/nsproxy.c          |    4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/init_task.h~add-an-identifier-to-nsproxy include/linux/init_task.h
--- a/include/linux/init_task.h~add-an-identifier-to-nsproxy
+++ a/include/linux/init_task.h
@@ -75,6 +75,7 @@ extern struct nsproxy init_nsproxy;
 #define INIT_NSPROXY(nsproxy) {						\
 	.count		= ATOMIC_INIT(1),				\
 	.nslock		= __SPIN_LOCK_UNLOCKED(nsproxy.nslock),		\
+	.id		= 0,						\
 	.uts_ns		= &init_uts_ns,					\
 	.mnt_ns		= NULL,						\
 	INIT_IPC_NS(ipc_ns)						\
diff -puN include/linux/nsproxy.h~add-an-identifier-to-nsproxy include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~add-an-identifier-to-nsproxy
+++ a/include/linux/nsproxy.h
@@ -23,6 +23,7 @@ struct ipc_namespace;
 struct nsproxy {
 	atomic_t count;
 	spinlock_t nslock;
+	unsigned long id;
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
diff -puN kernel/nsproxy.c~add-an-identifier-to-nsproxy kernel/nsproxy.c
--- a/kernel/nsproxy.c~add-an-identifier-to-nsproxy
+++ a/kernel/nsproxy.c
@@ -45,8 +45,10 @@ static inline struct nsproxy *clone_name
 	struct nsproxy *ns;
 
 	ns = kmemdup(orig, sizeof(struct nsproxy), GFP_KERNEL);
-	if (ns)
+	if (ns) {
 		atomic_set(&ns->count, 1);
+		ns->id = -1;
+	}
 	return ns;
 }
 
_

Patches currently in -mm which might be from clg@fr.ibm.com are

add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
mm-fix-pagecache-write-deadlocks-xip.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch

