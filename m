From: akpm@linux-foundation.org
Subject: +
 fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch added
 to -mm tree
Date: Wed, 26 Nov 2014 14:24:22 -0800
Message-ID: <54765316.IoFH7P1l6/+0Bwm4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKZWYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Nov 2014 17:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hch@infradead.org, heiko.carstens@de.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, seq_file: fallback to vmalloc instead of oom kill processes
has been added to the -mm tree.  Its filename is
     fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, seq_file: fallback to vmalloc instead of oom kill processes

Since commit 058504edd026 ("fs/seq_file: fallback to vmalloc allocation"),
seq_buf_alloc() falls back to vmalloc() when the kmalloc() for contiguous
memory fails.  This was done to address order-4 slab allocations for
reading /proc/stat on large machines and noticed because
PAGE_ALLOC_COSTLY_ORDER < 4, so there is no infinite loop in the page
allocator when allocating new slab for such high-order allocations.

Contiguous memory isn't necessary for caller of seq_buf_alloc(), however. 
Other GFP_KERNEL high-order allocations that are <=
PAGE_ALLOC_COSTLY_ORDER will simply loop forever in the page allocator and
oom kill processes as a result.

We don't want to kill processes so that we can allocate contiguous memory
in situations when contiguous memory isn't necessary.

This patch does the kmalloc() allocation with __GFP_NORETRY for high-order
allocations.  This still utilizes memory compaction and direct reclaim in
the allocation path, the only difference is that it will fail immediately
instead of oom kill processes when out of memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes
+++ a/fs/seq_file.c
@@ -36,7 +36,7 @@ static void *seq_buf_alloc(unsigned long
 {
 	void *buf;
 
-	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);
 	return buf;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-verify-compound-order-when-freeing-a-page.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-numa-balancing-rearrange-kconfig-entry.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-hugetlb-fix-__unmap_hugepage_range.patch
hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
memory-hotplug-remove-redundant-call-of-page_to_pfn.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
mm-utilc-add-kstrimdup.patch
sysctl-terminate-strings-also-on-r.patch
sysctl-terminate-strings-also-on-r-fix.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

