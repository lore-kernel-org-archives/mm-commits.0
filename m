Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FB3144D39
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291659; cv=none; b=UCyc9y3K2aXWaPjCfQWuu/bTynCDU8e67+jveGisH4XsWETHsMwmbAxiAy+pQ1SJvS1Hbeoh3usXCxGK8qnySdNISRSBKw6RRo56ctu6Ndib+w7S50Cxb2j3oSn6D04k3ZhbzycTJfVh32RLu4evMnLTyXk4lmkywrwszGhXVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291659; c=relaxed/simple;
	bh=Nc/y+it6rG3KWBZxM7ndQWVvQzmSCYMGw5XJhhZgkNg=;
	h=Date:To:From:Subject:Message-Id; b=dkyLhCHFTKS3OxNpwX+gsa/lZXbfpN//9sllvwIymoJcNDf2YUdEUlmf6uRvCs7HF+FtBbrXjb/ddKlMAjv+gVwatv2C3s57pfjkKqkpRWvZrZMuM2Yo1SbjXfpRh6FweZ9lUsGlSqA+Unguy5eeXDEyS6Zw/hwbD07uEw/uiAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FhEhrRhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FhEhrRhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE00DC32789;
	Tue, 25 Jun 2024 05:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291658;
	bh=Nc/y+it6rG3KWBZxM7ndQWVvQzmSCYMGw5XJhhZgkNg=;
	h=Date:To:From:Subject:From;
	b=FhEhrRhv/Lcedv7gg3e7uqNxzMSZgVIM0kSU3n22qrQnr6kKLXy8L9Sdj5YambZwQ
	 MQhayoA+4TY/A+ec0wGjg7Sb+DDzrCIYyjanNRhO1nhuMDNoMBb520HMlRl72H/1Lt
	 oBTkisTGwZ+tIlQeSZFoqLZJ6SiJ23kWedvAWQbg=
Date: Mon, 24 Jun 2024 22:00:58 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch removed from -mm tree
Message-Id: <20240625050058.BE00DC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/highmem: reimplement totalhigh_pages() by walking zones
has been removed from the -mm tree.  Its filename was
     mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/highmem: reimplement totalhigh_pages() by walking zones
Date: Fri, 7 Jun 2024 10:37:10 +0200

Patch series "mm/highmem: don't track highmem pages manually".

Let's remove highmem special-casing from adjust_managed_page_count(), to
result in less confusion why memblock manually adjusts totalram_pages, and
__free_pages_core() only adjusts the zone's managed pages -- what about
the highmem pages that adjust_managed_page_count() updates?

Now, we only maintain totalram_pages and a zone's managed pages
independent of highmem support.  We can derive the number of highmem pages
simply by looking at the relevant zone's managed pages.  I don't think
there is any particular fast path that needs a maximum-efficient
totalhigh_pages() implementation.

Note that highmem memory is currently initialized using
free_highmem_page()->free_reserved_page(), not __free_pages_core().  In
the future we might want to also use __free_pages_core() to initialize
highmem memory, to make that less special, and consider moving
totalram_pages updates into __free_pages_core() [1], so we can just use
adjust_managed_page_count() in there as well.

Booting a simple kernel in QEMU reveals no highmem accounting change:

Before:
  Memory: 3095448K/3145208K available (14802K kernel code, 2073K rwdata,
  5000K rodata, 740K init, 556K bss, 49760K reserved, 0K cma-reserved,
  2244488K highmem)

After:
  Memory: 3095276K/3145208K available (14802K kernel code, 2073K rwdata,
  5000K rodata, 740K init, 556K bss, 49932K reserved, 0K cma-reserved,
  2244488K highmem)

[1] https://lkml.kernel.org/r/20240601133402.2675-1-richard.weiyang@gmail.com


This patch (of 2):

Can we get rid of the highmem ifdef in adjust_managed_page_count()? 
Likely yes: we don't have that many totalhigh_pages() users, and they all
don't seem to be very performance critical.

So let's implement totalhigh_pages() like nr_free_highpages(), collecting
information from all zones.  This is now similar to what we do in
si_meminfo_node() to collect the per-node highmem page count.

In the common case (single node, 3-4 zones), we really shouldn't care.  We
could optimize a bit further (only walk ZONE_HIGHMEM and ZONE_MOVABLE if
required), but there doesn't seem a real need for that.

[david@redhat.com: fix build bot complaint]
  Link: https://lkml.kernel.org/r/b57e5bc4-eb72-40e3-add4-57dfa6e03df6@redhat.com
Link: https://lkml.kernel.org/r/20240607083711.62833-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240607083711.62833-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    9 ++-------
 mm/highmem.c                     |   17 ++++++++++++++---
 mm/page_alloc.c                  |    4 ----
 3 files changed, 16 insertions(+), 14 deletions(-)

--- a/include/linux/highmem-internal.h~mm-highmem-reimplement-totalhigh_pages-by-walking-zones
+++ a/include/linux/highmem-internal.h
@@ -132,7 +132,7 @@ static inline void __kunmap_atomic(const
 }
 
 unsigned int __nr_free_highpages(void);
-extern atomic_long_t _totalhigh_pages;
+unsigned long __totalhigh_pages(void);
 
 static inline unsigned int nr_free_highpages(void)
 {
@@ -141,12 +141,7 @@ static inline unsigned int nr_free_highp
 
 static inline unsigned long totalhigh_pages(void)
 {
-	return (unsigned long)atomic_long_read(&_totalhigh_pages);
-}
-
-static inline void totalhigh_pages_add(long count)
-{
-	atomic_long_add(count, &_totalhigh_pages);
+	return __totalhigh_pages();
 }
 
 static inline bool is_kmap_addr(const void *x)
--- a/mm/highmem.c~mm-highmem-reimplement-totalhigh_pages-by-walking-zones
+++ a/mm/highmem.c
@@ -111,9 +111,6 @@ static inline wait_queue_head_t *get_pkm
 }
 #endif
 
-atomic_long_t _totalhigh_pages __read_mostly;
-EXPORT_SYMBOL(_totalhigh_pages);
-
 unsigned int __nr_free_highpages(void)
 {
 	struct zone *zone;
@@ -127,6 +124,20 @@ unsigned int __nr_free_highpages(void)
 	return pages;
 }
 
+unsigned long __totalhigh_pages(void)
+{
+	unsigned long pages = 0;
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		if (is_highmem(zone))
+			pages += zone_managed_pages(zone);
+	}
+
+	return pages;
+}
+EXPORT_SYMBOL(__totalhigh_pages);
+
 static int pkmap_count[LAST_PKMAP];
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
--- a/mm/page_alloc.c~mm-highmem-reimplement-totalhigh_pages-by-walking-zones
+++ a/mm/page_alloc.c
@@ -5756,10 +5756,6 @@ void adjust_managed_page_count(struct pa
 {
 	atomic_long_add(count, &page_zone(page)->managed_pages);
 	totalram_pages_add(count);
-#ifdef CONFIG_HIGHMEM
-	if (PageHighMem(page))
-		totalhigh_pages_add(count);
-#endif
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

