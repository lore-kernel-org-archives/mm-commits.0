Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92A7A13A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273288; cv=none; b=PKIZOrRoRoGecTDS+aDHBl1qW/vmyI5URHiWXCrGqeVYZgxPCc+hgvKATRmD0DNwC173ok3AvfBzlb/hMIsbgXw2BFTVBJeYEBJ+3ophqQusL/8SGoWn0Y3yVTRa1/YpGPRRlzJWCqiCVWovrxrKLk1VbI5IpEVhfKNe4+qutMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273288; c=relaxed/simple;
	bh=8JtkON4yYNexZvykvIQpxYDbYjMGxZXfOtQnTKjHNgI=;
	h=Date:To:From:Subject:Message-Id; b=FQEQgPOQJqQ7hIcsAV9jCfAUAv8uCZYoQF9B9MJF+1xqMCkOOrH28pFCMWxkpxT/qafg9DK/QnSvhxfE0SAI+/EsDBFDAjR5pTsvujvtzA956RjGg1DguqrIkcUsQFvPYizKzJMbnQ3n5b5E04lkhXcx4ST4WZM7qWS9gj+Ey0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WxJZrhfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WxJZrhfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93844C4CEDD;
	Tue, 18 Mar 2025 04:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273288;
	bh=8JtkON4yYNexZvykvIQpxYDbYjMGxZXfOtQnTKjHNgI=;
	h=Date:To:From:Subject:From;
	b=WxJZrhfOOPwPTq595AFoFI3xLyHSorThQukkM4qt4JS9P7Ls4LTW70sjhZs1GioWf
	 vh/zu7Tvgw5hBA3QLxQAh+RzZlSk36ZKZRz3lgxawWa0ngg0NyH4gnw8FmW6SRj4xE
	 NRzhmr1utEgHDeX2Zj7EtK8SZQt0vVRaU/LMGv94=
Date: Mon, 17 Mar 2025 21:48:08 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,willy@infradead.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix.patch removed from -mm tree
Message-Id: <20250318044808.93844C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: page_io: zswap: do not crash the kernel on decompression failure (fix)
has been removed from the -mm tree.  Its filename was
     page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix.patch

This patch was dropped because it was folded into page_io-zswap-do-not-crash-the-kernel-on-decompression-failure.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: page_io: zswap: do not crash the kernel on decompression failure (fix)
Date: Thu, 6 Mar 2025 14:24:53 -0800

Fix the documentation of zswap_load() - should say load a folio (rather
than a page), and should be explicit that the folio is unlocked and marked
up-to-date in the success case.

Link: https://lkml.kernel.org/r/20250306222453.1269456-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix
+++ a/mm/zswap.c
@@ -1629,10 +1629,11 @@ check_old:
 }
 
 /**
- * zswap_load() - load a page from zswap
+ * zswap_load() - load a folio from zswap
  * @folio: folio to load
  *
- * Return: 0 on success, or one of the following error codes:
+ * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
+ * of the following error codes:
  *
  *  -EIO: if the swapped out content was in zswap, but could not be loaded
  *  into the page due to a decompression failure. The folio is unlocked, but
_

Patches currently in -mm which might be from nphamcs@gmail.com are

page_io-zswap-do-not-crash-the-kernel-on-decompression-failure.patch

