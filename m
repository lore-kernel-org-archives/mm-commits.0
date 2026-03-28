Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26B122B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671904; cv=none; b=IGxQuYYS4zUfqnmOtDEgD3WUnG+Q7nNO57UulO0O5A35+13zA7XW0xhNAA5d1X2qc0l5g/A57M5r/Nl6aYsCn7quIHDMfbwDM8VRppva0JCV0UzArFlFMX3NhLeL9C5yQdEA2nLxM+OZt58dCyU3MIGAje2MMQMvQFw9X/06vKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671904; c=relaxed/simple;
	bh=96RwmVeimhjoIS/UAkCGBIz87LQtPHwcGH7dzfudpq8=;
	h=Date:To:From:Subject:Message-Id; b=JD4n4pjUydzI2eW/liI8sNP1QQ1DTXt/p1CETxeAtu3ZweWKXeq4LY4h3ufLBCd/8NrYILUcQGKQnEBmY5vr3DVBEJeHO8rWaeGwTQAqUW2hhCFN/j8VErPRpAsVm83FOUguKuANftcXeE1fEfsYkvNS63lE6KkKDorSSoxR9FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1B/b5T0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1B/b5T0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE99C4CEF7;
	Sat, 28 Mar 2026 04:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671904;
	bh=96RwmVeimhjoIS/UAkCGBIz87LQtPHwcGH7dzfudpq8=;
	h=Date:To:From:Subject:From;
	b=1B/b5T0nkGu4WvJmgGIxBVjUhYVkMZ0WMWQfl47q6/2XsQvAQbdtmmK+6JzumhGYz
	 LhCT4eL5OKDqIhNGoMUTbVPc9Ij9jVv/EcobhSolcF62YYIaP/fogMshKQSSuJg4cU
	 AoucIHZbKCdQuT2YIWzZodrR+rCXaiPIuincYCjE=
Date: Fri, 27 Mar 2026 21:25:04 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch removed from -mm tree
Message-Id: <20260328042504.AAE99C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: glob: replace bitwise OR with logical operation on boolean
has been removed from the -mm tree.  Its filename was
     lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib: glob: replace bitwise OR with logical operation on boolean
Date: Sun, 1 Mar 2026 15:21:42 +0000

Using bitwise OR (|=) on a boolean variable is valid C, but replacing it
with a direct logical assignment makes the intent clearer and appeases
strict static analysis tools.

Link: https://lkml.kernel.org/r/20260301152143.2572137-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-replace-bitwise-or-with-logical-operation-on-boolean
+++ a/lib/glob.c
@@ -96,7 +96,8 @@ bool __pure glob_match(char const *pat,
 					class += 2;
 					/* Any special action if a > b? */
 				}
-				match |= (a <= c && c <= b);
+				if (a <= c && c <= b)
+					match = true;
 			} while ((a = *class++) != ']');
 
 			if (match == inverted)
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

