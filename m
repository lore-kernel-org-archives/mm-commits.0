Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4BC370AED
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027686; cv=none; b=lfRpEvYFtLT+ytPWBMbhGxUHFYzyremm0SyYo6LTmyhgrnpqsT6Q1nDJLbDrHAufHTqnrG+Fy3eRu0jPnCRbTuoyuoHtlS3aVz9XED5pb0TtCzzZFkJwtvsKu8RJESAs7Ar0Ll/ZikOBPJ9SybPNOmQ8skFry2yx5hocdw8KAVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027686; c=relaxed/simple;
	bh=5N1zgwyTc8uApVpzmCmOdsRMvTqsD39e/7aqUih/w6g=;
	h=Date:To:From:Subject:Message-Id; b=Lvk166FuHCqYCJ3Sc7VFMvSRsRLw7ilw9jx8HhUvBe8uJ0Jv58h6t1Rx0vm/4Q788uucP3sNOLYXKRmMAmB7ZopM6Wjn+Cs/Aekfvi3J7Ve0NnneIZ9hnu4uQGedN5wZUyfLI1uXPgN8BXKTCZc8ygxk113CXHTM/Te/4nz/oTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o7u9o+L0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o7u9o+L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A6B1F00898;
	Fri, 29 May 2026 04:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027685;
	bh=nKLbUY2hgPX16ich5T5R26mhcqczU5Hn1pIinx1mvJI=;
	h=Date:To:From:Subject;
	b=o7u9o+L0xtZowJD/I1p+pJDXSRW6vnN2XFXa0eNUwxhCqeNE1fIWLgqsPNCxyo7fx
	 M7RlKqCNx+OOX7p70V+L/iD4yb4O4K2GGDIeIgO8M5vd8qECKBhlQYg/0qE66iKCuM
	 rYNhhA3Npq+CYIKIQDV0VOtclQ9GdbfEWNMb9vLw=
Date: Thu, 28 May 2026 21:08:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch removed from -mm tree
Message-Id: <20260529040805.81A6B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE in MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2808,6 +2808,7 @@ static int madvise_collapse_errno(enum s
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
 	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch
mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch
selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch

