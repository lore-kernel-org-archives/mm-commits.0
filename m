Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D47F2AF09
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741544; cv=none; b=UeiLTwxnhuh6QAzyYOKhM9ySQS9mhSDi/X+/WLHDx1IVSgfytkPqm5WiwKxMQHwn61OVJkL9OYf7pM2/RZ4JcMSpz+/KuPcTKSdDnqLvJwBaK2TNoqixvgdI9e6mvRplwOxQwM6umhE4r8d+ROCOh+bFeEGFj9PokIIkztqRm3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741544; c=relaxed/simple;
	bh=1vSFzQoojRtF3Tx5n6qDJ6hgM9rjuxuDvMXrR9dkHSM=;
	h=Date:To:From:Subject:Message-Id; b=SLjm96T+qIznUDMm9SSJW6GG8UNXsGf2c+yEDOAOxi+mp10tlo9v/u866pXlZr/yVOVu+MRwzkCwjiULQANAoJz9EfZQXpTUK7yRyJgrCVoNvDws0+5ODdlSZQctyQKSEvAWQ0y2NvQxB8BM0PBO2EjNVUcrIWiFVajsA3ar2MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vxk3mJcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vxk3mJcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8906C4CED6;
	Mon, 13 Jan 2025 04:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741543;
	bh=1vSFzQoojRtF3Tx5n6qDJ6hgM9rjuxuDvMXrR9dkHSM=;
	h=Date:To:From:Subject:From;
	b=vxk3mJcfNLIOOdpPKsugdNVXJ8m6y9Woi1tSGrlEJp14JZPYtQLXvr1rdjtHJOB+S
	 XUgvw6pdNJNoKzyJWgWEMK7sxDnpCogqbixNk8C65kzIlDAQh7N8PfJoEVHW9S1EUE
	 SbZfpKe1zaDG9olaMdW6Ph842aTXpgSG4e3vklPE=
Date: Sun, 12 Jan 2025 20:12:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com,axboe@kernel.dk,asml.silence@gmail.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch removed from -mm tree
Message-Id: <20250113041223.A8906C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray-extract-helper-from-__xa_insertcmpxchg-fix
has been removed from the -mm tree.  Its filename was
     xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch

This patch was dropped because it was folded into xarray-extract-helper-from-__xa_insertcmpxchg.patch

------------------------------------------------------
From: Tamir Duberstein <tamird@gmail.com>
Subject: xarray-extract-helper-from-__xa_insertcmpxchg-fix
Date: Wed, 4 Dec 2024 10:21:59 -0500

fix __xa_erase()

Link: https://lkml.kernel.org/r/CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Reported-by: <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-extract-helper-from-__xa_insertcmpxchg-fix
+++ a/lib/xarray.c
@@ -1509,7 +1509,7 @@ static void *xas_result(struct xa_state
 void *__xa_erase(struct xarray *xa, unsigned long index)
 {
 	XA_STATE(xas, xa, index);
-	return xas_result(&xas, xas_store(&xas, NULL));
+	return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
 }
 EXPORT_SYMBOL(__xa_erase);
 
_

Patches currently in -mm which might be from tamird@gmail.com are

xarray-extract-xa_zero_to_null.patch
xarray-extract-helper-from-__xa_insertcmpxchg.patch
xarray-port-tests-to-kunit.patch
checkpatch-check-return-of-git_commit_info.patch
xarray-minor-documentation-improvements.patch

