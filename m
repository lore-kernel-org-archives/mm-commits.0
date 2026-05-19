Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03729343889;
	Tue, 19 May 2026 23:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233932; cv=none; b=V/XUspxGS8eX/G5OVrkdTjephPLz3l3JGryacu0vcA8sFQ3GHlumVBz+ZUZPmP7bEtmETdR1g6ntfZ/w6gWQ2SU4uDhE1zQ9Ja4etXMJDkjNeBKE85dOUo6gPLQvHxwZpn0dHWihhTXXrjPUuGpE9E4tPvul+WIiOh6SRCVX7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233932; c=relaxed/simple;
	bh=LpO4AGfvCs3ZVd7ZTSVCy35NcGWgtaHYMqiKe6Mig8E=;
	h=Date:To:From:Subject:Message-Id; b=JiHinjm9wZHhQ9kY0FqmUCn8MdG1/N+iFOVeN80j94xuLb+uIsGo+GpM4uybhivZ8td17GZb0vDkX8n8nAQb0w7k2RyPVKcj1+DXhZoVjEb53Vt3NwLw3VIz/sP+dhEzjDrok8fM6IplPFlf9nkzpvvLKow5UQ9La6h0gvsSnp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eWSP2X0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eWSP2X0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAD91F000E9;
	Tue, 19 May 2026 23:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779233930;
	bh=0Afm1h8tIz9UFkG1QCkdBsiFKvajENQnOjSl1hzdMJo=;
	h=Date:To:From:Subject;
	b=eWSP2X0mNdTiNWV0Fx/2F+e77BZnCegoHP36PeskSie6UiWwTNJiU29HG6t4Cr/uR
	 ZmRiqBpX+1dB3Ku5GyYwyy0o9eDIsPetFLoAbk1b7QLjiKO+TWeu1ygNVJtVoMmE6A
	 9BvonpUwokjETUnCYsG5WaABmXdSuEveaM2R5qNU=
Date: Tue, 19 May 2026 16:38:50 -0700
To: mm-commits@vger.kernel.org,yuehaibing@huawei.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,almasrymina@google.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20260519233850.8DAD91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch

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
Subject: mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
Date: Sun, 22 Mar 2026 05:21:20 +0000

When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. 
If copy_user_large_folio() subsequently fails (e.g.  -EHWPOISON when the
source page is hwpoisoned), folio_put() restores the global hugetlb pool
count through free_huge_folio(), but the per-VMA reservation map entry is
left marked consumed.

User-visible effect: on a UFFDIO_COPY into a private hugetlb VMA where the
resubmission path's copy fails, the reservation for that address is leaked
from the VMA's reserve map.  A subsequent fault at the same address takes
the no-reservation path, and under hugetlb pool pressure the task is
SIGBUSed at an address it had previously reserved.  One map entry is
leaked per occurrence.

Add the missing restore_reserve_on_error() call before folio_put(),
matching the first-attempt error path which already handles this
correctly.

Link: https://lore.kernel.org/20260519230503.121293-1-devnexen@gmail.com
Link: https://lore.kernel.org/20260322052120.14021-1-devnexen@gmail.com
Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: yuehaibing <yuehaibing@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path
+++ a/mm/hugetlb.c
@@ -6270,6 +6270,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-rename-swap_iocb-fields-for-clarity.patch
mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

