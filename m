Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70F6ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIIVsn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiIIVsb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACB8115CE7
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E3EB82660
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9478C433D7;
        Fri,  9 Sep 2022 21:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760107;
        bh=BfJHhKZy46j3H94HP3RCwj6PmnfpTlhsYYgXpgBhE/Q=;
        h=Date:To:From:Subject:From;
        b=KUupu7lb4WVW+lFB0shLDQ3UngdSCEoeohJ4BO/RiVj1y3F6HrXFosoIK4HKSYcHB
         voIRIZo/Zxp320O5gXf9mZsV1pLEdV3EYIfR4zrXmNS9qMSsQZyl0gTVgnESE4UKs/
         Zq6CNdWCDBghIf+2apieb74+dSrn1nOhYWSIk5G0=
Date:   Fri, 09 Sep 2022 14:48:26 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch added to mm-nonmm-unstable branch
Message-Id: <20220909214827.B9478C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: use kvcalloc to alloc page array in relay_alloc_page_array
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: wuchi <wuchi.zero@gmail.com>
Subject: relay: use kvcalloc to alloc page array in relay_alloc_page_array
Date: Fri, 9 Sep 2022 18:10:25 +0800

kvcalloc() is safer because it will check the integer overflows, and using
it will simple the logic of allocation size.

Link: https://lkml.kernel.org/r/20220909101025.82955-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/relay.c~relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array
+++ a/kernel/relay.c
@@ -60,10 +60,7 @@ static const struct vm_operations_struct
  */
 static struct page **relay_alloc_page_array(unsigned int n_pages)
 {
-	const size_t pa_size = n_pages * sizeof(struct page *);
-	if (pa_size > PAGE_SIZE)
-		return vzalloc(pa_size);
-	return kzalloc(pa_size, GFP_KERNEL);
+	return kvcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
 }
 
 /*
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
initramfs-mask-my_inptr-as-__initdata.patch
profile-simplify-redundant-code-in-profile_setup.patch
latencytop-use-the-last-element-of-latency_record-of-system.patch
relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

