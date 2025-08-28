Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA078270577
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 05:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359793; cv=none; b=P+mwNif9DWqB2v8gN/2dIV5034g+oU2Bz4eZ9du9IgrJB0+i3/k6bXkQc4Z1cmrOIr2tIti+XXAto6PI8tW1mZpNploScX3sIPPd2122Za5lHpi0RW7DevhNMeVrCts9xtRwdollUJgFL/Mc/qqwvgaCV1tWuZXcVxDCg4+BBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359793; c=relaxed/simple;
	bh=hclyrzHbAAcOAoN5W+piJ9Sy+HryKHB9iw1Mr056tjQ=;
	h=Date:To:From:Subject:Message-Id; b=EvF1N1/58Fg/Tfa4wC5h3Hf+QyVPc4jHu5my0OOMyEnETs4RtYBRb09jh+cHpnkjccL06pYlowgINc3mkNkOrZNr5mlj/E0xNetGx0lTy7HAjxfspiQxR2G78BJzGdCw1DWoFZnOjma14wM/bdriJegV8IM+vmOIwan0sp6/FPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wVWIEe7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wVWIEe7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C3FC4CEEB;
	Thu, 28 Aug 2025 05:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359793;
	bh=hclyrzHbAAcOAoN5W+piJ9Sy+HryKHB9iw1Mr056tjQ=;
	h=Date:To:From:Subject:From;
	b=wVWIEe7tpZaXGK6O51JluqfeR//C0nzo9IXsGyXa24o/BVUbX5wTxF5zyRNdvvucV
	 LDx6mPgF5+FPTEOSLPQy9uI5osY9viCUJq0+lVcqjUBKu08yXuJLZZefMPE7MIbWpg
	 Ixm3+veXlOnVsCjyFQPdZvuF9Y3PmkbySVzYWoqI=
Date: Wed, 27 Aug 2025 22:43:12 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lorenzo.stoakes@oracle.com,lkp@intel.com,dave.hansen@intel.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-and-use-pgdp4d_populate_kernel-fix.patch removed from -mm tree
Message-Id: <20250828054313.24C3FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix KASAN build error due to p*d_populate_kernel()
has been removed from the -mm tree.  Its filename was
     mm-introduce-and-use-pgdp4d_populate_kernel-fix.patch

This patch was dropped because it was folded into mm-introduce-and-use-pgdp4d_populate_kernel.patch

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm: fix KASAN build error due to p*d_populate_kernel()
Date: Fri, 22 Aug 2025 11:07:27 +0900

Address a linker error introduced by a patch currently in mm-hotfixes:
"mm: introduce and use {pgd,p4d}_populate_kernel" [1].

KASAN unconditionally references kasan_early_shadow_{p4d,pud}.
However, these global variables may not exist depending on the number of
page table levels. For example, if CONFIG_PGTABLE_LEVELS=3, both
variables do not exist. Although KASAN may refernce non-existent
variables, it didn't break builds because calls to {pgd,p4d}_populate()
are optimized away at compile time.

However, {pgd,p4d}_populate_kernel() is defined as a function regardless
of the number of page table levels, so the compiler may not optimize
them away. In this case, the following linker error occurs:

ld.lld: error: undefined symbol: kasan_early_shadow_p4d
>>> referenced by init.c:260 (/home/hyeyoo/mm-new/mm/kasan/init.c:260)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> referenced by init.c:260 (/home/hyeyoo/mm-new/mm/kasan/init.c:260)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> did you mean: kasan_early_shadow_pmd
>>> defined in: vmlinux.a(mm/kasan/init.o)

ld.lld: error: undefined symbol: kasan_early_shadow_pud
>>> referenced by init.c:263 (/home/hyeyoo/mm-new/mm/kasan/init.c:263)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> referenced by init.c:263 (/home/hyeyoo/mm-new/mm/kasan/init.c:263)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> referenced by init.c:200 (/home/hyeyoo/mm-new/mm/kasan/init.c:200)
>>>               mm/kasan/init.o:(zero_p4d_populate) in archive vmlinux.a
>>> referenced 1 more times

Therefore, to allow calls to {pgd,p4d}_populate_kernel() to be optimized
out at compile time, define {pgd,p4d}_populate_kernel() as macros.  This
way, when pgd_populate() or p4d_populate() are simply empty macros, the
corresponding *_populate_kernel() functions can also be optimized away.

Link: https://lkml.kernel.org/r/20250822020727.202749-1-harry.yoo@oracle.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508181636.0Rtk0T7x-lkp@intel.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/lkml/20250821160515.611d191e@canb.auug.org.au
Link: https://lore.kernel.org/linux-mm/20250818020206.4517-3-harry.yoo@oracle.com [1]
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc.h |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/include/linux/pgalloc.h~mm-introduce-and-use-pgdp4d_populate_kernel-fix
+++ a/include/linux/pgalloc.h
@@ -5,20 +5,25 @@
 #include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 
-static inline void pgd_populate_kernel(unsigned long addr, pgd_t *pgd,
-				       p4d_t *p4d)
-{
-	pgd_populate(&init_mm, pgd, p4d);
-	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
-		arch_sync_kernel_mappings(addr, addr);
-}
+/*
+ * {pgd,p4d}_populate_kernel() are defined as macros to allow
+ * compile-time optimization based on the configured page table levels.
+ * Without this, linking may fail because callers (e.g., KASAN) may rely
+ * on calls to these functions being optimized away when passing symbols
+ * that exist only for certain page table levels.
+ */
+#define pgd_populate_kernel(addr, pgd, p4d)				\
+	do {								\
+		pgd_populate(&init_mm, pgd, p4d);			\
+		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)	\
+			arch_sync_kernel_mappings(addr, addr);		\
+	} while (0)
 
-static inline void p4d_populate_kernel(unsigned long addr, p4d_t *p4d,
-				       pud_t *pud)
-{
-	p4d_populate(&init_mm, p4d, pud);
-	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
-		arch_sync_kernel_mappings(addr, addr);
-}
+#define p4d_populate_kernel(addr, p4d, pud)				\
+	do {								\
+		p4d_populate(&init_mm, p4d, pud);			\
+		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)	\
+			arch_sync_kernel_mappings(addr, addr);		\
+	} while (0)
 
 #endif /* _LINUX_PGALLOC_H */
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

mm-move-page-table-sync-declarations-to-linux-pgtableh.patch
mm-introduce-and-use-pgdp4d_populate_kernel.patch
x86-mm-64-define-arch_page_table_sync_mask-and-arch_sync_kernel_mappings.patch

