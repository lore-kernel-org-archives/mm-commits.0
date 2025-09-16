Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80A5E571
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 03:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757992710; cv=none; b=KgtuF+vrBi1/f2vBnL6pvrzh4f321B/Tgmq9DrY8N2EuNk/4nkG/OtJokKXuhmRvFrTadfdt78HxKw5/8jANqYyyi28O9kiIvY0QkvRlt4jEQpkuAmq1GcOXSplDDrccJ0gy4ZPxTZgy1/JnBS5fSegRhEm5VNp0+u4E+Str/zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757992710; c=relaxed/simple;
	bh=hznK8iIL0M6YDH1xkj/zxsJUVNESkLTMX1i3wSJd6h8=;
	h=Date:To:From:Subject:Message-Id; b=DEKcZmBxtKSCT3l5XzHbrFW8bbayFO0yUGCXlOu539XuDnzT9gKFj6r/2y7jUUcbS8ditgtvL3iJ6GDrqNbWhBxFpX/2Y9FfmI0LsMVP4ZTA06yj4xfptQYntJOWmD72Qa34Ea+k4uwna794rjhx3QE15V1KwE7z1LVSRnaLSRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OBpWlMFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OBpWlMFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4808EC4CEEB;
	Tue, 16 Sep 2025 03:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757992709;
	bh=hznK8iIL0M6YDH1xkj/zxsJUVNESkLTMX1i3wSJd6h8=;
	h=Date:To:From:Subject:From;
	b=OBpWlMFUBqmnyBl5v0qD4Qx+r90gFYldhNcUwUU4Znr/Ci1y+JDL7x6EtOxG+t3JU
	 Vx7aQ7SgMj2mFBSwbj/bCFbO06Phr4jNrqQ6YP8Yh5Yqqzs6WSUe1OubbZC4NbAC2M
	 fued6sVvIPbMf95xxr8BeYuSIgpb0GFwZ51zTTkU=
Date: Mon, 15 Sep 2025 20:18:28 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-interact-directly-with-zsmalloc-fix.patch added to mm-unstable branch
Message-Id: <20250916031829.4808EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: interact directly with zsmalloc fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-interact-directly-with-zsmalloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-interact-directly-with-zsmalloc-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: interact directly with zsmalloc fix
Date: Mon, 15 Sep 2025 10:56:15 -0400

Yosry points out that the default compressor check only applies when
something else is configured and we fall back, but not if it was
configured out of the box but isn't available.  Move the test.  Kconfig
should not permit this, so replace the pr_err() with a WARN.

Link: https://lkml.kernel.org/r/20250915153640.GA828739@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-interact-directly-with-zsmalloc-fix
+++ a/mm/zswap.c
@@ -306,12 +306,12 @@ static struct zswap_pool *__zswap_pool_c
 		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
-			pr_err("default compressor %s not available\n",
-			       zswap_compressor);
-			zswap_compressor = ZSWAP_PARAM_UNSET;
-			return NULL;
-		}
+	}
+
+	/* Default compressor should be available. Kconfig bug? */
+	if (WARN_ON_ONCE(!crypto_has_acomp(zswap_compressor, 0, 0))) {
+		zswap_compressor = ZSWAP_PARAM_UNSET;
+		return NULL;
 	}
 
 	return zswap_pool_create(zswap_compressor);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-interact-directly-with-zsmalloc.patch
mm-zswap-interact-directly-with-zsmalloc-fix.patch
mm-remove-unused-zpool-layer.patch
mm-zpdesc-minor-naming-and-comment-corrections.patch

