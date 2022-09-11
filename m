Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89E5ECAAD3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIKXbJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIKXbI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F56192AE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A964461118
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080E6C43470;
        Sun, 11 Sep 2022 23:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662939066;
        bh=Uy36YZ/mLwkkvZplj77Tsb1YNexZY81uDp4I/1u9BJo=;
        h=Date:To:From:Subject:From;
        b=ndZ+6HvqwqIp2JnMx/W/x6uPDNiI36B0Iv3XlIXbT7i3SrZeBHJFDTjIJva31aHGZ
         FRIKcwY2LsgNSLL5FvXrQL5airnKc0VFZcBQgxkQHQAUZkQ4FcNaUGlq/as9GfsDFi
         Wp/6d3vuFbAdAyw56Ttff2w0PQJgOYeXd9X9nrLo=
Date:   Sun, 11 Sep 2022 16:31:05 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-add-struct-collapse_control-fix-fix.patch removed from -mm tree
Message-Id: <20220911233106.080E6C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-khugepaged-add-struct-collapse_control-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-struct-collapse_control-fix-fix.patch

This patch was dropped because it was folded into mm-khugepaged-add-struct-collapse_control.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-khugepaged-add-struct-collapse_control-fix-fix

fix build

Link: https://lkml.kernel.org/r/20220721195508.15f1e07a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-struct-collapse_control-fix-fix
+++ a/mm/khugepaged.c
@@ -87,7 +87,9 @@ static struct kmem_cache *mm_slot_cache
 
 struct collapse_control {
 	/* Num pages scanned per node */
-#if HPAGE_PMD_ORDER < 16
+#if defined(CONFIG_PPC64)
+	u32 node_load[MAX_NUMNODES];
+#elif HPAGE_PMD_ORDER < 16
 	u16 node_load[MAX_NUMNODES];
 #else
 	u32 node_load[MAX_NUMNODES];
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-khugepaged-add-struct-collapse_control.patch

