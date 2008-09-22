From: akpm@linux-foundation.org
Subject: + cred-delete-alloc_creds-as-its-not-used.patch added to -mm tree
Date: Mon, 22 Sep 2008 16:38:06 -0700
Message-ID: <200809222338.m8MNc6p3004126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbYIVXj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 19:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jmorris@namei.org


The patch titled
     cred: delete alloc_creds() as it's not used
has been added to the -mm tree.  Its filename is
     cred-delete-alloc_creds-as-its-not-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: delete alloc_creds() as it's not used
From: David Howells <dhowells@redhat.com>

Delete alloc_creds() as it's not used.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred-internals.h |    5 -----
 kernel/cred.c           |   15 ---------------
 2 files changed, 20 deletions(-)

diff -puN kernel/cred-internals.h~cred-delete-alloc_creds-as-its-not-used kernel/cred-internals.h
--- a/kernel/cred-internals.h~cred-delete-alloc_creds-as-its-not-used
+++ a/kernel/cred-internals.h
@@ -10,11 +10,6 @@
  */
 
 /*
- * cred.c
- */
-extern struct cred *alloc_creds(const struct cred *, gfp_t);
-
-/*
  * user.c
  */
 static inline void sched_switch_user(struct task_struct *p)
diff -puN kernel/cred.c~cred-delete-alloc_creds-as-its-not-used kernel/cred.c
--- a/kernel/cred.c~cred-delete-alloc_creds-as-its-not-used
+++ a/kernel/cred.c
@@ -112,21 +112,6 @@ void __put_cred(struct cred *cred)
 }
 EXPORT_SYMBOL(__put_cred);
 
-/*
- * Allocate new credentials
- */
-struct cred *alloc_creds(const struct cred *old, gfp_t gfp)
-{
-	struct cred *new;
-
-	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
-	if (old)
-		memcpy(new, old, sizeof(struct cred));
-	return new;
-}
