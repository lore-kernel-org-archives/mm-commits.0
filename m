Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7C21ABB4;
	Wed, 26 Feb 2025 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740605335; cv=none; b=jpZZPLX1lZVZJ07bCPhhcCTJ3fDNSNw84qfVVOLyUldiNpC6rUJC4a44KvP4DopHCOa/Jxi/r1hH46QDmD8cE9FbF3Mio1ycgr2pc29ZNAa1CqrIi5BTsgQasix74oZk6MYmZu2Dbf744kGfZLapr4McoVuwDUaexZKj6smhpaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740605335; c=relaxed/simple;
	bh=z0jPa6HYFBB8qxMcfSmwuQXWgQt/gs3QJpsvPFdL67o=;
	h=Date:To:From:Subject:Message-Id; b=ia1PZJ+TcuMN+SZDXdJSCakjHvuYRTbrUz3fcEy2gRRNHWcQ+4HPGVuO6k0Svu/F0J+bIyvrTuykUKkl9whzyuCqWRHjqT2Xz67v0nwxKn580NfWog0XT6xIYK8tkg53viir9n1/1WCvIWUgKFLpb2a7t9Z+/EIz2y1hiiTDDik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K5tQ9Ghw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K5tQ9Ghw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4197EC4CED6;
	Wed, 26 Feb 2025 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740605335;
	bh=z0jPa6HYFBB8qxMcfSmwuQXWgQt/gs3QJpsvPFdL67o=;
	h=Date:To:From:Subject:From;
	b=K5tQ9GhwSAr1s4RKrNItALmurAS6oJMZNANMES1CA+uK2WJL15ZLaHE0SvSxLgOYV
	 BpKE4RhLJIqyDgKFJDsXA1tXlsL6ZU8YijFNHp6wHGoDtLlCHZzZAW2MDSz6kyWFpU
	 TrPSBlKsfPBaU1KBhpsAd28nbm94eZagKZyohy24=
Date: Wed, 26 Feb 2025 13:28:54 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,stable@vger.kernel.org,davem@davemloft.net,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch removed from -mm tree
Message-Id: <20250226212855.4197EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Date: Tue, 25 Feb 2025 16:53:58 +0800

Call crypto_free_acomp outside of the mutex in zswap_cpu_comp_dead() as
otherwise this could deadlock as the allocation path may lead back into
zswap while holding the same lock.  Zap the pointers to acomp and buffer
after freeing.

Also move the NULL check on acomp_ctx so that it takes place before
the mutex dereference.

Link: https://lkml.kernel.org/r/Z72FJnbA39zWh4zS@gondor.apana.org.au
Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead
+++ a/mm/zswap.c
@@ -881,18 +881,23 @@ static int zswap_cpu_comp_dead(unsigned
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct crypto_acomp *acomp = NULL;
+
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
-	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
-		acomp_ctx->req = NULL;
-		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
-	}
+	if (!IS_ERR_OR_NULL(acomp_ctx->req))
+		acomp_request_free(acomp_ctx->req);
+	acomp_ctx->req = NULL;
+	acomp = acomp_ctx->acomp;
+	acomp_ctx->acomp = NULL;
+	kfree(acomp_ctx->buffer);
+	acomp_ctx->buffer = NULL;
 	mutex_unlock(&acomp_ctx->mutex);
 
+	crypto_free_acomp(acomp);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are


