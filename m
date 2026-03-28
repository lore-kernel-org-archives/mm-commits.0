Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF37337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671970; cv=none; b=eoSKajYS2rRuU88xo6jNEEMbwBaKqjjZmGY8bCqgkkj3Fpm5dH2Kmkpj1SswBSqV0WFG2do/9oh6N+CX7BzgX6LNM0vO2qrtz5u/IL8MThcBTFk9VSpZ030W5+lP7Z+OuV/c6By0wX85Ul+UXQ9/69NAv8aEPguzqF0+xWSUrpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671970; c=relaxed/simple;
	bh=/GP7uC/dmIZsDXUgERP8Izi0RNWxo/ppem9Oq33RARE=;
	h=Date:To:From:Subject:Message-Id; b=Et/54s95yNiZvsxE7u9d0GvcKR3v6EWnqbS/zIaX3bUZ4nfVjvVUo7LHP4Tj3v00kT1bnpCLkMyLnypP6ImBZlEFDxzqjeWe7uX2vpbZscMZJpomDRxLekqerfNAr7FPpdcvCXI1Kgi8xdFaVBrAbxj4Mw12vKH6pSwW1AS2E+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UJu3Wn9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UJu3Wn9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231E7C4CEF7;
	Sat, 28 Mar 2026 04:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671970;
	bh=/GP7uC/dmIZsDXUgERP8Izi0RNWxo/ppem9Oq33RARE=;
	h=Date:To:From:Subject:From;
	b=UJu3Wn9iJpIfOhmxnnKv16d+DzqbXVTfReXzF+dI8YZ6BfmnnNxUrwRjd/OzmTUmI
	 yOyF36pFOFg+8U044zl2v18oPJgeGU7H4kxollGE50VPTZpVKD2UZAJwbTbIXEFJIR
	 WD9IzKIErgE+gVilQr+TuJ2DjaI15jgb6bB/1ZHU=
Date: Fri, 27 Mar 2026 21:26:09 -0700
To: mm-commits@vger.kernel.org,ivan.djelic@parrot.com,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch removed from -mm tree
Message-Id: <20260328042610.231E7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bch: fix signed shift overflow in build_mod8_tables
has been removed from the -mm tree.  Its filename was
     lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/bch: fix signed shift overflow in build_mod8_tables
Date: Wed, 18 Mar 2026 07:48:06 +0000

Cast loop variable to unsigned int before left-shifting to avoid undefined
behavior when i >= 128 and b == 3 (i << 24 overflows signed int).

Link: https://lkml.kernel.org/r/20260318074806.16527-3-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Djelic <ivan.djelic@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bch.c~lib-bch-fix-signed-shift-overflow-in-build_mod8_tables
+++ a/lib/bch.c
@@ -1116,7 +1116,7 @@ static void build_mod8_tables(struct bch
 		for (b = 0; b < 4; b++) {
 			/* we want to compute (p(X).X^(8*b+deg(g))) mod g(X) */
 			tab = bch->mod8_tab + (b*256+i)*l;
-			data = i << (8*b);
+			data = (unsigned int)i << (8*b);
 			while (data) {
 				d = deg(data);
 				/* subtract X^d.g(X) from p(X).X^(8*b+deg(g)) */
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

