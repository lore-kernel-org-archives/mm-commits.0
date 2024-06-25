Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256AB33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293189; cv=none; b=YiTn0E6EooZRTkhbAHG23BEp2M1uidqk4OqF+HkQX3mLpi3IV8eywtl4ofOkEQfobLFubI9VH2rMwTYfoBIHb4IqJzs29DrSyLhSkBC0X5KBs6ZCI+o5FMGi+wN2s6Op2P2gNpUjW8fcUbid+kfVgR31E8udwsHWYUHbdLUH+ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293189; c=relaxed/simple;
	bh=fL7XHUrQseUNvhkm5DJ3wusCgTNn8QLzGYbUWGYHdgw=;
	h=Date:To:From:Subject:Message-Id; b=UoqHH0BBHb4CNeFOy9Q1PGkNepso/QV5ZIYt21A+huz1aUz2pjsN89z/VlGTjFUX/52+wSxlx9fSRfCrd2G97cQXe5+wm0BpA7RFEMWyv2pCSJhdeCHh2SN9yzzct+VthZfXqW/VLIvFkLrI23hkFeSzY43lwJ/u6K9pHpwnajQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JSraeUNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JSraeUNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB5CC32789;
	Tue, 25 Jun 2024 05:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293189;
	bh=fL7XHUrQseUNvhkm5DJ3wusCgTNn8QLzGYbUWGYHdgw=;
	h=Date:To:From:Subject:From;
	b=JSraeUNzhMh4kqRtE2j+CUcITSkcit6eZH4tGP4PnyLaNK5qsKJ5giORFpwURU9Kf
	 jVfMH8LTUW8GZwEXV6Tb97zN/szNNYQcz6Uh6dvL8g6cH7eRIKVRprnIPFFUP3oLeO
	 DWcRBnXMnw5PK9CQaAvu2EgyRP5txLmvfgidPPq4=
Date: Mon, 24 Jun 2024 22:26:28 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch removed from -mm tree
Message-Id: <20240625052628.EFB5CC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort: optimize heapsort for handling final 2 or 3 elements
has been removed from the -mm tree.  Its filename was
     lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: optimize heapsort for handling final 2 or 3 elements
Date: Tue, 28 May 2024 04:30:10 +0800

After building the heap, the code continuously pops two elements from the
heap until only 2 or 3 elements remain, at which point it switches back to
a regular heapsort with one element popped at a time.  However, to handle
the final 2 or 3 elements, an additional else-if statement in the while
loop was introduced, potentially increasing branch misses.  Moreover, when
there are only 2 or 3 elements left, continuing with regular heapify
operations is unnecessary as these cases are simple enough to be handled
with a single comparison and 1 or 2 swaps outside the while loop.

Eliminating the additional else-if statement and directly managing cases
involving 2 or 3 elements outside the loop reduces unnecessary conditional
branches resulting from the numerous loops and conditionals in heapify.

This optimization maintains consistent numbers of comparisons and swaps
for arrays with even lengths while reducing swaps and comparisons for
arrays with odd lengths from 2.5 swaps and 1 comparison to 1.5 swaps and 1
comparison.

Link: https://lkml.kernel.org/r/20240527203011.1644280-4-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/lib/sort.c~lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements
+++ a/lib/sort.c
@@ -250,10 +250,7 @@ void sort_r(void *base, size_t num, size
 			a = size << shift;
 			n -= size;
 			do_swap(base + a, base + n, size, swap_func, priv);
-		} else if (n > size) {	/* Sorting: Extract root */
-			n -= size;
-			do_swap(base, base + n, size, swap_func, priv);
-		} else	{		/* Sort complete */
+		} else {		/* Sort complete */
 			break;
 		}
 
@@ -283,6 +280,11 @@ void sort_r(void *base, size_t num, size
 			do_swap(base + b, base + c, size, swap_func, priv);
 		}
 	}
+
+	n -= size;
+	do_swap(base, base + n, size, swap_func, priv);
+	if (n == size * 2 && do_cmp(base, base + size, cmp_func, priv) > 0)
+		do_swap(base, base + size, size, swap_func, priv);
 }
 EXPORT_SYMBOL(sort_r);
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


