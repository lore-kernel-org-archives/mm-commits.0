Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397EBC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 22:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbhLMWQO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbhLMWQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 17:16:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ADFC06173F
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 14:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C010961250
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 22:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12D4C34601;
        Mon, 13 Dec 2021 22:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639433773;
        bh=jbshNyt9R7MzKRdL18aeiSTYOfYAIQQzxlH1okzg1yA=;
        h=Date:From:To:Subject:From;
        b=VqnXKOHyHBUuSHIKTJseT3vzeJhT/nnKAfIcbHQnXUOp/u54bx+1aGvCY5U4eMNpV
         VRcarkCCIU1DoDkvZRM5iUtuiobG6MQ9sAXey3X0X8SslU1X4Clf7DKeGzUJG+z+CF
         P1SsFLia3MK6ulCSqlBeJIIeI6m+cvzhhHwBNQ/s=
Date:   Mon, 13 Dec 2021 14:16:11 -0800
From:   akpm@linux-foundation.org
To:     dan.streetman@canonical.com, daniel.hill@canonical.com,
        dongdong.tao@canonical.com, gavin.guo@canonical.com,
        gerald.yang@canonical.com, halves@canonical.com,
        ioanna-maria.alifieraki@canonical.com, jay.vosburgh@canonical.com,
        linmiaohe@huawei.com, matthew.ruffell@canonical.com,
        mfo@canonical.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        ponnuvel.palaniyappan@canonical.com, ying.huang@intel.com
Subject:  +
 mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch added
 to -mm tree
Message-ID: <20211213221611.naxP7o8lh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix race between MADV_FREE reclaim and blkdev direct IO read
has been added to the -mm tree.  Its filename is
     mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: mm: fix race between MADV_FREE reclaim and blkdev direct IO read

Problem:
=======

Userspace might read the zero-page instead of actual data from a direct IO
read on a block device if the buffers have been called madvise(MADV_FREE)
on earlier (this is discussed below) due to a race between page reclaim on
MADV_FREE and blkdev direct IO read.

Race condition:
==============

During page reclaim, the MADV_FREE page check in try_to_unmap_one() checks
if the page is not dirty, then discards its PTE (vs remap it back if the
page is dirty).

However, after try_to_unmap_one() returns to shrink_page_list(), it might
keep the page _anyway_ if page_ref_freeze() fails (it expects a single
page ref from the isolation).

Well, blkdev_direct_IO() gets references for all pages, and on READ
operations it sets them dirty later.

So, if MADV_FREE pages (i.e., not dirty) are used as buffers (more later)
for direct IO read from block devices and page reclaim runs during
__blkdev_direct_IO[_simple]() AFTER bio_iov_iter_get_pages() but BEFORE it
sets pages dirty, that situation happens.

The direct IO read eventually completes.  Now, when userspace reads the
buffers, the PTE is no longer there and the page fault handler
do_anonymous_page() services that with the zero-page, NOT the data!

A synthetic reproducer is provided.

Page faults:
===========

The data read from the block device probably won't generate faults due to
DMA (no MMU) but even in the case it wouldn't use DMA, that happens on
different virtual addresses (not user-mapped addresses) because `struct
bio_vec` stores `struct page` to figure addresses out (which are different
from/unrelated to user-mapped addresses) for the data read.

Thus userspace reads (to user-mapped addresses) still fault, then
do_anonymous_page() gets another `struct page` that would address/ map to
other memory than the `struct page` used by `struct bio_vec` for the read
(which runs correctly as the page wasn't freed due to page_ref_freeze(),
and is reclaimed later) -- but even if the page addresses matched, that
handler maps the zero-page in the PTE, not that page's memory (on read
faults.)

If page reclaim happens BEFORE bio_iov_iter_get_pages() the issue doesn't
happen, because that faults-in all pages as writeable, so
do_anonymous_page() sets up a new page/rmap/PTE, and that is used by
direct IO.  The userspace reads don't fault as the PTE is there (thus
zero-page is not used.)

Solution:
========

One solution is to check for the expected page reference count in
try_to_unmap_one() too, which should be exactly two: one from the
isolation (checked by shrink_page_list()), and the other from the rmap
(dropped by the discard: label).  If that doesn't match, then remap the
PTE back, just like page dirty does.

The new check in try_to_unmap_one() should be safe in races with
bio_iov_iter_get_pages() in get_user_pages() fast and slow paths, as it's
done under the PTE lock.  The fast path doesn't take that lock but it
checks the PTE has changed, then drops the reference and leaves the page
for the slow path (which does take that lock).

- try_to_unmap_one()
  - page_vma_mapped_walk()
    - map_pte() # see pte_offset_map_lock():
        pte_offset_map()
        spin_lock()
  - page_ref_count() # new check
  - page_vma_mapped_walk_done() # see pte_unmap_unlock():
      pte_unmap()
      spin_unlock()

- bio_iov_iter_get_pages()
  - __bio_iov_iter_get_pages()
    - iov_iter_get_pages()
      - get_user_pages_fast()
        - internal_get_user_pages_fast()

          # fast path
          - lockless_pages_from_mm()
            - gup_{pgd,p4d,pud,pmd,pte}_range()
                ptep = pte_offset_map() # not _lock()
                pte = ptep_get_lockless(ptep)
                page = pte_page(pte)
                try_grab_compound_head(page) # get ref
                if (pte_val(pte) != pte_val(*ptep))
                        put_compound_head(page) # put ref
                        # leave page for slow path
          # slow path
          - __gup_longterm_unlocked()
            - get_user_pages_unlocked()
              - __get_user_pages_locked()
                - __get_user_pages()
                  - follow_{page,p4d,pud,pmd}_mask()
                    - follow_page_pte()
                        ptep = pte_offset_map_lock()
                        pte = *ptep
                        page = vm_normal_page(pte)
                        try_grab_page(page) # get ref
                        pte_unmap_unlock()

Regarding transparent hugepages, that number shouldn't change, as
MADV_FREE (aka lazyfree) pages are PageAnon() && !PageSwapBacked()
(madvise_free_pte_range() -> mark_page_lazyfree() -> lru_lazyfree_fn())
thus should reach shrink_page_list() -> split_huge_page_to_list() before
try_to_unmap[_one](), so it deals with normal pages only.

(And in case unlikely/TTU_SPLIT_HUGE_PMD/split_huge_pmd_address() happens,
which it should not or be rare, the page refcount is not two, as the head
page counts tail pages, and tail pages have zero.  That also prevents
checking the head `page` then incorrectly call page_remove_rmap(subpage)
for a tail page, that isn't even in the shrink_page_list()'s page_list (an
effect of split huge pmd/pmvw), as it might happen today in this unlikely
scenario.)

MADV_FREE'd buffers:
===================

So, back to the "if MADV_FREE pages are used as buffers" note.  The case
is arguable, and subject to multiple interpretations.

The madvise(2) manual page on the MADV_FREE advice value says:
- 'After a successful MADV_FREE ... data will be lost when
   the kernel frees the pages.'
- 'the free operation will be canceled if the caller writes
   into the page' / 'subsequent writes ... will succeed and
   then [the] kernel cannot free those dirtied pages'
- 'If there is no subsequent write, the kernel can free the
   pages at any time.'

Thoughts, questions, considerations...
- Since the kernel didn't actually free the page (page_ref_freeze()
  failed), should the data not have been lost? (on userspace read.)
- Should writes performed by the direct IO read be able to cancel
  the free operation?
  - Should the direct IO read be considered as 'the caller' too,
    as it's been requested by 'the caller'?
  - Should the bio technique to dirty pages on return to userspace
    (bio_check_pages_dirty() is called/used by __blkdev_direct_IO())
    be considered in another/special way here?
- Should an upcoming write from a previously requested direct IO
  read be considered as a subsequent write, so the kernel should
  not free the pages? (as it's known at the time of page reclaim.)

Technically, the last point would seem a reasonable consideration and
balance, as the madvise(2) manual page apparently (and fairly) seem to
assume that 'writes' are memory access from the userspace process (not
explicitly considering writes from the kernel or its corner cases; again,
fairly)..  plus the kernel fix implementation for the corner case of the
largely 'non-atomic write' encompassed by a direct IO read operation, is
relatively simple; and it helps.

Reproducer:
==========

@ test.c (simplified, but works)

	#define _GNU_SOURCE
	#include <fcntl.h>
	#include <stdio.h>
	#include <unistd.h>
	#include <sys/mman.h>

	int main() {
		int fd, i;
		char *buf;

		fd = open(DEV, O_RDONLY | O_DIRECT);

		buf = mmap(NULL, BUF_SIZE, PROT_READ | PROT_WRITE,
                	   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

		for (i = 0; i < BUF_SIZE; i += PAGE_SIZE)
			buf[i] = 1; // init to non-zero

		madvise(buf, BUF_SIZE, MADV_FREE);

		read(fd, buf, BUF_SIZE);

		for (i = 0; i < BUF_SIZE; i += PAGE_SIZE)
			printf("%p: 0x%x
", &buf[i], buf[i]);

		return 0;
	}

@ block/fops.c (formerly fs/block_dev.c)

	+#include <linux/swap.h>
	...
	... __blkdev_direct_IO[_simple](...)
	{
	...
	+	if (!strcmp(current->comm, "good"))
	+		shrink_all_memory(ULONG_MAX);
	+
         	ret = bio_iov_iter_get_pages(...);
	+
	+	if (!strcmp(current->comm, "bad"))
	+		shrink_all_memory(ULONG_MAX);
	...
	}

@ shell

	# yes | dd of=test.img bs=1k count=16
	# DEV=$(losetup -f --show test.img)
	# gcc -DDEV=\"$DEV\" -DBUF_SIZE=16384 -DPAGE_SIZE=4096 test.c -o test

	# od -tx1 $DEV
	0000000 79 0a 79 0a 79 0a 79 0a 79 0a 79 0a 79 0a 79 0a
	*
	0040000

	# mv test good
	# ./good
	0x7f1509206000: 0x79
	0x7f1509207000: 0x79
	0x7f1509208000: 0x79
	0x7f1509209000: 0x79

	# mv good bad
	# ./bad
	0x7fd87272f000: 0x0
	0x7fd872730000: 0x0
	0x7fd872731000: 0x0
	0x7fd872732000: 0x0

Ceph/TCMalloc:
=============

For documentation purposes, the use case driving the analysis/fix is Ceph
on Ubuntu 18.04, as the TCMalloc library there still uses MADV_FREE to
release unused memory to the system from the mmap'ed page heap (might be
committed back/used again; it's not munmap'ed.)
- PageHeap::DecommitSpan() -> TCMalloc_SystemRelease() -> madvise()
- PageHeap::CommitSpan() -> TCMalloc_SystemCommit() -> do nothing.

Note: TCMalloc switched back to MADV_DONTNEED a few commits after the
release in Ubuntu 18.04 (google-perftools/gperftools 2.5), so the issue
just 'disappeared' on Ceph on later Ubuntu releases but is still present
in the kernel, and can be hit by other use cases.

The observed issue seems to be the old Ceph bug #22464 [1], where checksum
mismatches are observed (and instrumentation with buffer dumps shows
zero-pages read from mmap'ed/MADV_FREE'd page ranges).

The issue in Ceph was reasonably deemed a kernel bug (comment #50) and
mostly worked around with a retry mechanism, but other parts of Ceph could
still hit that (rocksdb).  Anyway, it's less likely to be hit again as
TCMalloc switched out of MADV_FREE by default.

(Some kernel versions/reports from the Ceph bug, and relation with
the MADV_FREE introduction/changes; TCMalloc versions not checked.)
- 4.4 good
- 4.5 (madv_free: introduction)
- 4.9 bad
- 4.10 good? maybe a swapless system
- 4.12 (madv_free: no longer free instantly on swapless systems)
- 4.13 bad

[1] https://tracker.ceph.com/issues/22464

Thanks:
======

Several people contributed to analysis/discussions/tests/reproducers
in the first stages when drilling down on ceph/tcmalloc/linux kernel:

- Dan Hill
- Dan Streetman
- Dongdong Tao
- Gavin Guo
- Gerald Yang
- Heitor Alves de Siqueira
- Ioanna Alifieraki
- Jay Vosburgh
- Matthew Ruffell
- Ponnuvel Palaniyappan

Link: https://lkml.kernel.org/r/20211211022115.1547617-1-mfo@canonical.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: Dan Hill <daniel.hill@canonical.com>
Cc: Dan Streetman <dan.streetman@canonical.com>
Cc: Dongdong Tao <dongdong.tao@canonical.com>
Cc: Gavin Guo <gavin.guo@canonical.com>
Cc: Gerald Yang <gerald.yang@canonical.com>
Cc: Heitor Alves de Siqueira <halves@canonical.com>
Cc: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Cc: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Ponnuvel Palaniyappan <ponnuvel.palaniyappan@canonical.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c   |   13 ++++++++++++-
 mm/vmscan.c |    2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read
+++ a/mm/rmap.c
@@ -1570,7 +1570,18 @@ static bool try_to_unmap_one(struct page
 
 			/* MADV_FREE page check */
 			if (!PageSwapBacked(page)) {
-				if (!PageDirty(page)) {
+				int refcount = page_ref_count(page);
+
+				/*
+				 * The only page refs must be from the isolation
+				 * (checked by the caller shrink_page_list() too)
+				 * and the (single) rmap (dropped by discard:).
+				 *
+				 * Check the reference count before dirty flag
+				 * with memory barrier; see __remove_mapping().
+				 */
+				smp_rmb();
+				if (refcount == 2 && !PageDirty(page)) {
 					/* Invalidate as we cleared the pte */
 					mmu_notifier_invalidate_range(mm,
 						address, address + PAGE_SIZE);
--- a/mm/vmscan.c~mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read
+++ a/mm/vmscan.c
@@ -1729,7 +1729,7 @@ retry:
 				mapping = page_mapping(page);
 			}
 		} else if (unlikely(PageTransHuge(page))) {
-			/* Split file THP */
+			/* Split file/lazyfree THP */
 			if (split_huge_page_to_list(page, page_list))
 				goto keep_locked;
 		}
_

Patches currently in -mm which might be from mfo@canonical.com are

mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch

