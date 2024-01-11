Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23155786E
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVowIe5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C59C433F1;
	Thu, 11 Jan 2024 20:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005158;
	bh=J6gHEeY8T7y99EFlExqdMsvihaTRkKYusyuEM9dSGY8=;
	h=Date:To:From:Subject:From;
	b=UVowIe5I2drpTgZ6t2D5QDJ4jtQBfcCrL3OsmVlmdYVg/yZTgV8e6BRD47hjxA7ec
	 p0atWgkO0sNP2qPUsbVz0fYjmQlV7qZHDobyf5NphRntgbpMqoUYVjI0jcuzaHbyTV
	 LWhWN73uD7D33hS7VUoMOd6o+DxdeXMN/pIVXWI4=
Date: Thu, 11 Jan 2024 12:32:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch added to mm-unstable branch
Message-Id: <20240111203238.27C59C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use pfn_swap_entry_folio() in __split_huge_pmd_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use pfn_swap_entry_folio() in __split_huge_pmd_locked()
Date: Thu, 11 Jan 2024 15:24:24 +0000

Call pfn_swap_entry_folio() in __split_huge_pmd_locked() as preparation
for converting mm counter functions to take a folio.

Link: https://lkml.kernel.org/r/20240111152429.3374566-6-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2432,7 +2432,7 @@ static void __split_huge_pmd_locked(stru
 			swp_entry_t entry;
 
 			entry = pmd_to_swp_entry(old_pmd);
-			page = pfn_swap_entry_to_page(entry);
+			folio = pfn_swap_entry_folio(entry);
 		} else {
 			page = pmd_page(old_pmd);
 			folio = page_folio(page);
@@ -2443,7 +2443,7 @@ static void __split_huge_pmd_locked(stru
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
 		}
-		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
+		add_mm_counter(mm, mm_counter_file(&folio->page), -HPAGE_PMD_NR);
 		return;
 	}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch

