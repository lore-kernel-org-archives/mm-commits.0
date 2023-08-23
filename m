Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2404C3DA66
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 20:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjHWUTz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 16:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbjHWUTq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 16:19:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A4210D2
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 13:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9AB76179C
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 20:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA671C433C7;
        Wed, 23 Aug 2023 20:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692821984;
        bh=8jgNTCuvNzPkmBPQrBbTQQuEft1Tp4j/DRXXngJOtME=;
        h=Date:To:From:Subject:From;
        b=VgmBiTekrMvKOisxFgaKQpC3qrBdrIgdoxBdSWqw4qRhc/MZwRSrL7mfwK9d7KJP2
         bR1L4Z6N3moq61BAJPJnjkx7IbKa8ekivT/U3fAUKW9dlxOxwAqXokBN0+c5CUJQr7
         aBPV9Vxc3+dH9SdouMJoLlDdYs09mMSfyOUeRWEo=
Date:   Wed, 23 Aug 2023 13:19:43 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix.patch added to mm-unstable branch
Message-Id: <20230823201943.DA671C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup: mm/swap: stop using page->private on tail pages for THP_SWAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix.patch

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
mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap-fix.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

