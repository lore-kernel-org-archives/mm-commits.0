From: akpm@linux-foundation.org
Subject: + mm-page_alloc-cleanup-add_active_range-related-comments.patch
 added to -mm tree
Date: Thu, 29 May 2014 14:56:51 -0700
Message-ID: <5387ad23.Ps9sftRXVAtVegVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaE2V4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 17:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, zhenzhang.zhang@huawei.com

Subject: + mm-page_alloc-cleanup-add_active_range-related-comments.patch added to -mm tree
To: zhenzhang.zhang@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 14:56:51 -0700


The patch titled
     Subject: mm/page_alloc.c: cleanup add_active_range() related comments
has been added to the -mm tree.  Its filename is
     mm-page_alloc-cleanup-add_active_range-related-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-cleanup-add_active_range-related-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-cleanup-add_active_range-related-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/page_alloc.c: cleanup add_active_range() related comments

add_active_range() has been repalced by memblock_set_node().  Clean up the
comments to comply with that change.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-cleanup-add_active_range-related-comments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-cleanup-add_active_range-related-comments
+++ a/mm/page_alloc.c
@@ -4387,9 +4387,6 @@ int __meminit init_currently_empty_zone(
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
- * Architectures may implement their own version but if add_active_range()
- * was used and there are no special requirements, this is a convenient
- * alternative
  */
 int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
@@ -4444,10 +4441,9 @@ bool __meminit early_pfn_in_nid(unsigned
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
  * @max_low_pfn: The highest PFN that will be passed to memblock_free_early_nid
  *
- * If an architecture guarantees that all ranges registered with
- * add_active_ranges() contain no holes and may be freed, this
- * this function may be used instead of calling memblock_free_early_nid()
- * manually.
+ * If an architecture guarantees that all ranges registered contain no holes
+ * and may be freed, this this function may be used instead of calling
+ * memblock_free_early_nid() manually.
  */
 void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
 {
@@ -4469,9 +4465,8 @@ void __init free_bootmem_with_active_reg
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
  *
- * If an architecture guarantees that all ranges registered with
- * add_active_ranges() contain no holes and may be freed, this
- * function may be used instead of calling memory_present() manually.
+ * If an architecture guarantees that all ranges registered contain no holes and may
+ * be freed, this function may be used instead of calling memory_present() manually.
  */
 void __init sparse_memory_present_with_active_regions(int nid)
 {
@@ -4489,7 +4484,7 @@ void __init sparse_memory_present_with_a
  * @end_pfn: Passed by reference. On return, it will have the node end_pfn.
  *
  * It returns the start and end page frame of a node based on information
- * provided by an arch calling add_active_range(). If called for a node
+ * provided by memblock_set_node(). If called for a node
  * with no available memory, a warning is printed and the start and end
  * PFNs will be 0.
  */
@@ -5066,7 +5061,7 @@ static unsigned long __init find_min_pfn
  * find_min_pfn_with_active_regions - Find the minimum PFN registered
  *
  * It returns the minimum PFN based on information provided via
- * add_active_range().
+ * memblock_set_node().
  */
 unsigned long __init find_min_pfn_with_active_regions(void)
 {
@@ -5287,7 +5282,7 @@ static void check_for_memory(pg_data_t *
  * @max_zone_pfn: an array of max PFNs for each zone
  *
  * This will call free_area_init_node() for each active node in the system.
- * Using the page ranges provided by add_active_range(), the size of each
+ * Using the page ranges provided by memblock_set_node(), the size of each
  * zone in each node and their holes is calculated. If the maximum PFN
  * between two adjacent zones match, it is assumed that the zone is empty.
  * For example, if arch_max_dma_pfn == arch_max_dma32_pfn, it is assumed
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

mm-page_alloc-cleanup-add_active_range-related-comments.patch
linux-next.patch

