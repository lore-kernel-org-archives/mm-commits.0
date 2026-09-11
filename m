Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010118DF80;
	Fri, 11 Sep 2026 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789089836; cv=none; b=Rljw5faEwRIdnCobH86yz3Zobkz0Os7STUp3+uyTCe5FrnMCm/2znfBGXThixUrZ7EVQ6LZ3Tx5UBh3VOLSA3JCGoFPrUzSAwtMNlYy2TXrhUzd3JBkk/+1eIeSQp2Xlf0WGx0chFLJGL8SLTf2iDATwo6xuM/NeY2bvs2kNSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789089836; c=relaxed/simple;
	bh=KuRfJQGV6M5WblNNGhdfEaOjFUigjF7Ucc3XXJVic4M=;
	h=Date:To:From:Subject:Message-Id; b=lTCrJDmS/TUA7cc8M6B8m5ag9zsG28+K3DXXelV1NeXACAV7Fs1xx61vD5EWTihDGukyirFfl3VqGyfBEtMmm64pIT1bWRD+miqET+AXnZiNL4cX6l+L5T1MhoJo/W4aUXQtZIApxkJkN+aRTB1TVDordBp8uoML3iuagQyvjMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cpH5Y+Sr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cpH5Y+Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5B21F000FF;
	Fri, 11 Sep 2026 01:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789089835;
	bh=TfxO/CxdoT8y8lLRCV6DW+mYA2+pEi4JKNnD9kr7rEQ=;
	h=Date:To:From:Subject;
	b=cpH5Y+Sr0umoLA6bK0qkQT221qZRmiHOIbqG1P7CsRF3SQMCPck5jFImIvYDofw9m
	 bvlspwuc+YhtuD/DSY9Fl7y1+do0KKqtZoNlzAvgIgb8VFm04NFM3N2S+tv04NvD0N
	 OKd44W58Cp6d16yQ2jcswzhv4tljDbfpxOXJG1bY=
Date: Thu, 10 Sep 2026 18:23:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-enable-static-key-after-runtime-pool-recovery.patch removed from -mm tree
Message-Id: <20260911012354.EC5B21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: enable static key after runtime pool recovery
has been removed from the -mm tree.  Its filename was
     mm-zswap-enable-static-key-after-runtime-pool-recovery.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/zswap: enable static key after runtime pool recovery
Date: Sat, 5 Sep 2026 20:50:28 +0800

When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
without a pool after a failed initial pool creation.  A later compressor
parameter update can create and publish a pool, but does not enable
zswap_ever_enabled.

If users then enable zswap, zswap_store() intercepts swapout while
zswap_load() still returns -ENOENT without consulting the xarray.  The
swapin path therefore reads a stale backing swap slot because the store
skipped writing it.

Enable the static key after a successful compressor and pool update.  Do
this outside zswap_pools_lock because static key updates may sleep.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor; a pool is
     recovered but the key stays off.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Link: https://lore.kernel.org/20260905125101.2970456-1-xialonglong2025@163.com
Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zswap.c~mm-zswap-enable-static-key-after-runtime-pool-recovery
+++ a/mm/zswap.c
@@ -586,6 +586,9 @@ static int zswap_compressor_param_set(co
 	else
 		ret = -EINVAL;
 
+	if (!ret)
+		static_branch_enable(&zswap_ever_enabled);
+
 	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch
mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch
mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

