Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131546;
	b=AV+L/OW3qmhqg3yveovzGRrlwq//nqChf94sUshSyxa8UO0Fj20C5xQBTSKB3VMGnZhp
	 HGT/tMfBrkau0UhZB7mOsGkCFcoT3s3Y5b3QN6rddjSY2M6pamx+ygum+jx+fO3+fp+sr
	 rApGs/u7trN9uGMMzYJuitxaxwayq5X2hFButvsLnfuhtxTBbUjPmx1253rfDcwLlwyBD
	 IBe2rUsmM3s5OZ0wR8+b8qibhLguKxZ2CkydNoeFVLObAczljw07LH0wnKg1iob6j70ei
	 RfmUrVsbDR9diH5X54dZojov8wFQzKs3QKF4IaGFf/0OHK4sWbsXtSZ0SIBTjrzWVUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131546;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SQrr+3GcCP/uSlxHJZWcnPLmSJdwfVnzUGYb/DSm8v8=;
	b=zRjKHnUgcFKg7tXlT0AgctIN1YWZC3ARsTECLylGytC+7aQLEToMMCs4KaXYox8zdNAK
	 VjMT15Fl4SiqSmJ5kpCsGf7USGixpDC54Qjrr7T6G2VIfYqe6PH2nR41W2gyOV2ubzhQT
	 UWwR08B55rADg7BYVUdnx1f/7+UKCRTDOLdHMebPzYTA7EnSh8pXNA6hbW693+ZXofRx3
	 trAYFYOpgmaJmthm6ni3G0SNb6i9XoDOUnRP1ROz0PLG++UJCqoQj1+Mi1/rLf6TPMl0/
	 oGNWXRT7drLKZxneILulSPXIGR9mvextW8wMvkTn5iMNemHEFbQwuSW4TjVwgI34IMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ng0M+B41;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1A2606A320;
	Tue, 27 Oct 2026 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ng0M+B41
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321851F01825;
	Tue, 27 Oct 2026 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131545;
	bh=SQrr+3GcCP/uSlxHJZWcnPLmSJdwfVnzUGYb/DSm8v8=;
	h=Date:To:From:Subject;
	b=Ng0M+B41LSCOTLvmeSrzpLh4sWZIKbW1rKbB6U8DjAHI7pOpLmyO0xoOgN70daCln
	 MXIq1Nj9tVlxDWSdfBXr42EBflvQLiGLbELwy2xGyscchm7BEi0jvokGsyhe6QWOCY
	 XusjJrdtlL4apr5m4at6hOPGgLah6/JTG4ZjCJyU=
Date: Tue, 27 Oct 2026 13:05:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch added to mm-unstable branch
Message-Id: <20261027200545.321851F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: check pageblock pfns under span seqlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/page_alloc: check pageblock pfns under span seqlock
Date: Tue, 27 Oct 2026 16:46:35 +0100

Whenever the flags of a pageblock are read or written, a kernel with
CONFIG_DEBUG_VM makes sure that the pfn lies within the zone of the page.
Unlike bad_range(), that check reads zone->zone_start_pfn and
zone->spanned_pages without zone->span_seqlock.

Memory hotplug changes the two fields one after the other. If the lower
end of a zone moves, the zone seems to end before its last pages in
between. A page of that part which is freed at that moment, on another
CPU, ends in

  page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
  kernel BUG at mm/page_alloc.c:372!
   free_unref_folios+0x55e/0xed0
   folios_put_refs+0x2b5/0x530

Read the span in a read section of the seqlock.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org
Fixes: 86051ca5eaf5 ("mm: fix usemap initialization")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-pageblock-pfns-under-span-seqlock
+++ a/mm/page_alloc.c
@@ -357,6 +357,21 @@ static __always_inline bool is_standalon
 	return pb_bit >= PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
 }
 
+/* Memory hotplug can resize the zone while we look at its span */
+static bool __maybe_unused zone_spans_pfn_stable(struct zone *zone,
+						 unsigned long pfn)
+{
+	unsigned int seq;
+	bool ret;
+
+	do {
+		seq = zone_span_seqbegin(zone);
+		ret = zone_spans_pfn(zone, pfn);
+	} while (zone_span_seqretry(zone, seq));
+
+	return ret;
+}
+
 static __always_inline void
 get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 			   unsigned long **bitmap_word, unsigned long *bitidx)
@@ -370,7 +385,7 @@ get_pfnblock_bitmap_bitidx(const struct
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
+	VM_BUG_ON_PAGE(!zone_spans_pfn_stable(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
 	*bitidx = pfn_to_bitidx(page, pfn);
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch
mm-page_alloc-clear-private-of-deferred-free-pages.patch
mm-page_frag-refill-the-cache-for-large-fragments.patch
mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch
mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch
mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

