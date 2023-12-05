Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975FDC4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 20:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjLEULg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 15:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjLEULe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 15:11:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D26ED5F
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 12:11:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17BAC433C7;
        Tue,  5 Dec 2023 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701807096;
        bh=GLwHT4d+CfDFAFzTKn+VCHcqTLAutTFB0BM990ArAfU=;
        h=Date:To:From:Subject:From;
        b=Bf/tBTIsrk7AkwFhSH5/coR5bXr0k1f35oGQmcM+6udlGH0M6ezs10L7RWNTSUOO9
         K83wGGnwIyfcKVBGH6IkBTC9qfq3r6p/1zlpPxSRNdkHh5nr1v/GuCCyp/gByS7wH3
         lpou8PD45ksvPs69g8GxndVgDuXGp2EgTtCgfMKk=
Date:   Tue, 05 Dec 2023 12:11:35 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        zeming@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-remove-unnecessary-initialization-of-ret.patch added to mm-unstable branch
Message-Id: <20231205201135.E17BAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: remove unnecessary initialization of ret
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-remove-unnecessary-initialization-of-ret.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-remove-unnecessary-initialization-of-ret.patch

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
From: Li zeming <zeming@nfschina.com>
Subject: mm: cma: remove unnecessary initialization of ret
Date: Tue, 5 Dec 2023 10:17:51 +0800

The ret variable can be defined without assigning a value, as it is
assigned before use.

Link: https://lkml.kernel.org/r/20231205021751.100459-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-remove-unnecessary-initialization-of-ret
+++ a/mm/cma.c
@@ -244,7 +244,7 @@ int __init cma_declare_contiguous_nid(ph
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
 	phys_addr_t highmem_start;
-	int ret = 0;
+	int ret;
 
 	/*
 	 * We can't use __pa(high_memory) directly, since high_memory
_

Patches currently in -mm which might be from zeming@nfschina.com are

mm-filemap-remove-unnecessary-iitialization-of-ret.patch
mm-cma-remove-unnecessary-initialization-of-ret.patch

