Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D7EC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiLAAFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLAADv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ED48EE5E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C1D26176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A9EC433D6;
        Thu,  1 Dec 2022 00:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852906;
        bh=DrXIY7DufZJmK2jS+GYp2s5NxA1lp8NUE2CeZewklKY=;
        h=Date:To:From:Subject:From;
        b=0sAIItgbrD3SfTgfn3g3iz4gpWtWnS3iquafH1+IbygUnnOcCVdW9VagbwaJ63pCB
         yLkybJiWjbS5cOJsABmtGaqRWck/VulagNr10yojo1SfUlwi3xoWnjGp/2n+PIJpr7
         E3JegQ7U/KB8tSsY09rZR3Y2hY3uPW09lJqQS/N8=
Date:   Wed, 30 Nov 2022 16:01:46 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, aneesh.kumar@linux.ibm.com, linmq006@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init.patch removed from -mm tree
Message-Id: <20221201000146.B6A9EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: fix NULL vs IS_ERR checking in memory_tier_init
has been removed from the -mm tree.  Its filename was
     mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaoqian Lin <linmq006@gmail.com>
Subject: mm/demotion: fix NULL vs IS_ERR checking in memory_tier_init
Date: Thu, 10 Nov 2022 07:07:51 +0400

alloc_memory_type() returns error pointers on error instead of NULL.  Use
IS_ERR() to check the return value to fix this.

Link: https://lkml.kernel.org/r/20221110030751.1627266-1-linmq006@gmail.com
Fixes: 7b88bda3761b ("mm/demotion/dax/kmem: set node's abstract distance to MEMTIER_DEFAULT_DAX_ADISTANCE")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init
+++ a/mm/memory-tiers.c
@@ -645,7 +645,7 @@ static int __init memory_tier_init(void)
 	 * than default DRAM tier.
 	 */
 	default_dram_type = alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
-	if (!default_dram_type)
+	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
 	/*
_

Patches currently in -mm which might be from linmq006@gmail.com are


