Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B98371877
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499103; cv=none; b=CtlJWrzMNkx6HmyxqhwUSOBNCmLl/cq5W7fftXKjwneahNW4oz/PhMaYKJ2SjZ0OgdTPrh5IX/+7kiVNKFSoTVs9ydvwSvYDjoGei7Vl79PFgZUjgcZRAdG2Gopz1CWOC2k7vvXfERDZFj3YBu+Fdvksk7+8uW3q+t/LSLwzGy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499103; c=relaxed/simple;
	bh=KKXjLmuzSOHCx7SpXqB6a33AsozgdSwgvHHIPHBxyIo=;
	h=Date:To:From:Subject:Message-Id; b=PZVRVZqAVmD5veVc5D611u2oFOtXsdBObw4CSRweFbEr5y/8uW5BFqmfL931DQl1SquT0ED35RAt9siFBRAs4orKuY8t7dsD+yMv529UVBwnM5Y/09WSJOjAPUdC+kAT9i84GYTb2kYrKUeZ/aVoC7i9tWVNnvTWkQHLfgY6Y4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dkNg1j45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dkNg1j45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70439C19424;
	Sat, 18 Apr 2026 07:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499102;
	bh=KKXjLmuzSOHCx7SpXqB6a33AsozgdSwgvHHIPHBxyIo=;
	h=Date:To:From:Subject:From;
	b=dkNg1j45wDHAEYJ/9PWUjXY/RQHkx+ycJUoYZI9asui6kuyh1FtB7DYI8xhTeqUdk
	 tEbge34kToeO1pJFqDFux/v7Kn6ije/37wxqXF6IdqRBnhvceXJgQtwHytApDhpZ/t
	 Q+lmK2ceTXbfn01GbxQl5SVoFz0WUY0+o8EY/mgc=
Date: Sat, 18 Apr 2026 00:58:17 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,neil@brown.name,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch removed from -mm tree
Message-Id: <20260418075821.70439C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
has been removed from the -mm tree.  Its filename was
     mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
Date: Thu, 2 Apr 2026 07:14:07 +0100

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base pages.

While large folios cannot currently reach this path (SWP_FS_OPS and
SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation is
gated on SWP_SYNCHRONOUS_IO), the accounting is semantically inconsistent
with the per-memcg path which correctly uses folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Link: https://lore.kernel.org/20260402061408.36119-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: NeilBrown <neil@brown.name>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete
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

