Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8068EC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D2061A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhCXWeO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235337AbhCXWeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E864E619E4;
        Wed, 24 Mar 2021 22:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616625253;
        bh=MwaFePaRTiaeA+XkoUVxUxGpQtlqRRy/TPFsYo75Ioc=;
        h=Date:From:To:Subject:From;
        b=t1U2twowUL6vT2XyZ65frGE1ixCBOdxa2UQ3eb+CM3f303a3Jh7UwmL+jmMB8XR8J
         L99LZPe4kSrPE3YnEWZQoG4S6sk3rW+AuL8CGCIrY2zOEWzQnBLjmOOmQgBs5geNro
         GF7EX7UnZhEvfcRhllNkZeEU5Bwagm2sipkx9wPo=
Date:   Wed, 24 Mar 2021 15:34:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sonnyrao@google.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, mtk.manpages@gmail.com,
        mst@redhat.com, minchan@kernel.org, luto@amacapital.net,
        lokeshgidra@google.com, kirill@shutemov.name, hughd@google.com,
        alx.manpages@gmail.com, aarcange@redhat.com, 0x7f454c46@gmail.com,
        bgeffon@google.com
Subject:  +
 mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch added to -mm tree
Message-ID: <20210324223412.xwADZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: extend MREMAP_DONTUNMAP to non-anonymous mappings
has been added to the -mm tree.  Its filename is
     mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm: extend MREMAP_DONTUNMAP to non-anonymous mappings

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

mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch
revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio.patch
selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch

