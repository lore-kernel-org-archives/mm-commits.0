Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3115F19B3FF
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770988; cv=none; b=h3lQq36FgqkNqaErbrkHx4k+XNNGpFCX5d2NSgSncWUIi93JE870pSAtc/G2QfmMXvcSrnISbWmfCgEm7+5iTUPKKWF14sHJaKi+GG8p9hxP9PNbIIQyMeNTZ3FfkxR6dzMcboP0BXW5579ovpUqsK4SrMZbEaI3gz4SeW2/DKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770988; c=relaxed/simple;
	bh=cV9Fo6T2gln3QpmqYWxWJqFjwtw9G8dUq9f+kXsLEXM=;
	h=Date:To:From:Subject:Message-Id; b=YoTy+ADW70d16tfBPG9pXhuZMcClnnfvODvoumCLhz/nMVl+6CxUVg7GSjWNEOmoak1VMRwp69iBLz6NOZHR6v0Menh3yvxkBshb7KSJ/H57jCNqAmGU7gQPg0fcWVv1BeOVtrKbHqFRl66nhoRw9Ar9b5pyaOpyBJgfP1H5C7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fOyXn+8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fOyXn+8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7348C4CEC6;
	Sat, 12 Oct 2024 22:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728770987;
	bh=cV9Fo6T2gln3QpmqYWxWJqFjwtw9G8dUq9f+kXsLEXM=;
	h=Date:To:From:Subject:From;
	b=fOyXn+8OaRg/X6L20dNvfSMcpMSkcvN93BRMfiDo08t7oevz7+jm1qL5TrnPi8rci
	 T5rOfeS4OlBFWa7XZOxKcTEcR+GQ76nL/hRcvM+RVTl3v/3wCeUSe50+QrD0/Th+PT
	 5PsRKkgDsadZ4LjJ7daY7A9mPaf50tbVo58aYfm8=
Date: Sat, 12 Oct 2024 15:09:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,skhan@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-fix-wunused-result-in-linuxc.patch added to mm-nonmm-unstable branch
Message-Id: <20241012220947.B7348C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: fix -Wunused-result in linux.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-fix-wunused-result-in-linuxc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-fix-wunused-result-in-linuxc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

tools-fix-wunused-result-in-linuxc.patch

