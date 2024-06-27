Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEE814D6EB
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520474; cv=none; b=WN5Y/adtOoCn4h1DwBwcHjsRJrQRrTbXzr16Xyn0FQvGRUZpZ8Fju3299i8cHLi7B87kU5swy4XQhaBQw+XJpcHBPrZafCbqLHE4b+ALiCk+wfdlLUlmp5jFsAqSmGUTalq3cDoyB6/cnkL30EZS9g73UGUHcZT9CK5/T1HQIFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520474; c=relaxed/simple;
	bh=pxZL5s0zjwlTziPpmzjVv657p7ghZYnxxT54tHBC2XM=;
	h=Date:To:From:Subject:Message-Id; b=GvGuNkOddfWNZSkC61dr4seZKQxLm0Ds69XYrEiiiJ10HflS81kYfp4HDY5+8bW7hqFGIYmdzyRbbybjR4hNabnZHPei1lcp0B71xm1onuBztTzghT658ryHYmuJxT3Za/gcoAHMXP2hm6oeA6663Cmfl/afULbnn3Eqn8VHR64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/6J2cMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/6J2cMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EE8C2BBFC;
	Thu, 27 Jun 2024 20:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719520473;
	bh=pxZL5s0zjwlTziPpmzjVv657p7ghZYnxxT54tHBC2XM=;
	h=Date:To:From:Subject:From;
	b=j/6J2cMgvRWFMYJhVApLAANF5GWU7XQgGXTH9MSnyGPXjY9OLAYU4zZqa3iuVPTa8
	 /zp9hMhcZPivJngALnIXevfpOIa5o9rvzh9JdOvTOCWMyzkAy9xX34WE/DCuy6ay0H
	 g43uPGM42c+QbIXyoVYzGP3mI75VnABktLrTFXjo=
Date: Thu, 27 Jun 2024 13:34:33 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch added to mm-unstable branch
Message-Id: <20240627203433.B4EE8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: fix class per-fullness zspage counts
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zsmalloc: fix class per-fullness zspage counts
Date: Thu, 27 Jun 2024 15:59:58 +0800

We always use insert_zspage() and remove_zspage() to update zspage's
fullness location, which will account correctly.

But this special async free path use "splice" instead of remove_zspage(),
so the per-fullness zspage count for ZS_INUSE_RATIO_0 won't decrease.

Fix it by decreasing when iterate over the zspage free list.

Link: https://lkml.kernel.org/r/20240627075959.611783-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-fix-class-per-fullness-zspage-counts
+++ a/mm/zsmalloc.c
@@ -1883,6 +1883,7 @@ static void async_free_zspage(struct wor
 
 		class = zspage_class(pool, zspage);
 		spin_lock(&class->lock);
+		class_stat_dec(class, ZS_INUSE_RATIO_0, 1);
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&class->lock);
 	}
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-ksm-refactor-out-try_to_merge_with_zero_page.patch
mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch
mm-ksm-optimize-the-chain-chain_prune-interfaces.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

