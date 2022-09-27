Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992D7C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiI0Cyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiI0Cw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C896305
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDBDFB81985
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6521AC43144;
        Tue, 27 Sep 2022 02:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246983;
        bh=gSdBt8Acrq3KD/ucUNBuYqq1GRalEBvzIOv1MUSYNtA=;
        h=Date:To:From:Subject:From;
        b=L8QT7vGXEtg+yVn3FTAYixjqyKkwaCm8AA4iMP9X0R3o+gt2hfnKjOROX1NbvoKTO
         nsXhdgUonwZLCe1Dkvqo3wnkC6snU3IcYxqfUHC3MMxQzbEoaPuCzWg3bd4GHFgaNZ
         ZsaXCS8S1X7Z8+7QhaeDh9reI5vLGZgMPn0I8G6I=
Date:   Mon, 26 Sep 2022 19:49:42 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-vma_find-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024943.6521AC43144@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: use vma_find() instead of vma linked list
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-vma_find-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/madvise: use vma_find() instead of vma linked list
Date: Tue, 6 Sep 2022 19:49:01 +0000

madvise_walk_vmas() no longer uses linked list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-55-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-vma_find-instead-of-vma-linked-list
+++ a/mm/madvise.c
@@ -1245,7 +1245,7 @@ int madvise_walk_vmas(struct mm_struct *
 		if (start >= end)
 			break;
 		if (prev)
-			vma = prev->vm_next;
+			vma = find_vma(mm, prev->vm_end);
 		else	/* madvise_remove dropped mmap_lock */
 			vma = find_vma(mm, start);
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


