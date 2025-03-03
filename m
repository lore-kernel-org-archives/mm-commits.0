Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4920123AE83
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741043944; cv=none; b=brA4cwR+g+I3bBGZC31UdEIGZO6yqOlRLo/E6/Dvsm/P3gaSW+jqkn468Ko0iTTdbt4oPcGOM1nmmEv015cN9+i5qn5oT+TiPnlRKnY0D6KErzrBVGt+AeXdFH+7TAqE8kPw8mZ7N4L1Kl3FXojza0IiuZ+Ohzkl+cT6t0K+LDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741043944; c=relaxed/simple;
	bh=/JwaqyJa+56ld2P0SrBA1H7iPNU3IGnu7eQiVsgvS48=;
	h=Date:To:From:Subject:Message-Id; b=PmIjoQ+nW6Iww1fTjHP7tv7QXYgGRgiM7SpyOn5TluSjYitxGwUt+Ayobj2RnWZQ9tOijZFD0PyqXPXh9RJaYkzDmQ9+u8WDSo0D6sP5GHgsgcUV/M34kpNUDlVm5eM3qsLvSVcbvmTBZKRYoEelrvEVQvw0RdqgJ9oki/vO1+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aN/ZW3AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aN/ZW3AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF29FC4CEE9;
	Mon,  3 Mar 2025 23:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741043943;
	bh=/JwaqyJa+56ld2P0SrBA1H7iPNU3IGnu7eQiVsgvS48=;
	h=Date:To:From:Subject:From;
	b=aN/ZW3AYPXST0JP9txY6h/lheQVi7vvY5LpnHpZX3nlPKMSWYTJgQh2z8HDetJgdk
	 MePL1MJKajxDokcrxHH4ZqUlYv1MWocBl7G4TAbp3GpjPaQvLgfVkgOFrEpa1aISOp
	 Ag/EczTdBI1hOvVaXhWLYbtFkCcsiALmFsgpPwmI=
Date: Mon, 03 Mar 2025 15:19:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hannes@cmpxchg.org,david@redhat.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change.patch removed from -mm tree
Message-Id: <20250303231903.AF29FC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add lockdep assertion for pageblock type change
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: add lockdep assertion for pageblock type change
Date: Thu, 27 Feb 2025 16:15:47 +0000

Since the migratetype hygiene patches [0], the locking here is
a bit more formalised, so write it down with an assert.

[0] https://lore.kernel.org/lkml/20240320180429.678181-3-hannes@cmpxchg.org/T/

Link: https://lkml.kernel.org/r/20250227-pageblock-lockdep-v1-1-3701efb331bb@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    1 +
 mm/memory_hotplug.c            |    5 +++++
 mm/page_alloc.c                |    4 ++++
 3 files changed, 10 insertions(+)

--- a/include/linux/memory_hotplug.h~mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change
+++ a/include/linux/memory_hotplug.h
@@ -175,6 +175,7 @@ void put_online_mems(void);
 
 void mem_hotplug_begin(void);
 void mem_hotplug_done(void);
+bool in_mem_hotplug(void);
 
 /* See kswapd_is_running() */
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat)
--- a/mm/memory_hotplug.c~mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change
+++ a/mm/memory_hotplug.c
@@ -267,6 +267,11 @@ void mem_hotplug_done(void)
 	cpus_read_unlock();
 }
 
+bool in_mem_hotplug(void)
+{
+	return percpu_is_write_locked(&mem_hotplug_lock);
+}
+
 u64 max_mem_size = U64_MAX;
 
 /* add this memory to iomem resource */
--- a/mm/page_alloc.c~mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change
+++ a/mm/page_alloc.c
@@ -417,6 +417,10 @@ void set_pfnblock_flags_mask(struct page
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
+	lockdep_assert_once(system_state == SYSTEM_BOOTING ||
+		in_mem_hotplug() ||
+		lockdep_is_held(&page_zone(page)->lock));
+
 	if (unlikely(page_group_by_mobility_disabled &&
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

