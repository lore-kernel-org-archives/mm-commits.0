Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1946C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 900756124C
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhJEXfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhJEXfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6ABF610A8;
        Tue,  5 Oct 2021 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633476825;
        bh=8NiC9kOxuaHlxlf7fhixb5eL+v7hzE6tdmIqU1HktDk=;
        h=Date:From:To:Subject:From;
        b=PY+j04u1meUhES+ziLUIZSmWAulX28z4FbIk5tbTXzhqOoFfbvkr/+IyScPhL5V84
         RIH099vVRAblYxgObe9LASrXvi8GAVD0oW9bwEUFrFX2MHozWi1NtIYylUpsr/63Sd
         yGRRDc5KOA75ogp2R0Ho+mMIw+macyDaTcD7mgNg=
Date:   Tue, 05 Oct 2021 16:33:44 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hch@infradead.org, hdanton@sina.com,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, oleksiy.avramchenko@sonymobile.com,
        pifang@redhat.com, rostedt@goodmis.org, urezki@gmail.com,
        willy@infradead.org
Subject:  +
 mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead.patch added
 to -mm tree
Message-ID: <20211005233344.bT4r4xuwr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: do not adjust the search size for alignment overhead
has been added to the -mm tree.  Its filename is
     mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: do not adjust the search size for alignment overhead

We used to include an alignment overhead into a search length, in that
case we guarantee that a found area will definitely fit after applying a
specific alignment that user specifies.  From the other hand we do not
guarantee that an area has the lowest address if an alignment is >=
PAGE_SIZE.

It means that, when a user specifies a special alignment together with a
range that corresponds to an exact requested size then an allocation will
fail.  This is what happens to KASAN, it wants the free block that exactly
matches a specified range during onlining memory banks:

[root@vm-0 fedora]# echo online > /sys/devices/system/memory/memory82/state
[root@vm-0 fedora]# echo online > /sys/devices/system/memory/memory83/state
[root@vm-0 fedora]# echo online > /sys/devices/system/memory/memory85/state
[root@vm-0 fedora]# echo online > /sys/devices/system/memory/memory84/state
[  223.858115] vmap allocation for size 16777216 failed: use vmalloc=<size> to increase size
[  223.859415] bash: vmalloc: allocation failure: 16777216 bytes, mode:0x6000c0(GFP_KERNEL), nodemask=(null),cpuset=/,mems_allowed=0
[  223.860992] CPU: 4 PID: 1644 Comm: bash Kdump: loaded Not tainted 4.18.0-339.el8.x86_64+debug #1
[  223.862149] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  223.863580] Call Trace:
[  223.863946]  dump_stack+0x8e/0xd0
[  223.864420]  warn_alloc.cold.90+0x8a/0x1b2
[  223.864990]  ? zone_watermark_ok_safe+0x300/0x300
[  223.865626]  ? slab_free_freelist_hook+0x85/0x1a0
[  223.866264]  ? __get_vm_area_node+0x240/0x2c0
[  223.866858]  ? kfree+0xdd/0x570
[  223.867309]  ? kmem_cache_alloc_node_trace+0x157/0x230
[  223.868028]  ? notifier_call_chain+0x90/0x160
[  223.868625]  __vmalloc_node_range+0x465/0x840
[  223.869230]  ? mark_held_locks+0xb7/0x120

Fix it by making sure that find_vmap_lowest_match() returns lowest start
address with any given alignment value, i.e.  for alignments bigger then
PAGE_SIZE the algorithm rolls back toward parent nodes checking right
sub-trees if the most left free block did not fit due to alignment
overhead.

Link: https://lkml.kernel.org/r/20211004142829.22222-1-urezki@gmail.com
Fixes: 68ad4a330433 ("mm/vmalloc.c: keep track of free blocks for vmap allocation")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: Ping Fang <pifang@redhat.com>
Tested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead
+++ a/mm/vmalloc.c
@@ -1195,18 +1195,14 @@ find_vmap_lowest_match(unsigned long siz
 {
 	struct vmap_area *va;
 	struct rb_node *node;
-	unsigned long length;
 
 	/* Start from the root. */
 	node = free_vmap_area_root.rb_node;
 
-	/* Adjust the search size for alignment overhead. */
-	length = size + align - 1;
-
 	while (node) {
 		va = rb_entry(node, struct vmap_area, rb_node);
 
-		if (get_subtree_max_size(node->rb_left) >= length &&
+		if (get_subtree_max_size(node->rb_left) >= size &&
 				vstart < va->va_start) {
 			node = node->rb_left;
 		} else {
@@ -1216,9 +1212,9 @@ find_vmap_lowest_match(unsigned long siz
 			/*
 			 * Does not make sense to go deeper towards the right
 			 * sub-tree if it does not have a free block that is
-			 * equal or bigger to the requested search length.
+			 * equal or bigger to the requested search size.
 			 */
-			if (get_subtree_max_size(node->rb_right) >= length) {
+			if (get_subtree_max_size(node->rb_right) >= size) {
 				node = node->rb_right;
 				continue;
 			}
@@ -1226,15 +1222,23 @@ find_vmap_lowest_match(unsigned long siz
 			/*
 			 * OK. We roll back and find the first right sub-tree,
 			 * that will satisfy the search criteria. It can happen
-			 * only once due to "vstart" restriction.
+			 * due to "vstart" restriction or an alignment overhead
+			 * that is bigger then PAGE_SIZE.
 			 */
 			while ((node = rb_parent(node))) {
 				va = rb_entry(node, struct vmap_area, rb_node);
 				if (is_within_this_va(va, size, align, vstart))
 					return va;
 
-				if (get_subtree_max_size(node->rb_right) >= length &&
+				if (get_subtree_max_size(node->rb_right) >= size &&
 						vstart <= va->va_start) {
+					/*
+					 * Shift the vstart forward. Please note, we update it with
+					 * parent's start address adding "1" because we do not want
+					 * to enter same sub-tree after it has already been checked
+					 * and no suitable free block found there.
+					 */
+					vstart = va->va_start + 1;
 					node = node->rb_right;
 					break;
 				}
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead.patch
mm-vmalloc-check-various-alignments-when-debugging.patch

