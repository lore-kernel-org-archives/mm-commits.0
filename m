Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793501158;
	b=DH+R2YJXBinHMPFLntZUIYZR0NEqK3S4lEEMHKH+T1kC3fHayni4qEfJWLfA7gNZNiz/
	 WIqteoHsTVKTWIfTF/llnlq6yr10iotppoG/r9ulxxD6U6isqQxOAiQw1wIb5Ij6hfalw
	 pHsICnaE3fX/UzJbRMbzzA2mgfOjCU0cA4hkEUs+9/i+sq5KyEF+x3Z57OOenbbFZe2BD
	 /gJ3qKtwLsnuJZ+SWgTwuiYdGwatC68657MxC+wnIXQfHoYfsPUjr3eYPwBybJ4+q8KKU
	 qE8Io30BpHhNmAO/b9gmrk2tCOJdNel1IUSd9q6YRgOhMfBl/mGbmGQGKUWW9ZR4DtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793501158;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3lDOY3CTHhVLbbzrwcEwNfwqpWEHKNOQe6ZB8zpFVOI=;
	b=4JBdM9YK+LjfvS4i/wRXk2vf7aN2Ypd+hwbHpw3S+zNC1OzoAEWpLqiWvs4NVoI2CAEa
	 ZZgfnO/bngvlRQ/2vSFiDo9ikCw5+yqzBu78I/XrgI5lDb8d2HxG5ZSFz4xPdFU8sTBSo
	 qO1nKLtgspVGTMXJinhgzKSW8jDZ7BwrbGAVOgMpkjeWl2q9jdN+8nuxbs+X9KvpXHjqy
	 U9ffvZYlMBF/wwAuz6+5cUWGsPQxgumcWVRABLV9hR0W5l9tVULcSEwd/gTQ1R1r6jWyd
	 l/+Eznh6nSmdutIOrJ5THQHObrHNBlZ6u6hthUH+jfgq+rbN6E0/Xf9UMfTMIBWKOgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0ycrfTV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7685606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 02:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0ycrfTV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3DF1F000C1;
	Sun,  1 Nov 2026 02:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793501157;
	bh=3lDOY3CTHhVLbbzrwcEwNfwqpWEHKNOQe6ZB8zpFVOI=;
	h=Date:To:From:Subject;
	b=0ycrfTV0Gqwy42Wvn+Ca2k8m7OTvX2PgQwsaoa13RFeUM9BpVACoDuJekooFN62Nn
	 m8kAS4ZDMBWFJML9VNSNhfI5n/T51nlbJ5YWEwHolMqLWqqNhfENRK70KlLaVr2CoO
	 az87ZyGjPNJ2FR8IbaW1gHoQF9QfshvHPuF3sXHo=
Date: Sat, 31 Oct 2026 19:45:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,
	azpijr@gmail.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch added to mm-new branch
Message-Id: <20261101024557.3C3DF1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/userfaultfd: store the child's new uffd context in the wait queue entry
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/userfaultfd: store the child's new uffd context in the wait queue entry
Date: Sat, 31 Oct 2026 11:47:48 -0400

A UFFD_EVENT_FORK message cannot carry the child's fd when it is queued,
because the fd has to be installed in the fd table of whichever task reads
the event.  The forking task has to hand the reader the new context
itself.  It does that by casting the child's userfaultfd_ctx pointer into
the arg.reserved.reserved1 field of the UAPI struct uffd_msg, which the
readers cast back.

That temporarily puts a kernel pointer in a struct that is copied to
userspace, and results in ugly casts when passing the uffd context around.
While resolve_userfault_fork() currently zeroes reserved1 before it is
exposed to userspace, this unnecessarily risks leaking a kernel pointer to
userspace if future modifications are buggy.

Store the fork_ctx pointer in struct userfaultfd_wait_queue instead, which
is kernel-internal and passed around anyway.  The casts and the zeroing go
away, at the (negligible) cost of 8 more bytes on the stack.

No functional change.

Link: https://lore.kernel.org/20261031-uffd-fork-ctx-v1-1-a837fd576ffc@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
---

 mm/userfaultfd.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry
+++ a/mm/userfaultfd.c
@@ -2443,6 +2443,8 @@ struct userfaultfd_wait_queue {
 	struct uffd_msg msg;
 	wait_queue_entry_t wq;
 	struct userfaultfd_ctx *ctx;
+	/* UFFD_EVENT_FORK: the context created for the child */
+	struct userfaultfd_ctx *fork_ctx;
 	bool waken;
 };
 
@@ -3019,14 +3021,8 @@ static void userfaultfd_event_wait_compl
 			 * didn't.
 			 */
 			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
-			if (ewq->msg.event == UFFD_EVENT_FORK) {
-				struct userfaultfd_ctx *new;
-
-				new = (struct userfaultfd_ctx *)
-					(unsigned long)
-					ewq->msg.arg.reserved.reserved1;
-				release_new_ctx = new;
-			}
+			if (ewq->msg.event == UFFD_EVENT_FORK)
+				release_new_ctx = ewq->fork_ctx;
 			break;
 		}
 
@@ -3124,7 +3120,7 @@ static void dup_fctx(struct userfaultfd_
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_FORK;
-	ewq.msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
+	ewq.fork_ctx = fctx->new;
 
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
@@ -3417,7 +3413,6 @@ static int resolve_userfault_fork(struct
 	if (fd < 0)
 		return fd;
 
-	msg->arg.reserved.reserved1 = 0;
 	msg->arg.fork.ufd = fd;
 	return 0;
 }
@@ -3495,9 +3490,7 @@ static ssize_t userfaultfd_ctx_read(stru
 			*msg = uwq->msg;
 
 			if (uwq->msg.event == UFFD_EVENT_FORK) {
-				fork_nctx = (struct userfaultfd_ctx *)
-					(unsigned long)
-					uwq->msg.arg.reserved.reserved1;
+				fork_nctx = uwq->fork_ctx;
 				list_move(&uwq->wq.entry, &fork_event);
 				/*
 				 * fork_nctx can be freed as soon as
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch

