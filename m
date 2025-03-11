Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7562026389D
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716701; cv=none; b=A+WeXNXkl/fsK3h4mmr29CHztFlKTQH/KBVj0Ser0pdiV6vjigx+DaJ35nXVnIY+BM5mvtDifvFc3H9yhg0x5LpoPuBZiv4YpkpZLmAtHqTLYAa3XwkVjzRkV1Nid7im1P1s2v6UuuYJ7xVT/p6iDD1mU0ffDwGqhQtiDPmBIWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716701; c=relaxed/simple;
	bh=jpGmdSkgU9Gk+73/oyxKUpNx0XF/kJdrzC/TA4QjryA=;
	h=Date:To:From:Subject:Message-Id; b=pCZsipxu7PrZB8kiFnXzk6Pedggt6ZyRlQ7iZk8xr8ibxV2hViLDvpy1zqE7A0B7uEwmGrC3RhDLZ1ptMv27ZnXCnuR6gEj+6tLi6RjinbYouQKNhb2RSEBF4XFFlnioknTV89bT2G0ZKniSdHJCMTJjS8F0SIPvcPdGad/XK70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GL2TseQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GL2TseQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03C9C4CEEC;
	Tue, 11 Mar 2025 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741716700;
	bh=jpGmdSkgU9Gk+73/oyxKUpNx0XF/kJdrzC/TA4QjryA=;
	h=Date:To:From:Subject:From;
	b=GL2TseQ0gPXJFdq9gR7zNsnP7clTSsKHfRFA7mpSMYue8LcQkScqR5GqEroe3cFPA
	 TFkFBtAeC3J/o5aSYr/beIZKmjPGNXR4fubZ2SDQ1onSgkvLBwqSzzJ9pJVkIdqjWn
	 Vv/TgpASY3WxnHlIexgGRSIlcq8tPDgbdH9/B+vU=
Date: Tue, 11 Mar 2025 11:11:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sfr@canb.auug.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix.patch added to mm-unstable branch
Message-Id: <20250311181140.D03C9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix.patch

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
Subject: mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix
Date: Tue Mar 11 11:05:31 AM PDT 2025

fix CONFIG_XARRAY_MULTI=n build

Link: https://lkml.kernel.org/r/20250311212606.0523be36@canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix
+++ a/lib/xarray.c
@@ -1233,7 +1233,6 @@ void xas_try_split(struct xa_state *xas,
 	xas_update(xas, node);
 }
 EXPORT_SYMBOL_GPL(xas_try_split);
-#endif
 
 /**
  * xas_try_split_min_order() - Minimal split order xas_try_split() can accept
@@ -1256,6 +1255,7 @@ unsigned int xas_try_split_min_order(uns
 	return order - (order % XA_CHUNK_SHIFT);
 }
 EXPORT_SYMBOL_GPL(xas_try_split_min_order);
+#endif
 
 /**
  * xas_pause() - Pause a walk to drop a lock.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

