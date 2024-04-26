Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5A478C96
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103869; cv=none; b=A8QTQ1f0cSYkSZWBhO9zxbwU09CK81JhI1G7s2N+wOrgEBF3zSx+pokz4yfnFZ/9P0YponLFCixXcFyNKtl9W/tAE5whXMx07/iSMuRnKX/75UliZhL4zD2URMlSKXSRpWSCCasZLpq1FIXU+KodAWFfE8Kio1hZWCy23/QSaMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103869; c=relaxed/simple;
	bh=b0n19kJZFg17L7IN4JlPhreAqvQPPjg9X1kzP+PaBIQ=;
	h=Date:To:From:Subject:Message-Id; b=lkiRHrSWvFVGDCK95yVj10NwmW4XpwemBXB+cJoiXUbW14BhW3KCd4FP/LbeoxDFY4Sddwz+/cgZb+MIznLVDRJLyw2+P8dHA7gdAGB1KqfTXWPHWb8HQxIZxW3/bf6s17xQ/eDRZUB+UvLYnpYeBaUQrfwaU/6LsrdhFq1yifw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJOBuC16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJOBuC16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B262CC113CD;
	Fri, 26 Apr 2024 03:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103869;
	bh=b0n19kJZFg17L7IN4JlPhreAqvQPPjg9X1kzP+PaBIQ=;
	h=Date:To:From:Subject:From;
	b=JJOBuC16cvAoLgMlT4BhgAfYCO5kbldv0wxV6VUCjtSHNphvnHEfuSKJR6j6Jta+g
	 QLYk3oKpbMlN0OyhHckEZzdS8hpahurCy8BPKqDOCvq00InXkLP2emUH7ZQrtKwaON
	 Uo4me37sD0EQjM2eUH/Tm3L4ahdx1Tbv20fE0JQE=
Date: Thu, 25 Apr 2024 20:57:49 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch removed from -mm tree
Message-Id: <20240426035749.B262CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: remove unnecessary check in zswap_find_zpool()
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: remove unnecessary check in zswap_find_zpool()
Date: Mon, 11 Mar 2024 23:52:10 +0000

zswap_find_zpool() checks if ZSWAP_NR_ZPOOLS > 1, which is always true. 
This is a remnant from a patch version that had ZSWAP_NR_ZPOOLS as a
config option and never made it upstream.  Remove the unnecessary check.

Link: https://lkml.kernel.org/r/20240311235210.2937484-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-unnecessary-check-in-zswap_find_zpool
+++ a/mm/zswap.c
@@ -871,12 +871,7 @@ static void zswap_entry_cache_free(struc
 
 static struct zpool *zswap_find_zpool(struct zswap_entry *entry)
 {
-	int i = 0;
-
-	if (ZSWAP_NR_ZPOOLS > 1)
-		i = hash_ptr(entry, ilog2(ZSWAP_NR_ZPOOLS));
-
-	return entry->pool->zpools[i];
+	return entry->pool->zpools[hash_ptr(entry, ilog2(ZSWAP_NR_ZPOOLS))];
 }
 
 /*
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

