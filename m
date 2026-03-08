Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592082DFA25
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773001466; cv=none; b=o6rS1xAi8k2Z8daOmn9ifLmdV4sV+IMmLmcFA61uiJo5n9pOzcIVZDzNtZzdwMia7TcLATZz3xUGSbBHUH80bE9g6wnfoBz99b5Z9d8oHOXOd/SUMNSwR7014jARhWqvGkA2gohAvdUE7/E+U4POgsEJngk6DUKudAOhfLX4EXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773001466; c=relaxed/simple;
	bh=dg+tzEK8TO9+eAX0Ej3KuQMh0GcClKtmfaB+f3zmYCY=;
	h=Date:To:From:Subject:Message-Id; b=nCThVvlDqXp7h3W8veTmlCljkrXpArtIq4npWXZVmQ9RB3LGV/uCIsZ6lWcclGrkSrXY07uN3Oc8Kao3lgqh3LxJDIkg1q/89AP4kjWNFsn9690gU7DbYjE1MZB8eH7AhKuKA6IyawGZlSbRJEH6sy94gjLQ+5oetAnC3Y2LM7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CHvBSVMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CHvBSVMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EE4C116C6;
	Sun,  8 Mar 2026 20:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773001465;
	bh=dg+tzEK8TO9+eAX0Ej3KuQMh0GcClKtmfaB+f3zmYCY=;
	h=Date:To:From:Subject:From;
	b=CHvBSVMh0g5SeDt34bmeoWjBKGYuo6SEaVrhoAu+ubS3VOOoffnHKtJDSiWWGoddd
	 SWYf1WoB9lpxlmc1GPX8ka4Htu596WzRkZbt6yeX8oEbRRvH6bmRSL6RQuWA1LXXLn
	 k8oIPJpYEyIal9w5DjbVwIwbQmP40VAlTvldH98w=
Date: Sun, 08 Mar 2026 13:24:25 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-josh-law-as-reviewer-for-library-code.patch added to mm-nonmm-unstable branch
Message-Id: <20260308202425.C9EE4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Josh Law as reviewer for library code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-josh-law-as-reviewer-for-library-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-josh-law-as-reviewer-for-library-code.patch

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
Subject: MAINTAINERS: add Josh Law as reviewer for library code
Date: Sat, 7 Mar 2026 22:21:54 +0000

Add myself as a designated reviewer for the library code to help review
incoming patches and improvements.

Link: https://lkml.kernel.org/r/20260307222154.2848660-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-josh-law-as-reviewer-for-library-code
+++ a/MAINTAINERS
@@ -14616,6 +14616,7 @@ F:	tools/testing/nvdimm/
 
 LIBRARY CODE
 M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Josh Law <objecting@objecting.org>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
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
maintainers-add-josh-law-as-reviewer-for-library-code.patch

