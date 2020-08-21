Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DB5C433E4
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C637207DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597970537;
	bh=wMiF2axUgwEcrOToR48UFzogQiIhFbXuPlL4odCp9Fk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VXa8spRjS+BRtY3twkwjW87w8MD3ZSmev4FRvTGqyE5k6LMEBogXRD/W5J4FttQLb
	 W1VHCO2dHg3dM/Mb4FW6iVTtxN4ifGBC1rV8S9j/fABBflGcukkXs3b1E+oP8F1Sy7
	 8ZYa/1VFXXue/rQJBRV81ycK518eEXVSznOkIjFc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHUAmQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgHUAmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F99207DF;
        Fri, 21 Aug 2020 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970529;
        bh=wMiF2axUgwEcrOToR48UFzogQiIhFbXuPlL4odCp9Fk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lSE286sXpCgm9nH+kUWnXwqYoa2gJPGhzmWLk9tGVAkn1dfWCAAsdHM5dVvaCie1W
         5LHG/cnaMPIZpRjBQv7Sel7HVdw7cLSBQwiK2FoZjj3gRf2NgpcC6yKNjhQCfKdswd
         WRwIzLomZibUSj9Da0g/GwFEntXT9FLywIsin5BQ=
Date:   Thu, 20 Aug 2020 17:42:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        leonro@nvidia.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/11] mm/rodata_test.c: fix missing function
 declaration
Message-ID: <20200821004208.Pn1y64Ro4%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
