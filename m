Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CA9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBFBD207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597862042;
	bh=N3Z9Ctn7Vj9epmEnDq2rwSq0zVD5nSwbrCEJs3bYU2A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VZpWIu6vWk07mfihQqJGj5pKzPISo/VRN8NAalYIPAkwG9ITHxf4jbkJLprbFTk8P
	 8lHzaw6nA603+I1LtXinvSqXMNVVja5pWny4LQVJSbiwhthy+o3lYwnupTyMVj34ji
	 r1EdgHLtjZyBjcGnsli4F8Y6s09+EDiPjAk4J76w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgHSSeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSSeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:34:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DF920658;
        Wed, 19 Aug 2020 18:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597862041;
        bh=N3Z9Ctn7Vj9epmEnDq2rwSq0zVD5nSwbrCEJs3bYU2A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y+/FYcOFasY467LC4c/DyC/DtMBwsMX/fwKgfTzn1mEN7esvh12e31iI1sXGDSvlY
         wgNsXn1LkXi1vwsGYFVURsc+8MsMOmy5BEdpl7zl/HvflcAmB5Ui5zWxdipipTgc4F
         PbmiifCUGe3WSF/QgXB0gm+5hDGsjG6ZxK4mtf7A=
Date:   Wed, 19 Aug 2020 11:34:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anshuman.khandual@arm.com, leonro@nvidia.com,
        mm-commits@vger.kernel.org
Subject:  + mm-fix-missing-function-declaration.patch added to -mm
 tree
Message-ID: <20200819183400.o7TEDuD5k%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rodata_test.c: fix missing function declaration
has been added to the -mm tree.  Its filename is
     mm-fix-missing-function-declaration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-missing-function-declaration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-missing-function-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-missing-function-declaration.patch

