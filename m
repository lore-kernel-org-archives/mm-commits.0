Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF6B153573;
	Mon, 16 Dec 2024 05:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734326685; cv=none; b=V58FxQxoOBqk+XeNdbQbFbo2wJOJTnutZF706fC/kzdRaXsxGNK6aGwAD1KhbF0hoGKnc/GpYbuo7Y6TBKPim2Uh6wUMnpoWn4o9v1vPhQsr3b/LN5zCr1W4NxMJZqNem0+n30JAciLgwQCJsKQsJhN/6ylLyx/26PS3+QWMcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734326685; c=relaxed/simple;
	bh=l+nQX0LAxClsLAYJMb1zdUz3IkrQHkhTD/k0PRrdl7w=;
	h=Date:To:From:Subject:Message-Id; b=pzuR16v8QrDdUgkAGWh/dEO2TKJ1i/th2IkFD2Kr3wVpyB7H/+FJRmXPv3Wwelhw0fk6a4Ldi9MkN4CVgDprJf/Ee9j7Cbhe/CI1PBvYzv4F8594uH+3JN1gm2Zx7ohakfH13z5SQZiaAsVWmnpjhaZXn1xOJmTbVoKFjpZ/zNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRfM6wTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRfM6wTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C92EC4CED0;
	Mon, 16 Dec 2024 05:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734326685;
	bh=l+nQX0LAxClsLAYJMb1zdUz3IkrQHkhTD/k0PRrdl7w=;
	h=Date:To:From:Subject:From;
	b=xRfM6wThcn9g3dpeMqYBgDej24/WK5uPwtfs7BUaQ+cuycXd/Ysf2leC23fkyU+IU
	 xPAoyEKHx3IdGu60ol815HOt/kU4Zfh1ldW0jAdDSfIuUyXX+GqaN7wziMe7YZO+do
	 qIk4606PI9n8cfJlYewJsvpkx7+0M3LUlqbnW2Vg=
Date: Sun, 15 Dec 2024 21:24:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,oliver.sang@intel.com,david@redhat.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-fix-large-folio-support-in-async-readahead.patch added to mm-hotfixes-unstable branch
Message-Id: <20241216052445.4C92EC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: fix large folio support in async readahead
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/readahead: fix large folio support in async readahead
Date: Fri, 6 Dec 2024 16:30:25 +0800

When testing large folio support with XFS on our servers, we observed that
only a few large folios are mapped when reading large files via mmap. 
After a thorough analysis, I identified it was caused by the
`/sys/block/*/queue/read_ahead_kb` setting.  On our test servers, this
parameter is set to 128KB.  After I tune it to 2MB, the large folio can
work as expected.  However, I believe the large folio behavior should not
be dependent on the value of read_ahead_kb.  It would be more robust if
the kernel can automatically adopt to it.

With /sys/block/*/queue/read_ahead_kb set to 128KB and performing a
sequential read on a 1GB file using MADV_HUGEPAGE, the differences in
/proc/meminfo are as follows:

- before this patch
  FileHugePages:     18432 kB
  FilePmdMapped:      4096 kB

- after this patch
  FileHugePages:   1067008 kB
  FilePmdMapped:   1048576 kB

This shows that after applying the patch, the entire 1GB file is mapped to
huge pages.  The stable list is CCed, as without this patch, large folios
don't function optimally in the readahead path.

It's worth noting that if read_ahead_kb is set to a larger value that
isn't aligned with huge page sizes (e.g., 4MB + 128KB), it may still fail
to map to hugepages.

Link: https://lkml.kernel.org/r/20241108141710.9721-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20241206083025.3478-1-laoar.shao@gmail.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Tested-by: kernel test robot <oliver.sang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/readahead.c~mm-readahead-fix-large-folio-support-in-async-readahead
+++ a/mm/readahead.c
@@ -646,7 +646,11 @@ void page_cache_async_ra(struct readahea
 			1UL << order);
 	if (index == expected) {
 		ra->start += ra->size;
-		ra->size = get_next_ra_size(ra, max_pages);
+		/*
+		 * In the case of MADV_HUGEPAGE, the actual size might exceed
+		 * the readahead window.
+		 */
+		ra->size = max(ra->size, get_next_ra_size(ra, max_pages));
 		ra->async_size = ra->size;
 		goto readit;
 	}
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead.patch

