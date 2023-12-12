Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8975680029
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PIQALACT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52707C433C7;
	Tue, 12 Dec 2023 18:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407583;
	bh=TkvakQcHbTqV5M2BFkEKEMF98Hd436hMXk0au5Zcvhw=;
	h=Date:To:From:Subject:From;
	b=PIQALACThVXvYFyUwIgsTQhFTUSdzagOi38lM8kTrWs00VcU/1Z7zU1h9jNvgob94
	 Z6Jkj/zXbWgoFHYuNNB85Ol5t3H50OppS7PR4KxNDDh70pkwstm3GIFNfQR7WOWkF6
	 USqugw/XlCZ3FnfwDhX/8E+eMgDUOMhWxBIbB6W0=
Date: Tue, 12 Dec 2023 10:59:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-do-not-allow-order-1-folio.patch removed from -mm tree
Message-Id: <20231212185943.52707C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: do not allow order-1 folio
has been removed from the -mm tree.  Its filename was
     mm-readahead-do-not-allow-order-1-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/readahead: do not allow order-1 folio
Date: Fri, 1 Dec 2023 16:10:45 +0000

The THP machinery does not support order-1 folios because it requires meta
data spanning the first 3 `struct page`s.  So order-2 is the smallest
large folio that we can safely create.

There was a theoretical bug whereby if ra->size was 2 or 3 pages (due to
the device-specific bdi->ra_pages being set that way), we could end up
with order = 1.  Fix this by unconditionally checking if the preferred
order is 1 and if so, set it to 0.  Previously this was done in a few
specific places, but with this refactoring it is done just once,
unconditionally, at the end of the calculation.

This is a theoretical bug found during review of the code; I have no
evidence to suggest this manifests in the real world (I expect all
device-specific ra_pages values are much bigger than 3).

Link: https://lkml.kernel.org/r/20231201161045.3962614-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/readahead.c~mm-readahead-do-not-allow-order-1-folio
+++ a/mm/readahead.c
@@ -511,16 +511,14 @@ void page_cache_ra_order(struct readahea
 		unsigned int order = new_order;
 
 		/* Align with smaller pages if needed */
-		if (index & ((1UL << order) - 1)) {
+		if (index & ((1UL << order) - 1))
 			order = __ffs(index);
-			if (order == 1)
-				order = 0;
-		}
 		/* Don't allocate pages past EOF */
-		while (index + (1UL << order) - 1 > limit) {
-			if (--order == 1)
-				order = 0;
-		}
+		while (index + (1UL << order) - 1 > limit)
+			order--;
+		/* THP machinery does not support order-1 */
+		if (order == 1)
+			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

