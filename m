Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20211C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 20:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiESU57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 16:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242104AbiESU56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 16:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0734EC3D1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 13:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80252B8288D
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 20:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3906DC385B8;
        Thu, 19 May 2022 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652993875;
        bh=//wictz7xGEX7zTjjgfqdhV/NbZNigmcpeQB2Lh0hos=;
        h=Date:To:From:Subject:From;
        b=McD2luS2qX5Y6wpZonya7qNyrrzusmKqqUYB8f7m9syCB72rdOyBWNJNpfEmQJSOA
         lf/q2nDo2lDr/LeqlbtI0L1c/+rNxol9dg73x1HRYr86jqRZGkHlIJI15Ji5tJKw81
         rqS8LQC1k26kNwkrDl0kMc2u+RxhgZ3lpSfE/Xh0=
Date:   Thu, 19 May 2022 13:57:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-add-helper-swap_offset_available-fix.patch removed from -mm tree
Message-Id: <20220519205755.3906DC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-add-helper-swap_offset_available-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-add-helper-swap_offset_available-fix.patch

This patch was dropped because it was folded into mm-swap-add-helper-swap_offset_available.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-add-helper-swap_offset_available-fix
Date: Tue May 17 04:34:25 PM PDT 2022

s/swap_offset_available/swap_offset_available_and_locked/, per Neil

Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-add-helper-swap_offset_available-fix
+++ a/mm/swapfile.c
@@ -775,7 +775,8 @@ static void set_cluster_next(struct swap
 	this_cpu_write(*si->cluster_next_cpu, next);
 }
 
-static inline bool swap_offset_available(struct swap_info_struct *si, unsigned long offset)
+static bool swap_offset_available_and_locked(struct swap_info_struct *si,
+					     unsigned long offset)
 {
 	if (data_race(!si->swap_map[offset])) {
 		spin_lock(&si->lock);
@@ -967,7 +968,7 @@ done:
 scan:
 	spin_unlock(&si->lock);
 	while (++offset <= READ_ONCE(si->highest_bit)) {
-		if (swap_offset_available(si, offset))
+		if (swap_offset_available_and_locked(si, offset))
 			goto checks;
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
@@ -977,7 +978,7 @@ scan:
 	}
 	offset = si->lowest_bit;
 	while (offset < scan_base) {
-		if (swap_offset_available(si, offset))
+		if (swap_offset_available_and_locked(si, offset))
 			goto checks;
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap-add-helper-swap_offset_available.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

