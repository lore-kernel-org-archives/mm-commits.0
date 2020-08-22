Return-Path: <SRS0=1ZdY=CA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFBFC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2568920855
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598117398;
	bh=4+2QZWGU3pBFAxR8NesmHlGKUHdkWoVo3wwoOYHHGb4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hlN0Dj1PhtYV2CB1XaO4nDLLjXX3+p6Ldod8O9ve7iZipNcgLZSG0quzAnxYSSxFU
	 KzWWFo+yLUj51eYC+Nx0a0AiviKiv/lbVZzjoM4OY2jEaB2DYP7mbX2X0/cqrQm7O9
	 lgLPd6KprCWMqLEpAt9iha43/XLllAWHoMerx994=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgHVR3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Aug 2020 13:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbgHVR3v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74EE620825;
        Sat, 22 Aug 2020 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117391;
        bh=4+2QZWGU3pBFAxR8NesmHlGKUHdkWoVo3wwoOYHHGb4=;
        h=Date:From:To:Subject:From;
        b=zuwuXZkXRizAtD1kASneISNwEB5AXqlwiQSZEdHZr61lyQ6/a0FaR+Hy7k+dwKwNB
         GxNeU1QlB6riNPwCt15BC5MSJj9Xxx6KlrNhMET7IWjHvy3bj75M2huR+Z7ebf3CM8
         HuS1ZjfEuGOWjluHJElhhchYrPONtQ5iGY62EJ1o=
Date:   Sat, 22 Aug 2020 10:29:51 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, leonro@nvidia.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-fix-missing-function-declaration.patch
 removed from -mm tree
Message-ID: <20200822172951.Jvtl8PZam%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rodata_test.c: fix missing function declaration
has been removed from the -mm tree.  Its filename was
     mm-fix-missing-function-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Leon Romanovsky <leonro@nvidia.com>
Subject: mm/rodata_test.c: fix missing function declaration

The compilation with CONFIG_DEBUG_RODATA_TEST set produces the following
warning due to the missing include.

 mm/rodata_test.c:15:6: warning: no previous prototype for 'rodata_test' [-Wmissing-prototypes]
    15 | void rodata_test(void)
      |      ^~~~~~~~~~~

Link: https://lkml.kernel.org/r/20200819080026.918134-1-leon@kernel.org
Fixes: 2959a5f726f6 ("mm: add arch-independent testcases for RODATA")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rodata_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rodata_test.c~mm-fix-missing-function-declaration
+++ a/mm/rodata_test.c
@@ -7,6 +7,7 @@
  */
 #define pr_fmt(fmt) "rodata_test: " fmt
 
+#include <linux/rodata_test.h>
 #include <linux/uaccess.h>
 #include <asm/sections.h>
 
_

Patches currently in -mm which might be from leonro@nvidia.com are


