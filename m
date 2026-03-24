Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8843388E42
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364661; cv=none; b=sm9YM/UN8yV2QhhJ54bStuyUYIxC1kc1ROzFAzil5ywUmlXLJ1CBVvoVWgnZtLFrcVsqH+p2Ez/uZKA1+EFi9AVrhM7d55Td/Eb5vYnUPvyvX0yktSDPfVxEesuXSE8cZWo4usDmWxWtdCwe36duEe2FjpxtNJ8m+jtk2dCSMc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364661; c=relaxed/simple;
	bh=NCNgB1sI4m8v5YyVwX5W80trjf4tziCXl97F5f638E4=;
	h=Date:To:From:Subject:Message-Id; b=n0MofAlHZOMvqYQdk9eWUrWzhxxBwACW+sxONaW8XJygafHXKYvT+EOOdb2Kh7fqridvcBYZx5AZMNApq+BvwnwWMXgeLMXUBCiTXg+s9naD09Dx0Go1UJZZVbdxwepr367Ia64gSLP2jUhyzhzOSJuYJuvWwQWE6bcZtBzAr8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JvDoWsp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JvDoWsp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6E1C19424;
	Tue, 24 Mar 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774364661;
	bh=NCNgB1sI4m8v5YyVwX5W80trjf4tziCXl97F5f638E4=;
	h=Date:To:From:Subject:From;
	b=JvDoWsp+9JZ47cPFcpFmaYn/P9tHt0qWymuh2HODbVwWma0wkKoP3yVcsIEWIfO3w
	 dxovBKSZgtBABRVbYoeYluWsNI9U3TL9kulW7jJSVKeCAu2zzYQwYlCC2HIEBoQ2QC
	 0Y8bJVKvnztnlviKRotQeTXM37S78d5YG1IftrXg=
Date: Tue, 24 Mar 2026 08:04:21 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch added to mm-new branch
Message-Id: <20260324150421.9F6E1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

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
Fixes: 6a8c068774ad ("mm/page_io: use a folio in sio_read_complete()")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
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
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch
mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

