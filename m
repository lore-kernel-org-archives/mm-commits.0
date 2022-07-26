Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4132EC00140
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jul 2022 18:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiGZSfG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiGZSfF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 14:35:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03062205EF
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 11:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93CAF614A9
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE11EC433C1;
        Tue, 26 Jul 2022 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658860504;
        bh=OAPe4IW04yoBGr20UGMnlclDmXuiqMDW8lg+Ptf7twk=;
        h=Date:To:From:Subject:From;
        b=OY0KgmALp4QOH1qC3XzEfuTyaZw89eFnXt9i609aNin3nHfjaNk1E0m5L58axTDDU
         DlkdkSsVRODwN9muCVdF+DwFSBzYNvABZ50+4HuoLh3oT5Ep5pwHLgoO5DO/DyPZ/X
         32Ts1orb0dEjZeIY32IWjcIYslu97a+ErkKXX3XA=
Date:   Tue, 26 Jul 2022 11:35:03 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cleanup-is_highmem.patch added to mm-unstable branch
Message-Id: <20220726183503.DE11EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup is_highmem()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cleanup-is_highmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cleanup-is_highmem.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: cleanup is_highmem()
Date: Tue, 26 Jul 2022 21:18:16 +0800

It is unnecessary to add CONFIG_HIGHMEM check in is_highmem(), which has
been done in is_highmem_idx(), and move is_highmem() close to
is_highmem_idx().  This has no functional impact.

Link: https://lkml.kernel.org/r/20220726131816.149075-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/include/linux/mmzone.h~mm-cleanup-is_highmem
+++ a/include/linux/mmzone.h
@@ -1137,15 +1137,6 @@ static inline int is_highmem_idx(enum zo
 #endif
 }
 
-#ifdef CONFIG_ZONE_DMA
-bool has_managed_dma(void);
-#else
-static inline bool has_managed_dma(void)
-{
-	return false;
-}
-#endif
-
 /**
  * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
@@ -1155,12 +1146,17 @@ static inline bool has_managed_dma(void)
  */
 static inline int is_highmem(struct zone *zone)
 {
-#ifdef CONFIG_HIGHMEM
 	return is_highmem_idx(zone_idx(zone));
+}
+
+#ifdef CONFIG_ZONE_DMA
+bool has_managed_dma(void);
 #else
-	return 0;
-#endif
+static inline bool has_managed_dma(void)
+{
+	return false;
 }
+#endif
 
 /* These two functions are used to setup the per zone pages min values */
 struct ctl_table;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-cleanup-is_highmem.patch

