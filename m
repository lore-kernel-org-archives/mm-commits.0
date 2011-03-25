From: akpm@linux-foundation.org
Subject: + ipcns-fix-use-after-free-in-free_ipc_ns.patch added to -mm tree
Date: Thu, 24 Mar 2011 23:35:13 -0700
Message-ID: <201103250635.p2P6Z7nk023800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab1CYGfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 02:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, serge.hallyn@canonical.com


The patch titled
     ipcns: fix use after free in free_ipc_ns()
has been added to the -mm tree.  Its filename is
     ipcns-fix-use-after-free-in-free_ipc_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
ipcns-fix-use-after-free-in-free_ipc_ns.patch

