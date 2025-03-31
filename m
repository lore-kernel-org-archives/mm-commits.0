Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A85FDDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457089; cv=none; b=XeNIOp0L0ZKfh6S52L8ua+w1lPgj2EYfBSQBXlQ/PugL7KATfQqswgKDqXQiTJcCE0dbMobXNGeE3Ge2SV0B0bNGaIj+ZFppAKnpsTMclXprFxLpqdUk0QNlb+3J66FHKlS3CKURK2mKNYohlXpNqy+C0VJbualD+y5V6d0/yjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457089; c=relaxed/simple;
	bh=uUh20SzIu7gZ5s5b8X9safFjhmhkiPjUgIn1rfcDU4k=;
	h=Date:To:From:Subject:Message-Id; b=Su7UMr9w5gj7cEcF7IpultuNNd+JMZo7AO2MK3KVShlw81+ZpyxUvhmXxcvp8L1gt1fROT4e3Wc9IcpD3Ya+PermVZiWjU91mnWzlakB3UEaOy2oaQF69rcLgNFDQFXFR4Ho+0DajL8rld7dpXAK5FdfR4/xk9cCU0tP5a3fUoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZM7yO3or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZM7yO3or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACE6C4CEE3;
	Mon, 31 Mar 2025 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457088;
	bh=uUh20SzIu7gZ5s5b8X9safFjhmhkiPjUgIn1rfcDU4k=;
	h=Date:To:From:Subject:From;
	b=ZM7yO3orUZCUXPeccVBO8481F57/NA7aEuJINFAgYaGTbjgwy5EtO7rDFz484wDku
	 xg8O6utBGSNX7agjWe3KYUewxeiLzE17ATkJfK3RSsLCIb7jV1Duv7sgqVfBuFQ10m
	 /UdKQ0tlB4H0BEq6SZ25ur1fzb2iDVuvXyj58+qY=
Date: Mon, 31 Mar 2025 14:38:08 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch added to mm-new branch
Message-Id: <20250331213808.DACE6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: check if both GUP_GET and GUP_PIN are set in __get_user_pages() earlier
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: check if both GUP_GET and GUP_PIN are set in __get_user_pages() earlier
Date: Mon, 31 Mar 2025 16:13:22 +0800

In __get_user_pages(), it will traverse page table and take a reference to
the page the given user address corresponds to if GUP_GET or GUP_PIN is
et.  However, it's not supported both GUP_GET and GUP_PIN are set.  This
check should be done earlier, but not doing it till entering into
follow_page_pte() and failed.

Here move the checking to the beginning of __get_user_pages().

Link: https://lkml.kernel.org/r/20250331081327.256412-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: <x86@kernel.org>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier
+++ a/mm/gup.c
@@ -844,11 +844,6 @@ static struct page *follow_page_pte(stru
 	pte_t *ptep, pte;
 	int ret;
 
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
-			 (FOLL_PIN | FOLL_GET)))
-		return ERR_PTR(-EINVAL);
-
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		return no_page_table(vma, flags, address);
@@ -1434,6 +1429,11 @@ static long __get_user_pages(struct mm_s
 
 	VM_BUG_ON(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
 
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE((gup_flags & (FOLL_PIN | FOLL_GET)) ==
+			 (FOLL_PIN | FOLL_GET)))
+		return -EINVAL;
+
 	do {
 		struct page *page;
 		unsigned int page_increm;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

