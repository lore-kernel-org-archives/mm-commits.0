Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6945933121C
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474955; cv=none; b=F+Qlbk2nPAHA0uau3gccy2utKTkPDxr4w76QcjisYUiNnNnyupuQrfC10V42wWgMOB6ze6rKI81YbuuFG0Fd0BjqNm5NvplAmSXt0bX52KBbb0DA2k7RHA/sp6xaHHN4AAScuGcs8JBSQkLHwePqa6ifgU6Rs5rmcBF83bNW6Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474955; c=relaxed/simple;
	bh=42xzMHi7+jXYyFCpdkYBI/JZ9o827bL9tSVsQr6vgPk=;
	h=Date:To:From:Subject:Message-Id; b=TJBLLJ1ZnChE/8wsMdEztzzKzIUUUDqoZW/rIw9WNeZvxWabe87XMNcrVQTxEfgPA3sKsg2MfOkJ5Ew6UOUQeDLt8ZABYSk9wMH6snQgsjV1izW6NRzvzKaIYCMGoMaivXOX4/BFKL1J6jV4D2kOCQs3JPMwiUUjHCfGDX4M5Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c6oCmstb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c6oCmstb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA905C19425;
	Wed, 29 Apr 2026 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777474955;
	bh=42xzMHi7+jXYyFCpdkYBI/JZ9o827bL9tSVsQr6vgPk=;
	h=Date:To:From:Subject:From;
	b=c6oCmstbdaqHaVPC6xo8jfcHEc4jDSjc4fRvj+ZxS5RNMgJPeJJEsc0Z7hDikgfiS
	 PwvlLANrBzhHLq/SCkw7rbByZEdnzaybRPLjRzHNicCBeJAwjSXiqoOlZFxoqqQ0BH
	 klP/w98RB9TjFxhYEnAV9skYCipo37vQcO/vUUAc=
Date: Wed, 29 Apr 2026 08:02:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch added to mm-new branch
Message-Id: <20260429150234.EA905C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE in MADV_COLLAPSE
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch

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
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE in MADV_COLLAPSE
Date: Wed, 29 Apr 2026 19:34:34 +0530

MADV_COLLAPSE uses errno values to provide actionable feedback to
userspace.  Temporary resource constraints are mapped to -EAGAIN so the
caller may retry, while intrinsic failures of the specified range are
mapped to -EINVAL.

collapse_file() returns SCAN_PAGE_HAS_PRIVATE when filemap_release_folio()
fails while isolating file-backed folios for collapse.  This currently
falls through the default case in madvise_collapse_errno() and is reported
to userspace as -EINVAL.

However, filemap_release_folio() failure commonly reflects temporary folio
state rather than a permanently uncollapsible range.

For example, ext4 returns false when a folio still has dirty journalled
data, btrfs returns false for dirty or writeback folios before extent
state release, and NFS may return false while reclaiming
filesystem-private folio state.

In such cases, retrying MADV_COLLAPSE after writeback, reclaim or journal
progress may succeed.  This matches the existing -EAGAIN handling for
SCAN_PAGE_DIRTY_OR_WRITEBACK and other transient collapse failures more
closely than -EINVAL.

Therefore, map SCAN_PAGE_HAS_PRIVATE to -EAGAIN so userspace receives
retryable feedback for this temporary failure path.

Link: https://lore.kernel.org/20260429140434.439456-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse
+++ a/mm/khugepaged.c
@@ -3151,6 +3151,7 @@ static int madvise_collapse_errno(enum s
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
 	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch
mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch

