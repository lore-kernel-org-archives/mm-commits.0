Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E38C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04ED920786
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790458;
	bh=Mg3BbV+i1YytrQODK6nOXksC36fe+7yf4fR5WP/CNZg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JU56unG/RAmScuYrFI7JBKokLGx3f2tgB6IblkSs6n9arh7AGujHv5f7J136gsefg
	 qya5Rp2PumiUbv7ladNBKYf/gqYxles/H/FGxb86MbfBFe1K83N/2rNX9hu0TVFNif
	 GzmljycmW4/wIbybdnb0WMPdL8oVg4Bdk5KF7YDU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgHRWk5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHRWkz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58B820786;
        Tue, 18 Aug 2020 22:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790454;
        bh=Mg3BbV+i1YytrQODK6nOXksC36fe+7yf4fR5WP/CNZg=;
        h=Date:From:To:Subject:From;
        b=Pv4MDjq0oNwbD07nPRQHnd8dFVaOf932ybuT5siY79vR9IUJDt68lyNd8JDjYeur6
         FCOGtK6vhyt/FddFxGsALorJrETdJeGqhWcoLAqQp9PcK3eS1YTrbwfz+EYSRjHXCh
         pkmaM30ujzu1rpoUzTyHOWJgI4D2EYyCK/w4yJ90=
Date:   Tue, 18 Aug 2020 15:40:54 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, hughd@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-swapfile-fix-and-annotate-various-data-races.patch removed from -mm tree
Message-ID: <20200818224054.0RtT4y9JB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: fix and annotate various data races
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-and-annotate-various-data-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/swapfile: fix and annotate various data races

swap_info_struct si.highest_bit, si.swap_map[offset] and si.flags could
be accessed concurrently separately as noticed by KCSAN,

=== si.highest_bit ===

 write to 0xffff8d5abccdc4d4 of 4 bytes by task 5353 on cpu 24:
  swap_range_alloc+0x81/0x130
  swap_range_alloc at mm/swapfile.c:681
  scan_swap_map_slots+0x371/0xb90
  get_swap_pages+0x39d/0x5c0
  get_swap_page+0xf2/0x524
  add_to_swap+0xe4/0x1c0
  shrink_page_list+0x1795/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290

 read to 0xffff8d5abccdc4d4 of 4 bytes by task 6672 on cpu 70:
  scan_swap_map_slots+0x4a6/0xb90
  scan_swap_map_slots at mm/swapfile.c:892
  get_swap_pages+0x39d/0x5c0
  get_swap_page+0xf2/0x524
  add_to_swap+0xe4/0x1c0
  shrink_page_list+0x1795/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 70 PID: 6672 Comm: oom01 Tainted: G        W    L 5.5.0-next-20200205+ #3
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

=== si.swap_map[offset] ===

 write to 0xffffbc370c29a64c of 1 bytes by task 6856 on cpu 86:
  __swap_entry_free_locked+0x8c/0x100
  __swap_entry_free_locked at mm/swapfile.c:1209 (discriminator 4)
  __swap_entry_free.constprop.20+0x69/0xb0
  free_swap_and_cache+0x53/0xa0
  unmap_page_range+0x7f8/0x1d70
  unmap_single_vma+0xcd/0x170
  unmap_vmas+0x18b/0x220
  exit_mmap+0xee/0x220
  mmput+0x10e/0x270
  do_exit+0x59b/0xf40
  do_group_exit+0x8b/0x180

 read to 0xffffbc370c29a64c of 1 bytes by task 6855 on cpu 20:
  _swap_info_get+0x81/0xa0
  _swap_info_get at mm/swapfile.c:1140
  free_swap_and_cache+0x40/0xa0
  unmap_page_range+0x7f8/0x1d70
  unmap_single_vma+0xcd/0x170
  unmap_vmas+0x18b/0x220
  exit_mmap+0xee/0x220
  mmput+0x10e/0x270
  do_exit+0x59b/0xf40
  do_group_exit+0x8b/0x180

=== si.flags ===

 write to 0xffff956c8fc6c400 of 8 bytes by task 6087 on cpu 23:
  scan_swap_map_slots+0x6fe/0xb50
  scan_swap_map_slots at mm/swapfile.c:887
  get_swap_pages+0x39d/0x5c0
  get_swap_page+0x377/0x524
  add_to_swap+0xe4/0x1c0
  shrink_page_list+0x1795/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290

 read to 0xffff956c8fc6c400 of 8 bytes by task 6207 on cpu 63:
  _swap_info_get+0x41/0xa0
  __swap_info_get at mm/swapfile.c:1114
  put_swap_page+0x84/0x490
  __remove_mapping+0x384/0x5f0
  shrink_page_list+0xff1/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290

The writes are under si->lock but the reads are not. For si.highest_bit
and si.swap_map[offset], data race could trigger logic bugs, so fix them
by having WRITE_ONCE() for the writes and READ_ONCE() for the reads
except those isolated reads where they compare against zero which a data
race would cause no harm. Thus, annotate them as intentional data races
using the data_race() macro.

For si.flags, the readers are only interested in a single bit where a
data race there would cause no issue there.

[cai@lca.pw: add a missing annotation for si->flags in memory.c]
  Link: http://lkml.kernel.org/r/1581612647-5958-1-git-send-email-cai@lca.pw
Link: http://lkml.kernel.org/r/1581095163-12198-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    4 ++--
 mm/swapfile.c |   31 ++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-swapfile-fix-and-annotate-various-data-races
+++ a/mm/memory.c
@@ -3130,8 +3130,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!page) {
 		struct swap_info_struct *si = swp_swap_info(entry);
 
-		if (si->flags & SWP_SYNCHRONOUS_IO &&
-				__swap_count(entry) == 1) {
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
+		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 							vmf->address);
--- a/mm/swapfile.c~mm-swapfile-fix-and-annotate-various-data-races
+++ a/mm/swapfile.c
@@ -672,7 +672,7 @@ static void swap_range_alloc(struct swap
 	if (offset == si->lowest_bit)
 		si->lowest_bit += nr_entries;
 	if (end == si->highest_bit)
-		si->highest_bit -= nr_entries;
+		WRITE_ONCE(si->highest_bit, si->highest_bit - nr_entries);
 	si->inuse_pages += nr_entries;
 	if (si->inuse_pages == si->pages) {
 		si->lowest_bit = si->max;
@@ -705,7 +705,7 @@ static void swap_range_free(struct swap_
 	if (end > si->highest_bit) {
 		bool was_full = !si->highest_bit;
 
-		si->highest_bit = end;
+		WRITE_ONCE(si->highest_bit, end);
 		if (was_full && (si->flags & SWP_WRITEOK))
 			add_to_avail_list(si);
 	}
@@ -870,7 +870,7 @@ checks:
 		else
 			goto done;
 	}
-	si->swap_map[offset] = usage;
+	WRITE_ONCE(si->swap_map[offset], usage);
 	inc_cluster_info_page(si, si->cluster_info, offset);
 	unlock_cluster(ci);
 
@@ -929,12 +929,13 @@ done:
 
 scan:
 	spin_unlock(&si->lock);
-	while (++offset <= si->highest_bit) {
-		if (!si->swap_map[offset]) {
+	while (++offset <= READ_ONCE(si->highest_bit)) {
+		if (data_race(!si->swap_map[offset])) {
 			spin_lock(&si->lock);
 			goto checks;
 		}
-		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+		if (vm_swap_full() &&
+		    READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
 			spin_lock(&si->lock);
 			goto checks;
 		}
@@ -946,11 +947,12 @@ scan:
 	}
 	offset = si->lowest_bit;
 	while (offset < scan_base) {
-		if (!si->swap_map[offset]) {
+		if (data_race(!si->swap_map[offset])) {
 			spin_lock(&si->lock);
 			goto checks;
 		}
-		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+		if (vm_swap_full() &&
+		    READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
 			spin_lock(&si->lock);
 			goto checks;
 		}
@@ -1149,7 +1151,7 @@ static struct swap_info_struct *__swap_i
 	p = swp_swap_info(entry);
 	if (!p)
 		goto bad_nofile;
-	if (!(p->flags & SWP_USED))
+	if (data_race(!(p->flags & SWP_USED)))
 		goto bad_device;
 	offset = swp_offset(entry);
 	if (offset >= p->max)
@@ -1175,7 +1177,7 @@ static struct swap_info_struct *_swap_in
 	p = __swap_info_get(entry);
 	if (!p)
 		goto out;
-	if (!p->swap_map[swp_offset(entry)])
+	if (data_race(!p->swap_map[swp_offset(entry)]))
 		goto bad_free;
 	return p;
 
@@ -1244,7 +1246,10 @@ static unsigned char __swap_entry_free_l
 	}
 
 	usage = count | has_cache;
-	p->swap_map[offset] = usage ? : SWAP_HAS_CACHE;
+	if (usage)
+		WRITE_ONCE(p->swap_map[offset], usage);
+	else
+		WRITE_ONCE(p->swap_map[offset], SWAP_HAS_CACHE);
 
 	return usage;
 }
@@ -1296,7 +1301,7 @@ struct swap_info_struct *get_swap_device
 		goto bad_nofile;
 
 	rcu_read_lock();
-	if (!(si->flags & SWP_VALID))
+	if (data_race(!(si->flags & SWP_VALID)))
 		goto unlock_out;
 	offset = swp_offset(entry);
 	if (offset >= si->max)
@@ -3484,7 +3489,7 @@ static int __swap_duplicate(swp_entry_t
 	} else
 		err = -ENOENT;			/* unused swap entry */
 
-	p->swap_map[offset] = count | has_cache;
+	WRITE_ONCE(p->swap_map[offset], count | has_cache);
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

