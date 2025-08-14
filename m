Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F51C9DE5
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2025 22:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755211014; cv=none; b=eu4S7uM6QbiQpTikUZDE1nrfdfrVeadmfBDcNWTSke/xtjyu1RDDcyCLkOUehRN6jLRykNfF8Mj3Xb3uTt1M+1vmGxg70E/k3ZXcqjFXGlsN+gkIPhEAH2IKCTxXYsD5c2vl7QRzbQd34leuOS2Vi6R5D1Xkz8Y6/enOSXRV7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755211014; c=relaxed/simple;
	bh=L152c2L47ErUeaVqNE8piOTRk54rjWLvB6Leh38zD4w=;
	h=Date:To:From:Subject:Message-Id; b=L1scJbV5zff/hWu6UKdzVrHXKIEEvxPIca685AgSVHW2ad0vK67ybk67H6sMF+yS/2PQTAlgTPrQ1q84rq3UCyjhU52JaAZjaDZWTvToJyWu7SgUPusDXUinafaer9ELJ9oUm+DOCik0+wDdiRgKAKVwFDGksPBubDzbJ+MTImo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N38pQ17O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N38pQ17O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0C3C4CEED;
	Thu, 14 Aug 2025 22:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755211014;
	bh=L152c2L47ErUeaVqNE8piOTRk54rjWLvB6Leh38zD4w=;
	h=Date:To:From:Subject:From;
	b=N38pQ17OvOY7JdaDtjcERTGC5GKfMN+SY4yGAXBtFC2ZBluIjbsFxvBSLimjsWe38
	 E25ucKlq4NWDYx/TIep60aab4B2Fn7CjKawiccFT+8FoZcG/Sou0S5AIUEQ65vgE92
	 SHC/AiXT2Wm2mZHKyswipgVZbpK42UEHbKLSOs3s=
Date: Thu, 14 Aug 2025 15:36:53 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch added to mm-unstable branch
Message-Id: <20250814223654.2D0C3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: always inline __folio_rmap_sanity_checks()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/rmap: always inline __folio_rmap_sanity_checks()
Date: Thu, 14 Aug 2025 13:05:22 -0700

Commit 5e901e249ad1 ("mm/rmap: convert "enum rmap_level" to "enum
pgtable_level"") changed VM_WARN_ON_ONCE, a run time warning, into
BUILD_BUG, a compile time error. After this adjustment, certain builds
with older versions of clang (such as arm64 allmodconfig) started
failing to build with:

  In file included from mm/rmap.c:63:
  In file included from include/linux/ksm.h:14:
  include/linux/rmap.h:440:3: error: call to __compiletime_assert_890 declared with 'error' attribute: BUILD_BUG failed
                  BUILD_BUG();
                  ^
  ...
  <scratch space>:21:1: note: expanded from here
  __compiletime_assert_890
  ^

While __folio_rmap_sanity_checks() is marked 'inline', the compiler may
not always honor it, such as when sanitizers or other instrumentation is
enabled.  If __folio_rmap_sanity_checks() is not inlined, there is no
way the compiler can eliminate the default cause.

Mark __folio_rmap_sanity_checks() as __always_inline to allow the
BUILD_BUG() to work consistently, which clears up the error.

Link: https://lkml.kernel.org/r/20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix
+++ a/include/linux/rmap.h
@@ -394,7 +394,7 @@ typedef int __bitwise rmap_t;
 /* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
-static inline void __folio_rmap_sanity_checks(const struct folio *folio,
+static __always_inline void __folio_rmap_sanity_checks(const struct folio *folio,
 		const struct page *page, int nr_pages, enum pgtable_level level)
 {
 	/* hugetlb folios are handled separately. */
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch

