Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52197C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 098F761A26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCXW1g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhCXW1a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEACB61A1D;
        Wed, 24 Mar 2021 22:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616624850;
        bh=yao0S+P7cbCevuzJJdtppDJOPc/9ArGA32qf8V2mKOg=;
        h=Date:From:To:Subject:From;
        b=kpw+RRhPmgjeAWkQbUWPq79c0rWc5EFArVtDB8qAH50t/pK4kBiDDv3fI8Rk5V1X0
         Jv9e07ut7dNrsNemAQDAuBJNYOE/QP2WTTi8ztRbUhpSu9Hoq0MSZ+qwKTeq1mlcu3
         D1A/LFtbx8SZ1tnmoiE/B/QZMT/wjjGDJMXgzkAk=
Date:   Wed, 24 Mar 2021 15:27:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sonnyrao@google.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, mst@redhat.com,
        minchan@kernel.org, luto@amacapital.net, lokeshgidra@google.com,
        kirill@shutemov.name, hughd@google.com, axelrasmussen@google.com,
        aarcange@redhat.com, bgeffon@google.com
Subject:  [to-be-updated]
 mm-allow-shmem-mappings-with-mremap_dontunmap.patch removed from -mm tree
Message-ID: <20210324222729.Ojs6p%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow shmem mappings with MREMAP_DONTUNMAP
has been removed from the -mm tree.  Its filename was
     mm-allow-shmem-mappings-with-mremap_dontunmap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm: allow shmem mappings with MREMAP_DONTUNMAP

Currently MREMAP_DONTUNMAP only accepts private anonymous mappings.  This
change will widen the support to include shmem mappings.  The primary use
case is to support MREMAP_DONTUNMAP on mappings which may have been
created from a memfd.

Lokesh Gidra who works on the Android JVM, provided an explanation of how
such a feature will improve Android JVM garbage collection: "Android is
developing a new garbage collector (GC), based on userfaultfd.  The
garbage collector will use userfaultfd (uffd) on the java heap during
compaction.  On accessing any uncompacted page, the application threads
will find it missing, at which point the thread will create the compacted
page and then use UFFDIO_COPY ioctl to get it mapped and then resume
execution.  Before starting this compaction, in a stop-the-world pause the
heap will be mremap(MREMAP_DONTUNMAP) so that the java heap is ready to
receive UFFD_EVENT_PAGEFAULT events after resuming execution.

To speedup mremap operations, pagetable movement was optimized by moving
PUD entries instead of PTE entries [1].  It was necessary as mremap of
even modest sized memory ranges also took several milliseconds, and
stopping the application for that long isn't acceptable in response-time
sensitive cases.  With UFFDIO_CONTINUE feature [2], it will be even more
efficient to implement this GC, particularly the 'non-moveable' portions
of the heap.  It will also help in reducing the need to copy (UFFDIO_COPY)
the pages.  However, for this to work, the java heap has to be on a
'shared' vma.  Currently MREMAP_DONTUNMAP only supports private anonymous
mappings, this patch will enable using UFFDIO_CONTINUE for the new
userfaultfd-based heap compaction."

[1] https://lore.kernel.org/linux-mm/20201215030730.NC3CU98e4%25akpm@linux-foundation.org/
[2] https://lore.kernel.org/linux-mm/20210302000133.272579-1-axelrasmussen@google.com/
Link: https://lkml.kernel.org/r/20210303175235.3308220-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Tested-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mremap.c~mm-allow-shmem-mappings-with-mremap_dontunmap
+++ a/mm/mremap.c
@@ -653,8 +653,7 @@ static struct vm_area_struct *vma_to_res
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (flags & MREMAP_DONTUNMAP && (!vma_is_anonymous(vma) ||
-			vma->vm_flags & VM_SHARED))
+	if (flags & MREMAP_DONTUNMAP && !(vma_is_anonymous(vma) || vma_is_shmem(vma)))
 		return ERR_PTR(-EINVAL);
 
 	if (is_vm_hugetlb_page(vma))
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch
revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio.patch
selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch

