Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C44EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiCYWpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiCYWpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEF020E96F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A21614D8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83EC004DD;
        Fri, 25 Mar 2022 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248200;
        bh=MspBSM+rV9BAsX7Ca9cPvwjXlYd0Z3uBT8CAhgMqvp8=;
        h=Date:To:From:Subject:From;
        b=oRUzgrkJqQe8pcwpgWbMjhScmrj/zDvrtTXhgiHwD608T912+coHJ5CKXnmgFtRGI
         QZxX0h/VmQNI4tbWQWc9LQmYsr5ZtUcf6kxX6pcxyQKSwf1UGSno9CnpzOuM33If0E
         cIkCBNu/VeGJSd5vs0OocEGtQtcjt9EVbVo1pmfQ=
Date:   Fri, 25 Mar 2022 15:43:19 -0700
To:     mm-commits@vger.kernel.org, sashal@kernel.org,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        kirill.shutemov@linux.intel.com, dave@stgolabs.net,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch removed from -mm tree
Message-Id: <20220325224320.7C83EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unmap_mapping_range_tree() with i_mmap_rwsem shared
has been removed from the -mm tree.  Its filename was
     mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: unmap_mapping_range_tree() with i_mmap_rwsem shared

Revert 48ec833b7851 ("Revert "mm/memory.c: share the i_mmap_rwsem"") to
reinstate c8475d144abb ("mm/memory.c: share the i_mmap_rwsem"): the
unmap_mapping_range family of functions do the unmapping of user pages
(ultimately via zap_page_range_single) without modifying the interval tree
itself, and unmapping races are necessarily guarded by page table lock,
thus the i_mmap_rwsem should be shared in unmap_mapping_pages() and
unmap_mapping_folio().

Commit 48ec833b7851 was intended as a short-term measure, allowing the
other shared lock changes into 3.19 final, before investigating three
trinity crashes, one of which had been bisected to commit c8475d144ab:

[1] https://lkml.org/lkml/2014/11/14/342
https://lore.kernel.org/lkml/5466142C.60100@oracle.com/
[2] https://lkml.org/lkml/2014/12/22/213
https://lore.kernel.org/lkml/549832E2.8060609@oracle.com/
[3] https://lkml.org/lkml/2014/12/9/741
https://lore.kernel.org/lkml/5487ACC5.1010002@oracle.com/

Two of those were Bad page states: free_pages_prepare() found PG_mlocked
still set - almost certain to have been fixed by 4.4 commit b87537d9e2fe
("mm: rmap use pte lock not mmap_sem to set PageMlocked").  The NULL deref
on rwsem in [2]: unclear, only happened once, not bisected to c8475d144ab.

No change to the i_mmap_lock_write() around __unmap_hugepage_range_final()
in unmap_single_vma(): IIRC that's a special usage, helping to serialize
hugetlbfs page table sharing, not to be dabbled with lightly.  No change
to other uses of i_mmap_lock_write() by hugetlbfs.

I am not aware of any significant gains from the concurrency allowed by
this commit: it is submitted more to resolve an ancient misunderstanding.

Link: https://lkml.kernel.org/r/e4a5e356-6c87-47b2-3ce8-c2a95ae84e20@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared
+++ a/mm/memory.c
@@ -3388,11 +3388,11 @@ void unmap_mapping_folio(struct folio *f
 	details.even_cows = false;
 	details.single_folio = folio;
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 
 /**
@@ -3418,11 +3418,11 @@ void unmap_mapping_pages(struct address_
 	if (last_index < first_index)
 		last_index = ULONG_MAX;
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 
_

Patches currently in -mm which might be from hughd@google.com are


