Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257933115BC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334304; cv=none; b=WbFJYqV61+hlCdQukFZQyRs/Ds+R2gx1M1DqLbD/31isSjm/psBRe2NL6DHKNDiw0k3qauzdwaPxELrss1tKZmET3PB28zvcQ4HtZSbQL9TQ7+p9Pnzk++02oW7i9mRPoB/b2AJvefpK4M3rRBLFNG4Na9lzHKjxLqBfpG4GrDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334304; c=relaxed/simple;
	bh=ARzyJepV7rE92kQZX2TCi2boKZqKrCWrM0uI5MZR0UU=;
	h=Date:To:From:Subject:Message-Id; b=hm6aiiQWmi66xzi7X0kEMahisdsEoRucqTFnkB1c9wUv7ml9NcAZQpEFKrKG26hhgKhNTlSU2E9eFzncjcMugXduq1rZlUS1a8hqkmQQiC5ZScHcOKenh8hV6s/3HJuosGa1xGul9BNzY5VGT6n+W8SG/Jq6SRD8hlp0b70iFUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VFr/Nmeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VFr/Nmeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7381F0089C;
	Wed,  7 Oct 2026 00:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334302;
	bh=RMOa4m2iQx/f1jRI7Pox5CrsgfQ5d33KCGhyl9Gx5H8=;
	h=Date:To:From:Subject;
	b=VFr/NmeoqF7g6LG0E/rXPcEkccoImxW8+bfoRFyhj6U2qPxwkPO460Uq0t8Gu86C9
	 RF7+4Qr48uWwEsYqaD+EV3atjOsew63+OrSz4ZK1wianNaKeQBkQGBW6lRlB2KQ/da
	 JR3CiS0V/amDsILXm7ydL3TSaJxQ2VRPWYCe+xQM=
Date: Tue, 06 Oct 2026 17:51:41 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_test-report-actual-pinned-bytes.patch removed from -mm tree
Message-Id: <20261007005141.EE7381F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup_test: report actual pinned bytes
has been removed from the -mm tree.  Its filename was
     mm-gup_test-report-actual-pinned-bytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: mm/gup_test: report actual pinned bytes
Date: Mon, 31 Aug 2026 15:43:04 +0530

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch.  If GUP pins more than
0 pages but less than the requested batch size, addr still advances by the
requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Link: https://lore.kernel.org/20260831101304.162867-1-sarthak.sharma@arm.com
Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
---

 mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_test-report-actual-pinned-bytes
+++ a/mm/gup_test.c
@@ -188,7 +188,7 @@ static int __gup_test_ioctl(unsigned int
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

mm-gup_test-safely-calculate-gup-batch-size.patch
selftests-mm-make-file-helpers-return-errors.patch
selftests-mm-make-file-helpers-return-errors-fix.patch
tools-lib-mm-add-shared-file-helpers.patch
tools-lib-mm-move-hugepage_settings-out-of-selftests.patch
tools-mm-move-gup_test-from-selftests-mm-to-tools-mm.patch
tools-mm-make-gup_bench-a-benchmark-only-tool.patch
selftests-mm-add-a-gup-selftest.patch

