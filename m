Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E691C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiLAACc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiLAAA6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A132888B5A
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52AE2B81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1061BC433B5;
        Thu,  1 Dec 2022 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852850;
        bh=WDLPtwpPkEItcOjG4bgLAWpJMqH+eAeTjC7CdFGaP/Q=;
        h=Date:To:From:Subject:From;
        b=tyV8FfJ+OdI0txvX13rJwfsYyjmeVdEW0dTH4TYbDO59uLFjnzvphxK3rPJ1ctkXO
         SXcCQnoP3tbeJBCk/HHdYkeiQTWdLI2O1XahYLM0OuvL+remtwPpq1JYyhLtdBtwwb
         HhGKN0z43V9IoNRq0pZiyvQR0mUfuMAjEsuPSPMs=
Date:   Wed, 30 Nov 2022 16:00:49 -0800
To:     mm-commits@vger.kernel.org, wangdeming@inspur.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-replace-is_err-with-is_err_value.patch removed from -mm tree
Message-Id: <20221201000050.1061BC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: replace IS_ERR() with IS_ERR_VALUE()
has been removed from the -mm tree.  Its filename was
     zsmalloc-replace-is_err-with-is_err_value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -387,7 +387,7 @@ static int zs_zpool_malloc(void *pool, s
 {
 	*handle = zs_malloc(pool, size, gfp);
 
-	if (IS_ERR((void *)(*handle)))
+	if (IS_ERR_VALUE(*handle))
 		return PTR_ERR((void *)*handle);
 	return 0;
 }
_

Patches currently in -mm which might be from wangdeming@inspur.com are


