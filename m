Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06308367B98;
	Fri, 29 May 2026 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026670; cv=none; b=m4hMBLU5T17p4HPvns51LUdyfNkavzeeOt7oq9KHByhnGHkI17vDOyoqmy5kUGt5HM4tDAZAPUOjTk5xFnq0RiqVbWbGgZW15g/x6ftcnfeOnUyrDzjNUuoUcDzDuCFLnP4Y3mp2QpagrkzOyU2lXdqFsueWD5LPRnEtEEgqSI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026670; c=relaxed/simple;
	bh=6obA5AvI870lObVtys1NH172KzL4InSVVN8XceU5G4A=;
	h=Date:To:From:Subject:Message-Id; b=qnl+6BUfCxXY16T6Ly5xbX2Zht/nKKsIbGVoe/l9M93GWy5Cup2futhRp60QnLNKC5BTD7rudjcFNsQPfD9krHMVVK900EozCXsDMGhbao6zfvRyCOGxj6q9aTjn/QcqD9u/MAnVvQKT0mDTlK++AG2FEvyd+xA8H9wIVrE7y1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WhV626V9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WhV626V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956CB1F000E9;
	Fri, 29 May 2026 03:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026668;
	bh=Mh9ywv87efi6Kt7xmCQtESrFiq2NQthv4Q0GN8+nPFU=;
	h=Date:To:From:Subject;
	b=WhV626V9VyaXt4Q76LVjqFPX/3Dj8jc84XKPCe33znU5dGaTKVQs9R38uBvG8ZfLn
	 lKdPwynixWSFbEZd30b3RK7WvySd8ukJA84T2g3VAJAUV7wMeXBsSzbU8OOD7ETg31
	 RQBY37mEOapJ7I2ZXSC/918XsTPG1YpFNwgPllK4=
Date: Thu, 28 May 2026 20:51:08 -0700
To: mm-commits@vger.kernel.org,yuehaibing@huawei.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,almasrymina@google.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch removed from -mm tree
Message-Id: <20260529035108.956CB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: restore reservation on error in hugetlb folio copy paths
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-restore-reservation-on-error-in-hugetlb-folio-copy-paths.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_io-rename-swap_iocb-fields-for-clarity.patch
mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

