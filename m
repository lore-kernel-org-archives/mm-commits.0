Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832543;
	b=dbsSlo2wMCXiTZZ4y86DjGOJtf7/l2mdOFEz1h78g3/pwyX9BwhWWGTKThJwjcN+emgH
	 UiJaEwqLv5sHkXIz+8OsKUvcF9DWrMU6J8UHwFByAGXdJWgANkNw2E8DdnziYa5/xa8ar
	 0GCbMq7STQ3htXgFe1DiFPVTGBiJZUlQTqWd8p+h5hY6oQ7vX2qaiJU/AdLe3Awom4f+h
	 5Cc3C9/cA1CLtY6qORy1iIKOJgEo44M7EvccdX8sD3NtExFvYHtmStVRNNFiupY6A+quT
	 JRVKrk5i2t63R4+8EijV04M5iSHmv+q8mW8dPjRGWrj9dpYgoStPu9FlpWMpQRmRekw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832543;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qpyEClfV88Tz4LBT8+dmn8OUCQS9GDTEQ4d4FOqfsSg=;
	b=HoUxXSaOQ/PaS5CcjEKaBIKwASycRbwL8PZFAip13oZaHUUNUo5uVsJTyOirtQqeDeKd
	 0fqETSqXoFARQoTkDwXbejw6Tevj9I+wjJAxPiXbHzn6qGh2iuDxPqCtdBoQTPhJrk0ry
	 xyrOsjqWH0Vg55KHlnsEI8Rwl/IHPK3QAM4YSAd1ha7i1atxN/R7w25MV7Uo9iLme1PZx
	 oD2BWAAGo8ilRK3T1oIWf/fkPNs2P8Lfu34r2a/0OzI5ewkBf+eJpLznwnxWvJIGK2tPP
	 QfYdeubPwFdJYSoTz4hosqZh4wv8n8GuecXh1n8WZXH/Xl0h+Wg48hOoZLJN5olW5Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=an4CrEvU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E24606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=an4CrEvU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130501F01828;
	Sat, 24 Oct 2026 09:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832543;
	bh=qpyEClfV88Tz4LBT8+dmn8OUCQS9GDTEQ4d4FOqfsSg=;
	h=Date:To:From:Subject;
	b=an4CrEvUaqq/RBrXAsw3iOT/D9QaxVTv29r5C4x495nzDbZwViRbUnuEhARXADBFu
	 6pAudBbrhjCmKVil7JgjA96U9bLr1/V8muGxFX4OPkho721mCX1w2v96geKjr2nNXo
	 dJycrT/21nZ+voujo+CU8mrD1EXpUFu6zVFfxbdE=
Date: Sat, 24 Oct 2026 02:02:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,vbabka@kernel.org,sj@kernel.org,ljs@kernel.org,akpm@linux-foundation.org,liam@infradead.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-shared-catch-a-failed-posix_memalign.patch removed from -mm tree
Message-Id: <20261024090223.130501F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: tools/testing/shared: catch a failed posix_memalign()
has been removed from the -mm tree.  Its filename was
     tools-testing-shared-catch-a-failed-posix_memalign.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 8801c35c3672 ("tools: fix -Wunused-result in linux.c")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
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


