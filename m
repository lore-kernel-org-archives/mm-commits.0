Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F42C321AE
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OeXfRhI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE91DC433C8;
	Fri,  5 Jan 2024 17:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704476718;
	bh=0YXQ6WmG2CQgr938ygvD0gkk5ZkAtithL3ekLc6MDCI=;
	h=Date:To:From:Subject:From;
	b=OeXfRhI10GrcVU8knYJwPU6zFy6t3qighbRCOd1TD5UjOwnQst662H78TPlyo02Cn
	 IHbYL2FMk071pZPsGOFjs9/EFDF/is4+xIz3HWVNB2MYciFw9prABlA0FTWzrG5MV9
	 AjyUBVfOLSYU2+npiq+WWz39vj72jG/i/xFp4iTA=
Date: Fri, 05 Jan 2024 09:45:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks.patch added to mm-nonmm-unstable branch
Message-Id: <20240105174517.DE91DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Fri, 5 Jan 2024 16:57:29 +0100
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

mm-rmap-silence-vm_warn_on_folio-in-__folio_rmap_sanity_checks.patch

