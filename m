Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6B711CAF;
	Fri, 22 May 2026 00:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779410649; cv=none; b=sQynqwD/7JNUXlk6g73dAp23g8QKe+mFiNlMmKV18m1uB+Ur1C9rgeQ2XF/jUWyn8wvEuNm3cmzuxVw5mFSiMP0OZGO+hZUz0b94rf9b922bJ34cJKY4yojk5MePGm4Qeohodq8YP/8DfQ2Fg7N4ycgo5wX5xX99+GVkDmR28sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779410649; c=relaxed/simple;
	bh=19YLvgtlMzU8ANelrSCykr6qqnrBqL0oi8/RpSbL01s=;
	h=Date:To:From:Subject:Message-Id; b=EzNnhJZMeBWY5ylAH8DYS4Dwtzu98QANHzbagJ7g5e+Svv4R7GFuJgIn6BPFvSidBHdAXafF5/Lriyp+p012K5r0n7ya0EU6oRhz00XAg6tPcXircZFEi6Da1lU1o3/lfN5Q32INRb8UZ+0PrWA6cFEJZyk7Gojphb2do5Kavvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lzOIcNAr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lzOIcNAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03401F000E9;
	Fri, 22 May 2026 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410647;
	bh=2JBhH1Zuv1KpnjGr18PzaaMKL6STg2UjLyqqaX6vLoE=;
	h=Date:To:From:Subject;
	b=lzOIcNAr83h1fzrFKhE/BCuWDSKkIPRs7bMTtLkheMA0cTywd7WzgjYDfF5i/TF+n
	 OyoLqcdiLjZcWAYPFNGTNJJV5N0FwLVKNlsqU4KkC3IlCVOEEDPYFPU3UvVb7z6wh7
	 A+u/b5YKu5EXKaCHPy3M3XnclThjXmECQfHOZa9M=
Date: Thu, 21 May 2026 17:44:07 -0700
To: mm-commits@vger.kernel.org,yuehaibing@huawei.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,almasrymina@google.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch added to mm-hotfixes-unstable branch
Message-Id: <20260522004407.C03401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: restore reservation on error in hugetlb folio copy paths
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/hugetlb: restore reservation on error in hugetlb folio copy paths
Date: Wed, 20 May 2026 05:49:12 +0100

Two sites in mm/hugetlb.c allocate a hugetlb folio via
alloc_hugetlb_folio() (consuming a VMA reservation) and then call
copy_user_large_folio(), which became int-returning in commit 1cb9dc4b475c
("mm: hwpoison: support recovery from HugePage copy-on-write faults") and
can now fail (e.g.  -EHWPOISON on a hwpoisoned source page).  On the
failure path, folio_put() restores the global hugetlb pool count through
free_huge_folio(), but the per-VMA reservation map entry is left marked
consumed:

  - hugetlb_mfill_atomic_pte() resubmission path (UFFDIO_COPY)
  - copy_hugetlb_page_range() fork-time CoW path when
    hugetlb_try_dup_anon_rmap() fails (rare: pinned hugetlb anon
    folio under fork)

User-visible effect: on UFFDIO_COPY into a private hugetlb VMA where the
resubmission copy fails, the reservation for that address is leaked from
the VMA's reserve map.  A subsequent fault at the same address takes the
no-reservation path, and under hugetlb pool pressure the task is SIGBUSed
at an address it had previously reserved.  The fork-time CoW path leaks
the same way in the child VMA's reserve map, though it requires the much
rarer combination of pinned hugetlb anon page + hwpoisoned source.

Add the missing restore_reserve_on_error() call before folio_put() on both
error paths.

Link: https://lore.kernel.org/20260520044912.6751-1-devnexen@gmail.com
Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: yuehaibing <yuehaibing@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths
+++ a/mm/hugetlb.c
@@ -4977,6 +4977,7 @@ again:
 							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
+					restore_reserve_on_error(h, dst_vma, addr, new_folio);
 					folio_put(new_folio);
 					break;
 				}
@@ -6273,6 +6274,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch
mm-page_io-rename-swap_iocb-fields-for-clarity.patch
mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

