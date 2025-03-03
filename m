Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CAA23A9AD
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042535; cv=none; b=VKTXxDT+ITTbPb7wXwPZjYGXDqhFVWP6dwhHqf25SoZ21iyrs3rWNevBv55RKs+WpKpHHHDbJCjZM8tsxnb9L/io7O4S24AsVd7Y0Qb1MflAN4E38v6thT3aq6NpH12l4xCNKyyFGzH0WTG3GRuiwbSvQhonn0Fx8ivAq98AxK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042535; c=relaxed/simple;
	bh=n6IOdSMGzvu88Sv+gBFWhR8nlk7xb6agFY/XFo0MdPs=;
	h=Date:To:From:Subject:Message-Id; b=DhNe/CQKXyLYOW8C9qymD9soLV23Duhco+wVRNWt4F5IUoV6Ws3TMJaQo7wmB4MoqDyW0rxxa37yzETGVgFiTAtpZCOANh/+G7N/+/INshq/AkinH6TJxcN9q7DSoynrh32G8i+FuNXcVKe7AlAZtQQcRR7FKR+fD+mdIAyOUGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qYMm7OHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qYMm7OHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A94C4CEE8;
	Mon,  3 Mar 2025 22:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042535;
	bh=n6IOdSMGzvu88Sv+gBFWhR8nlk7xb6agFY/XFo0MdPs=;
	h=Date:To:From:Subject:From;
	b=qYMm7OHi5T9nSJZ/NA9f3yThkQK0riYyS1KfszvWihJI5dC7b3ZCo0OVLmMR7Z9Ur
	 uRv4WVU/ay5ihP+R2gZM2tnpQLP8Y3MDHsr2dDVFo/QTMdxCopEvEqyUvMlfO4fDu2
	 elA8m/x4k8x2mPqLAL+OVbnXvcIa+IdTgI/i+gyY=
Date: Mon, 03 Mar 2025 14:55:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch added to mm-unstable branch
Message-Id: <20250303225534.D9A94C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: factor out large folio handling from folio_order() into folio_large_order()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: factor out large folio handling from folio_order() into folio_large_order()
Date: Mon, 3 Mar 2025 17:29:54 +0100

Patch series "mm: MM owner tracking for large folios (!hugetlb) +
CONFIG_NO_PAGE_MAPCOUNT", v3.

Let's add an "easy" way to decide -- without false positives, without
page-mapcounts and without page table/rmap scanning -- whether a large
folio is "certainly mapped exclusively" into a single MM, or whether it
"maybe mapped shared" into multiple MMs.

Use that information to implement Copy-on-Write reuse, to convert
folio_likely_mapped_shared() to folio_maybe_mapped_share(), and to
introduce a kernel config option that lets us not use+maintain per-page
mapcounts in large folios anymore.

The bigger picture was presented at LSF/MM [1].

This series is effectively a follow-up on my early work [2], which
implemented a more precise, but also more complicated, way to identify
whether a large folio is "mapped shared" into multiple MMs or "mapped
exclusively" into a single MM.


1 Patch Organization
====================

Patch #1 -> #6: make more room in order-1 folios, so we have two
                "unsigned long" available for our purposes

Patch #7 -> #11: preparations

Patch #12: MM owner tracking for large folios

Patch #13: COW reuse for PTE-mapped anon THP

Patch #14: folio_maybe_mapped_shared()

Patch #15 -> #20: introduce and implement CONFIG_NO_PAGE_MAPCOUNT


2 MM owner tracking
===================

We assign each MM a unique ID ("MM ID"), to be able to squeeze more
information in our folios.  On 32bit we use 15-bit IDs, on 64bit we use
31-bit IDs.

For each large folios, we now store two MM-ID+mapcount ("slot")
combinations:
* mm0_id + mm0_mapcount
* mm1_id + mm1_mapcount

On 32bit, we use a 16-bit per-MM mapcount, on 64bit an ordinary 32bit
mapcount.  This way, we require 2x "unsigned long" on 32bit and 64bit for
both slots.

Paired with the large mapcount, we can reliably identify whether one of
these MMs is the current owner (-> owns all mappings) or even holds all
folio references (-> owns all mappings, and all references are from
mappings).

As long as only two MMs map folio pages at a time, we can reliably and
precisely identify whether a large folio is "mapped shared" or "mapped
exclusively".

Any additional MM that starts mapping the folio while there are no free
slots becomes an "untracked MM".  If one such "untracked MM" is the last
one mapping a folio exclusively, we will not detect the folio as "mapped
exclusively" but instead as "maybe mapped shared".  (exception: only a
single mapping remains)

So that's where the approach gets imprecise.

For now, we use a bit-spinlock to sync the large mapcount + slots, and
make sure we do keep the machinery fast, to not degrade (un)map
performance drastically: for example, we make sure to only use a single
atomic (when grabbing the bit-spinlock), like we would already perform
when updating the large mapcount.


3 CONFIG_NO_PAGE_MAPCOUNT
=========================

patch #15 -> #20 spell out and document what exactly is affected when not
maintaining the per-page mapcounts in large folios anymore.

Most importantly, as we cannot maintain folio->_nr_pages_mapped anymore
when (un)mapping pages, we'll account a complete folio as mapped if a
single page is mapped.  In addition, we'll not detect partially mapped
anonymous folios as such in all cases yet.

Likely less relevant changes include that we might now under-estimate the
USS (Unique Set Size) of a process, but never over-estimate it.

The goal is to make CONFIG_NO_PAGE_MAPCOUNT the default at some point, to
then slowly make it the only option, as we learn about real-life impacts
and possible ways to mitigate them.


4 Performance
=============

Detailed performance numbers were included in v1 [3], and not that much
changed between v1 and v2.

I did plenty of measurements on different systems in the meantime, that
all revealed slightly different results.

The pte-mapped-folio micro-benchmarks [4] are fairly sensitive to code
layout changes on some systems.  Especially the fork() benchmark started
being more-shaky-than-before on recent kernels for some reason.

In summary, with my micro-benchmarks:

* Small folios are not impacted.

* CoW performance seems to be mostly unchanged across all folios sizes.

* CoW reuse performance of large folios now matches CoW reuse
  performance of small folios, because we now actually implement the CoW
  reuse optimization.  On an Intel Xeon Silver 4210R I measured a ~65%
  reduction in runtime, on an arm64 system I measured ~54% reduction.

* munmap() performance improves with CONFIG_NO_PAGE_MAPCOUNT.  I saw
  double-digit % reduction (up to ~30% on an Intel Xeon Silver 4210R and
  up to ~70% on an AmpereOne A192-32X) with larger folios.  The larger the
  folios, the larger the performance improvement.

* munmao() performance very slightly (couple percent) degrades without
  CONFIG_NO_PAGE_MAPCOUNT for smaller folios.  For larger folios, there
  seems to be no change at all.

* fork() performance improves with CONFIG_NO_PAGE_MAPCOUNT.  I saw
  double-digit % reduction (up to ~20% on an Intel Xeon Silver 4210R and
  up to ~10% on an AmpereOne A192-32X) with larger folios.  The larger the
  folios, the larger the performance improvement.

* While fork() performance without CONFIG_NO_PAGE_MAPCOUNT seems to be
  almost unchanged on some systems, I saw some degradation for smaller
  folios on the AmpereOne A192-32X.  I did not investigate the details
  yet, but I suspect code layout changes or suboptimal code placement /
  inlining.

I'm not to worried about the fork() micro-benchmarks for smaller folios
given how shaky the results are lately and by how much we improved fork()
performance recently.

I also ran case-anon-cow-rand and case-anon-cow-seq part of
vm-scalability, to assess the scalability and the impact of the
bit-spinlock.  My measurements on a two 2-socket 10-core Intel Xeon Silver
4210R CPU revealed no significant changes.

Similarly, running these benchmarks with 2 MiB THPs enabled on the
AmpereOne A192-32X with 192 cores, I got < 1% difference with < 1% stdev,
which is nice.

So far, I did not get my hands on a similarly large system with multiple
sockets.

I found no other fitting scalability benchmarks that seem to really hammer
on concurrent mapping/unmapping of large folio pages like
case-anon-cow-seq does.


5 Concerns
==========

5.1 Bit spinlock
----------------

I'm not quite happy about the bit-spinlock, but so far it does not seem to
affect scalability in my measurements.

If it ever becomes a problem we could either investigate improving the
locking, or simply stopping the MM tracking once there are "too many
mappings" and simply assume that the folio is "mapped shared" until it was
freed.

This would be similar (but slightly different) to the "0,1,2,stopped"
counting idea Willy had at some point.  Adding that logic to "stop
tracking" adds more code to the hot path, so I avoided that for now.


5.2 folio_maybe_mapped_shared()
-------------------------------

I documented the change from folio_likely_mapped_shared() to
folio_maybe_mapped_shared() quite extensively.  If we run into surprises,
I have some ideas on how to resolve them.  For now, I think we should be
fine.


5.3 Added code to map/unmap hot path
------------------------------------

So far, it looks like the added code on the rmap hot path does not really
seem to matter much in the bigger picture.  I'd like to further reduce it
(and possibly improve fork() performance further), but I don't easily see
how right now.  Well, and I am out of puff 🙂

Having that said, alternatives I considered (e.g., per-MM per-folio
mapcount) would add a lot more overhead to these hot paths.


6 Future Work
=============

6.1 Large mapcount
------------------

It would be very handy if the large mapcount would count how often folio
pages are actually mapped into page tables: a PMD on x86-64 would count
512 times.  Calculating the average per-page mapcount will be easy, and
remapping (PMD->PTE) folios would get even faster.

That would also remove the need for the entire mapcount (except for
PMD-sized folios for memory statistics reasons ...), and allow for mapping
folios larger than PMDs (e.g., 4 MiB) easily.

We likely would also have to take the same number of folio references to
make our folio_mapcount() == folio_ref_count() work, and we'd want to be
able to avoid mapcount+refcount overflows: this could already become an
issue with pte-mapped PUD-sized folios (fsdax).

One approach we discussed in the THP cabal meeting is (1) extending the
mapcount for large folios to 64bit (at least on 64bit systems) and (2)
keeping the refcount at 32bit, but (3) having exactly one reference if the
the mapcount != 0.

It should be doable, but there are some corner cases to consider on the
unmap path; it is something that I will be looking into next.


6.2 hugetlb
-----------

I'd love to make use of the same tracking also for hugetlb.

The real problem is PMD table sharing: getting a page mapped by MM X and
unmapped by MM Y will not work.  With mshare, that problem should not
exist (all mapping/unmapping will be routed through the mshare MM).

[1] https://lwn.net/Articles/974223/
[2] https://lore.kernel.org/linux-mm/a9922f58-8129-4f15-b160-e0ace581bcbe@redhat.com/T/
[3] https://lkml.kernel.org/r/20240829165627.2256514-1-david@redhat.com
[4] https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/pte-mapped-folio-benchmarks.c


This patch (of 20):

Let's factor it out into a simple helper function.  This helper will also
come in handy when working with code where we know that our folio is
large.

Maybe in the future we'll have the order readily available for small and
large folios; in that case, folio_large_order() would simply translate to
folio_order().

Link: https://lkml.kernel.org/r/20250303163014.1128035-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250303163014.1128035-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order
+++ a/include/linux/mm.h
@@ -1194,6 +1194,11 @@ struct inode;
 
 extern void prep_compound_page(struct page *page, unsigned int order);
 
+static inline unsigned int folio_large_order(const struct folio *folio)
+{
+	return folio->_flags_1 & 0xff;
+}
+
 /*
  * compound_order() can be called without holding a reference, which means
  * that niceties like page_folio() don't work.  These callers should be
@@ -1207,7 +1212,7 @@ static inline unsigned int compound_orde
 
 	if (!test_bit(PG_head, &folio->flags))
 		return 0;
-	return folio->_flags_1 & 0xff;
+	return folio_large_order(folio);
 }
 
 /**
@@ -1223,7 +1228,7 @@ static inline unsigned int folio_order(c
 {
 	if (!folio_test_large(folio))
 		return 0;
-	return folio->_flags_1 & 0xff;
+	return folio_large_order(folio);
 }
 
 #include <linux/huge_mm.h>
@@ -2139,7 +2144,7 @@ static inline long folio_nr_pages(const
 #ifdef CONFIG_64BIT
 	return folio->_folio_nr_pages;
 #else
-	return 1L << (folio->_flags_1 & 0xff);
+	return 1L << folio_large_order(folio);
 #endif
 }
 
@@ -2164,7 +2169,7 @@ static inline unsigned long compound_nr(
 #ifdef CONFIG_64BIT
 	return folio->_folio_nr_pages;
 #else
-	return 1L << (folio->_flags_1 & 0xff);
+	return 1L << folio_large_order(folio);
 #endif
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch
lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch
mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch
mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch
mm-memory-document-restore_exclusive_pte.patch
mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch
mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

