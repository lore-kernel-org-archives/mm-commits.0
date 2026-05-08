Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6BC36F40D
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 21:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274936; cv=none; b=uq1d2haOVe+mILpPHY409scZTiFATyXwwTXiiD7nfu3/cAt1VDOqVJ8BX2x+FRWHOMkPA+M49yZ1MEHaxFDV30YSeYO/93F9dVpWSXO0pwx8pdP0MHNh8E/qq1Ohq24snk2Mqo6MJWob+HRUWDQ1sh71ByJSfWE3vf2ZGWy4QVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274936; c=relaxed/simple;
	bh=21Bb2zodZuuLpBsQeGAFfgjP2afF/ehFQIBVXVxW6DU=;
	h=Date:To:From:Subject:Message-Id; b=XKI6Kl8Fo+cPVWpMbnbmSqSGm5PnT2h4Fv8Hafs1A48orfjBa9lLm0V4UkdAxKiRoErmnNeM5twV1DH1k4ZuLXKl0Mi8XEBxc8Mo+p5iyq7rja729Q7z7GFLKKChegrV9PKLR/U2T7flmExN/z5LvLnSHkwNKLi4yTSfHir1rbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pb3kfyEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pb3kfyEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488FEC2BCB4;
	Fri,  8 May 2026 21:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778274936;
	bh=21Bb2zodZuuLpBsQeGAFfgjP2afF/ehFQIBVXVxW6DU=;
	h=Date:To:From:Subject:From;
	b=pb3kfyEwRspiKCsZBwBGd0Yiq1PK8jqcOzwWpSdSlzVTihHP9pTVUbRxnMlwL+OdQ
	 XyjpjtjH/yKFtpOLlFZJhcr2lB18BQAGt5Kz5hcKy675r0Axwulc9WXqJjkx80BNvz
	 zBR723QKPBIiI/vYwOFWf71247tX1iOMHs5AkTCY=
Date: Fri, 08 May 2026 14:15:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch added to mm-new branch
Message-Id: <20260508211536.488FEC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix mapping_pmd_folio_support() to represent its exact meaning
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Zi Yan <ziy@nvidia.com>
Subject: fix mapping_pmd_folio_support() to represent its exact meaning
Date: Thu, 7 May 2026 02:02:28 -0400

Link: https://lore.kernel.org/73AB53AB-6EAA-4077-AFCA-90929F20D17A@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/include/linux/pagemap.h
@@ -530,7 +530,8 @@ static inline bool mapping_pmd_folio_sup
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
 
-	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+	return mapping_min_folio_order(mapping) <= PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >= PMD_ORDER;
 }
 #else
 static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

