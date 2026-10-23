Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792797795;
	b=J4hAqOZiQamJW/6qG8ZG2ooqiZjV1Uj6n71RKRvQQ0NNyLP4bXQG/TnB27IcePEWgZMH
	 TGZC2+tUp27FkX9OcSjhVX4URrhv/QfvwR0psjItuo9718AUs4H6gqJXdEkoDQedy/Er4
	 mz1D/geeS4DIKf+L/s/GG9HjRTfzh4k3Sa5igzrDwfkUpJZZ7FQQJKExvjUW6+X63bFuI
	 JdSd0sUutRyhvCOA3o93aFrPVN/OUkdvss+kpMxwoWryeDNaa9DwLRPaLw58T0P+XfMcu
	 rW0hLwRQi00+/NLhFBCncr0SgeakeLizi8mI2ti1TSlW63lJTHCnrEMY2NjeUGpkLbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792797795;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iVZkY0w4+AtBdI4GNcrfP/1SpAN3/7KKi7FsPElMBfQ=;
	b=LlNwpZ+pSiLJUFIDzhBxmRLHtx0Sf29lR3w7JePs2IVAcLG7n3K0F74NjNnOxTWWiDGt
	 T4P67pSElU9N8FwETZ9/vanTTLndrCS7hnw5TyDqikmUSRx759Yes/36QdTw9mAbm+i2B
	 WTXZJeejeOpJLbbC511wr9xVejHmvmPbMXtsCQUwPxKJAYmoIO+IpH26SavuVvQ13pfnU
	 BxfcUy2XRFSl//b+I5XuoQAi2hlxbiVtQcoa5MAfyTRaqAfC8vD7A4LE53rqgUwY4cs4o
	 HjlP6VlLK2HuAiPP51QASm/0GiPOu8723D61aD8cYedSUZvJW1N8rmMDckwrNUJycgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="e/nDuuwX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA4606A31A
	for <mm-commits@vger.kernel.org>; Fri, 23 Oct 2026 23:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e/nDuuwX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC14F1F01825;
	Fri, 23 Oct 2026 23:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792797794;
	bh=iVZkY0w4+AtBdI4GNcrfP/1SpAN3/7KKi7FsPElMBfQ=;
	h=Date:To:From:Subject;
	b=e/nDuuwXCfPV2mPmAyRlaLWk/VMkhbi0n1Z2kEvNu02h3ALqLt6ZZF66r+nb3YOZy
	 Jirn/UDCqaDxjum3tXUjviSDYlkMnYl9yN89oIdxRVJM5qCgEaGPAk4DYuMma7e60k
	 nx/6Gh1aHqisIKLp30amS8W3TNH+xajBoDVDKlXI=
Date: Fri, 23 Oct 2026 16:23:14 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,suseendranb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success.patch added to mm-unstable branch
Message-Id: <20261023232314.CC14F1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/zswap: validate dlen and normalize comp_ret on compression success
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success.patch

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
From: Suseendran Bhaskaran <suseendranb@google.com>
Subject: mm/zswap: validate dlen and normalize comp_ret on compression success
Date: Thu, 22 Oct 2026 23:27:33 +0000

In zswap_compress(), dlen is only meaningful when compression succeeds
(!comp_ret), as compressors do not consistently set req->dlen on error
(e.g. zstd, 842, and qat set dlen = 0; lz4, lz4hc, lzo, lzo-rle,
deflate, and iaa leave dlen at PAGE_SIZE; hisi_zip sets dlen to the
hardware-reported produced bytes).

When !comp_ret and dlen == PAGE_SIZE with zswap writeback disabled,
zswap_compress() sets comp_ret to -EINVAL instead of -ENOSPC,
miscounting the page under reject_compress_fail instead of
reject_compress_poor.

When !comp_ret, set comp_ret = -ENOSPC if dlen == PAGE_SIZE, or
comp_ret = -EINVAL if WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE). This
allows simplifying the failure check to 'if (comp_ret)' and dropping
the ternary assignment in the writeback-disabled path.

Link: https://lore.kernel.org/20261022232734.496064-1-suseendranb@google.com
Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
---

 mm/zswap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success
+++ a/mm/zswap.c
@@ -918,6 +918,12 @@ static bool zswap_compress(struct folio
 	comp_ret = crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
 				   &comp_ctx->areq.wait);
 	dlen = comp_ctx->areq.req->dlen;
+	if (!comp_ret) {
+		if (dlen == PAGE_SIZE)
+			comp_ret = -ENOSPC;
+		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
+			comp_ret = -EINVAL;
+	}
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
@@ -926,11 +932,10 @@ static bool zswap_compress(struct folio
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+	if (comp_ret) {
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 			rcu_read_unlock();
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
 		rcu_read_unlock();
_

Patches currently in -mm which might be from suseendranb@google.com are

mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success.patch

