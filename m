Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8C28371;
	Thu, 26 Sep 2024 21:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384649; cv=none; b=mFMZwMZIeXtrqpM3JsoINkmCdQJAtOv4gQFijFYDiO26J6Jssd4nBMJPrcjDLHOHblkmC3UNv8b2TEg3HvNoJLRy0x8CJ6aAWAULa4yMinLID1Sx0bpbg+yCoSwasAMFR3J9IYksIooV7MYSMc3TNO/j8XG8APaWMkoXLOpM9+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384649; c=relaxed/simple;
	bh=VvBdKj+W2U5/Yt/pOj/u0EVQCdwIdQoRAskCLA2c6hI=;
	h=Date:To:From:Subject:Message-Id; b=lFvnMWUhz2OuNGehbmA4S2ZFkXDwTx1KZRB81ZEfefz2C6FGF+iSYxx6lInYA+IF1tBGBjEHYcO78l0NHLix2zy7MJhWXPj46RM0TUQYQGSPp0/Pgx10nrdFzMb3FQu3CEU8Ls5jT/r/F3/RQ2P8L7fxK6BlnXob5rCNLqvfZ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNYjgQjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNYjgQjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA507C4CEC7;
	Thu, 26 Sep 2024 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384648;
	bh=VvBdKj+W2U5/Yt/pOj/u0EVQCdwIdQoRAskCLA2c6hI=;
	h=Date:To:From:Subject:From;
	b=LNYjgQjZnpfWjPjOSs/HWbBuSxDuBaAHz3voi1FFc+kbI01KgzpWyp07tzdNhA4/V
	 4XY7NX3louEvO8pXU80ubkkcx/LRTAVi+5R/4/HY5xV7OyOHARlm3AaJg11q0lvh+Y
	 HrGPAAsz5xgtIyOPO8cqt5nY1GSgwzk760iLcClc=
Date: Thu, 26 Sep 2024 14:04:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch removed from -mm tree
Message-Id: <20240926210408.CA507C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: fix filemap_get_folios_contig THP panic
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm/filemap: fix filemap_get_folios_contig THP panic
Date: Tue, 3 Sep 2024 07:25:17 -0700

Patch series "memfd-pin huge page fixes".

Fix multiple bugs that occur when using memfd_pin_folios with hugetlb
pages and THP.  The hugetlb bugs only bite when the page is not yet
faulted in when memfd_pin_folios is called.  The THP bug bites when the
starting offset passed to memfd_pin_folios is not huge page aligned.  See
the commit messages for details.


This patch (of 5):

memfd_pin_folios on memory backed by THP panics if the requested start
offset is not huge page aligned:

BUG: kernel NULL pointer dereference, address: 0000000000000036
RIP: 0010:filemap_get_folios_contig+0xdf/0x290
RSP: 0018:ffffc9002092fbe8 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000002 RCX: 0000000000000002

The fault occurs here, because xas_load returns a folio with value 2:

    filemap_get_folios_contig()
        for (folio = xas_load(&xas); folio && xas.xa_index <= end;
                        folio = xas_next(&xas)) {
                ...
                if (!folio_try_get(folio))   <-- BOOM

"2" is an xarray sibling entry.  We get it because memfd_pin_folios does
not round the indices passed to filemap_get_folios_contig to huge page
boundaries for THP, so we load from the middle of a huge page range see a
sibling.  (It does round for hugetlbfs, at the is_file_hugepages test).

To fix, if the folio is a sibling, then return the next index as the
starting point for the next call to filemap_get_folios_contig.

Link: https://lkml.kernel.org/r/1725373521-451395-1-git-send-email-steven.sistare@oracle.com
Link: https://lkml.kernel.org/r/1725373521-451395-2-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/filemap.c~mm-filemap-fix-filemap_get_folios_contig-thp-panic
+++ a/mm/filemap.c
@@ -2196,6 +2196,10 @@ unsigned filemap_get_folios_contig(struc
 		if (xa_is_value(folio))
 			goto update_start;
 
+		/* If we landed in the middle of a THP, continue at its end. */
+		if (xa_is_sibling(folio))
+			goto update_start;
+
 		if (!folio_try_get(folio))
 			goto retry;
 
_

Patches currently in -mm which might be from steven.sistare@oracle.com are


