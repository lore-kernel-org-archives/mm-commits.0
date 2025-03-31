Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A443CDDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457097; cv=none; b=iu7FtxA5ZHp4sg4SVcArA5yEEuE4mrAvJ4/c0HhuxqC0Hpls6lRulFBGWM1Mr0+vEp4eCd5zlT548Q0Q3zfkensVdbtxFCEw5TkawUUn9gE87sqMETBCS8xYK41oeVvtbzRO87Q59HZvBeNHzEgfZRMH3xhuRw7AJpUOgYDT2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457097; c=relaxed/simple;
	bh=BTfP++c1FYIdgMhyfIhnkHj0ncyUXEz2jwhbovWuiwg=;
	h=Date:To:From:Subject:Message-Id; b=LH0rYF0yADDMwrV6y4ItqNGSbDQqM2YTXOT/qlnUx/tvk5zRnCYJM1IUNIQpVn3DT99lz9YXMEVDNw4eNiK1w8LICRoA99NkHV1NrucIchA0QnBLTrq0Uf/ZGoad/5Q5voMpONolHvmjC4zqPOkIi0ygchzxk6uT4HQ9XQo3/Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=epLeUvDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="epLeUvDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB81C4CEE3;
	Mon, 31 Mar 2025 21:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457097;
	bh=BTfP++c1FYIdgMhyfIhnkHj0ncyUXEz2jwhbovWuiwg=;
	h=Date:To:From:Subject:From;
	b=epLeUvDg5IVNa4zWYQWXDGHSWffGMsJa8Yjyhzt2xr9V4c9rmaWf7yjlzPypE4ECl
	 03OIqLz09YSBmI5DCFxOL5hlH6WbTiuM84AkCfkx+0P/IjR57T1dUOIw5UDjJHKd27
	 wIKLr7qwXYdoDZlgxIrpaEr/JcnuaLb8DxAvMQh4=
Date: Mon, 31 Mar 2025 14:38:16 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-remove-p4d_leaf-definition.patch added to mm-new branch
Message-Id: <20250331213816.EBB81C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: remove p4d_leaf definition
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-remove-p4d_leaf-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-remove-p4d_leaf-definition.patch

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
Subject: x86/mm: remove p4d_leaf definition
Date: Mon, 31 Mar 2025 16:13:26 +0800

There's no p4d huge page support yet, let's use the generic definition.

And also update the BUILD_BUG_ON() in pti_user_pagetable_walk_pmd()
because p4d_leaf() returns boolean value.

Link: https://lkml.kernel.org/r/20250331081327.256412-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: <x86@kernel.org>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    7 -------
 arch/x86/mm/pti.c              |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-remove-p4d_leaf-definition
+++ a/arch/x86/include/asm/pgtable.h
@@ -292,13 +292,6 @@ static inline unsigned long pgd_pfn(pgd_
 	return (pgd_val(pgd) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
-#define p4d_leaf p4d_leaf
-static inline bool p4d_leaf(p4d_t p4d)
-{
-	/* No 512 GiB pages yet */
-	return 0;
-}
-
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 #define pmd_leaf pmd_leaf
--- a/arch/x86/mm/pti.c~x86-mm-remove-p4d_leaf-definition
+++ a/arch/x86/mm/pti.c
@@ -206,7 +206,7 @@ static pmd_t *pti_user_pagetable_walk_pm
 	if (!p4d)
 		return NULL;
 
-	BUILD_BUG_ON(p4d_leaf(*p4d) != 0);
+	BUILD_BUG_ON(p4d_leaf(*p4d));
 	if (p4d_none(*p4d)) {
 		unsigned long new_pud_page = __get_free_page(gfp);
 		if (WARN_ON_ONCE(!new_pud_page))
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

