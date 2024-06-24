Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827711A2573
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271533; cv=none; b=FgAY8UrGSpJA/HlCuhb5ujQGvQt1oXKMGHzI5o62OHuW8Yrnba5/dkYWMAh2u6n24ItXVFFJ3AMPnO1xAHzwNVJIBO9om4rhbQLOXXd5Q2k5BWHMnysffgPLx/P0zLH8/Y/8RhsqNHgQtXBY2tb4FK3JcJIhrHn1TOYmvA83Q7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271533; c=relaxed/simple;
	bh=vxkPVVc97iKqTbHcXsJ7l8zUS0k+7eJ6W/jvSg/6viQ=;
	h=Date:To:From:Subject:Message-Id; b=ZcTuahmJXqcLlGrOyeHlwGbTMa8XwJzyCY3Y8yCzoY1026EaBaR3gxpC7S5u8RjG1uNwXhNwzFlvFhhIAoNYrC9H4otnu5p/ExLGXOwS08WSSHkXo3SptzLB7u6ZVo7xA7O9rVRvTGvfJOOcQHEnCDeANgIu2Ea5cUWQwdVjctE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cu8erOhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cu8erOhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84A3C2BBFC;
	Mon, 24 Jun 2024 23:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719271532;
	bh=vxkPVVc97iKqTbHcXsJ7l8zUS0k+7eJ6W/jvSg/6viQ=;
	h=Date:To:From:Subject:From;
	b=Cu8erOhvGB0qlHwynFcWCDkcQW2x2pQRjwgMCF4Fcdl8iYlWVamqMrYwK5Y7ow9Pn
	 6a1r/AXTuD96adU/YoItJORnrRIhc30f/El/5P9kvwZwYXiR7PPK765zQBioAxg/fD
	 G34FYQQvTXjgwJSbMLLkP06XGcO2PRMpOd2o2eNY=
Date: Mon, 24 Jun 2024 16:25:31 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch added to mm-unstable branch
Message-Id: <20240624232531.E84A3C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
Date: Sat, 22 Jun 2024 15:14:53 +1200

Link: https://lkml.kernel.org/r/20240622032002.53033-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    1 +
 mm/swapfile.c |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/memory.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
+++ a/mm/memory.c
@@ -4346,6 +4346,7 @@ check_folio:
 		 * here, we have to be careful.
 		 */
 		VM_WARN_ON_ONCE(folio_test_large(folio));
+		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
--- a/mm/swapfile.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
+++ a/mm/swapfile.c
@@ -1923,6 +1923,7 @@ static int unuse_pte(struct vm_area_stru
 		 */
 		if (!folio_test_anon(folio)) {
 			VM_WARN_ON_ONCE(folio_test_large(folio));
+			VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 			folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
 		} else {
 			folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

