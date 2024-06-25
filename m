Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3351448DF
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291675; cv=none; b=cInx00ZqozmCQLwBDme5ELISzmzwZTGBRYUZbAXCmG2ED0U+HZ4LWoAitArN0mOS/4oPnCmJxJRMkJLGw1blwNmvLwml4ZZWiwVqfGovahw2Vg2iuRgksDkKnZWlMBEFbuEHKG9WoIVB74PEUhKfS5L2acJV3JHmfK0N4ir0MEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291675; c=relaxed/simple;
	bh=IVLnF52ze4UAwB7suN3oU8t/mIa29eq106POGwr2t+Y=;
	h=Date:To:From:Subject:Message-Id; b=b+/dwSmFK+M9OZjWRMR6PWvWOkqta8EhsTllyTC2NIpwT/8Ai/h9qiMQnGRZrDr53TYDQDnSGua996bSutiCAQLxrT3Oj358HhEZm7P5Ucx0RYvpTeU9Y4vvudlsBFzr2/lHHTJUlfy2mBMtWbu0WfJhC4S5ZpqCE+w9fNPZ4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5Ga5WeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5Ga5WeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7339DC32789;
	Tue, 25 Jun 2024 05:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291675;
	bh=IVLnF52ze4UAwB7suN3oU8t/mIa29eq106POGwr2t+Y=;
	h=Date:To:From:Subject:From;
	b=R5Ga5WeB7ocQZChlfwzSePPLzZtnJWYqxSNS91fAPwpror9pkhSUwSGUfXQHe6MsR
	 htEJB7h20XPwQf6Vpf6ocvYVMMrpgYdMsyI1r8S7Zzg7EB9Wt7NvJiVSoX9D6YYka3
	 IvhYH/A9WBYBCOM+NhFwCO/i71FlClqHviOtbSZg=
Date: Mon, 24 Jun 2024 22:01:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,minchan@kernel.org,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch removed from -mm tree
Message-Id: <20240625050115.7339DC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: set pte writable while pte_soft_dirty() is true in do_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: set pte writable while pte_soft_dirty() is true in do_swap_page()
Date: Sat, 8 Jun 2024 09:13:58 +1200

This patch leverages the new pte_needs_soft_dirty_wp() helper to optimize
a scenario where softdirty is enabled, but the softdirty flag has already
been set in do_swap_page().  In this situation, we can use pte_mkwrite
instead of applying write-protection since we don't depend on write
faults.

Link: https://lkml.kernel.org/r/20240607211358.4660-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page
+++ a/mm/memory.c
@@ -4324,7 +4324,7 @@ check_folio:
 	if (!folio_test_ksm(folio) &&
 	    (exclusive || folio_ref_count(folio) == 1)) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
-		    !vma_soft_dirty_enabled(vma)) {
+		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
 			if (vmf->flags & FAULT_FLAG_WRITE) {
 				pte = pte_mkdirty(pte);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

