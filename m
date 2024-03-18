Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DA381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710787670; cv=none; b=OXOIS2Gi9n7oqzdPNZG+seS0wfke0xWW7ZXUhCH4ONj5f8N2Qf0j/P2cmHWS9OrRjBaIH9sPNCzanKM5a4ZaDRavwovlYHHDx1rbOlqDedOV1ovcXltKLme50bMK2C6O9poXCogQirxumVpuvFzVsL/zQF0k+gIKDnU1seE1Qqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710787670; c=relaxed/simple;
	bh=EdrW1DCQfn9Sr7OjrKlu1eqB+0yrfJmnl98gOi0PKLg=;
	h=Date:To:From:Subject:Message-Id; b=lR+DWF4rZbUBrHPWtMByhTp72SDNmcA+18Gehl+TFv4Xrwozf1ByJHXWg6g7MXS/SLwn8+2PFe/OxM7o9bazBAsbXx9LbBgLcF+asTDy67q4iZCYwtfRWdQFiBT8IpJMimlkEwFM4/I4AoMOTVx85Diz+uB0afpypkIJ0+iN6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PWtue/zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PWtue/zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B16C433C7;
	Mon, 18 Mar 2024 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710787670;
	bh=EdrW1DCQfn9Sr7OjrKlu1eqB+0yrfJmnl98gOi0PKLg=;
	h=Date:To:From:Subject:From;
	b=PWtue/zmxEHCXeI3EdKiRlmM1hRCTydfUPWjaupqjn9Ywr/MlDMrmWC6NS2+XgWXG
	 /J9hY7vzKog4vH201QD9j5odrjuy5gnLCClMDP327fDUbng4j0YnzT98Y9atR2d7K3
	 yN+LEtN4y3jut89nDleXE5ozs8MVqMvOaaAxNY1Q=
Date: Mon, 18 Mar 2024 11:47:49 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318184750.60B16C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: fix missing pte marker for !page on pte zaps
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/memory: fix missing pte marker for !page on pte zaps
Date: Wed, 13 Mar 2024 17:31:07 -0400

Commit 0cf18e839f64 of large folio zap work broke uffd-wp.  Now mm's uffd
unit test "wp-unpopulated" will trigger this WARN_ON_ONCE().

The WARN_ON_ONCE() asserts that an VMA cannot be registered with
userfaultfd-wp if it contains a !normal page, but it's actually possible. 
One example is an anonymous vma, register with uffd-wp, read anything will
install a zero page.  Then when zap on it, this should trigger.

What's more, removing that WARN_ON_ONCE may not be enough either, because
we should also not rely on "whether it's a normal page" to decide whether
pte marker is needed.  For example, one can register wr-protect over some
DAX regions to track writes when UFFD_FEATURE_WP_ASYNC enabled, in which
case it can have page==NULL for a devmap but we may want to keep the
marker around.

Link: https://lkml.kernel.org/r/20240313213107.235067-1-peterx@redhat.com
Fixes: 0cf18e839f64 ("mm/memory: handle !page case in zap_present_pte() separately")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps
+++ a/mm/memory.c
@@ -1536,7 +1536,9 @@ static inline int zap_present_ptes(struc
 		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
 		arch_check_zapped_pte(vma, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
-		VM_WARN_ON_ONCE(userfaultfd_wp(vma));
+		if (userfaultfd_pte_wp(vma, ptent))
+			zap_install_uffd_wp_if_needed(vma, addr, pte, 1,
+						      details, ptent);
 		ksm_might_unmap_zero_page(mm, ptent);
 		return 1;
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch

