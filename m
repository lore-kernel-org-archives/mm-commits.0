From: akpm@linux-foundation.org
Subject: [merged] ipcns-fix-use-after-free-in-free_ipc_ns.patch removed from -mm tree
Date: Mon, 28 Mar 2011 13:40:13 -0700
Message-ID: <201103282039.p2SKdZJH027611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1C1UkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 16:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfeng@redhat.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: fix use after free in free_ipc_ns()
has been removed from the -mm tree.  Its filename was
     ipcns-fix-use-after-free-in-free_ipc_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: fix use after free in free_ipc_ns()
From: Xiaotian Feng <dfeng@redhat.com>

commit b515498 ("userns: add a user namespace owner of ipc ns") added a
user namespace owner of ipc ns, but it also introduced a use after free in
free_ipc_ns().

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/namespace.c~ipcns-fix-use-after-free-in-free_ipc_ns ipc/namespace.c
--- a/ipc/namespace.c~ipcns-fix-use-after-free-in-free_ipc_ns
+++ a/ipc/namespace.c
@@ -104,7 +104,6 @@ static void free_ipc_ns(struct ipc_names
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
-	kfree(ns);
 	atomic_dec(&nr_ipc_ns);
 
 	/*
@@ -113,6 +112,7 @@ static void free_ipc_ns(struct ipc_names
 	 */
 	ipcns_notify(IPCNS_REMOVED);
 	put_user_ns(ns->user_ns);
+	kfree(ns);
 }
 
 /*
_

Patches currently in -mm which might be from dfeng@redhat.com are

origin.patch

