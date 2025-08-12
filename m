Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA901CF5C6
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959477; cv=none; b=f2j4ALTvC5ySmTzPLg//38mSsYDzPPJ8t+YZMRc2S4Z/aHojdiiXNEega/t0JwlnJAlmFsGzR3pDDXwPzYC3kYtInL02zH3MyklR3XQcqRGkDRGE8Ei+4shK0Lken46TuvyC0rgZJSEtcvkVOe1vuscMzDlL5ZT83H32Qkcp2GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959477; c=relaxed/simple;
	bh=afiOL0LDtYEDeK5t2XYZ08Fy2Sv0wenPGdL+hK/guvU=;
	h=Date:To:From:Subject:Message-Id; b=YT5uGiw8OW3FvLG/FG5iWtqbSD9mB5zdyikVKBXXaZrZ2bFbrLUayAjBjvhbmkMpoJIbz3sVnuS9MGCiZvDXP3cgpXN6gjWJ0DqrRs/eyXL+x31Swo4PlOLbl+kATfo43jokasIc0L05I3HurCOZ0/bOrAYRK0VRXMBNvLEHW7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cSvVRlIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cSvVRlIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28127C4CEED;
	Tue, 12 Aug 2025 00:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959477;
	bh=afiOL0LDtYEDeK5t2XYZ08Fy2Sv0wenPGdL+hK/guvU=;
	h=Date:To:From:Subject:From;
	b=cSvVRlIaJiZLXjTtKaB9URtwUlQiRQ7aRc9vN6Mfs9+gkpT++gtE1Jbze1f40xnju
	 6roO8e4Va3wZHmW8UdyZj1rDwjUcMyuSrhmz9qajARJ8I4UiQVGvYnVOUwseU7oT8J
	 iEsggHf5mc28kmg68/Qy5zqwRqiLump4Ha5IQvjE=
Date: Mon, 11 Aug 2025 17:44:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,npache@redhat.com,mhocko@suse.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hch@lst.de,djwong@kernel.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,axboe@kernel.dk,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch added to mm-new branch
Message-Id: <20250812004437.28127C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: block: use largest_zero_folio in __blkdev_issue_zero_pages()
has been added to the -mm mm-new branch.  Its filename is
     block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: block: use largest_zero_folio in __blkdev_issue_zero_pages()
Date: Mon, 11 Aug 2025 10:41:13 +0200

Use largest_zero_folio() in __blkdev_issue_zero_pages().  On systems with
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO enabled, we will end up sending larger
bvecs instead of multiple small ones.

Noticed a 4% increase in performance on a commercial NVMe SSD which does
not support OP_WRITE_ZEROES.  The device's MDTS was 128K.  The performance
gains might be bigger if the device supports bigger MDTS.

Link: https://lkml.kernel.org/r/20250811084113.647267-6-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-lib.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/block/blk-lib.c~block-use-largest_zero_folio-in-__blkdev_issue_zero_pages
+++ a/block/blk-lib.c
@@ -196,6 +196,8 @@ static void __blkdev_issue_zero_pages(st
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned int flags)
 {
+	struct folio *zero_folio = largest_zero_folio();
+
 	while (nr_sects) {
 		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
 		struct bio *bio;
@@ -208,15 +210,14 @@ static void __blkdev_issue_zero_pages(st
 			break;
 
 		do {
-			unsigned int len, added;
+			unsigned int len;
 
-			len = min_t(sector_t,
-				PAGE_SIZE, nr_sects << SECTOR_SHIFT);
-			added = bio_add_page(bio, ZERO_PAGE(0), len, 0);
-			if (added < len)
+			len = min_t(sector_t, folio_size(zero_folio),
+				    nr_sects << SECTOR_SHIFT);
+			if (!bio_add_folio(bio, zero_folio, len, 0))
 				break;
-			nr_sects -= added >> SECTOR_SHIFT;
-			sector += added >> SECTOR_SHIFT;
+			nr_sects -= len >> SECTOR_SHIFT;
+			sector += len >> SECTOR_SHIFT;
 		} while (nr_sects);
 
 		*biop = bio_chain_and_submit(*biop, bio);
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-rename-huge_zero_page-to-huge_zero_folio.patch
mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
mm-add-persistent-huge-zero-folio.patch
mm-add-largest_zero_folio-routine.patch
block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch

