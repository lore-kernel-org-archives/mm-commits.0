Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944AFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 23:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiEQXjy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 19:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiEQXjl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 19:39:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC88353B42
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 16:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AF556148C
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 23:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D16C385B8;
        Tue, 17 May 2022 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652830780;
        bh=7CjFpuumXL5ux4kdzgLb+sbXyofqzMB74DB/yh1dNa8=;
        h=Date:To:From:Subject:From;
        b=Lk04kGZLNzsNlw+4SV5IgxOjAA8W3irIz7mGgHPtevprBLC36bxPqmgNwI02CMBUO
         +gPtBxeQEsxsyJ190Zr7W9Bie4W+Dkd6bLa5nPPetEaXeBW98PxRSW6S90rbTERNK1
         22W3TpjTCc6/opakucF6YJIz6YTIPZsBqLoqIXs0=
Date:   Tue, 17 May 2022 16:39:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch added to mm-unstable branch
Message-Id: <20220517233939.E1D16C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch

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

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

