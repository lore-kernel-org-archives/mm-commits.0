From: akpm@linux-foundation.org
Subject: + ipc-sem-avoid-indexing-past-end-of-sem_array.patch added to -mm tree
Date: Tue, 09 May 2017 13:49:32 -0700
Message-ID: <59122b5c.U/ZIl3QJenp0uogH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdEIUtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 16:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: avoid indexing past end of sem_array
has been added to the -mm tree.  Its filename is
     ipc-sem-avoid-indexing-past-end-of-sem_array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-avoid-indexing-past-end-of-sem_array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-avoid-indexing-past-end-of-sem_array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/sem: avoid indexing past end of sem_array

This changes the struct + trailing data pattern to using a void * so that
the end of sem_array is found without possibly indexing past the end which
can upset some static analyzers.  Mostly, this ends up avoiding a cast
between different non-void types, which the future randstruct GCC plugin
was warning about.

Link: http://lkml.kernel.org/r/20170508222345.GA52073@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipc-sem-avoid-indexing-past-end-of-sem_array ipc/sem.c
--- a/ipc/sem.c~ipc-sem-avoid-indexing-past-end-of-sem_array
+++ a/ipc/sem.c
@@ -475,6 +475,7 @@ static int newary(struct ipc_namespace *
 {
 	int id;
 	int retval;
+	void *sem_alloc;
 	struct sem_array *sma;
 	int size;
 	key_t key = params->key;
@@ -488,11 +489,14 @@ static int newary(struct ipc_namespace *
 		return -ENOSPC;
 
 	size = sizeof(*sma) + nsems * sizeof(struct sem);
-	sma = ipc_rcu_alloc(size);
-	if (!sma)
+	sem_alloc = ipc_rcu_alloc(size);
+	if (!sem_alloc)
 		return -ENOMEM;
 
-	memset(sma, 0, size);
+	memset(sem_alloc, 0, size);
+
+	sma = sem_alloc;
+	sma->sem_base = sem_alloc + sizeof(*sma);
 
 	sma->sem_perm.mode = (semflg & S_IRWXUGO);
 	sma->sem_perm.key = key;
@@ -504,8 +508,6 @@ static int newary(struct ipc_namespace *
 		return retval;
 	}
 
-	sma->sem_base = (struct sem *) &sma[1];
