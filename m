Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBC5C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49EAC2083B
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599160569;
	bh=igwKqbR9RpUGJHxPEl533znc0rLqOInivDfz2rTPsPE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GpPl0dcZm9foKzxFVyILzZUWFxSk9yHZWt68roSbAh4WXDALUwUB8Oni/Gaw8L6eL
	 bFgL08PUzJ/FfTivB1MccAOxCqliwivCCOg9B2oGyf7AaOHhoTUJ7d0pCFPVR2Ph8H
	 Fw3T/HXwlUlndveKLYsDTFfxRVajdzEWlzpdz4cE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgICTQJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgICTQG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:16:06 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9442098B;
        Thu,  3 Sep 2020 19:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599160565;
        bh=igwKqbR9RpUGJHxPEl533znc0rLqOInivDfz2rTPsPE=;
        h=Date:From:To:Subject:From;
        b=my+jVS2X/dJx6KiCqnPwW9a+MZCB5s7DLq1OaH2jn1jiDioU6ci0lvZeYK+6vhCBh
         pzC2PmsQqbVZokU/wxMmJ20Zy+gdSskQN64uACFz70SI4Rw9Iy5vjUVrxEo07W4NCE
         IRF7rSblL3skh8u7gdSo2sSG8KKUyRfODuuNosWE=
Date:   Thu, 03 Sep 2020 12:16:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songliubraving@fb.com, shy828301@gmail.com,
        pankaj.gupta.linux@gmail.com, ebiggers@google.com,
        dhowells@redhat.com
Subject:  + fix-khugepageds-request-size-in-collapse_file.patch added
 to -mm tree
Message-ID: <20200903191605.fyhfB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged.c: fix khugepaged's request size in collapse_file
has been added to the -mm tree.  Its filename is
     fix-khugepageds-request-size-in-collapse_file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-khugepageds-request-size-in-collapse_file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-khugepageds-request-size-in-collapse_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm/khugepaged.c: fix khugepaged's request size in collapse_file

collapse_file() in khugepaged passes PAGE_SIZE as the number of pages to
be read to page_cache_sync_readahead().  The intent was probably to read a
single page.  Fix it to use the number of pages to the end of the window
instead.

Link: https://lkml.kernel.org/r/20200903140844.14194-2-willy@infradead.org
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~fix-khugepageds-request-size-in-collapse_file
+++ a/mm/khugepaged.c
@@ -1709,7 +1709,7 @@ static void collapse_file(struct mm_stru
 				xas_unlock_irq(&xas);
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
-							  PAGE_SIZE);
+							  end - index);
 				/* drain pagevecs to help isolate_lru_page() */
 				lru_add_drain();
 				page = find_lock_page(mapping, index);
_

Patches currently in -mm which might be from dhowells@redhat.com are

fix-khugepageds-request-size-in-collapse_file.patch
mutex-subsystem-synchro-test-module.patch

