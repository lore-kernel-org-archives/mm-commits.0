Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3F194082
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 21:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727730404; cv=none; b=tiPWpvLHUC65OncAvnyz5ui4l6+Kc+ou0Cy3WBNKtz5r40E2sCb/3Qj3rGU2cxcRj8y0od+6Y951QOMd9s/myGh/7uoYj0SirNb0YL7HcyGmn0bilx4OpHmrfJdW4xGOyPWhwlEhBcQzI2D7214aplBe6d4i4yHAO3lI/mW1f48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727730404; c=relaxed/simple;
	bh=ryo4JUXWi4cEN4c1qknPFxiukLmGEJIAZAushNHzq7Q=;
	h=Date:To:From:Subject:Message-Id; b=L+4+FgYh0KM3MiijfNrrbFOVQ2blh2ONgtdUDzay1BWQGZxi9W2mMCTgUftN1cCq7zL7E+skbpp1UKAhO3TLKNqZXKuNbFmdxqcm6EltRV4vtfxc7CAE17bazwLeF9RrYsrMKpgrEpdPRTIb8FUaSBPA8n3I8UzTxHPfwe3PmRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ryyNZ4sP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ryyNZ4sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDCBC4CEC7;
	Mon, 30 Sep 2024 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727730403;
	bh=ryo4JUXWi4cEN4c1qknPFxiukLmGEJIAZAushNHzq7Q=;
	h=Date:To:From:Subject:From;
	b=ryyNZ4sPeHZUoN7C966HuzPpiTmUk9I7hNkDj+S7I6Q9lvho/j94atpWy+oNw05fi
	 zzKOIm/KBZ+qelyWSzlwHj4juhc8HFI+ZkqbP4XF4IyT+OdwRP+L81a0w5G5id9Gws
	 ijD2VakSEZUBJ3lGObAJRnlZ8vjfLE1VE/7mZvIA=
Date: Mon, 30 Sep 2024 14:06:42 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-check-pmd_special-only-after-pmd_present.patch added to mm-hotfixes-unstable branch
Message-Id: <20240930210643.8FDCBC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: check pmd_special() only after pmd_present()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-check-pmd_special-only-after-pmd_present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-check-pmd_special-only-after-pmd_present.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/huge_memory: check pmd_special() only after pmd_present()
Date: Thu, 26 Sep 2024 17:42:34 +0200

We should only check for pmd_special() after we made sure that we have a
present PMD.  For example, if we have a migration PMD, pmd_special() might
indicate that we have a special PMD although we really don't.

This fixes confusing migration entries as PFN mappings, and not doing what
we are supposed to do in the "is_swap_pmd()" case further down in the
function -- including messing up COW, page table handling and accounting.

Link: https://lkml.kernel.org/r/20240926154234.2247217-1-david@redhat.com
Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+bf2c35fa302ebe3c7471@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/66f15c8d.050a0220.c23dd.000f.GAE@google.com/
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-check-pmd_special-only-after-pmd_present
+++ a/mm/huge_memory.c
@@ -1586,7 +1586,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	int ret = -ENOMEM;
 
 	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_special(pmd))) {
+	if (unlikely(pmd_present(pmd) && pmd_special(pmd))) {
 		dst_ptl = pmd_lock(dst_mm, dst_pmd);
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-check-pmd_special-only-after-pmd_present.patch
selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

