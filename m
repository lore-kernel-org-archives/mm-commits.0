Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38582837A
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741780; cv=none; b=hKzTUSMPRQfqgz1x/LUA55w+Mf6RP4xtdC50GK6REaR3Ej0E5z2SUoSjS2slki3ysQei48MaCrgpwq+idO0oN54rs40I/b+tD9BR8O/byXM/ZGk9NieJgtPADinWrspa9xMt6GNTTKzkO8aBfRSGaG7Tph0raj189Xxm15deALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741780; c=relaxed/simple;
	bh=x4DsbRpNEQuwwWJaW1+sebegAbQTW3DcJ8lX5J9p1Ck=;
	h=Date:To:From:Subject:Message-Id; b=Z5qKrkYv8XrvWJl2c3GXXWKsmL/lYM1EG+XbnxLYzhP1xENYWmpC6Vq0OFds/gAEzX43AiCbbsnbabp9TTC6/q/HJUlUtJHLSKRoX2TpbLoV5RYIz39k9a2mnGmCVpBfId1PKLzETbQ7J6A4FOTs8W5A4iEda0a/drOwVcXKiPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S433mDD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S433mDD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02415C4CED6;
	Mon, 13 Jan 2025 04:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741779;
	bh=x4DsbRpNEQuwwWJaW1+sebegAbQTW3DcJ8lX5J9p1Ck=;
	h=Date:To:From:Subject:From;
	b=S433mDD87DqiOIC4oWJ3T5CepG5l+u1oY2cdT4AgpDgkADda1P2SqSPQmpXj74vy8
	 2cdTot1AdUkc7yxRp3iKfEDP7hu0Q8e5NCuPThXFiOrP5VuaMA6HHAsjfP19v6XVvA
	 xHc7w7FMwJLYXvOztqZULeHsFTwEicEuvzQqVZTQ=
Date: Sun, 12 Jan 2025 20:16:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,phillip@squashfs.org.uk,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch removed from -mm tree
Message-Id: <20250113041619.02415C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: fix a NULL vs IS_ERR() bug
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch

This patch was dropped because it was folded into squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: squashfs: fix a NULL vs IS_ERR() bug
Date: Wed, 8 Jan 2025 12:16:30 +0300

__filemap_get_folio() never returns NULL, it returns error pointers.  This
incorrect check would lead to an Oops on the following line when we pass
"push_folio" to folio_test_uptodate().

Link: https://lkml.kernel.org/r/7b7f44d6-9153-4d7c-b65b-2d78febe6c7a@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/file.c~squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix
+++ a/fs/squashfs/file.c
@@ -406,7 +406,7 @@ void squashfs_copy_cache(struct folio *f
 					FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
 					mapping_gfp_mask(mapping));
 
-		if (!push_folio)
+		if (IS_ERR(push_folio))
 			continue;
 
 		if (folio_test_uptodate(push_folio))
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch
checkpatch-dont-warn-about-extra-parentheses-in-staging.patch

