Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8190C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB3F6141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWnP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWnO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86ED961402;
        Sat,  8 May 2021 22:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513732;
        bh=71pUn1ewKBuA+u5skOgTpDjsakJnM7dPQnd9DCGK2Ro=;
        h=Date:From:To:Subject:From;
        b=UcfM9PGI4wQymKs4x+A+eVnzIX7LK14LBz/EzIo3UMnZrn1lScsMlb2UXJvjs23Fz
         0ilrmiQ0m0u2NwlKQ+eS3ukdtGN79N4ai5xL45RdptA8nIsx+Zi1uVFsmcQ7qznrSk
         a4aXR0wjh0w2s5L5v6+Me/ZTVgI+noxdc+FwnC2s=
Date:   Sat, 08 May 2021 15:42:11 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, aarcange@redhat.com, alx.manpages@gmail.com,
        bgeffon@google.com, hughd@google.com, kirill@shutemov.name,
        lokeshgidra@google.com, luto@amacapital.net, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, mtk.manpages@gmail.com,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, sonnyrao@google.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch removed from -mm
 tree
Message-ID: <20210508224211.CEPcCBTth%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: extend MREMAP_DONTUNMAP to non-anonymous mappings
has been removed from the -mm tree.  Its filename was
     mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm: extend MREMAP_DONTUNMAP to non-anonymous mappings

Patch series "mm: Extend MREMAP_DONTUNMAP to non-anonymous mappings", v5.


This patch (of 3):

Currently MREMAP_DONTUNMAP only accepts private anonymous mappings.  This
restriction was placed initially for simplicity and not because there
exists a technical reason to do so.

This change will widen the support to include any mappings which are not
VM_DONTEXPAND or VM_PFNMAP.  The primary use case is to support
MREMAP_DONTUNMAP on mappings which may have been created from a memfd. 
This change will result in mremap(MREMAP_DONTUNMAP) returning -EINVAL if
VM_DONTEXPAND or VM_PFNMAP mappings are specified.

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
sensitive cases.

With UFFDIO_CONTINUE feature [2], it will be even more efficient to
implement this GC, particularly the 'non-moveable' portions of the heap. 
It will also help in reducing the need to copy (UFFDIO_COPY) the pages. 
However, for this to work, the java heap has to be on a 'shared' vma. 
Currently MREMAP_DONTUNMAP only supports private anonymous mappings, this
patch will enable using UFFDIO_CONTINUE for the new userfaultfd-based heap
compaction."

[1] https://lore.kernel.org/linux-mm/20201215030730.NC3CU98e4%25akpm@linux-foundation.org/
[2] https://lore.kernel.org/linux-mm/20210302000133.272579-1-axelrasmussen@google.com/

Link: https://lkml.kernel.org/r/20210323182520.2712101-1-bgeffon@google.com
Link: https://lkml.kernel.org/r/20210323182520.2712101-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Alejandro Colomar <alx.manpages@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-extend-mremap_dontunmap-to-non-anonymous-mappings
+++ a/mm/mremap.c
@@ -653,8 +653,8 @@ static struct vm_area_struct *vma_to_res
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (flags & MREMAP_DONTUNMAP && (!vma_is_anonymous(vma) ||
-			vma->vm_flags & VM_SHARED))
+	if ((flags & MREMAP_DONTUNMAP) &&
+			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
 		return ERR_PTR(-EINVAL);
 
 	if (is_vm_hugetlb_page(vma))
_

Patches currently in -mm which might be from bgeffon@google.com are


