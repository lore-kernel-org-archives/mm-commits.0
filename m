Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D05EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjFXAAe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjFXAAP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B95270E
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 115F4615DE
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67445C433C8;
        Sat, 24 Jun 2023 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564813;
        bh=MWOQGTnP/pRLN9xWLkAoTYfnRhslKFqpBgaqrz/nYyw=;
        h=Date:To:From:Subject:From;
        b=hMJm5GybK6tno3n3hzQzpW9F8V2Lu+iOSk52QjkQXydjqfwjt3sZruyNHiHoDy8RG
         8nRoRIE12JER2q9vBLtMyZGDOEH8FbWyKO33CUGyzYzYIPsC2ixPJGxk9+Zfw6c3+E
         8gW4qTzepMXOYdjKf7XZ0UCX16JY6+iU9BY4Fexw=
Date:   Fri, 23 Jun 2023 17:00:12 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-delete-outdated-pte_offset_map-comment.patch removed from -mm tree
Message-Id: <20230624000013.67445C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: delete outdated pte_offset_map() comment
has been removed from the -mm tree.  Its filename was
     mm-swapfile-delete-outdated-pte_offset_map-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/swapfile: delete outdated pte_offset_map() comment
Date: Mon, 19 Jun 2023 23:50:00 -0700 (PDT)

Delete a triply out-of-date comment from add_swap_count_continuation():
1. vmalloc_to_page() changed from pte_offset_map() to pte_offset_kernel()
2. pte_offset_map() changed from using kmap_atomic() to kmap_local_page()
3. kmap_atomic() changed from using fixed FIX_KMAP addresses in 2.6.37.

Link: https://lkml.kernel.org/r/9022632b-ba9d-8cb0-c25-4be9786481b5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-delete-outdated-pte_offset_map-comment
+++ a/mm/swapfile.c
@@ -3456,11 +3456,6 @@ int add_swap_count_continuation(swp_entr
 		goto out;
 	}
 
-	/*
-	 * We are fortunate that although vmalloc_to_page uses pte_offset_map,
-	 * no architecture is using highmem pages for kernel page tables: so it
-	 * will not corrupt the GFP_ATOMIC caller's atomic page table kmaps.
-	 */
 	head = vmalloc_to_page(si->swap_map + offset);
 	offset &= ~PAGE_MASK;
 
_

Patches currently in -mm which might be from hughd@google.com are


