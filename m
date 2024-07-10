Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB44848E
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633725; cv=none; b=dbAZCgnaSIMTA99VBZXo4XuGEsmWDyPItqZlFGWUEseTlgYqfqMZMcEcc4QHXgMfYKDvcHf/tLf3dt0MKx5b3LKJ8vAdTFNXNZSonKP5xGMlvhjOOn1dgPQ+2pjGvUBNyQForiNe55XaTOikDuJQacQq48dxjrS0TJShIM23JFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633725; c=relaxed/simple;
	bh=hDMTeWZ9FkovqwYFKF7/M/F1+C4NDYlbPgs6xa2+ILo=;
	h=Date:To:From:Subject:Message-Id; b=KFtMhzEDB8LX6iuzqXu1s/Q7CtYpFGLGyDnSXuxA0KXOzuylyg/JNVEVCMwqrLMgsH28OI085qCj/qhr3/YPkGbJ0EgisHAoPWqZ5Itrhv/3tEhMC2JKjnaQ9S1HOPBSDTmj68m9JcUPv6K2UWh/4/2yDOBlBqgxi4cqGzKU4gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bkLTl98c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bkLTl98c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891B4C32781;
	Wed, 10 Jul 2024 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720633724;
	bh=hDMTeWZ9FkovqwYFKF7/M/F1+C4NDYlbPgs6xa2+ILo=;
	h=Date:To:From:Subject:From;
	b=bkLTl98cxYVjxn4ehlCKYRYI/BxcS6nxb6JPDrezxzJ8wZkkUt8v4VXWOo4MpXOcU
	 ygbrVd8tYDN3ZC9COZVRQ5GVNmvoURjGfdbP5Rxmf/b8BlKRVkHy5IdFzM+j8kUuGk
	 tC2NslDNTcx4YTZptE1GKzXYag/YdAQDflwXRDQk=
Date: Wed, 10 Jul 2024 10:48:44 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterx@redhat.com,mingo@redhat.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,arnd@arndb.de,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-x86-drop-own-definition-of-pgdp4d_leaf.patch added to mm-unstable branch
Message-Id: <20240710174844.891B4C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/x86: drop own definition of pgd,p4d_leaf
has been added to the -mm mm-unstable branch.  Its filename is
     arch-x86-drop-own-definition-of-pgdp4d_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-x86-drop-own-definition-of-pgdp4d_leaf.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/x86: drop own definition of pgd,p4d_leaf
Date: Wed, 10 Jul 2024 09:51:20 +0200

We provide generic definitions of pXd_leaf in pgtable.h when the arch do
not define their own, where the generic pXd_leaf always return false.

Although x86 defines {pgd,p4d}_leaf, they end up being a no-op, so drop
them and make them fallback to the generic one.

Link: https://lkml.kernel.org/r/bcd6ab8246348f18fdc77694e321ee6458f05781.1720597744.git.christophe.leroy@csgroup.eu
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~arch-x86-drop-own-definition-of-pgdp4d_leaf
+++ a/arch/x86/include/asm/pgtable.h
@@ -252,13 +252,6 @@ static inline unsigned long pgd_pfn(pgd_
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
@@ -1396,9 +1389,6 @@ static inline bool pgdp_maps_userspace(v
 	return (((ptr & ~PAGE_MASK) / sizeof(pgd_t)) < PGD_KERNEL_START);
 }
 
-#define pgd_leaf	pgd_leaf
-static inline bool pgd_leaf(pgd_t pgd) { return false; }
-
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 /*
  * All top-level MITIGATION_PAGE_TABLE_ISOLATION page tables are order-1 pages
_

Patches currently in -mm which might be from osalvador@suse.de are

arch-x86-drop-own-definition-of-pgdp4d_leaf.patch

