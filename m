Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BE2C4332E
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CD764EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbhCDA6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352570AbhCCXHr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 18:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE04D64EF9;
        Wed,  3 Mar 2021 23:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614812782;
        bh=7i0KKzWNUBFjfF+WUScylI2sao98Hb0NvM4hKsmPTcc=;
        h=Date:From:To:Subject:From;
        b=nhwbk/l99zND4binfQBmED4YXk7GxvAaCGTakIBLCBM85A1AymrUUEYjQqVIV0A0z
         x02OITczQIKlB2pB2A0hH7ickHWGULfJpFK+ONUIN6wDWmGmNIvCM7xTj8Qhvg5/NK
         9EyVxqOBe4pm04iaay/BpO00djtPSwH8ygRRwGlo=
Date:   Wed, 03 Mar 2021 15:06:21 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com, bgeffon@google.com,
        hughd@google.com, kirill@shutemov.name, lokeshgidra@google.com,
        luto@amacapital.net, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, sonnyrao@google.com, vbabka@suse.cz
Subject:  + mm-allow-shmem-mappings-with-mremap_dontunmap.patch
 added to -mm tree
Message-ID: <20210303230621.DGeICL84h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow shmem mappings with MREMAP_DONTUNMAP
has been added to the -mm tree.  Its filename is
     mm-allow-shmem-mappings-with-mremap_dontunmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-allow-shmem-mappings-with-mremap_dontunmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-allow-shmem-mappings-with-mremap_dontunmap.patch

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

mm-allow-shmem-mappings-with-mremap_dontunmap.patch

