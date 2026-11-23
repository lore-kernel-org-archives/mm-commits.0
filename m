Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795453614;
	b=LND76iFRC6NE3zQTRd1PnVkekvmACenTD0lMlZIZETTbEQdP7/lWucxCN9ZnLf+CbdCN
	 TGn6HLObZ2+LQol0Rm/FLlE3WE1175T9+IXxlwRUOJtw9fgrHmY5W1EL8GoCDyO+G4FSa
	 QGntiCZzza+McJfbImoSg3xkOgiiS+v+XTz/PjbAV53pe0wEjDsB1xC/YMa225uAmlvCp
	 x0eE5lUqjcLqklK5vV0qJ12Sp+LZ3ntN0CDvGXbQYKJ1im4bLaQteATQJlgTuwAZSJAa9
	 /1H8RZlrkxxES4Xt0LkxXAM9fsDRdWpERxD+uQhCXyp1g8/IL+FIrVtlptxTRr1knGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453614;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=hMbBmJN41CScJ5lVLHb4W8mmrVYHZRmL6MNgODToP2A=;
	b=jN+dmHRN1rMxWeZo38S5uVeODbQEYW/B6g9wNVrUvsi3YQVL68F8sSbxHBxFGcO1Qw0+
	 fud8lps004oK2Pfxq5OD7hPyYsp527hmy0z/FywprS1rQeerrWV4zmnTvoSB/b9AkalZ0
	 EJ0DY+Ud44a8EliV1kew42uthwUw8rbESOw6uoyaFSCbvGT3Ft8G0OvCV0CSv7CtzqbQs
	 xz+mb/Q1l+2g0LamiE6+xTwgYp11C+j2FHQmZmlz8k31wl5NQ8AAglMtAa8/rUpG/E6hG
	 VXayRKVRhb08S0T5Rb9dpbFkdn164u9janKZFsmGw5XZ0wFUcOprmgxgidascV1Cinw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="NY/xQ6Ym";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E80606A32C
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NY/xQ6Ym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A3E1F000D0;
	Mon, 23 Nov 2026 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795453613;
	bh=hMbBmJN41CScJ5lVLHb4W8mmrVYHZRmL6MNgODToP2A=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=NY/xQ6Ym2XXMmlkL8KCSINwpp4xdmDLyEVvz8piZ0MuaEH2j+a4Eh3++T4VZrOXd/
	 zv9wvRYFtj4sKJcyEQxQ6ZH/LxRo2M9VmoKYulryZ+T6vS6487wPbsdhR3BvJkJhxq
	 4VSt9wrzOd3oyWSD7SsFBptKfHpkpF1SCkOXtHhI=
Date: Mon, 23 Nov 2026 09:06:53 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,
	joshua.hahnjy@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,
	raizudeen.kerneldev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
References: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
Subject: + mm-zswap-remove-dead-length-check-in-zswap_store_page.patch added to mm-new branch
Message-Id: <20261123170653.C1A3E1F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: zswap: remove dead length check in zswap_store_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-remove-dead-length-check-in-zswap_store_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-dead-length-check-in-zswap_store_page.patch

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
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: mm: zswap: remove dead length check in zswap_store_page()
Date: Mon, 23 Nov 2026 08:55:12 +0530

zswap_compress() never succeeds with entry->length == 0, so the condition
is always true.  Remove it.

Link: https://patch.msgid.link/20261123032512.6119-1-raizudeen.kerneldev@gmail.com
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>

 mm/zswap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-dead-length-check-in-zswap_store_page
+++ a/mm/zswap.c
@@ -1597,10 +1597,8 @@ static bool zswap_store_page(struct foli
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
-	}
+	INIT_LIST_HEAD(&entry->lru);
+	zswap_lru_add(entry);
 
 	return true;
 
_

Patches currently in -mm which might be from raizudeen.kerneldev@gmail.com are

mm-zswap-remove-dead-length-check-in-zswap_store_page.patch

