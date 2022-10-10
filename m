Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CE3C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 10 Oct 2022 20:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJJUOD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Oct 2022 16:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJJUOB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2022 16:14:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8A631DE2
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 13:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48880B80F9B
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 20:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF250C433D6;
        Mon, 10 Oct 2022 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665432835;
        bh=AinEwSPm+ku1WJQ7YCmn+EC2Av5/Ren4wMwyBAsaT5Y=;
        h=Date:To:From:Subject:From;
        b=KxwyX+EXk/phH5R2JwakE7COPnjhp5WerIkMa/BoSe5B6jMEg2hCmbSKEj9Lxfgyb
         /wijbC7UCtNsXvcBFEXiS1QXOfNhqY4gek4Lis3LK1CJ5CnHzKInbv09F8sBfQ8JBV
         erZbpleD+DBRdPySqwtgnZxmY5g2crwjGwfTq2Ic=
Date:   Mon, 10 Oct 2022 13:13:54 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, lkp@intel.com, ira.weiny@intel.com, hch@lst.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch added to mm-unstable branch
Message-Id: <20221010201355.CF250C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
Date: Mon Oct 10 01:12:33 PM PDT 2022

fix warning

mm/highmem.c:164:7: warning: Local variable 'i' shadows outer variable [shadowVariable]

Reported-by: kernel test robot <lkp@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
+++ a/mm/highmem.c
@@ -160,11 +160,8 @@ struct page *__kmap_to_page(void *vaddr)
 
 	/* kmap() mappings */
 	if (WARN_ON_ONCE(addr >= PKMAP_ADDR(0) &&
-			 addr < PKMAP_ADDR(LAST_PKMAP))) {
-		int i = PKMAP_NR(addr);
-
-		return pte_page(pkmap_page_table[i]);
-	}
+			 addr < PKMAP_ADDR(LAST_PKMAP)))
+		return pte_page(pkmap_page_table[PKMAP_NR(addr)]);
 
 	/* kmap_local_page() mappings */
 	if (WARN_ON_ONCE(base >= __fix_to_virt(FIX_KMAP_END) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix-2.patch
highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch

