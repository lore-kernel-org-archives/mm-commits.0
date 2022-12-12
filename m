Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6781EC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiLLCNy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiLLCNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3064BF47
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDAD60E77
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A1EC433F2;
        Mon, 12 Dec 2022 02:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811218;
        bh=easN8WYrG+FHl0DkVGSK1ZG/ES0EaWk6wX5ognBwJNU=;
        h=Date:To:From:Subject:From;
        b=W17jvKY6YN72gs+J/YEZQupY/yRxJADalHBdzb2gt+n2oc3zwOxLBr9YRYcIhv8Qg
         nhglgyrry6MUK0DcpeXwYze3PHqGA0iU6QzrwnNsZOAu2mJwnYdoy5Cbb04v7rYKCE
         SwDao0AH/rvnqCApTVVZ3yMazenmu86Uob6fj14k=
Date:   Sun, 11 Dec 2022 18:13:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch removed from -mm tree
Message-Id: <20221212021338.18A1EC433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: fix KSM COW breaking with userfaultfd-wp via FAULT_FLAG_UNSHARE
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: fix KSM COW breaking with userfaultfd-wp via FAULT_FLAG_UNSHARE
Date: Fri, 21 Oct 2022 12:11:37 +0200

Let's stop breaking COW via a fake write fault and let's use
FAULT_FLAG_UNSHARE instead.  This avoids any wrong side effects of the
fake write fault, such as mapping the PTE writable and marking the pte
dirty/softdirty.

Consequently, we will no longer trigger a fake write fault and break COW
without any such side-effects.

Also, this fixes KSM interaction with userfaultfd-wp: when we have a KSM
page that's write-protected by userfaultfd, break_ksm()->handle_mm_fault()
will fail with VM_FAULT_SIGBUS and will simply return in break_ksm() with
0 instead of actually breaking COW.

For now, the KSM unmerge tests can trigger that:
    $ sudo ./ksm_functional_tests
    TAP version 13
    1..3
    # [RUN] test_unmerge
    ok 1 Pages were unmerged
    # [RUN] test_unmerge_discarded
    ok 2 Pages were unmerged
    # [RUN] test_unmerge_uffd_wp
    not ok 3 Pages were unmerged
    Bail out! 1 out of 3 tests failed
    # Planned tests != run tests (2 != 3)
    # Totals: pass:2 fail:1 xfail:0 xpass:0 skip:0 error:0

The warning in dmesg also indicates this wrong handling:
    [  230.096368] FAULT_FLAG_ALLOW_RETRY missing 881
    [  230.100822] CPU: 1 PID: 1643 Comm: ksm-uffd-wp [...]
    [  230.110124] Hardware name: [...]
    [  230.117775] Call Trace:
    [  230.120227]  <TASK>
    [  230.122334]  dump_stack_lvl+0x44/0x5c
    [  230.126010]  handle_userfault.cold+0x14/0x19
    [  230.130281]  ? tlb_finish_mmu+0x65/0x170
    [  230.134207]  ? uffd_wp_range+0x65/0xa0
    [  230.137959]  ? _raw_spin_unlock+0x15/0x30
    [  230.141972]  ? do_wp_page+0x50/0x590
    [  230.145551]  __handle_mm_fault+0x9f5/0xf50
    [  230.149652]  ? mmput+0x1f/0x40
    [  230.152712]  handle_mm_fault+0xb9/0x2a0
    [  230.156550]  break_ksm+0x141/0x180
    [  230.159964]  unmerge_ksm_pages+0x60/0x90
    [  230.163890]  ksm_madvise+0x3c/0xb0
    [  230.167295]  do_madvise.part.0+0x10c/0xeb0
    [  230.171396]  ? do_syscall_64+0x67/0x80
    [  230.175157]  __x64_sys_madvise+0x5a/0x70
    [  230.179082]  do_syscall_64+0x58/0x80
    [  230.182661]  ? do_syscall_64+0x67/0x80
    [  230.186413]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

This is primarily a fix for KSM+userfaultfd-wp, however, the fake write
fault was always questionable.  As this fix is not easy to backport and
it's not very critical, let's not cc stable.

Link: https://lkml.kernel.org/r/20221021101141.84170-6-david@redhat.com
Fixes: 529b930b87d9 ("userfaultfd: wp: hook userfault handler to write protection fault")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare
+++ a/mm/ksm.c
@@ -420,17 +420,15 @@ static inline bool ksm_test_exit(struct
 }
 
 /*
- * We use break_ksm to break COW on a ksm page: it's a stripped down
+ * We use break_ksm to break COW on a ksm page by triggering unsharing,
+ * such that the ksm page will get replaced by an exclusive anonymous page.
  *
- *	if (get_user_pages(addr, 1, FOLL_WRITE, &page, NULL) == 1)
- *		put_page(page);
- *
- * but taking great care only to touch a ksm page, in a VM_MERGEABLE vma,
+ * We take great care only to touch a ksm page, in a VM_MERGEABLE vma,
  * in case the application has unmapped and remapped mm,addr meanwhile.
  * Could a ksm page appear anywhere else?  Actually yes, in a VM_PFNMAP
  * mmap of /dev/mem, where we would not want to touch it.
  *
- * FAULT_FLAG/FOLL_REMOTE are because we do this outside the context
+ * FAULT_FLAG_REMOTE/FOLL_REMOTE are because we do this outside the context
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
@@ -454,7 +452,7 @@ static int break_ksm(struct vm_area_stru
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
-				      FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE,
+				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
 	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
 	/*
_

Patches currently in -mm which might be from david@redhat.com are


