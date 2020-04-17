From: akpm@linux-foundation.org
Subject: +
 mm-swap-properly-update-readahead-statistics-in-unuse_pte_range.patch added
 to -mm tree
Date: Thu, 16 Apr 2020 21:09:11 -0700
Message-ID: <20200417040911.z3FIIGx2_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEJN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 00:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anchalag@amazon.com, andrea.righi@canonical.com, hughd@google.com, kelleynnn@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, vpillai@digitalocean.com, ying.huang@intel.com


The patch titled
     Subject: mm: swap: properly update readahead statistics in unuse_pte_range()
has been added to the -mm tree.  Its filename is
     mm-swap-properly-update-readahead-statistics-in-unuse_pte_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-properly-update-readahead-statistics-in-unuse_pte_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-properly-update-readahead-statistics-in-unuse_pte_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Righi <andrea.righi@canonical.com>
Subject: mm: swap: properly update readahead statistics in unuse_pte_range()

In unuse_pte_range() we blindly swap-in pages without checking if the swap
entry is already present in the swap cache.

By doing this, the hit/miss ratio used by the swap readahead heuristic is
not properly updated and this leads to non-optimal performance during
swapoff.

Tracing the distribution of the readahead size returned by the swap
readahead heuristic during swapoff shows that a small readahead size is
used most of the time as if we had only misses (this happens both with
cluster and vma readahead), for example:

r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
        COUNT      EVENT
        36948      $retval = 8
        44151      $retval = 4
        49290      $retval = 1
        527771     $retval = 2

Checking if the swap entry is present in the swap cache, instead, allows
to properly update the readahead statistics and the heuristic behaves in
a better way during swapoff, selecting a bigger readahead size:

r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
        COUNT      EVENT
        1618       $retval = 1
        4960       $retval = 2
        41315      $retval = 4
        103521     $retval = 8

In terms of swapoff performance the result is the following:

Testing environment
===================

 - Host:
   CPU: 1.8GHz Intel Core i7-8565U (quad-core, 8MB cache)
   HDD: PC401 NVMe SK hynix 512GB
   MEM: 16GB

 - Guest (kvm):
   8GB of RAM
   virtio block driver
   16GB swap file on ext4 (/swapfile)

Test case
=========
 - allocate 85% of memory
 - `systemctl hibernate` to force all the pages to be swapped-out to the
   swap file
 - resume the system
 - measure the time that swapoff takes to complete:
   # /usr/bin/time swapoff /swapfile

Result (swapoff time)
======
                  5.6 vanilla   5.6 w/ this patch
                  -----------   -----------------
cluster-readahead      22.09s              12.19s
    vma-readahead      18.20s              15.33s

Link: http://lkml.kernel.org/r/20200416180132.GB3352@xps-13
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Anchal Agarwal <anchalag@amazon.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vineeth Remanan Pillai <vpillai@digitalocean.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swap-properly-update-readahead-statistics-in-unuse_pte_range
+++ a/mm/swapfile.c
@@ -1937,10 +1937,14 @@ static int unuse_pte_range(struct vm_are
 
 		pte_unmap(pte);
 		swap_map = &si->swap_map[offset];
-		vmf.vma = vma;
-		vmf.address = addr;
-		vmf.pmd = pmd;
-		page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, &vmf);
+		page = lookup_swap_cache(entry, vma, addr);
+		if (!page) {
+			vmf.vma = vma;
+			vmf.address = addr;
+			vmf.pmd = pmd;
+			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
+						&vmf);
+		}
 		if (!page) {
 			if (*swap_map == 0 || *swap_map == SWAP_MAP_BAD)
 				goto try_next;
_

Patches currently in -mm which might be from andrea.righi@canonical.com are

mm-swap-properly-update-readahead-statistics-in-unuse_pte_range.patch
