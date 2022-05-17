Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C317C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 23:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiEQXj7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 19:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiEQXjy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 19:39:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5916653B5F
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 16:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D19526146E
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 23:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BB3C385B8;
        Tue, 17 May 2022 23:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652830782;
        bh=FApLaU4vJe911kpXN2F0mXrjapkGRygNiSkUryCLWZI=;
        h=Date:To:From:Subject:From;
        b=b5tjKrDHXWkaiiX6RZVsiFxJUbTZF9osjBI74YYvp10uJVs+CeRbcS8O9ZtLxFHOe
         3pH6VuqO56dES1bIo7zp6OV9JnLLQ2aBeYsYZheQepE4z+ObuJ6CHuubHV4zaJ8o2M
         ESL7xYP1D7CFDb+H0oGaAaZ8pKdtK5IRuGBhw9cA=
Date:   Tue, 17 May 2022 16:39:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-helper-swap_offset_available-fix.patch added to mm-unstable branch
Message-Id: <20220517233942.36BB3C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-add-helper-swap_offset_available-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-add-helper-swap_offset_available-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-helper-swap_offset_available-fix.patch

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

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

