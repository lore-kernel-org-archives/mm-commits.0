Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792469132;
	b=iAqmopxfcM1ftjvofqFfSjVeIzRGFM/arejm+WvG2n4NBYZPbIIus5fgbMU0YvSZfWlM
	 gELLh1ZrHzO0xz6nA1ezSBSJMyS0NTA/a+hhplwwq2J+/lscyULwxaRndPtF6Dgbz0w3S
	 +r0J+2oe2GBMd7Krj5YG3x2k1UpIRBWcFJXhP08UQ0jgIDLK2ser8CNz7M92jGNS1tPzd
	 lRV7lPlNKPOTK9ZdS+INMWfnSJBNmxzeAmhdWgl/6SYGaG97RXR/LETky3DrpkU3IfYa1
	 ssU1JTOKKBOxtpAMVtf2fjBRzrZ2KK+K7zqDcAGipDZOgRu5bPSj9dC3ghkrP6LkmGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792469132;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AokNy0c6SqCsGKqDBWyeN8gQImpc+qeya8HWaDRr81w=;
	b=1wQFGtSLwwaubM5j3lHaYrGdcZHBNFAxSU8osfE2dQv7OL9Cxi+ILo1ZBwzgKwo5TCGp
	 1kHGx58wBFXMCJG6tClRXUorC4tw7hhKiIFEJMLpjHglkeIkzTvbIKDgsB1BdFeXdmwCQ
	 0cTZSeGEhpiZDVz8bsmq73VsLZaOASCjsQH28jhmZ9BH7rG3T1CzBh9NluIhthZDM9xK/
	 bmm3UN7+Wf1qX1qHpam1zJ4dCv6X5dxIVs1tQzK/uXVZNwBxdDYCVZtBvOy8J7i+KwZot
	 Mss4CDr9eASkA1YdBWCGcAY2CyXeDkBbK67lqJwUZRO5ZDrDs3RYfH0BbIg0C0u3nyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eOpYn2if;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B87D606A319
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 04:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eOpYn2if
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8761F000C4;
	Tue, 20 Oct 2026 04:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792469131;
	bh=AokNy0c6SqCsGKqDBWyeN8gQImpc+qeya8HWaDRr81w=;
	h=Date:To:From:Subject;
	b=eOpYn2ifIhWGwHUAXxmq3jMtqUuSaBGWGfYeMZbMUH3hqR56+SSF0qCpOqTbTD+vD
	 5cCRoQZyPhyCSgvliQ+k6YSrZ2KPPrHZ5wtQj+Xoyo8lQ+nQ1a+bTu1C9BBY7tbGJs
	 z4HKqfYKwIR4W0fRO3mN9vZ+4SB/NHJtikg650H0=
Date: Mon, 19 Oct 2026 21:05:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,ljs@kernel.org,akpm@linux-foundation.org,liam@infradead.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-shared-catch-a-failed-posix_memalign.patch added to mm-unstable branch
Message-Id: <20261020040531.CE8761F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/testing/shared: catch a failed posix_memalign()
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-shared-catch-a-failed-posix_memalign.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-shared-catch-a-failed-posix_memalign.patch

This patch will later appear in the mm-unstable branch at
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
From: "Liam R. Howlett (Google)" <liam@infradead.org>
Subject: tools/testing/shared: catch a failed posix_memalign()
Date: Mon, 19 Oct 2026 23:31:28 -0400

posix_memalign() returns zero or a positive error number and never sets
errno, so the checks for a negative return in kmem_cache_alloc_lru() and
kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
carries on with the pointer unset, into the constructor or the memset().

Test for any non-zero return.

Link: https://lore.kernel.org/20261020033128.1934349-1-liam@infradead.org
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/shared/linux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/shared/linux.c~tools-testing-shared-catch-a-failed-posix_memalign
+++ a/tools/testing/shared/linux.c
@@ -83,7 +83,7 @@ void *kmem_cache_alloc_lru(struct kmem_c
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
 		if (cachep->align) {
-			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
+			if (posix_memalign(&p, cachep->align, cachep->size))
 				return NULL;
 		} else {
 			p = malloc(cachep->size);
@@ -191,7 +191,7 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 
 			if (cachep->align) {
 				if (posix_memalign(&p[i], cachep->align,
-					       cachep->size) < 0)
+					       cachep->size))
 					break;
 			} else {
 				p[i] = malloc(cachep->size);
_

Patches currently in -mm which might be from liam@infradead.org are

tools-testing-shared-catch-a-failed-posix_memalign.patch

