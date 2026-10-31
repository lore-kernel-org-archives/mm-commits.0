Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793434697;
	b=n0s5WT5MYab4mcHEHMVzsbhXY0ZLNcVny5bX0LHknmrrhsSYpzkhrLX8VlTlud3XwEat
	 WT4jRQiDW7LhERUSXAExEboKo/MQJ+7NgAn/mT5VOa12rN6RQmQaOJkqyVq8Z0/x2rbYD
	 J83eLrSTUpwqvQTK+uG4ThLpodx8cBu7y0BdK0dJKRJ9OGDWkXbqqgr1XNN9RbHqmjV5Z
	 YI6wXBrB26Hnsvz+2cu1pdfg7+RDUxPoVR0ItKx6+G63kdDDpuVxqml8szN3LYpIcrN91
	 4beQogG+JHIYp3THKsXoz5KtQG7iCwRh3HXgY9p+5ned4GAw3KVbFqhMeeBpppc2Ptg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793434697;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jRnA9D7J67xDbMeGFm3UP9yHmxzoA/EESkgCstUoQG4=;
	b=ua1lSEPSxkZbVu0PdNMmrRT7LpVHef1b1vbknaoA1JSg7/mdY9EF59kLAGEVaKTQLhN4
	 nIKZOVLKAXBQGaAidbiVRFU25IzWglLGMyItz25xhTBtXCWSQpn4axrmfAZPeALm/Q1CW
	 LCT4ziXKledzhab7HJBGz+7yamGcUovBIqSt2uL4gGkThQAJMXOP6h2NBbn6pLsg+J/Yc
	 6fTZoLdb97WJqoNunG7CkQX11+ZfAg2DQrocenOzT34BQ+HRJ7pf8JgdaUlCjH8dtoPhY
	 r50jWAISlV//0XDvWA8koRzZyWwBcWBTsq1QG5fHZ74QVE9s9zRpRRX74A7MlZYl2cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g4oYFLd3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4BF606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g4oYFLd3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567811F0093A;
	Sat, 31 Oct 2026 08:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793434696;
	bh=jRnA9D7J67xDbMeGFm3UP9yHmxzoA/EESkgCstUoQG4=;
	h=Date:To:From:Subject;
	b=g4oYFLd3Ems7HV0K2u5yggDI8ENeuNKnmjMF0smh/Gkkv8gwd+GZXX1faiW6cSbag
	 P7Y3Uo0OjHf87PBb8iEb2ixmjXMb9BrHkjXR1S9i/BZV9dnlgZeJDUR/LTzGz2SDkm
	 5S051cmfQHt8yRh360e9+EJ8A6mygPx1RhXIqFSg=
Date: Sat, 31 Oct 2026 01:18:15 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,arnd@arndb.de,
	alexander@lechthaler.online,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-fix-malformed-kernel-doc-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20261031081816.567811F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/sem: fix malformed kernel-doc comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-fix-malformed-kernel-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-fix-malformed-kernel-doc-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Alexander Lechthaler <alexander@lechthaler.online>
Subject: ipc/sem: fix malformed kernel-doc comment
Date: Fri, 22 May 2026 21:05:07 +0200

perform_atomic_semop[_slow]() uses unsupported kernel-doc syntax,
triggering a warning:

  This comment starts with '/**', but isn't a kernel-doc comment

Split the shared comment into separate kernel-doc blocks for
perform_atomic_semop() and perform_atomic_semop_slow().

No functional change.

Link: https://lore.kernel.org/20260522190507.97175-1-alexander@lechthaler.online
Signed-off-by: Alexander Lechthaler <alexander@lechthaler.online>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@kernel.org>
---

 ipc/sem.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/ipc/sem.c~ipc-sem-fix-malformed-kernel-doc-comment
+++ a/ipc/sem.c
@@ -627,8 +627,8 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 }
 
 /**
- * perform_atomic_semop[_slow] - Attempt to perform semaphore
- *                               operations on a given array.
+ * perform_atomic_semop_slow - Attempt to perform semaphore
+ *                             operations on a given array.
  * @sma: semaphore array
  * @q: struct sem_queue that describes the operation
  *
@@ -716,6 +716,23 @@ undo:
 	return result;
 }
 
+/**
+ * perform_atomic_semop - Attempt to perform semaphore
+ *                        operations on a given array.
+ * @sma: semaphore array
+ * @q: struct sem_queue that describes the operation
+ *
+ * Caller blocking are as follows, based the value
+ * indicated by the semaphore operation (sem_op):
+ *
+ *  (1) >0 never blocks.
+ *  (2)  0 (wait-for-zero operation): semval is non-zero.
+ *  (3) <0 attempting to decrement semval to a value smaller than zero.
+ *
+ * Returns 0 if the operation was possible.
+ * Returns 1 if the operation is impossible, the caller must sleep.
+ * Returns <0 for error codes.
+ */
 static int perform_atomic_semop(struct sem_array *sma, struct sem_queue *q)
 {
 	int result, sem_op, nsops;
_

Patches currently in -mm which might be from alexander@lechthaler.online are

ipc-sem-fix-malformed-kernel-doc-comment.patch

