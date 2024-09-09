Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3500118E05F
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925294; cv=none; b=P5NXPZgQkk3oeNy6ve7PT534A17ZYqA1+qHpcxOroovt1FoUJVAW1lwfpq0p+yuZY92mDrm4wejIFX2LtdrwqQgxxN70X0O/uGKmSTnyZP5WOr818aMIK35MdrIGIo91nKQVaoWtXs9puOv4oc33PVCIrr1+ULB/G2FehI0aghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925294; c=relaxed/simple;
	bh=4nnw1nTMGivRuT+U+yDjDElX54dvjuubsKUCcXltxx4=;
	h=Date:To:From:Subject:Message-Id; b=L7p5s6avSQ/q8vGcdwuyoXQ24NX0yBzF5uKwjPle/Jya3mcA3bIqcqoNyZaqkCy8MKXVmX17d3Z0wyIGzcv2phpmJb2q8K71mwwMEdsf/DcirKprukHuOaukmsD0LblM6tDyUx3OC5zM50+qLEqaz+niivuFaTiE0rSvLaatgeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/kqXDmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/kqXDmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF32C4CEC5;
	Mon,  9 Sep 2024 23:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925294;
	bh=4nnw1nTMGivRuT+U+yDjDElX54dvjuubsKUCcXltxx4=;
	h=Date:To:From:Subject:From;
	b=v/kqXDmF5uDRxEwpdkUcS1RdqDUQwBNn93aKPgdjmjI/8BCvHk+QRehrYotqd24tG
	 K5zY/mBGH/4xKzf1yExvgXeIWyvN1WF4OZgO8dcRdkOp8swIeRaHSD9iWH57T4W1t7
	 Qi4fR3Nu+uAtuT5sz8YVbq2MuXoDcGTHTLjOgamk=
Date: Mon, 09 Sep 2024 16:41:33 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,hannes@cmpxchg.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-fixup-zsmalloc-configuration.patch removed from -mm tree
Message-Id: <20240909234134.0AF32C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Kconfig: fixup zsmalloc configuration
has been removed from the -mm tree.  Its filename was
     mm-kconfig-fixup-zsmalloc-configuration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm: Kconfig: fixup zsmalloc configuration
Date: Tue, 3 Sep 2024 13:00:22 +0900

zsmalloc is not exclusive to zswap.  Commit b3fbd58fcbb1 ("mm: Kconfig:
simplify zswap configuration") made CONFIG_ZSMALLOC only visible when
CONFIG_ZSWAP is selected, which makes it impossible to menuconfig
zsmalloc-specific features (stats, chain-size, etc.) on systems that use
ZRAM but don't have ZSWAP enabled.

Make zsmalloc depend on both ZRAM and ZSWAP.

Link: https://lkml.kernel.org/r/20240903040143.1580705-1-senozhatsky@chromium.org
Fixes: b3fbd58fcbb1 ("mm: Kconfig: simplify zswap configuration") 
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-fixup-zsmalloc-configuration
+++ a/mm/Kconfig
@@ -188,7 +188,7 @@ config Z3FOLD
 
 config ZSMALLOC
 	tristate
-	prompt "N:1 compression allocator (zsmalloc)" if ZSWAP
+	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
 	depends on MMU
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

