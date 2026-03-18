Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED743E9F61
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773860900; cv=none; b=VE0Fuyo/Eolz2nL8VS3MtfLtTk8B0Y2jr9GUuXrY50AqDdxFEcR9U68TVAxw/JK9XsTfuK6Su6INdWgjUPM8mc1FUgUL7BB0fo3Y53VioYQ38LOph/LV1u6ohCc8CeMhVbbVCeJIP7GhrUVN/xCt02Ad36j4diuHJ+5GUTlyDIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773860900; c=relaxed/simple;
	bh=DNcdKv8A8h1QCToKnhLVoXqDECh2Ao8k3hXW7RXD9YA=;
	h=Date:To:From:Subject:Message-Id; b=KMe5vfsvCzVPWpBQ+Sx1M3H/IDczlMUtJA1Bq9rvhKLI4iM9T2/1mWynlOQn7DW83w3XgMdAKTqOWTiz9DWeLfx6wvdVnLwK4lURPv+kUPpk7cx+N7m0HzEOSrp5Ci8ubKDXd3hFoPhs8q2fT81LiVPfUCFI20A2+KNdSThRLRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ta1tONqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ta1tONqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2099C19421;
	Wed, 18 Mar 2026 19:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773860899;
	bh=DNcdKv8A8h1QCToKnhLVoXqDECh2Ao8k3hXW7RXD9YA=;
	h=Date:To:From:Subject:From;
	b=Ta1tONqbVLYKFais34JKSZ6ni76SaQrCuygjy8w0wqB42dV284c2GhJTzTrIBqcfj
	 +QwR1de7nknpy5uFZeF/aicKx8lvObZQ9InKUMsi8WbJt4r8M5W+D8zp4RFx+8o1eg
	 o63sGaSHQ2Qb0CARkgCaasACPn4a7WYB5F0B6pYY=
Date: Wed, 18 Mar 2026 12:08:19 -0700
To: mm-commits@vger.kernel.org,ivan.djelic@parrot.com,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch added to mm-nonmm-unstable branch
Message-Id: <20260318190819.D2099C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bch: fix signed shift overflow in build_mod8_tables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch
lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

