Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B47E1CBE9E;
	Thu, 17 Oct 2024 07:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150146; cv=none; b=iJPWRFfqx3Ox/BkZlwuDXyRK9bVnHDxccanNoc+ssWbFQhPU1qZtjjpADo07eNgQ9gOHickccNstnM0EooY3WKVq+H3jX8Rts3D1f56pudDzHtokBArUJl9A3+2iOfS5JxSowwxp+O4zikm1chS1D0WR2KGdtzNUXsd+P+6pmqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150146; c=relaxed/simple;
	bh=e6tCHMbfsCTFd/ITJ/vm6s/793AgZAesqK0Jf8z7Fb4=;
	h=Date:To:From:Subject:Message-Id; b=gLyFA2V4GtbP6GiGI+F1Ow73kFFurhA8bvIP5dINOlJcAn4FTEmsjnXhexZ10r8+EjUfMFF+ORGG+PVqiFFHqgmGNMNjCpgtGXo9aJm+eoWyEIpw9L47vBxADwl7UPbiw2IApxdyHgC+G35j0yV8xTOj6/u/7Dd1rgvVfFBpNPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKDaQ4EC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKDaQ4EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27785C4CEC3;
	Thu, 17 Oct 2024 07:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150146;
	bh=e6tCHMbfsCTFd/ITJ/vm6s/793AgZAesqK0Jf8z7Fb4=;
	h=Date:To:From:Subject:From;
	b=GKDaQ4ECHCpNiMXg/eSAaoWuMMtuKuU+rMANnLrjFddxTd2Tr1k4vzPpD+xKSjBHx
	 yrhfhUIjoERnm1101Vgw2pag3/BV0WubXt2bPGO4ucBGU4CmtWYU267R2tWOT9BUm1
	 o2kWV8BoWJzoxakep90WNegWu7if6CHYVMthndjU=
Date: Thu, 17 Oct 2024 00:29:05 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,suleiman@google.com,stable@vger.kernel.org,heftig@archlinux.org,bgeffon@google.com,axelrasmussen@google.com,weixugc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch removed from -mm tree
Message-Id: <20241017072906.27785C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: only clear kswapd_failures if reclaimable
has been removed from the -mm tree.  Its filename was
     mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Xu <weixugc@google.com>
Subject: mm/mglru: only clear kswapd_failures if reclaimable
Date: Mon, 14 Oct 2024 22:12:11 +0000

lru_gen_shrink_node() unconditionally clears kswapd_failures, which can
prevent kswapd from sleeping and cause 100% kswapd cpu usage even when
kswapd repeatedly fails to make progress in reclaim.

Only clear kswap_failures in lru_gen_shrink_node() if reclaim makes some
progress, similar to shrink_node().

I happened to run into this problem in one of my tests recently.  It
requires a combination of several conditions: The allocator needs to
allocate a right amount of pages such that it can wake up kswapd
without itself being OOM killed; there is no memory for kswapd to
reclaim (My test disables swap and cleans page cache first); no other
process frees enough memory at the same time.

Link: https://lkml.kernel.org/r/20241014221211.832591-1-weixugc@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Wei Xu <weixugc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-only-clear-kswapd_failures-if-reclaimable
+++ a/mm/vmscan.c
@@ -4963,8 +4963,8 @@ static void lru_gen_shrink_node(struct p
 
 	blk_finish_plug(&plug);
 done:
-	/* kswapd should never fail */
-	pgdat->kswapd_failures = 0;
+	if (sc->nr_reclaimed > reclaimed)
+		pgdat->kswapd_failures = 0;
 }
 
 /******************************************************************************
_

Patches currently in -mm which might be from weixugc@google.com are


