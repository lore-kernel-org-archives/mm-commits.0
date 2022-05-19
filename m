Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFDFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241058AbiESU5i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 16:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiESU5h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 16:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79657EC330
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 13:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CDC4B827DD
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 20:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64F5C385AA;
        Thu, 19 May 2022 20:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652993854;
        bh=YhBlEzNrsdCG4clWS20P7T68DSwQGrJ3HqY2Vih9Jlw=;
        h=Date:To:From:Subject:From;
        b=f0kLfrEtFUH9j9Z6i+ZAsHd31Lk9WFMrcWuhlzca4XMOPvo6rX9+Nz/q811ufnQ+h
         BD2ScimOUAg4psyl8FswALIgib1ThYH6udre3yV+nMeKVx2ydTOgsqUNuuXEitbLLw
         8emcHgI0Rimg6KzM8Hj6jJ+uN6M1qiECxB+Xw8ig=
Date:   Thu, 19 May 2022 13:57:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch removed from -mm tree
Message-Id: <20220519205733.E64F5C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch

This patch was dropped because it was folded into mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix
Date: Tue May 17 04:31:16 PM PDT 2022

use data_race() on si->flags, per Neil

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

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix
+++ a/mm/memory.c
@@ -3889,7 +3889,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			exclusive = true;
 		} else if (exclusive && PageWriteback(page) &&
-			  (si->flags & SWP_STABLE_WRITES)) {
+			  data_race(si->flags & SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

