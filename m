Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C262F25
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408252; cv=none; b=JnSkUEIRVRFGC3nyCN6OChQ5xBPcpO/GlfZ1LIXOnxIqvXIy+J6acMREKKGfcEN56BdvohFAdrE2opRUQNrvIincggKINyv7IW1aArcdI4rdIMo2F27gcrz05vuOjyislllov3twPgVo1ERsz7FQlKv/tj/bIqtOuzLjM3MJXvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408252; c=relaxed/simple;
	bh=Oc16uIyTlRh9DuvaU74TPcPWI9C96Y4GR1xI3tNCuGM=;
	h=Date:To:From:Subject:Message-Id; b=qAx/HdgGUONuQlhPtkT9FEIKLvgUq2ZsHxkvqe8lWTZcCbDzuih7WRdWoz3khZ6H0BJo64A6xqH9QnRwasDTnCeaymSIzh91NEtGlH+fI6pv6sXNIuuZjdFc1XdD18gOp+QA/FoebvjC1pXaF0aDqN7ZypB78+tVmAxcUKUhlNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2QOjAQU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2QOjAQU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F586C113CD;
	Mon, 29 Apr 2024 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408251;
	bh=Oc16uIyTlRh9DuvaU74TPcPWI9C96Y4GR1xI3tNCuGM=;
	h=Date:To:From:Subject:From;
	b=2QOjAQU7/e9HMj/oQTB7ZPinHZlImoCaaufManOlixIRURkp6JUPXENehCowh0rNF
	 VfbXh+9nLprprEtdNzW/nTcFkuShZGxpC0kDCZd7WGz+WV7uqrmYywXT9Cyq+wqj2+
	 YIADpyYNRayJEFjpCe65dNkNbiuIfJV+OXlJZD/M=
Date: Mon, 29 Apr 2024 09:30:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,david@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch added to mm-unstable branch
Message-Id: <20240429163051.6F586C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: rename mm_slot for get_next_rmap_item
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

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
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: rename mm_slot for get_next_rmap_item
Date: Sun, 28 Apr 2024 18:06:18 +0800

To distinguish ksm_mm_slot and mm_slot for better code readability, rename
parameter "struct ksm_mm_slot *mm_slot", as "struct ksm_mm_slot
*ksm_slot".  No function change.

Link: https://lkml.kernel.org/r/20240428100619.3332036-4-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-mm_slot-for-get_next_rmap_item
+++ a/mm/ksm.c
@@ -2468,7 +2468,7 @@ static void cmp_and_merge_page(struct pa
 	}
 }
 
-static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
+static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *ksm_slot,
 					    struct ksm_rmap_item **rmap_list,
 					    unsigned long addr)
 {
@@ -2488,7 +2488,7 @@ static struct ksm_rmap_item *get_next_rm
 	rmap_item = alloc_rmap_item();
 	if (rmap_item) {
 		/* It has already been zeroed */
-		rmap_item->mm = mm_slot->slot.mm;
+		rmap_item->mm = ksm_slot->slot.mm;
 		rmap_item->mm->ksm_rmap_items++;
 		rmap_item->address = addr;
 		rmap_item->rmap_list = *rmap_list;
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch
mm-ksm-rename-mm_slot-members-to-ksm_slot-for-better-readability.patch
mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items.patch
mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch
mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

