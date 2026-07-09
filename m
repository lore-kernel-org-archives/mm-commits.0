Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9F2AEF5;
	Thu,  9 Jul 2026 22:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637397; cv=none; b=KaKwa7K0DvGWrrzAiDznhZF3jIJ6GqO8Fg8qth+4PeM29SWH5bO/cGvtPwnIrnr0WVfxswtLkw6nEjtd2QBHIP/RMl+bld8JM81VPbXSsCYnE7uOi9IA9mNGHmN30YVitsJEZCP/EWp0tST34FPpkIdNneNZXwULmlxtrrZZVaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637397; c=relaxed/simple;
	bh=J2ZHywfMWzulZuy2OjWCdxoBkkP/zZ82wfTx4AbpumY=;
	h=Date:To:From:Subject:Message-Id; b=V29x3KwEvaDEsTCmYiTJ4AMQyHQIftCruoukFyBv8XoUyIhT+wmwW9kVvW3zuJGibepDR+DlbW5dGGQCwWBHCJthiDxkHMJI9cMMwJHIPKnqwnfOXi0cYgiIvI8a8TPHUWT1MMmTDrik2h4WisU3k4v7RaqIF1rrW5ZV5h9RU8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CUpBrn30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CUpBrn30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEA81F00A3A;
	Thu,  9 Jul 2026 22:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637396;
	bh=cAlVrl6XaLaTpGvh18XYl4py9y1ozHd2thqHEBxpXEo=;
	h=Date:To:From:Subject;
	b=CUpBrn30HDmvibGopaXoCKT9z8sRqpx6/cYjHE5+Vim94SdaWOOdLMYRqZiCef3fI
	 Vwniq97KQSZG6kovxWRIiN9c3XM6WqSJBPQLgwWbfsAHNXU0XlRQ6MJOZ/LBySECrL
	 neZtwkcfSznHkwoUDv7XS2I+K8yE5J5Mgg1yTVZE=
Date: Thu, 09 Jul 2026 15:49:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,schwab@linux-m68k.org,geert@linux-m68k.org,david@kernel.org,ankur.a.arora@oracle.com,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] m68k-avoid-wunused-but-set-parameter-in-clear_user_page.patch removed from -mm tree
Message-Id: <20260709224955.DDEA81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: m68k: avoid -Wunused-but-set-parameter in clear_user_page()
has been removed from the -mm tree.  Its filename was
     m68k-avoid-wunused-but-set-parameter-in-clear_user_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: m68k: avoid -Wunused-but-set-parameter in clear_user_page()
Date: Mon, 25 May 2026 10:33:52 +0200

The loop in clear_user_pages() iterates over all pages and calls
clear_user_page() for each of them.  During the loop "vaddr" is modified. 
However on m68k clear_user() is a macro which does not use "vaddr".  The
compiler sees a variable which is modified but never used and emits a
warning for that:

include/linux/highmem.h: In function 'clear_user_pages':
include/linux/highmem.h:234:63: warning: parameter 'vaddr' set but not used [-Wunused-but-set-parameter=]
    static inline void clear_user_pages(void *addr, unsigned long vaddr,

Other architectures use an inline function for clear_user_page() which
avoids the warning.  This is not possible on m68k, as dlush_dcache_page()
is another macro which is not yet defined where clear_user_page() is
defined.  Including cacheflush_mm.h will trigger recursive and lots of
other issues.

So hide the warning with a cast to (void) instead.

While we are here, do the same for copy_user_page().

Link: https://lore.kernel.org/20260525-m68k-clear_user_page-v2-1-0c8981c6eca1@weissschuh.net
Fixes: 62a9f5a85b98 ("mm: introduce clear_pages() and clear_user_pages()")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page_mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/include/asm/page_mm.h~m68k-avoid-wunused-but-set-parameter-in-clear_user_page
+++ a/arch/m68k/include/asm/page_mm.h
@@ -55,10 +55,12 @@ static inline void clear_page(void *page
 #define clear_user_page(addr, vaddr, page)	\
 	do {	clear_page(addr);		\
 		flush_dcache_page(page);	\
+		(void)(vaddr);			\
 	} while (0)
 #define copy_user_page(to, from, vaddr, page)	\
 	do {	copy_page(to, from);		\
 		flush_dcache_page(page);	\
+		(void)(vaddr);			\
 	} while (0)
 
 extern unsigned long m68k_memoffset;
_

Patches currently in -mm which might be from linux@weissschuh.net are


