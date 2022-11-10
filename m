Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D90C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiKJDcE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiKJDb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:31:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC6E28E2B
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:31:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28BD2B82083
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C308AC433D7;
        Thu, 10 Nov 2022 03:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668051115;
        bh=dV++Lpu8a+fgfTMTc8hzYGCwIwhGjbKr+kp3DEW5Bmg=;
        h=Date:To:From:Subject:From;
        b=0A00zEaAZO77TDSnyZvcpT82EDmOkFrgYtWwU4RySVhBbqx2Yeg/KbHLenaN06fxc
         QKtBOeaq/GcMZib+fmPSdBNHo84YYr81lbXVEUWmprTkTIAf9H1qJKqxXzCDoiyLxR
         +v1r20oDYI9LNWsRWDGnJNOW7tzCTFnTclMKGhZs=
Date:   Wed, 09 Nov 2022 19:31:54 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, aneesh.kumar@linux.ibm.com, linmq006@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init.patch added to mm-unstable branch
Message-Id: <20221110033155.C308AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: fix NULL vs IS_ERR checking in memory_tier_init
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init.patch

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

mm-demotion-fix-null-vs-is_err-checking-in-memory_tier_init.patch

