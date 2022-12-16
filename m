Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E34C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 22:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiLPW2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 17:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLPW2s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 17:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E6860351
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 14:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8007F6215C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 22:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F6EC433EF;
        Fri, 16 Dec 2022 22:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671229725;
        bh=KSFaDkmF5EidfUcEkxm2k99SYfG8B1sIVEBTOS10Wr4=;
        h=Date:To:From:Subject:From;
        b=fxv1zLsdkuqFPLw4h3eUusEQdYjzG/1q8mnv4qtHdB7i+dvxUCbuC9UHSJ/yimsts
         WJYkiVEDcBLtrf9gQxO+yLMjqXra4b14xE1WexJHp9fsLVAfg49apOPF12TIV8rwQl
         1Wcra2/Z1TeagJoVSFBRRZos2O88kF+YS2Ldjkx0=
Date:   Fri, 16 Dec 2022 14:28:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-folio_set_compound_order-to-mm-internalh-update.patch added to mm-unstable branch
Message-Id: <20221216222845.D1F6EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-folio_set_compound_order-to-mm-internalh-update
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-folio_set_compound_order-to-mm-internalh-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-folio_set_compound_order-to-mm-internalh-update.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm-move-folio_set_compound_order-to-mm-internalh-update
Date: Tue, 13 Dec 2022 13:20:53 -0800

alter the folio_set_order() warning

Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-move-folio_set_compound_order-to-mm-internalh-update
+++ a/mm/internal.h
@@ -384,8 +384,10 @@ int split_free_page(struct page *free_pa
  */
 static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
-	if (WARN_ON_ONCE(!folio_test_large(folio)))
+	if (!folio_test_large(folio)) {
+		WARN_ON_ONCE(order);
 		return;
+	}
 
 	folio->_folio_order = order;
 #ifdef CONFIG_64BIT
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-move-folio_set_compound_order-to-mm-internalh-update.patch

