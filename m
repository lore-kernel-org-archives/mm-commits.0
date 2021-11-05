Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2E1C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B877C611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhKEUlG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhKEUlF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D11E611C4;
        Fri,  5 Nov 2021 20:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144705;
        bh=MLR4U50RT2yuKzbSmLF7KMClNgDVmIHCRhN6LqHDA00=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oGr7Qywh7TabM8X8doTvLkWtMHIxFonRL7FdwNdL9oSp0OOIX+QAIMKmUd+O78gH0
         /FD2Nm9SUNHOyPw95R8I/8EoiSuGk4RuYz0MJROiXbZAnxXblTz75RzVejjuAdVdnR
         5d0O8YcWfc7LqLL6DqCLLNOL1rH1qwyapmHdrOsE=
Date:   Fri, 05 Nov 2021 13:38:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        axelrasmussen@google.com, david@redhat.com, hughd@google.com,
        jglisse@redhat.com, kirill@shutemov.name, liam.howlett@oracle.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 072/262] mm/shmem: unconditionally set pte dirty
 in mfill_atomic_install_pte
Message-ID: <20211105203824.F5P-pkCc0%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: unconditionally set pte dirty in mfill_atomic_install_pte

Patch series "mm: A few cleanup patches around zap, shmem and uffd", v4.

IMHO all of them are very nice cleanups to existing code already, they're
all small and self-contained.  They'll be needed by uffd-wp coming series.


This patch (of 4):

It was conditionally done previously, as there's one shmem special case
that we use SetPageDirty() instead.  However that's not necessary and it
should be easier and cleaner to do it unconditionally in
mfill_atomic_install_pte().

The most recent discussion about this is here, where Hugh explained the
history of SetPageDirty() and why it's possible that it's not required at
all:

https://lore.kernel.org/lkml/alpine.LSU.2.11.2104121657050.1097@eggly.anvils/

Currently mfill_atomic_install_pte() has three callers:

        1. shmem_mfill_atomic_pte
        2. mcopy_atomic_pte
        3. mcontinue_atomic_pte

After the change: case (1) should have its SetPageDirty replaced by the
dirty bit on pte (so we unify them together, finally), case (2) should
have no functional change at all as it has page_in_cache==false, case (3)
may add a dirty bit to the pte.  However since case (3) is UFFDIO_CONTINUE
for shmem, it's merely 100% sure the page is dirty after all because
UFFDIO_CONTINUE normally requires another process to modify the page cache
and kick the faulted thread, so should not make a real difference either.

This should make it much easier to follow on which case will set dirty for
uffd, as we'll simply set it all now for all uffd related ioctls. 
Meanwhile, no special handling of SetPageDirty() if there's no need.

Link: https://lkml.kernel.org/r/20210915181456.10739-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210915181456.10739-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c       |    1 -
 mm/userfaultfd.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte
+++ a/mm/shmem.c
@@ -2423,7 +2423,6 @@ int shmem_mfill_atomic_pte(struct mm_str
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 
-	SetPageDirty(page);
 	unlock_page(page);
 	return 0;
 out_delete_from_cache:
--- a/mm/userfaultfd.c~mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte
+++ a/mm/userfaultfd.c
@@ -69,10 +69,9 @@ int mfill_atomic_install_pte(struct mm_s
 	pgoff_t offset, max_off;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
+	_dst_pte = pte_mkdirty(_dst_pte);
 	if (page_in_cache && !vm_shared)
 		writable = false;
-	if (writable || !page_in_cache)
-		_dst_pte = pte_mkdirty(_dst_pte);
 	if (writable) {
 		if (wp_copy)
 			_dst_pte = pte_mkuffd_wp(_dst_pte);
_
