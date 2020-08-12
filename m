Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B190C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A021207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195998;
	bh=FH8spxGXSetEgCsPugRfFHHZtSXbOXlAJrqTFqQb2JY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RWghEN8sGENk2urHDT6KZ/Bp43KsJe1Fi7XiepvcCaqCj6hArVV0mhQx93V8TiS6A
	 IfdOcipE+ZERAkO4E0Jy0BS5kUJ0UIunHNA1Im2L3UFhJF28rNwKjgrQZkGL+Gf9tV
	 Tl4rRlPOXrS/Wo1IPleiQXh+TGmhV8a6wpNew7bU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHLBdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B6E206B2;
        Wed, 12 Aug 2020 01:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195997;
        bh=FH8spxGXSetEgCsPugRfFHHZtSXbOXlAJrqTFqQb2JY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=10I6ezmoMPSr9WyUuK3EmWgtEiHryJmQ7Oxwc1E3c7+jf2pqs2JtnXUsC34ht8/Kl
         PLHXoRNAXJZ6ZQBHBK8MYZqfodqRCDNZrI6zLP5QFxmx/iOSTC9V6MMc+p7yzOpOV3
         oy/ykXkNdQqhc2ojlM9v8wKGp78/Fwt9mI889rtA=
Date:   Tue, 11 Aug 2020 18:33:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 057/165] mm/shmem.c: delete duplicated word
Message-ID: <20200812013317.is4Fy-hkH%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/shmem.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-11-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmemc-delete-duplicated-word
+++ a/mm/shmem.c
@@ -1686,7 +1686,7 @@ static int shmem_replace_page(struct pag
  * Swap in the page pointed to by *pagep.
  * Caller has to make sure that *pagep contains a valid swapped page.
  * Returns 0 and the page in pagep if success. On failure, returns the
- * the error code and NULL in *pagep.
+ * error code and NULL in *pagep.
  */
 static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 			     struct page **pagep, enum sgp_type sgp,
_
