Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D90414439;
	Fri,  9 Oct 2026 05:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525519; cv=none; b=NsVMEuOslu+RmC6ZiN7tTSuVpq1ozgih6/phRFBZGx0Ymvdx523HlZkkD9QnokDhQZzqLU7qVULTzBkNGZXv2FJQbY8PNBmDC/QaE323xrMVu3kuUlo0f+tTWLAMNF9reLlikulnfU/Ry//Kog8+wzVMyeAfbmgCVci7kIvXLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525519; c=relaxed/simple;
	bh=T7N6Z3Ccv1UOfGzwLyP32GsVwjB8EeRzg2I+0SsVN5c=;
	h=Date:To:From:Subject:Message-Id; b=Gp+BMcPKQwc7bv20vHABDzkUsqv1XakdixBLBrPArcSBvmikz5PTRagzt0mjJUNpUx6sB7anrX3UlP/mzJtQyJ8Kjwmgj4TMK1hyO4OwFNzRm9NMhUINVMIWZDVL/lre4l/9BEkCeWNAXIpr/JynC1fZOWTPpHzNafZa4bjxXik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YqtqSfDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YqtqSfDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903E81F00893;
	Fri,  9 Oct 2026 05:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525518;
	bh=Hd8MUiGCJtmOzx2ddpRr94hXpGVG8cJEVuwEmhMgVlg=;
	h=Date:To:From:Subject;
	b=YqtqSfDpwfUdY4KmA2Bdu1Nm/OcagBHLpUvFQHEOKnwhYIt0NJNVe4kn7OpTb1G1S
	 CxYYQvSXOZN+u1E1IvT/xPGI5BBdBCOWArkCH4kWTCnC11GN7G9UKffCaKdq9RCY88
	 BktUUFmhMLt/aIRjbIpQpdIUHtkmNVyLWVqoT5LY=
Date: Thu, 08 Oct 2026 22:58:38 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch removed from -mm tree
Message-Id: <20261009055838.903E81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
has been removed from the -mm tree.  Its filename was
     mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sun, 6 Sep 2026 21:59:38 +0800

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to zswap is
corrupted on swapin.

Enable the static key in zswap_pool_create(), covering boot-time and
runtime pool creation with a single site.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Link: https://lore.kernel.org/20260906135938.3568108-1-xialonglong2025@163.com
Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Assisted-by: Zcode:GLM-5.3
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/zswap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create
+++ a/mm/zswap.c
@@ -329,6 +329,8 @@ static struct zswap_pool *zswap_pool_cre
 
 	zswap_pool_debug("created", pool);
 
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1818,7 +1820,6 @@ static int zswap_setup(void)
 		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are


