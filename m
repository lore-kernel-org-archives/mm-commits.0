Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4982EC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3285861C6D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhGFTKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231802AbhGFTKy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69AF561C56;
        Tue,  6 Jul 2021 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598494;
        bh=C1JzRli58DjFFAXJ2XbcKR76qEGq0Yea9+UpOLuE76A=;
        h=Date:From:To:Subject:From;
        b=uXrFNAguloayBAYpSs0IW+gehF/m6W/Cp3wRtnNBwZmOPSvYX/nVf7Yt1j5fSb208
         osWqyRauSSX9n42E1mv3U963Y1c/luTK7dCah2asFhjUvUN0UTw+8RwhadZgaQBuUa
         yoi5PhzGp3z8xdp2mCfel2Ht6CHENb2Xt9kBQLm8=
Date:   Tue, 06 Jul 2021 12:08:14 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, masahiroy@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged]
 ia64-mca_drv-fix-incorrect-array-size-calculation.patch removed from -mm
 tree
Message-ID: <20210706190814.JW_YK4-AH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mca_drv: fix incorrect array size calculation
has been removed from the -mm tree.  Its filename was
     ia64-mca_drv-fix-incorrect-array-size-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ia64: mca_drv: fix incorrect array size calculation

gcc points out a mistake in the mca driver that goes back to before the
git history:

arch/ia64/kernel/mca_drv.c: In function 'init_record_index_pools':
arch/ia64/kernel/mca_drv.c:346:54: error: expression does not compute the number of elements in this array; element typ
e is 'int', not 'size_t' {aka 'long unsigned int'} [-Werror=sizeof-array-div]
  346 |         for (i = 1; i < sizeof sal_log_sect_min_sizes/sizeof(size_t); i++)
      |                                                      ^

This is the same as sizeof(size_t), which is two shorter than the actual
array.  Use the ARRAY_SIZE() macro to get the correct calculation instead.

Link: https://lkml.kernel.org/r/20210514214123.875971-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/mca_drv.c~ia64-mca_drv-fix-incorrect-array-size-calculation
+++ a/arch/ia64/kernel/mca_drv.c
@@ -343,7 +343,7 @@ init_record_index_pools(void)
 
 	/* - 2 - */
 	sect_min_size = sal_log_sect_min_sizes[0];
-	for (i = 1; i < sizeof sal_log_sect_min_sizes/sizeof(size_t); i++)
+	for (i = 1; i < ARRAY_SIZE(sal_log_sect_min_sizes); i++)
 		if (sect_min_size > sal_log_sect_min_sizes[i])
 			sect_min_size = sal_log_sect_min_sizes[i];
 
_

Patches currently in -mm which might be from arnd@arndb.de are


