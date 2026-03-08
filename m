Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55FA318B96
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773004633; cv=none; b=tnznA6ACkdKHcirL5gYg23/n3LoTZEMM11OLpI2cIusrn6ocKLeUsdOtC3Kp8ijHshUQXZ5JXASEYeG3//ZsWvrc0zQSIxc+X46RnTlyDwwCIcDGf6QLrpaMtVMRU7WD/IEG4M9gyUZxVJhUtNOKEqRCW6wqa2zKKEFGUsgGijE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773004633; c=relaxed/simple;
	bh=/0iRLveWMa0s+vWu5dc7RjMpyxBl4/3OU9aRuipWNks=;
	h=Date:To:From:Subject:Message-Id; b=VVLdO+6MheDsif7ACEKRvE42mIbDtEGVq/Mx5sGJWsCbNITlKePfl1xxeRuFxYKeyL96BW/yWx/DZu5VkDZiPBUkGixietSp80nFIACRaIx3UutdWPNbjRGzxwQfJB6DMVUZS07W6E065FbcxzYEwLDwC8wdEC7qsQxv79wGE4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YNPCsm0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YNPCsm0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E84EC116C6;
	Sun,  8 Mar 2026 21:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773004632;
	bh=/0iRLveWMa0s+vWu5dc7RjMpyxBl4/3OU9aRuipWNks=;
	h=Date:To:From:Subject:From;
	b=YNPCsm0/2+FhCpHZkHPfAnltrQxR8b+ynvgwUSEJf0tfbo90Wvq/0C5j8CvJBmLF2
	 6zAgHmJ7PoXzZ3CXLQ5zyzHciJ4feQtlTFryBVmFpVJpnnz1vJr0bvXTpp1/tpciOj
	 PDjcTy1JL0yuQ181ijyIep78mOkbOFTEubQmsee0=
Date: Sun, 08 Mar 2026 14:17:11 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20260308211712.5E84EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bootconfig: fix typo "budy" in _xbc_exit() comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch

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
Subject: lib/bootconfig: fix typo "budy" in _xbc_exit() comment
Date: Sat, 7 Mar 2026 12:26:46 +0000

Fix a spelling error in the _xbc_exit() kernel-doc comment where "budy
system" was written instead of "buddy system".

Link: https://lkml.kernel.org/r/20260307122646.2838540-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment
+++ a/lib/bootconfig.c
@@ -911,7 +911,7 @@ static int __init xbc_parse_tree(void)
 
 /**
  * _xbc_exit() - Clean up all parsed bootconfig
- * @early: Set true if this is called before budy system is initialized.
+ * @early: Set true if this is called before buddy system is initialized.
  *
  * This clears all data structures of parsed bootconfig on memory.
  * If you need to reuse xbc_init() with new boot config, you can
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
lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch

