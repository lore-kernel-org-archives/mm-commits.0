Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1058E7734B
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 22:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbjI2W7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjI2W7h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 18:59:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3AADD
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 15:59:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD6C433C7;
        Fri, 29 Sep 2023 22:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696028374;
        bh=CYnxdgrMzyax5XN8tQl8TvJHJD43bOonuFJTngQCUM0=;
        h=Date:To:From:Subject:From;
        b=lxZkOZmt1/Gb+1lxm51ADKJzRyN1syoe79iXrCznhWyLuTBCQ3+iDrr0uH1aBuTJK
         hXd4BioY2cUzimSF859ItjdhXoqDZi3+3m5DPjzi0nnkl7o6OrT5AqITK1LbH6ZiA5
         gX1AqbCD+BdG6xn1bItjNTXWDUE22ri4hM2+SBuk=
Date:   Fri, 29 Sep 2023 15:59:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        christophe.jaillet@wanadoo.fr, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch added to mm-unstable branch
Message-Id: <20230929225934.D2DD6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: fix allocation calculation in kmem_cache_alloc_bulk()
has been added to the -mm mm-unstable branch.  Its filename is
     radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: radix tree test suite: fix allocation calculation in kmem_cache_alloc_bulk()
Date: Fri, 29 Sep 2023 16:13:59 -0400

The bulk allocation is iterating through an array and storing enough
memory for the entire bulk allocation instead of a single array entry. 
Only allocate an array element of the size set in the kmem_cache.

Link: https://lkml.kernel.org/r/20230929201359.2857583-1-Liam.Howlett@oracle.com
Fixes: cc86e0c2f306 ("radix tree test suite: add support for slab bulk APIs")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk
+++ a/tools/testing/radix-tree/linux.c
@@ -165,9 +165,9 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		for (i = 0; i < size; i++) {
 			if (cachep->align) {
 				posix_memalign(&p[i], cachep->align,
-					       cachep->size * size);
+					       cachep->size);
 			} else {
-				p[i] = malloc(cachep->size * size);
+				p[i] = malloc(cachep->size);
 			}
 			if (cachep->ctor)
 				cachep->ctor(p[i]);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-mas_active-to-detect-in-tree-walks.patch
maple_tree-add-mas_underflow-and-mas_overflow-states.patch
mm-mempolicy-fix-set_mempolicy_home_node-previous-vma-pointer.patch
mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch
mmap-fix-error-paths-with-dup_anon_vma.patch
mmap-add-clarifying-comment-to-vma_merge-code.patch
radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch

