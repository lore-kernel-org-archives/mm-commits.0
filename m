Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250D0337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671969; cv=none; b=IJQWa0DuDw7WCruBC4QXqTCxga65d5uRWaWg2k1CFdm5oVNG8NvZpZd4+WJNRLfTp5az4nTyJCtYbSHZ1BbvCM64ycw/cA9B46qaaFO/IJ4Fd0tCCfnnZuvUj160ftWJYX/lWc/Qw2p1q9g/M3z4fHxIS3Sr9KbvMkjL+UVgabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671969; c=relaxed/simple;
	bh=ZOy9h7oNv1/M5BggJ00O2AYVcDNQhhBXtXaVCpS+neg=;
	h=Date:To:From:Subject:Message-Id; b=CzE0kD/EuJYDU9FttqTBj08kVd7/TdcwvoG1du2CFXX+U9PG6lctGhxpp4kA7XfYjGy/qIL/pBf7ohXVdb2kc3/eVR7LvcBiyOImnfYPk1kodraB3HLH2vfopZwsEbNXbd1xA1cAaGf+4x2rl3Ae5u2Dy7NWRTxcO2PK4ZrJwD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fIfA1CxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fIfA1CxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24CBC4CEF7;
	Sat, 28 Mar 2026 04:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671969;
	bh=ZOy9h7oNv1/M5BggJ00O2AYVcDNQhhBXtXaVCpS+neg=;
	h=Date:To:From:Subject:From;
	b=fIfA1CxA8l4487m+4IZzlh/8F0Gqlx1OAbWqGDXAjw3CuKaqQWqOzVVuVo3urd9al
	 nHnS1BeDYEZwbnWaFPjWuQque6X3/QwkYyj+kcLIYAdZrMIkzz3S9uYJZ0x8YWLNLp
	 mI+Q0dKl9odvVJuvetjQFWV9bNcwocCsmSynI/5A=
Date: Fri, 27 Mar 2026 21:26:08 -0700
To: mm-commits@vger.kernel.org,ivan.djelic@parrot.com,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bch-fix-signed-left-shift-undefined-behavior.patch removed from -mm tree
Message-Id: <20260328042608.F24CBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bch: fix signed left-shift undefined behavior
has been removed from the -mm tree.  Its filename was
     lib-bch-fix-signed-left-shift-undefined-behavior.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/bch: fix signed left-shift undefined behavior
Date: Wed, 18 Mar 2026 07:48:05 +0000

Patch series "lib/bch: fix undefined behavior from signed left-shifts".

Fix two instances of undefined behavior in lib/bch.c caused by
left-shifting signed integers into or past the sign bit.

While the kernel's -fno-strict-overflow flag prevents miscompilation
today, these are formally UB per C11 6.5.7p4 and trivial to fix.


This patch (of 2):

Use 1u instead of 1 to avoid undefined behavior when left-shifting into
the sign bit of a signed int.  deg() can return up to 31, and 1 << 31 is
UB per C11.

Link: https://lkml.kernel.org/r/20260318074806.16527-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Djelic <ivan.djelic@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/bch.c~lib-bch-fix-signed-left-shift-undefined-behavior
+++ a/lib/bch.c
@@ -392,7 +392,7 @@ static void compute_syndromes(struct bch
 			for (j = 0; j < 2*t; j += 2)
 				syn[j] ^= a_pow(bch, (j+1)*(i+s));
 
-			poly ^= (1 << i);
+			poly ^= (1u << i);
 		}
 	} while (s > 0);
 
@@ -612,7 +612,7 @@ static int find_poly_deg2_roots(struct b
 		while (v) {
 			i = deg(v);
 			r ^= bch->xi_tab[i];
-			v ^= (1 << i);
+			v ^= (1u << i);
 		}
 		/* verify root */
 		if ((gf_sqr(bch, r)^r) == u) {
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

