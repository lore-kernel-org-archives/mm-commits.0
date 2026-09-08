Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431455908C2
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890137; cv=none; b=bf2QSBjA1bHGPmPasP5GyMpPCTANehLSgd4Nf+jHmnMmXsEKOd5phabeUx/mX9m8pQPXyidKBjVNb2mnUV6DbvXo3HyfYmYrVSoZKQw7hpZ5o+m5CPcTMSXZlqXgiPedjP8sn66cwTOS6MS1ZW5frHkfxpuGr0C7u1vvgk0Ojbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890137; c=relaxed/simple;
	bh=ZqEtS2llyTTm7quIIH6LW+Fy/tgE4oURZcxyG2neCyw=;
	h=Date:To:From:Subject:Message-Id; b=kiCYj38lC1Q85M2vVwRFDAqIaPiTToU9auV5x0EtUfFj5VsoHs3kv6YZzn3RTDbpvJV+U7suTRpMleI0aummmVbbH7M/7p6adGnEv7fff6vwj2njEOq+waSpvo8pDxLRJH65QNsI648ir2WMAY35YLOyPrawkRSXMbHSzdG2vN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NB0muVwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NB0muVwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F661F00A3A;
	Tue,  8 Sep 2026 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788890135;
	bh=c7In9iGrlBMilQSbSGBjYus4fGeE1pIg6JR9wpauX5I=;
	h=Date:To:From:Subject;
	b=NB0muVweg2S5mubGvJ2Ddjv+jOMVqu84IRts/43jOSzjqvQtR0fzsTNDhJ/YlWUZT
	 o2t0EkrVocaxbb/CrlC/5AP9ymeLHAhUiwrdPYXcGvPHqEXBOYx5MqLO26c/IEGDyJ
	 /FghhY1iahWS+MeZYPTQy06S9XKK3TZ6uR5YuaPM=
Date: Tue, 08 Sep 2026 10:55:34 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch added to mm-new branch
Message-Id: <20260908175534.D7F661F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mte: make mte_save_tags() and mte_restore_tags() static
has been added to the -mm mm-new branch.  Its filename is
     arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: arm64: mte: make mte_save_tags() and mte_restore_tags() static
Date: Tue, 08 Sep 2026 11:16:36 -0400

mte_save_tags() and mte_restore_tags() are only used by
arch_prepare_to_swap() and arch_swap_restore() in mteswap.c.  Make them
static and remove their declarations from mte.h.

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-6-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte.h |    2 --
 arch/arm64/mm/mteswap.c      |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/mte.h~arm64-mte-make-mte_save_tags-and-mte_restore_tags-static
+++ a/arch/arm64/include/asm/mte.h
@@ -23,9 +23,7 @@ unsigned long mte_copy_tags_from_user(vo
 				      unsigned long n);
 unsigned long mte_copy_tags_to_user(void __user *to, void *from,
 				    unsigned long n);
-int mte_save_tags(struct page *page);
 void mte_save_page_tags(const void *page_addr, void *tag_storage);
-void mte_restore_tags(swp_entry_t entry, struct page *page);
 void mte_restore_page_tags(void *page_addr, const void *tag_storage);
 void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
--- a/arch/arm64/mm/mteswap.c~arm64-mte-make-mte_save_tags-and-mte_restore_tags-static
+++ a/arch/arm64/mm/mteswap.c
@@ -20,7 +20,7 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-int mte_save_tags(struct page *page)
+static int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
@@ -47,7 +47,7 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-void mte_restore_tags(swp_entry_t entry, struct page *page)
+static void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch

