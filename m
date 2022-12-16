Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D56C4167B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLPAi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLPAi6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:38:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6033722A
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16FF261FB9
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6702DC433EF;
        Fri, 16 Dec 2022 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151136;
        bh=vnWSnI3Ruao8u0bK2ZEIg+xjHWADJta2c3o1JIGGo/o=;
        h=Date:To:From:Subject:From;
        b=NoPND+lbRJaoiPiTgsAZMhsr0zC4wKDzgsZLrprqZUnmiDDGmy8VyPZP2+PIvmFrC
         u2wQPrRnyQHCsz4XSgJhpxvw+GZ8V7yeSC0/N1MNxB8o5WmQii/zpa8yCwe4YbPfJp
         YzYkb5gyn//HnqOzfn0NACF0vDHjywgVIhOEMgVU=
Date:   Thu, 15 Dec 2022 16:38:55 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, julia.lawall@lip6.fr,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree.patch removed from -mm tree
Message-Id: <20221216003856.6702DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup_test: free memory allocated via kvcalloc() using kvfree()
has been removed from the -mm tree.  Its filename was
     mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup_test: free memory allocated via kvcalloc() using kvfree()
Date: Mon, 12 Dec 2022 19:20:18 +0100

We have to free via kvfree(), not via kfree().

Link: https://lkml.kernel.org/r/20221212182018.264900-1-david@redhat.com
Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree
+++ a/mm/gup_test.c
@@ -214,7 +214,7 @@ static inline void pin_longterm_test_sto
 		if (pin_longterm_test_nr_pages)
 			unpin_user_pages(pin_longterm_test_pages,
 					 pin_longterm_test_nr_pages);
-		kfree(pin_longterm_test_pages);
+		kvfree(pin_longterm_test_pages);
 		pin_longterm_test_pages = NULL;
 		pin_longterm_test_nr_pages = 0;
 	}
@@ -255,7 +255,7 @@ static inline int pin_longterm_test_star
 	fast = !!(args.flags & PIN_LONGTERM_TEST_FLAG_USE_FAST);
 
 	if (!fast && mmap_read_lock_killable(current->mm)) {
-		kfree(pages);
+		kvfree(pages);
 		return -EINTR;
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are


