Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1033A6F9;
	Sat, 28 Mar 2026 04:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671947; cv=none; b=G85w/PypVh/FIWzP/TarNTLJ45Sw3c1zXmPAAd5L8SgmTxWQcEQd+UXWLXY9Y9G26jLTqr48PSXCoFIThoxhZZdQdxeRMKbldVULUXfEJQNFFL93VxSm+uxOqXU8TechWnVHEKgzL8wT8H4qXb+Qp950TV8i3JjMc/ExnWiUTeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671947; c=relaxed/simple;
	bh=4vTYs+xQAUuGk4y8NNmd9eqztVFDT26xA77hTWq7WQg=;
	h=Date:To:From:Subject:Message-Id; b=tpcPZ/7MIb91CtOxiwXH8j0yocuqLmv3NSpvTGdVlU3zMLRwmrW6tcmFKoDN6TT+tK7vfbDJFxnrkg+FWkKhHkc9D3pPq0kh8U5xCw4hEpjYspP6MLJ+ghB396VnsNz/O7h9VoeGSTP0zgXY2F3njgVA8O5jd0Mh8kVxj9HXL5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bCxsZUEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bCxsZUEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38A5C4CEF7;
	Sat, 28 Mar 2026 04:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671947;
	bh=4vTYs+xQAUuGk4y8NNmd9eqztVFDT26xA77hTWq7WQg=;
	h=Date:To:From:Subject:From;
	b=bCxsZUEIp/Tl7V+yJqOnoyk4I2FDNZFUoLmum1OwgPu1AnNQYT9injCpBJ6YanI8+
	 sXffWBFSihDQ4NefDaX8w4qax1DCDw0VT7H0nKBjeeRWOxqTmyJCtXikYXWQfqbPwC
	 ruH3ltcqMXlQLL02y9pDQ/rUxcRbdsSmUJWRBekM=
Date: Fri, 27 Mar 2026 21:25:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch removed from -mm tree
Message-Id: <20260328042547.B38A5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/ts_kmp: fix integer overflow in pattern length calculation
has been removed from the -mm tree.  Its filename was
     lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/ts_kmp: fix integer overflow in pattern length calculation
Date: Sun, 8 Mar 2026 20:20:28 +0000

The ts_kmp algorithm stores its prefix_tbl[] table and pattern in a single
allocation sized from the pattern length.  If the prefix_tbl[] size
calculation wraps, the resulting allocation can be too small and
subsequent pattern copies can overflow it.

Fix this by rejecting zero-length patterns and by using overflow helpers
before calculating the combined allocation size.


This fixes a potential heap overflow.  The pattern length calculation can
wrap during a size_t addition, leading to an undersized allocation. 
Because the textsearch library is reachable from userspace via Netfilter's
xt_string module, this is a security risk that should be backported to LTS
kernels.

Link: https://lkml.kernel.org/r/20260308202028.2889285-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_kmp.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/lib/ts_kmp.c~lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation
+++ a/lib/ts_kmp.c
@@ -94,8 +94,22 @@ static struct ts_config *kmp_init(const
 	struct ts_config *conf;
 	struct ts_kmp *kmp;
 	int i;
-	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
-	size_t priv_size = sizeof(*kmp) + len + prefix_tbl_len;
+	unsigned int prefix_tbl_len;
+	size_t priv_size;
+
+	/* Zero-length patterns would make kmp_find() read beyond kmp->pattern. */
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * kmp->pattern is stored immediately after the prefix_tbl[] table.
+	 * Reject lengths that would wrap while sizing either region.
+	 */
+	if (unlikely(check_mul_overflow(len, sizeof(*kmp->prefix_tbl),
+					&prefix_tbl_len) ||
+		     check_add_overflow(sizeof(*kmp), (size_t)len, &priv_size) ||
+		     check_add_overflow(priv_size, prefix_tbl_len, &priv_size)))
+		return ERR_PTR(-EINVAL);
 
 	conf = alloc_ts_config(priv_size, gfp_mask);
 	if (IS_ERR(conf))
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

