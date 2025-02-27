Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74B429D0E
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695593; cv=none; b=DYsvg9IQg37ov+GH1uNkjvLj56AM6wDEssRyqAKtChyKNVDkItPFX4EQ6nkIVUOkOFYk9gbq7MBKbd5+X1YNpYFHVxc1iYE5Y68sc/2aw00u63girbZRWIPGrb3hQUOE+hfvy0L06DIrnh3/oj1nIu+G41q84UNUwXtD6qupBKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695593; c=relaxed/simple;
	bh=5yZncDb/Ho/3otKFufKcMfGxgOqp3A0LfmTBiF0dGWk=;
	h=Date:To:From:Subject:Message-Id; b=S8eZFetUAAKF1nfqe9NHklbTEkPZFt2vi/ri06ZBkUMfsK9FMOK88hd1ElQno4PyXpBXYNcS13C7Ci7Y1pnkmO3sn1DQHzwaKP5xgFDbPvPyO55p3nz8lmJrEXF1g3jw0OxelfZoeCx5n4dLkRC6m0jC12JHfoDR3cbUPo4RPhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hJCxfv9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hJCxfv9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F602C4CEDD;
	Thu, 27 Feb 2025 22:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695593;
	bh=5yZncDb/Ho/3otKFufKcMfGxgOqp3A0LfmTBiF0dGWk=;
	h=Date:To:From:Subject:From;
	b=hJCxfv9v2728ShCZS7xFb2U//WP3/1DRRcyF9V+yNLK4qHQUagxc9U7XcledhRdD8
	 R2UBK5UJiNHfkGp0PyTbCOZzV36RJ3bZ9HwEasibYEYeb9wapXC9/OVuL2U/mNxZKD
	 1biuO3yXUNFV2iyWmu5g6Qai8bemtFE8WOejLrKM=
Date: Thu, 27 Feb 2025 14:33:12 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hannes@cmpxchg.org,david@redhat.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change.patch added to mm-unstable branch
Message-Id: <20250227223313.2F602C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add lockdep assertion for pageblock type change
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change.patch

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
mm-page_alloc-add-lockdep-assertion-for-pageblock-type-change.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

