From: akpm@linux-foundation.org
Subject: + ipc-delete-nr_ipc_ns.patch added to -mm tree
Date: Mon, 11 Jul 2016 14:28:02 -0700
Message-ID: <57840f62.TAn/ppjNAol4WK78%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbcGKV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 17:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: delete "nr_ipc_ns"
has been added to the -mm tree.  Its filename is
     ipc-delete-nr_ipc_ns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-delete-nr_ipc_ns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-delete-nr_ipc_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -40,7 +40,6 @@ static struct ipc_namespace *create_ipc_
 		kfree(ns);
 		return ERR_PTR(err);
 	}
-	atomic_inc(&nr_ipc_ns);
 
 	sem_init_ns(ns);
 	msg_init_ns(ns);
@@ -95,7 +94,6 @@ static void free_ipc_ns(struct ipc_names
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
-	atomic_dec(&nr_ipc_ns);
 
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cflags-add-wunused-but-set-parameter.patch
ban-config_localversion_auto-with-allmodconfig.patch
ipc-delete-nr_ipc_ns.patch

