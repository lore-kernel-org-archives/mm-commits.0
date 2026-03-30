Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCA52ECD1D;
	Mon, 30 Mar 2026 22:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909234; cv=none; b=AGZjZwv50SS8JTZ7S+J/M0RcMwivrT2QVV3a594pZDrpklmvHv5pGf/VfxlT20uu0OmW+WqwH8kXw5QL0/tvm3aEFSASrgq4oKOo4k1GjQfyqGIPrkHG8wsyQWLGgRxjYgVJRmNY67QoI7oSKQlbT/lX4TxINTeMD6ALvz0bh+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909234; c=relaxed/simple;
	bh=k+NdETrGiDBGa0a7NxxeZZXU28MZohtqDIOG7XgqfqM=;
	h=Date:To:From:Subject:Message-Id; b=Worg8+oPsUTC7r8JYiCmam+cDmryX/PtUoCnIx6qq7+Q49WlIBJFPOKKK33LiyhLeK4DGxRzrVYkZL/PIlFDLPjYPJZnwHnvNne7WY8huPJpcT4Mx3JBPhiSOtu0/cMjmJXJiCxSM+6YBj25dP+ytKxmGxpkKgNK1ZJcidmFdtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gBUQOcAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gBUQOcAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766DEC2BCB4;
	Mon, 30 Mar 2026 22:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774909233;
	bh=k+NdETrGiDBGa0a7NxxeZZXU28MZohtqDIOG7XgqfqM=;
	h=Date:To:From:Subject:From;
	b=gBUQOcAdjwGDRrwb0Thzyc5p7CUamxKJi1ViN8pH0N9Q6c4vYx0siWHRgbhBRlfiS
	 08ggu1aVdZ6tX6toMERyPKq+gNZcYqyYwpI+X0uCKZ5yTq/zs895BahYZTwaEdG6Ga
	 xbwI4K39U5XL1n6ba+VzTjKgkzQa0T+le0xqCcmU=
Date: Mon, 30 Mar 2026 15:20:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch added to mm-unstable branch
Message-Id: <20260330222033.766DEC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

This patch will later appear in the mm-unstable branch at
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
From: David Carlier <devnexen@gmail.com>
Subject: mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
Date: Mon, 23 Mar 2026 23:13:15 +0000

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base pages.
For large folios this undercounts compared to the per-memcg path which
correctly uses folio_nr_pages(), and compared to the bdev read paths which
also use folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Link: https://lkml.kernel.org/r/20260323231315.240137-1-devnexen@gmail.com
Fixes: a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete
+++ a/mm/page_io.c
@@ -497,7 +497,7 @@ static void sio_read_complete(struct kio
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
-		count_vm_events(PSWPIN, sio->pages);
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

