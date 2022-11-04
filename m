Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4792CC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiKDWFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKDWFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:05:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF4D6555
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3226233F
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C97C433D6;
        Fri,  4 Nov 2022 22:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667599548;
        bh=Txi/sgL+Rsbj8hGUl4n0fdhL9/f0GhAE4Y7esdAs2UQ=;
        h=Date:To:From:Subject:From;
        b=Y0EPJSsVeKK4+36dRFjZNa9/wHr5p1LlPMKdrV5hO3VIbDM1t4XvKI218kcSsrjM7
         vQPyWXQTsAz071MWSypGxjwrv2+Ola/ECyhkc3sr0zf58IRq3HDQYp5i5LZyYkz4/c
         rXdMi/aYMxE1BJa2p1KPXnyr28i8L+cOjrwq4i1s=
Date:   Fri, 04 Nov 2022 15:05:47 -0700
To:     mm-commits@vger.kernel.org, wangdeming@inspur.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-replace-is_err-with-is_err_value.patch added to mm-unstable branch
Message-Id: <20221104220548.01C97C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: replace IS_ERR() with IS_ERR_VALUE()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-replace-is_err-with-is_err_value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-replace-is_err-with-is_err_value.patch

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
From: Deming Wang <wangdeming@inspur.com>
Subject: zsmalloc: replace IS_ERR() with IS_ERR_VALUE()
Date: Thu, 3 Nov 2022 22:38:18 -0400

Avoid typecasts that are needed for IS_ERR() and use IS_ERR_VALUE()
instead.

Link: https://lkml.kernel.org/r/20221104023818.1728-1-wangdeming@inspur.com
Signed-off-by: Deming Wang <wangdeming@inspur.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-replace-is_err-with-is_err_value
+++ a/mm/zsmalloc.c
@@ -379,7 +379,7 @@ static int zs_zpool_malloc(void *pool, s
 {
 	*handle = zs_malloc(pool, size, gfp);
 
-	if (IS_ERR((void *)(*handle)))
+	if (IS_ERR_VALUE(*handle))
 		return PTR_ERR((void *)*handle);
 	return 0;
 }
_

Patches currently in -mm which might be from wangdeming@inspur.com are

mm-use-vma_lookup-instead-of-find_vma.patch
zsmalloc-replace-is_err-with-is_err_value.patch

