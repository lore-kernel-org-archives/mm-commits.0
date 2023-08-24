Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24A2C6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjHXXNf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbjHXXNZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:13:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2424D1BD4
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B384A644C8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A15C433C8;
        Thu, 24 Aug 2023 23:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918803;
        bh=O2lR647xkH4bVn4Y1NnKwDXMXwpQscgwsmQew+S+HEA=;
        h=Date:To:From:Subject:From;
        b=aMBsBl5uJhu38bOu7h/amqfkCPrRWWtHyB7vSMdwlD+B/kmocavxhUwjlPIK93UXK
         MuBuZ9I99i+Yxo1iGqyBs3ZDvh9MA+USITVF0psnO0cakv0VTER/J5DFowJZNlhfwH
         kLNFwcN9z0/X1q6hCL97vk0pn+Or3OExCqL9/AXc=
Date:   Thu, 24 Aug 2023 16:13:22 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix.patch removed from -mm tree
Message-Id: <20230824231323.17A15C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup: mm/swap: stop using page->private on tail pages for THP_SWAP
has been removed from the -mm tree.  Its filename was
     mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix.patch

This patch was dropped because it was folded into mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/swap: stop using page->private on tail pages for THP_SWAP

Per Yoshry, use folio_page_idx(). It shouldn't make a difference for
our (THP) use case, but it's certainly cleaner.

Link: https://lkml.kernel.org/r/6f0a82a3-6948-20d9-580b-be1dbf415701@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix
+++ a/include/linux/swap.h
@@ -344,7 +344,7 @@ static inline swp_entry_t page_swap_entr
 	struct folio *folio = page_folio(page);
 	swp_entry_t entry = folio_swap_entry(folio);
 
-	entry.val += page - &folio->page;
+	entry.val += folio_page_idx(folio, page);
 	return entry;
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

