Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C08CDDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457095; cv=none; b=KzZRa21A3kFG3HXKDM6UdLKfE3kQxVnEQl5pdDtbbLt6vgrUHoLJMsz4hmG+hSZGXfGXAVWTHYQ1NRKIZ2tE1OyNRyiBp1poZxztFhukEurplXpdYU0M/UdaRdLXpsU/m0ykxZ79lGAZn5J9eG9Bn4wRm6ao3ImCxSUGYOTgK6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457095; c=relaxed/simple;
	bh=yyeR16bTxoG8qW2gQzctPiJONoXgbRwHhbDDgSNlTQc=;
	h=Date:To:From:Subject:Message-Id; b=ii8RHDvazMXv5E3l6+PSdllpyjtM9tgYhCtaa3xqY5fwJTqLdkYBgKLEudOegP5U0bURYRzF7HrGqATgjPRx0WMAE4GUZmc5Uzu2w1re9FaLnQKGUT+IO9inrH0Ptd/vqTQdhJ7YVhk9Ev93OK4/4ZtQ/Lzb944MNBYIhNc6YEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mfITTogN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfITTogN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B1C4CEE3;
	Mon, 31 Mar 2025 21:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457094;
	bh=yyeR16bTxoG8qW2gQzctPiJONoXgbRwHhbDDgSNlTQc=;
	h=Date:To:From:Subject:From;
	b=mfITTogNFXf0JsShGg08HyH56nNJ2KgLAXagSLEO14C7LvxMV1svhRa3lKTrK43q9
	 /Fhr+KV8VgX9FTQovJQp7QCWYvUN1/MROJTqVir0KZdsnAMFh7w4yQAMCF9jbOV/Fi
	 rcMj1dg0AXaIVKU3fzJlBdOYz7duvRfEfCUKEpfE=
Date: Mon, 31 Mar 2025 14:38:14 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-remove-pgd_leaf-definition-in-arch.patch added to mm-new branch
Message-Id: <20250331213814.A25B1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: remove pgd_leaf definition in arch
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-remove-pgd_leaf-definition-in-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-remove-pgd_leaf-definition-in-arch.patch

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
Subject: x86/mm: remove pgd_leaf definition in arch
Date: Mon, 31 Mar 2025 16:13:25 +0800

pgd huge page is not supported yet, let's use the generic definition in
linux/pgtable.h.

And also update the BUILD_BUG_ON() checking for pgd_leaf() in
pti_user_pagetable_walk_p4d() because pgd_leaf() returns boolean value.

Link: https://lkml.kernel.org/r/20250331081327.256412-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: <x86@kernel.org>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    3 ---
 arch/x86/mm/pti.c              |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-remove-pgd_leaf-definition-in-arch
+++ a/arch/x86/include/asm/pgtable.h
@@ -1472,9 +1472,6 @@ static inline bool pgdp_maps_userspace(v
 	return (((ptr & ~PAGE_MASK) / sizeof(pgd_t)) < PGD_KERNEL_START);
 }
 
-#define pgd_leaf	pgd_leaf
-static inline bool pgd_leaf(pgd_t pgd) { return false; }
-
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 /*
  * All top-level MITIGATION_PAGE_TABLE_ISOLATION page tables are order-1 pages
--- a/arch/x86/mm/pti.c~x86-mm-remove-pgd_leaf-definition-in-arch
+++ a/arch/x86/mm/pti.c
@@ -185,7 +185,7 @@ static p4d_t *pti_user_pagetable_walk_p4
 
 		set_pgd(pgd, __pgd(_KERNPG_TABLE | __pa(new_p4d_page)));
 	}
-	BUILD_BUG_ON(pgd_leaf(*pgd) != 0);
+	BUILD_BUG_ON(pgd_leaf(*pgd));
 
 	return p4d_offset(pgd, address);
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

