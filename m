Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0D110A0E
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957015; cv=none; b=d51x/vU0fFZUr7Ha+ofwLA53VEpJXTZm6NOopOlALATCo7SGvotY3OIbiF1oQUmC8SKRcPxWTzJtx2c1LAjnAkDS5MDJBG1hge8PCeRpOzBzuzIhpfma1Qff9dU0JBocGk56ZVEcRVwE6lKzsvC5TW1XA+aeET3ZPdKN5SbzKgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957015; c=relaxed/simple;
	bh=tihDpQ2bGel0R+4gs/+cTsB2SU/H5i11DQZnu9cAhCM=;
	h=Date:To:From:Subject:Message-Id; b=q7S95cpFVXF1EowRxNeii8xC76idspEiD2odK/UMLnsY2pBv5oy7CQh49qglNPBslj7lK7fPzys8PlDyo5WP26DNdLQa8ZrGq/SjwkG3vZzb75QEY8sdkIYxUvfv33YvCyKpqLoqMOLIXww4lVPvms816UX4l/mW+Tz57tbNk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KuTWEl15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KuTWEl15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35D0C116B1;
	Mon,  6 May 2024 00:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957014;
	bh=tihDpQ2bGel0R+4gs/+cTsB2SU/H5i11DQZnu9cAhCM=;
	h=Date:To:From:Subject:From;
	b=KuTWEl15s00CaKuuZIxebvVevFHaHYu+Gln4o19emlahv/CR3sSQ+xX2FfRlx7BZZ
	 i5AZjTl3qBdhXofDuWKijom2ytgXazCQkRBYZIYGeRZAEG1SWTM6mDnshubNAzNfnt
	 gkHtZSk8iFQZJ6Ta5FFg/KOrKa39gOYAPqksW2Fo=
Date: Sun, 05 May 2024 17:56:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch removed from -mm tree
Message-Id: <20240506005654.C35D0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xtensa/mm: convert check_tlb_entry() to sanity check folios
has been removed from the -mm tree.  Its filename was
     xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: xtensa/mm: convert check_tlb_entry() to sanity check folios
Date: Tue, 9 Apr 2024 21:22:59 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  So let's convert check_tlb_entry() to perform
sanity checks on folios instead of pages.

This essentially already happened: page_count() is mapped to
folio_ref_count(), and page_mapped() to folio_mapped() internally. 
However, we would have printed the page_mapount(), which does not really
match what page_mapped() would have checked.

Let's simply print the folio mapcount to avoid using page_mapcount().  For
small folios there is no change.

Link: https://lkml.kernel.org/r/20240409192301.907377-17-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/tlb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/xtensa/mm/tlb.c~xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios
+++ a/arch/xtensa/mm/tlb.c
@@ -256,12 +256,13 @@ static int check_tlb_entry(unsigned w, u
 					dtlb ? 'D' : 'I', w, e, r0, r1, pte);
 			if (pte == 0 || !pte_present(__pte(pte))) {
 				struct page *p = pfn_to_page(r1 >> PAGE_SHIFT);
-				pr_err("page refcount: %d, mapcount: %d\n",
-						page_count(p),
-						page_mapcount(p));
-				if (!page_count(p))
+				struct folio *f = page_folio(p);
+
+				pr_err("folio refcount: %d, mapcount: %d\n",
+					folio_ref_count(f), folio_mapcount(f));
+				if (!folio_ref_count(f))
 					rc |= TLB_INSANE;
-				else if (page_mapcount(p))
+				else if (folio_mapped(f))
 					rc |= TLB_SUSPICIOUS;
 			} else {
 				rc |= TLB_INSANE;
_

Patches currently in -mm which might be from david@redhat.com are


