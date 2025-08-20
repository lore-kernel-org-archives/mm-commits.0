Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8658D24A067
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 02:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755658631; cv=none; b=OFJtWRlc7axqWzOTiGRRKpq1kmmTY3P4GkQd2x3RMqkhEYtyRGXxXIDS8dAY1wKclOEqK6gYRTTV9zQRvRV/waO2tUkYNd0Kq+snCjwcrT88AcTt1AJy/kC59AFq6G3Mbar8PDjiwyD8jh6KY8zoCcwdmR9rxYJbKw5qmloH+y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755658631; c=relaxed/simple;
	bh=9H6kz5l9lRMcIo6MZBmdS+ZWZFdOWSa4dvz+Nwux0ec=;
	h=Date:To:From:Subject:Message-Id; b=JeypLhUcFHPuwnMHN2SDeUSGsAJXd6S0r/BtEDtuy8t+b3HQGEzGZPANhMVMzZUVM0d7tjdcV+NuEpp8hNmF0GIZ+k804JDIYfBC9z/kKX+FGCFsh9mkjU35OJixRA20V5VvS8QcB6cQCfYEJNMe+8zwWKv7YEq6oMd4S2hDDzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5bIDmKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5bIDmKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE65C116D0;
	Wed, 20 Aug 2025 02:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755658631;
	bh=9H6kz5l9lRMcIo6MZBmdS+ZWZFdOWSa4dvz+Nwux0ec=;
	h=Date:To:From:Subject:From;
	b=E5bIDmKuOf/VQ3wQragtBWZY6yNqUlD96uLxf8pf351grqicMWyN2VGRWjXOr9tjN
	 HJUteMCL+5RuHcTY6PbpaHx98SvU7qvVIEaMU1lnOTVBKNZM6zyZRbJ8gV/a/MEv83
	 HTozrfN878xI1yDG+3H6g+mHnYonuN6nb31UPWsY=
Date: Tue, 19 Aug 2025 19:57:10 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,dja@axtens.net,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-avoid-lazy-mmu-mode-hazards.patch added to mm-hotfixes-unstable branch
Message-Id: <20250820025711.1DE65C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: avoid lazy MMU mode hazards
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kasan-avoid-lazy-mmu-mode-hazards.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-avoid-lazy-mmu-mode-hazards.patch

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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/kasan: avoid lazy MMU mode hazards
Date: Mon, 18 Aug 2025 18:39:13 +0200

Functions __kasan_populate_vmalloc() and __kasan_depopulate_vmalloc() use
apply_to_pte_range() function, which enters the lazy MMU mode.  In that
mode updating PTEs may not be observed until the mode is left.

That may lead to a situation that otherwise correct reads and writes to a
PTE using ptep_get(), set_pte(), pte_clear() and other access primitives
bring wrong results when the vmalloc shadow memory is being
(de-)populated.

To avoid these hazards leave the lazy MMU mode before and re-enter it
after each PTE manipulation.

Link: https://lkml.kernel.org/r/0d2efb7ddddbff6b288fbffeeb10166e90771718.1755528662.git.agordeev@linux.ibm.com
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/kasan/shadow.c~mm-kasan-avoid-lazy-mmu-mode-hazards
+++ a/mm/kasan/shadow.c
@@ -305,6 +305,8 @@ static int kasan_populate_vmalloc_pte(pt
 	pte_t pte;
 	int index;
 
+	arch_leave_lazy_mmu_mode();
+
 	index = PFN_DOWN(addr - data->start);
 	page = data->pages[index];
 	__memset(page_to_virt(page), KASAN_VMALLOC_INVALID, PAGE_SIZE);
@@ -317,6 +319,8 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
+	arch_enter_lazy_mmu_mode();
+
 	return 0;
 }
 
@@ -461,6 +465,8 @@ static int kasan_depopulate_vmalloc_pte(
 	pte_t pte;
 	int none;
 
+	arch_leave_lazy_mmu_mode();
+
 	spin_lock(&init_mm.page_table_lock);
 	pte = ptep_get(ptep);
 	none = pte_none(pte);
@@ -471,6 +477,8 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
+	arch_enter_lazy_mmu_mode();
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-kasan-fix-vmalloc-shadow-memory-de-population-races.patch
mm-kasan-avoid-lazy-mmu-mode-hazards.patch

