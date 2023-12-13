Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864FF1873;
	Wed, 13 Dec 2023 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LZFVxNJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F8AC433CB;
	Wed, 13 Dec 2023 01:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430456;
	bh=k8Yywz/8+M3CjJ83DO4dwQteDjX5I/IfJIiRKWxm0DY=;
	h=Date:To:From:Subject:From;
	b=LZFVxNJw7Cj+5dO47ndO5pceXoF+QuH7ld0bpWp+Nj4GKhOKBiuz+0STIzqQOulN2
	 0i/8+4ZP14DDrUotexjBml0LlWnC0+zUMSasOzr6tH3tZ8NWK/3XbtPQ1iX+PZbsNo
	 U0PfoP6r4TlUEWpg8/E/DiUgGzI+eFVKKQbCXNh8=
Date: Tue, 12 Dec 2023 17:20:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,suleiman@google.com,stable@vger.kernel.org,stevensd@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch removed from -mm tree
Message-Id: <20231213012056.50F8AC433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix race in shmem_undo_range w/THP
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/shmem: fix race in shmem_undo_range w/THP
Date: Tue, 18 Apr 2023 17:40:31 +0900

Split folios during the second loop of shmem_undo_range.  It's not
sufficient to only split folios when dealing with partial pages, since
it's possible for a THP to be faulted in after that point.  Calling
truncate_inode_folio in that situation can result in throwing away data
outside of the range being targeted.

[akpm@linux-foundation.org: tidy up comment layout]
Link: https://lkml.kernel.org/r/20230418084031.3439795-1-stevensd@google.com
Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Signed-off-by: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-race-in-shmem_undo_range-w-thp
+++ a/mm/shmem.c
@@ -1080,7 +1080,24 @@ whole_folios:
 				}
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
-				truncate_inode_folio(mapping, folio);
+
+				if (!folio_test_large(folio)) {
+					truncate_inode_folio(mapping, folio);
+				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+					/*
+					 * If we split a page, reset the loop so
+					 * that we pick up the new sub pages.
+					 * Otherwise the THP was entirely
+					 * dropped or the target range was
+					 * zeroed, so just continue the loop as
+					 * is.
+					 */
+					if (!folio_test_large(folio)) {
+						folio_unlock(folio);
+						index = start;
+						break;
+					}
+				}
 			}
 			folio_unlock(folio);
 		}
_

Patches currently in -mm which might be from stevensd@chromium.org are


