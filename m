Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C803C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbiEJEUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiEJET6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309972AC6CC
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C85E4B81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C11EC385A6;
        Tue, 10 May 2022 04:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156083;
        bh=dpcIQO1k20B8nN9OqBYqYQidE83TNRO6Gr8LLii6b6s=;
        h=Date:To:From:Subject:From;
        b=1ajZ7G4+/QziGq8RHWMTSua5iq9wtPlN0IJK8gaN8CfvfL2m8KXrH/6o9nQPFSawi
         TWoVYb2l92xL15zAfMjQCSrmoklu+NKZGF0SLdPTod+pz5+4Hva1WneaLeNErS7YOe
         H4CdNSenO6mb4CgOTDwOmuJ4KnRHlwdYVPvwFyk0=
Date:   Mon, 09 May 2022 21:14:42 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch removed from -mm tree
Message-Id: <20220510041443.7C11EC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: remove outdated VM_WARN_ON_ONCE_PAGE from unmap_page()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: remove outdated VM_WARN_ON_ONCE_PAGE from unmap_page()

We can already theoretically fail to unmap (still having page_mapped()) in
case arch_unmap_one() fails, which can happen on sparc.  Failures to unmap
are handled gracefully, just as if there are other references on the
target page: freezing the refcount in split_huge_page_to_list() will fail
if still mapped and we'll simply remap.

In commit 504e070dc08f ("mm: thp: replace DEBUG_VM BUG with VM_WARN when
unmap fails for split") we already converted to VM_WARN_ON_ONCE_PAGE,
let's get rid of it completely now.

This is a preparation for making try_to_migrate() fail on anonymous pages
with GUP pins, which will make this VM_WARN_ON_ONCE_PAGE trigger more
frequently.

Link: https://lkml.kernel.org/r/20220428083441.37290-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page
+++ a/mm/huge_memory.c
@@ -2240,8 +2240,6 @@ static void unmap_page(struct page *page
 		try_to_migrate(folio, ttu_flags);
 	else
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
-
-	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
 }
 
 static void remap_page(struct folio *folio, unsigned long nr)
_

Patches currently in -mm which might be from david@redhat.com are


