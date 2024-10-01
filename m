Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BCD1CCEE5
	for <mm-commits@vger.kernel.org>; Tue,  1 Oct 2024 22:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727820808; cv=none; b=r5BmcH7yJi1HDv3/NhrpsJu9ChhaS4p+GfEwAJWwMuqt7+ABN2WNuOw8zidsk9HTPNbUstWgo+OQkJFaCgqhwdryl98H2mdQHRMlkxEdJo8y1b98XdtZU/07AcSchRqcq9Iw6yKpCh504H19/Jc6WrIYKs00jAORzLCOU95UdWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727820808; c=relaxed/simple;
	bh=GJwVGJkM1Pxl3qysISkEOf5rnSdvKSLzyDET7vvSKno=;
	h=Date:To:From:Subject:Message-Id; b=m7VXDgPXDTHEr3h9X6DaoJuIFoSwrMXsq97XcTNMimQYeQKX6W5H3AfYH6xD79xNAm+S0XTJTpUtCIKYbWXxp+mGk//VIRpC7XOhATNLVauLFBmn2+OW4jnuI4khcb12izw/57IaKP4fDctu9R4UIkkek5+mKYDFeYq9BA/lnHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wUpjV1gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wUpjV1gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1722DC4CEC6;
	Tue,  1 Oct 2024 22:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727820808;
	bh=GJwVGJkM1Pxl3qysISkEOf5rnSdvKSLzyDET7vvSKno=;
	h=Date:To:From:Subject:From;
	b=wUpjV1gkSKXjkZouRtIUT/XrReViEGU68Sp1ecct9v5MDaG5o0cRZXb4dLhBlDZLh
	 NQiJkx0cLpoh5qxn3N28vYP6d3yyLTO3sG5GpBUqeU0t7SEopP8ulcakvhZx3+AyTW
	 al0iD+Sne2w50yEvqpFYKbw5z7UfpFDLGFKlyy3o=
Date: Tue, 01 Oct 2024 15:13:27 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch added to mm-unstable branch
Message-Id: <20241001221328.1722DC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: Count successful large folio zswap stores in hugepage zswpout stats.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

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
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: swap: Count successful large folio zswap stores in hugepage zswpout stats.
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
@@ -611,6 +611,7 @@ static struct kobj_attribute _name##_att
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
 #ifdef CONFIG_SHMEM
@@ -629,6 +630,7 @@ static struct attribute *anon_stats_attr
 	&anon_fault_fallback_attr.attr,
 	&anon_fault_fallback_charge_attr.attr,
 #ifndef CONFIG_SHMEM
+	&zswpout_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
@@ -659,6 +661,7 @@ static struct attribute_group file_stats
 
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

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

