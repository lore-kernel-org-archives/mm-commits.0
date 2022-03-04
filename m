Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C2AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 01:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiCDByu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiCDBys (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 20:54:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2D617BC48
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 17:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F6C6B82729
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 01:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ED3C004E1;
        Fri,  4 Mar 2022 01:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646358838;
        bh=Y8oDHEl/DJ33kLkULwrOBqGJaFYK/K68xQ66/tnl+qA=;
        h=Date:To:From:Subject:From;
        b=J/Cv+56HhhVlus3nc6VOFfO9qizfU+Y/CjyFU/1Xn7pmdKaK3o+tX9lSMKUFEW7Ko
         3XXkskIaeqc0BlwHCCZ3khW+kHyvLXcBjC3QUsb+rSOUnHTxXhdkbueQfetxtoag8f
         3tnHw0zSjkIvPAfZHQWni/H5iLmULJDrnLps7AYk=
Date:   Thu, 03 Mar 2022 17:53:57 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, namit@vmware.com,
        jack@suse.cz, david@redhat.com, aarcange@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch added to -mm tree
Message-Id: <20220304015358.54ED3C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-provide-unmasked-address-on-page-fault-v3-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

