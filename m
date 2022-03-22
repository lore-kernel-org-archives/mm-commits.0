Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F42C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiCVTPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiCVTPi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:15:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8835CBF6F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 319B9B81D59
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3379C340F0;
        Tue, 22 Mar 2022 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976447;
        bh=v303HEFxJr2MniwaRskUGpmhDfsuJ5m66rSwxBqCS8Q=;
        h=Date:To:From:Subject:From;
        b=bSNN9t9By94neApJIqA9SQPCfcIVn8vkm8ucJleK15+HWuHTf4pHqNUUbaucrevCm
         EJP3o06EKA/TYiN7I+MrPfWAq7XW7XUhftzss1Q7MOCyY/aETU5qPkQwbWLnQeHDlB
         h7biY47w1tTqn+T6haAD7eA+fA3eq0sHTyIm3BjY=
Date:   Tue, 22 Mar 2022 12:14:07 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, namit@vmware.com,
        jack@suse.cz, david@redhat.com, aarcange@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch removed from -mm tree
Message-Id: <20220322191407.B3379C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-provide-unmasked-address-on-page-fault-v3-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch

This patch was dropped because it was folded into userfaultfd-provide-unmasked-address-on-page-fault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-provide-unmasked-address-on-page-fault-v3-fix

fix typo in comment, per Jan

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~userfaultfd-provide-unmasked-address-on-page-fault-v3-fix
+++ a/include/linux/mm.h
@@ -479,7 +479,7 @@ struct vm_fault {
 		gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 		pgoff_t pgoff;			/* Logical page offset based on vma */
 		unsigned long address;		/* Faulting virtual address - masked */
-		unsigned long real_address;	/* Faulting virtual address - unmaked */
+		unsigned long real_address;	/* Faulting virtual address - unmasked */
 	};
 	enum fault_flag flags;		/* FAULT_FLAG_xxx flags
 					 * XXX: should really be 'const' */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

userfaultfd-provide-unmasked-address-on-page-fault.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

