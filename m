Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC5A16FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855626; cv=none; b=m3JYeZcwg84oHQQI5MIjJpO/JFTh6zj1gO7ZUOaPQNlR1A59+zrOd2rjehYQk6ecWbbf5rI14ZVjnCVoVPOyEP1xgpOlqM7PEneaRLa4tMvDhz1l0BAix8aSX1zNtA6SUU0MHXuMViNcKFgM2zvaqyRFL8XZHVaN2sdaGN7P76A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855626; c=relaxed/simple;
	bh=Ku5HuIhGDWvkTbRIwga+jPWQp44ENu2tq5NoQQekzsM=;
	h=Date:To:From:Subject:Message-Id; b=vDKMoYZo2X26HLCm9C1OQCZDNH5e+aOMzexlxiGEMqvf9zedAG9eyIXBmT7w9GAYIaWE/jP7SvpjBvSamOV2KZehvp+Cg6AXkwRrz2oCKIrWjWFy8jfpA7W832vFAGTsLcY3i3nm8toj6pdb+7a1W8Swsh4JU99TMUKCxbxonkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jGu9rBqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jGu9rBqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DB8C4CECF;
	Wed,  6 Nov 2024 01:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855625;
	bh=Ku5HuIhGDWvkTbRIwga+jPWQp44ENu2tq5NoQQekzsM=;
	h=Date:To:From:Subject:From;
	b=jGu9rBqY3LRmfYCGTfzmwY2t1YhGDvMcMldavrnaBuO3ZJa/w7m0fX9mDa2rjpx1t
	 meOuXIrMzy61Imsjt+6sL4IPws6ONzzk4APzXM+hYJmqrzacf7mpajj6Fsr3QUsPEN
	 B2sNrmvCTB1pGgGhMvzWtTeMyqf6JUqFQPt/R4Ow=
Date: Tue, 05 Nov 2024 17:13:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,skhan@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-fix-wunused-result-in-linuxc.patch removed from -mm tree
Message-Id: <20241106011345.D4DB8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: fix -Wunused-result in linux.c
has been removed from the -mm tree.  Its filename was
     tools-fix-wunused-result-in-linuxc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shuah Khan <skhan@linuxfoundation.org>
Subject: tools: fix -Wunused-result in linux.c
Date: Fri, 11 Oct 2024 16:51:55 -0600

Fix the following -Wunused-result warnings on posix_memalign()
return values and add error handling.

./shared/linux.c:100:25: warning: ignoring return value of `posix_memalign' declared with attribute `warn_unused_result' [-Wunused-result]
  100 |          posix_memalign(&p, cachep->align, cachep->size);
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../shared/linux.c: In function `kmem_cache_alloc_bulk':
../shared/linux.c:198:33: warning: ignoring return value of `posix_memalign' declared with attribute `warn_unused_result' [-Wunused-result]
  198 |          posix_memalign(&p[i], cachep->align,
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  199 |                                cachep->size);
      |                                ~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241011225155.27607-1-skhan@linuxfoundation.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/tools/testing/shared/linux.c~tools-fix-wunused-result-in-linuxc
+++ a/tools/testing/shared/linux.c
@@ -96,10 +96,13 @@ void *kmem_cache_alloc_lru(struct kmem_c
 		p = node;
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
-		if (cachep->align)
-			posix_memalign(&p, cachep->align, cachep->size);
-		else
+		if (cachep->align) {
+			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
+				return NULL;
+		} else {
 			p = malloc(cachep->size);
+		}
+
 		if (cachep->ctor)
 			cachep->ctor(p);
 		else if (gfp & __GFP_ZERO)
@@ -195,8 +198,9 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			}
 
 			if (cachep->align) {
-				posix_memalign(&p[i], cachep->align,
-					       cachep->size);
+				if (posix_memalign(&p[i], cachep->align,
+					       cachep->size) < 0)
+					break;
 			} else {
 				p[i] = malloc(cachep->size);
 				if (!p[i])
_

Patches currently in -mm which might be from skhan@linuxfoundation.org are


