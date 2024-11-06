Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E2B1741CB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854754; cv=none; b=uzJovEYJClbOGesykMyFb3FBv6O7Azod+bZhAF6thKqStDS0mbKC8fWeJRbeoTzQW742e0lXkEkWOwx3/0l6kL+tGViIDeD07y/FYLG1x5VHX1ESJxFhhyEcTFhCvd/vbz1ENx2lDkgh19RCLgBo9DV6R8rVKd6CRuHxSlxjdv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854754; c=relaxed/simple;
	bh=XqmF70BoLMUNIanRM0wAQbWQBatdfKcKEtqYVrQMW1c=;
	h=Date:To:From:Subject:Message-Id; b=RWNEB3eyzAqs6QqpDmnKOp/th4SSk470dkxCUsM4XHjtCVaoh5HiUmNPNaj13+ja3p0ImJzl+4cjken1zba4qNxTuH/AjysNLiR+Q0qfNd9vjotB0CsxGr05N+CEZW3D4h1o+XsASak8Os9P8LDZcJCjv3LYsb3E6ESFOd+0abw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MOXZX47c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MOXZX47c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B471C4CECF;
	Wed,  6 Nov 2024 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854754;
	bh=XqmF70BoLMUNIanRM0wAQbWQBatdfKcKEtqYVrQMW1c=;
	h=Date:To:From:Subject:From;
	b=MOXZX47ccmxTTx6pNMCOIlioPu3leQtZasIcMIEzsFtk3FAFqTUsbqh9hQTMDBr0P
	 +0hlm2pE2ZDINrNK+i+/w8r/dCXoTy74VqvaEotV2rt92eJWb673/124OyQj/rCLKV
	 Ak9mxfhm7SdAGq6eZSIV06xzFCSJC7WgObRAfUtQ=
Date: Tue, 05 Nov 2024 16:59:13 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch removed from -mm tree
Message-Id: <20241106005914.5B471C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: Count successful large folio zswap stores in hugepage zswpout stats
has been removed from the -mm tree.  Its filename was
     mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: swap: Count successful large folio zswap stores in hugepage zswpout stats
Date: Mon, 30 Sep 2024 22:32:22 -0700

Added a new MTHP_STAT_ZSWPOUT entry to the sysfs transparent_hugepage
stats so that successful large folio zswap stores can be accounted under
the per-order sysfs "zswpout" stats:

/sys/kernel/mm/transparent_hugepage/hugepages-*kB/stats/zswpout

Other non-zswap swap device swap-out events will be counted under
the existing sysfs "swpout" stats:

/sys/kernel/mm/transparent_hugepage/hugepages-*kB/stats/swpout

Also, added documentation for the newly added sysfs per-order hugepage
"zswpout" stats. The documentation clarifies that only non-zswap swapouts
will be accounted in the existing "swpout" stats.

Link: https://lkml.kernel.org/r/20241001053222.6944-8-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    8 ++++++--
 include/linux/huge_mm.h                    |    1 +
 mm/huge_memory.c                           |    3 +++
 mm/page_io.c                               |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -530,10 +530,14 @@ anon_fault_fallback_charge
 	instead falls back to using huge pages with lower orders or
 	small pages even though the allocation was successful.
 
-swpout
-	is incremented every time a huge page is swapped out in one
+zswpout
+	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
 
+swpout
+	is incremented every time a huge page is swapped out to a non-zswap
+	swap device in one piece without splitting.
+
 swpout_fallback
 	is incremented if a huge page has to be split before swapout.
 	Usually because failed to allocate some continuous swap space
--- a/include/linux/huge_mm.h~mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats
+++ a/include/linux/huge_mm.h
@@ -119,6 +119,7 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	MTHP_STAT_ZSWPOUT,
 	MTHP_STAT_SWPOUT,
 	MTHP_STAT_SWPOUT_FALLBACK,
 	MTHP_STAT_SHMEM_ALLOC,
--- a/mm/huge_memory.c~mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats
+++ a/mm/huge_memory.c
@@ -600,6 +600,7 @@ static struct kobj_attribute _name##_att
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
 #ifdef CONFIG_SHMEM
@@ -618,6 +619,7 @@ static struct attribute *anon_stats_attr
 	&anon_fault_fallback_attr.attr,
 	&anon_fault_fallback_charge_attr.attr,
 #ifndef CONFIG_SHMEM
+	&zswpout_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
@@ -648,6 +650,7 @@ static struct attribute_group file_stats
 
 static struct attribute *any_stats_attrs[] = {
 #ifdef CONFIG_SHMEM
+	&zswpout_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
--- a/mm/page_io.c~mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats
+++ a/mm/page_io.c
@@ -269,6 +269,7 @@ int swap_writepage(struct page *page, st
 		swap_zeromap_folio_clear(folio);
 	}
 	if (zswap_store(folio)) {
+		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		folio_unlock(folio);
 		return 0;
 	}
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


