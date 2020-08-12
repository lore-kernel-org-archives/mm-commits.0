Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4ACC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710B42078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266172;
	bh=k/Gwy+1UZ6XwiWaxlVQdYizWE//v64ctuKokyOyupNI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2J31n7XNCKqH9lykZA1FrEDbxca7H2L1TDkp/I4lwSJ0JqRDuFniAtbEdkDlU+SMI
	 kDbqswTjDofHXlBWO3ikWiCFdJuMGmk35/m3ae1gw/37SswNmSSEBCFmoAaqyY8yet
	 bpv9YMRaDYoDSVAw+WcsFKeTHw7LoK4w/A1qh6DA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLVCw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F73520774;
        Wed, 12 Aug 2020 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266171;
        bh=k/Gwy+1UZ6XwiWaxlVQdYizWE//v64ctuKokyOyupNI=;
        h=Date:From:To:Subject:From;
        b=ma6zbFMuwis+Eip5sTsBZEAQLP2O1nyCLZnMzjEC5FiMbm4MR6xXm1zU/OhcMure8
         jCn3Ywyvlphf4BkStp1EnmyJ3QvW7Qs8sGpd0D2Ehr+lAu43zqihSsdOm846sk4++S
         gCBLYC/lIFGlkwCrBH6K9KnuR74xSoMu4/l6ju84=
Date:   Wed, 12 Aug 2020 14:02:51 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-hmmc-delete-duplicated-word.patch removed
 from -mm tree
Message-ID: <20200812210251.Pn10Sb5Uz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm.c: delete duplicated word
has been removed from the -mm tree.  Its filename was
     mm-hmmc-delete-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/hmm.c: delete duplicated word

Drop the repeated word "pages".

Link: http://lkml.kernel.org/r/20200801173822.14973-4-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-delete-duplicated-word
+++ a/mm/hmm.c
@@ -249,7 +249,7 @@ static int hmm_vma_handle_pte(struct mm_
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages pages, but just report
+		 * Never fault in device private pages, but just report
 		 * the PFN even if not present.
 		 */
 		if (hmm_is_device_private_entry(range, entry)) {
_

Patches currently in -mm which might be from rdunlap@infradead.org are


