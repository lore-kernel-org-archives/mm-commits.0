Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642F53589C
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ugFwoq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3EEC433CC;
	Fri,  5 Jan 2024 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478711;
	bh=Dr/4+fXhvAS2eSZY/41BnzoE33+yaKMRKPTqsewCeow=;
	h=Date:To:From:Subject:From;
	b=2ugFwoq/RsIWPcsL+WoJNbcEJXYNAuCF2lcWYJ+ow0UjDek1ywAXpcHSnC3/wbJJn
	 q0/gajUwmT48fgMVnsFPBacVEFUbpoiAS6ECwHRcWJWoJ1gu7v302UigE4dFa0tGiy
	 QCVOCeI47i0B13xUAkcar58wFmu4NY43UxruwMJI=
Date: Fri, 05 Jan 2024 10:18:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks.patch removed from -mm tree
Message-Id: <20240105181831.CA3EEC433CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Date: Fri, 5 Jan 2024 16:57:29 +0100
has been removed from the -mm tree.  Its filename was
     mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Date: Fri, 5 Jan 2024 16:57:29 +0100
Subject: mm/rmap: silence VM_WARN_ON_FOLIO() in __folio_rmap_sanity_checks()

Unfortunately, vm_insert_page() and friends and up passing
driver-allocated folios into folio_add_file_rmap_pte() using
insert_page_into_pte_locked().

While these driver-allocated folios can be compound pages (large folios),
they are not proper "rmappable" folios.

In these VM_MIXEDMAP VMAs, there isn't really the concept of a reverse
mapping, so long-term, we should clean that up and not call into rmap
code.

For the time being, document how we can end up in rmap code with large
folios that are not marked rmappable.

Link: https://lkml.kernel.org/r/793c5cee-d5fc-4eb1-86a2-39e05686233d@redhat.com
Fixes: 68f0320824fa ("mm/rmap: convert folio_add_file_rmap_range() into folio_add_file_rmap_[pte|ptes|pmd]()")
Reported-by: syzbot+50ef73537bbc393a25bb@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000014174060e09316e@google.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks
+++ a/include/linux/rmap.h
@@ -199,8 +199,15 @@ static inline void __folio_rmap_sanity_c
 {
 	/* hugetlb folios are handled separately. */
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
-	VM_WARN_ON_FOLIO(folio_test_large(folio) &&
-			 !folio_test_large_rmappable(folio), folio);
+
+	/*
+	 * TODO: we get driver-allocated folios that have nothing to do with
+	 * the rmap using vm_insert_page(); therefore, we cannot assume that
+	 * folio_test_large_rmappable() holds for large folios. We should
+	 * handle any desired mapcount+stats accounting for these folios in
+	 * VM_MIXEDMAP VMAs separately, and then sanity-check here that
+	 * we really only get rmappable folios.
+	 */
 
 	VM_WARN_ON_ONCE(nr_pages <= 0);
 	VM_WARN_ON_FOLIO(page_folio(page) != folio, folio);
_

Patches currently in -mm which might be from david@redhat.com are


