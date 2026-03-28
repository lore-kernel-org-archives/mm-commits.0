Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC49A33A005;
	Sat, 28 Mar 2026 04:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671946; cv=none; b=Gx5oi67lueJY0dn4Mh7VBCxi2lNa1Z29D4qFKJFhTd+hHyamBTh9A5INu/jEiZvvvRHPiaHGVMPrjNNKUPN5aEE4xVz4twJem/yECqI3/q78MJTkbGo8u/PpufO9V/0y5sFoEJgsweLz2vocwvV4thCcfwyneiXgv0IBeSDL5q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671946; c=relaxed/simple;
	bh=euI4TNES+HReAqmi8gYcl6Y+l+rqaLdZcO/u61ors88=;
	h=Date:To:From:Subject:Message-Id; b=WMUI+6uOgTdMW26IDw03Qbxx8+IN6v8Nn4oaBCxlZy7mpPHKT+MDnr/GVAz3+D90PHaXsVSGNdMohLyTooT5lrgjoIohdh1k8DBWMo1EePwd8/1rAot8QPHYyK0n3BB8nfydoFEKUxsP4Q1tf1qNji6Ru2nfSlWHhLXUagDaCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CSusWI3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CSusWI3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6CFC4CEF7;
	Sat, 28 Mar 2026 04:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671946;
	bh=euI4TNES+HReAqmi8gYcl6Y+l+rqaLdZcO/u61ors88=;
	h=Date:To:From:Subject:From;
	b=CSusWI3a5T9jbEginJ9j9ywz/Ns/Zt/cuSURB9iUoGPOAO8v+/svGFXpTAPwzSzYf
	 rzxra1L508eCFTXo6t+DaHcWHSwUqTg6IEdZVI3Q6JdBwMLvEk116VzMhWCpAjLR/Z
	 /zHENZeJWUq6ADK6PMsV5+rH75FDiA2VlK4PArzE=
Date: Fri, 27 Mar 2026 21:25:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch removed from -mm tree
Message-Id: <20260328042546.8B6CFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/ts_bm: fix integer overflow in pattern length calculation
has been removed from the -mm tree.  Its filename was
     lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/ts_bm: fix integer overflow in pattern length calculation
Date: Sun, 8 Mar 2026 20:20:27 +0000

The ts_bm algorithm stores its good_shift[] table and pattern in a single
allocation sized from the pattern length.  If the good_shift[] size
calculation wraps, the resulting allocation can be too small and
subsequent pattern copies can overflow it.

Fix this by rejecting zero-length patterns and by using overflow helpers
before calculating the combined allocation size.

This fixes a potential heap overflow.  The pattern length calculation can
wrap during a size_t addition, leading to an undersized allocation. 
Because the textsearch library is reachable from userspace via Netfilter's
xt_string module, this is a security risk that should be backported to LTS
kernels.

Link: https://lkml.kernel.org/r/20260308202028.2889285-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_bm.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/lib/ts_bm.c~lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation
+++ a/lib/ts_bm.c
@@ -163,8 +163,22 @@ static struct ts_config *bm_init(const v
 	struct ts_config *conf;
 	struct ts_bm *bm;
 	int i;
-	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
-	size_t priv_size = sizeof(*bm) + len + prefix_tbl_len;
+	unsigned int prefix_tbl_len;
+	size_t priv_size;
+
+	/* Zero-length patterns would underflow bm_find()'s initial shift. */
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * bm->pattern is stored immediately after the good_shift[] table.
+	 * Reject lengths that would wrap while sizing either region.
+	 */
+	if (unlikely(check_mul_overflow(len, sizeof(*bm->good_shift),
+					&prefix_tbl_len) ||
+		     check_add_overflow(sizeof(*bm), (size_t)len, &priv_size) ||
+		     check_add_overflow(priv_size, prefix_tbl_len, &priv_size)))
+		return ERR_PTR(-EINVAL);
 
 	conf = alloc_ts_config(priv_size, gfp_mask);
 	if (IS_ERR(conf))
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

