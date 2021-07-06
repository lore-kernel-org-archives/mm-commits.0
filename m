Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8395C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C03EA61107
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhGFTPt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTPs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A6A060FEE;
        Tue,  6 Jul 2021 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598788;
        bh=Eqhrr4bZ1F8Fmv/4wZKSC4T4JwSQVFJ049F5j8hrs48=;
        h=Date:From:To:Subject:From;
        b=aYkT6cEPrfH0OgRSaK+GN6kKy5Xkawg49NRsxGkUyJm3OG1zvGfviW9fkE1zYQOrq
         qHWJo2lQLi4Xl+5xB97zNvseLY44zpkAq+q5yyjQR+yG96XwVaZ8dxqogr316RnKE7
         C7cE6CPU5bjugxbKTub6cNg1PrDtwClzvO8Xr/uM=
Date:   Tue, 06 Jul 2021 12:13:08 -0700
From:   akpm@linux-foundation.org
To:     jrdr.linux@gmail.com, lkp@intel.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, ysato@users.sourceforge.jp
Subject:  [merged] h8300-remove-unused-variable.patch removed from
 -mm tree
Message-ID: <20210706191308.0hNZpjxuw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: remove unused variable
has been removed from the -mm tree.  Its filename was
     h8300-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: h8300: remove unused variable

Kernel test robot throws below warning ->

>> arch/h8300/kernel/setup.c:72:26:
warning: Unused variable: region [unusedVariable]
    struct memblock_region *region;

Fixed it by removing unused variable.

Link: https://lkml.kernel.org/r/20210602185431.11416-1-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/h8300/kernel/setup.c~h8300-remove-unused-variable
+++ a/arch/h8300/kernel/setup.c
@@ -69,8 +69,6 @@ void __init h8300_fdt_init(void *fdt, ch
 
 static void __init bootmem_init(void)
 {
-	struct memblock_region *region;
-
 	memory_end = memory_start = 0;
 
 	/* Find main memory where is the kernel */
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are


