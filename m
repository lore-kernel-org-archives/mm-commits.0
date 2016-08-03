From: akpm@linux-foundation.org
Subject: [merged] ipc-delete-nr_ipc_ns.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:15:06 -0700
Message-ID: <57a234aa.N2xtY0acr2OzqkHj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbcHCSPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: delete "nr_ipc_ns"
has been removed from the -mm tree.  Its filename was
     ipc-delete-nr_ipc_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ipc: delete "nr_ipc_ns"

Write-only variable.

Link: http://lkml.kernel.org/r/20160708214356.GA6785@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 --
 ipc/msgutil.c                 |    2 --
 ipc/namespace.c               |    2 --
 3 files changed, 6 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-delete-nr_ipc_ns include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-delete-nr_ipc_ns
+++ a/include/linux/ipc_namespace.h
@@ -63,8 +63,6 @@ struct ipc_namespace {
 };
 
 extern struct ipc_namespace init_ipc_ns;
-extern atomic_t nr_ipc_ns;
-
 extern spinlock_t mq_lock;
 
 #ifdef CONFIG_SYSVIPC
diff -puN ipc/msgutil.c~ipc-delete-nr_ipc_ns ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-delete-nr_ipc_ns
+++ a/ipc/msgutil.c
@@ -37,8 +37,6 @@ struct ipc_namespace init_ipc_ns = {
 #endif
 };
 
-atomic_t nr_ipc_ns = ATOMIC_INIT(1);
-
 struct msg_msgseg {
 	struct msg_msgseg *next;
 	/* the next part of the message follows immediately */
diff -puN ipc/namespace.c~ipc-delete-nr_ipc_ns ipc/namespace.c
--- a/ipc/namespace.c~ipc-delete-nr_ipc_ns
+++ a/ipc/namespace.c
@@ -43,7 +43,6 @@ static struct ipc_namespace *create_ipc_
 		kfree(ns);
 		return ERR_PTR(err);
 	}
-	atomic_inc(&nr_ipc_ns);
 
 	sem_init_ns(ns);
 	msg_init_ns(ns);
@@ -96,7 +95,6 @@ static void free_ipc_ns(struct ipc_names
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
-	atomic_dec(&nr_ipc_ns);
 
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch

