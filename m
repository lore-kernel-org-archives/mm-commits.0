From: akpm@linux-foundation.org
Subject: + ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch added
 to -mm tree
Date: Thu, 25 May 2017 15:11:16 -0700
Message-ID: <59275684.vDj6pDN1JO1/YN2n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163339AbdEYWLR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: avoid ipc_rcu_putref for failed ipc_addid()
has been added to the -mm tree.  Its filename is
     ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: avoid ipc_rcu_putref for failed ipc_addid()

Loosely based on a patch from Kees Cook <keescook@chromium.org>:
- id and retval can be merged
- if ipc_addid() fails, then use call_rcu() directly.

The difference is that call_rcu is used for failed ipc_addid() calls, to
continue to guaranteed an rcu delay for security_sem_free().

Link: http://lkml.kernel.org/r/20170525185107.12869-14-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid
+++ a/ipc/sem.c
@@ -479,7 +479,6 @@ static struct sem_array *sem_alloc(size_
  */
 static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 {
-	int id;
 	int retval;
 	struct sem_array *sma;
 	key_t key = params->key;
@@ -520,10 +519,10 @@ static int newary(struct ipc_namespace *
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
 
-	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
-	if (id < 0) {
-		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
-		return id;
+	retval = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
+	if (retval < 0) {
+		call_rcu(&sma->sem_perm.rcu, sem_rcu_free);
+		return retval;
 	}
 	ns->used_sems += nsems;
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-semc-remove-sem_base-embed-struct-sem-v3.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
include-linux-semh-correctly-document-sem_ctime.patch
ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

