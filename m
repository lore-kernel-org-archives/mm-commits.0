Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0E12248BD
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757482611; cv=none; b=ksknRLHElXTn0b3S23NwTi+cwsTbp/jrUVLzEw5ai1BexckDchARZtgllyXQMtPFGKI9mmQb2s1sIJzHFpPFF14Dn2J+voTj2dJSYW9+zX0QKy0vpfTzQ3D7h2xIHjMBU9YkTV4CYIQyf0390/SBKBf9Qe8KPSvXdOEXOH5Scs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757482611; c=relaxed/simple;
	bh=i8lQ5akgEwZACCR2Mfqd01qIiupAeM/XlBYD/hCm8Y8=;
	h=Date:To:From:Subject:Message-Id; b=b9Menz9lOSTlhTjAb3bwJ5vG5STituTl93nHcf/klJQqWjZt0SW2QmxZjJRgrU2vs5XnhzG8oO+xgpNKMIPzKpSNestQb9/h8SC7j2G7GQLmMCuspw1OKbQ6qY95ngo5Hnn8MILvjiK7IqXSpvYYk1oFqhi8dkLSBClzvFaFSRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IsGNtgsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IsGNtgsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78D5C4CEF0;
	Wed, 10 Sep 2025 05:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757482610;
	bh=i8lQ5akgEwZACCR2Mfqd01qIiupAeM/XlBYD/hCm8Y8=;
	h=Date:To:From:Subject:From;
	b=IsGNtgsC2Eu+ZNWnanwsikt2CkIjg1BeQFmtyiGB1KcKKMFcKtwuDAS6nuWPBI081
	 iG9L8vIpx8hbEIMkc0t0KR+ZL9qPSEqxbxSys5ULD5/tIWJ3Lb5IOGVwrq3qPDvxH3
	 Oreg8muby2EGk5sQ26ZAPLCSY0hns/IzAx0nt9Nk=
Date: Tue, 09 Sep 2025 22:36:50 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix.patch added to mm-unstable branch
Message-Id: <20250910053650.C78D5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix
Date: Tue Sep  9 10:35:05 PM PDT 2025

fix CONFIG_SWAP=n

Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap.h~mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix
+++ a/mm/swap.h
@@ -451,8 +451,10 @@ static inline int non_swapcache_batch(sw
  */
 static inline pgoff_t folio_index(struct folio *folio)
 {
+#ifdef CONFIG_MMU
 	if (unlikely(folio_test_swapcache(folio)))
 		return swp_offset(folio->swap);
+#endif
 	return folio->index;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
docs-mm-add-document-for-swap-table-fix.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

