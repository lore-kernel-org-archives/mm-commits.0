Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AFBC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbjHKXA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbjHKW7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D563A98
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 509ED676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73A9C433C8;
        Fri, 11 Aug 2023 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794768;
        bh=3rVQjNV7TXFwZvh1z6AvnijZ8uOmryiDmKeY8i9w4gc=;
        h=Date:To:From:Subject:From;
        b=UkoHWdx9qAZysQwCC103ZW+Yvntv329dI0gq5JKUYLHnNyXJbipXIo6CLXF4Ud33r
         Q4/77uvyFRErgeUkoAeQJOJ/EAuW8QWMnAa+ZPrprwansYRRxSAUCZrtit8+QC5twr
         1kZ0PtcfnQODhuS5DFEk4J8JFwgM/M/d1I+Vz0Pw=
Date:   Fri, 11 Aug 2023 15:59:28 -0700
To:     mm-commits@vger.kernel.org, pintu.ping@gmail.com,
        minchan@kernel.org, quic_pintu@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-print-cma-name-as-well-in-cma_alloc-debug.patch removed from -mm tree
Message-Id: <20230811225928.A73A9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: cma: print cma name as well in cma_alloc debug
has been removed from the -mm tree.  Its filename was
     mm-cma-print-cma-name-as-well-in-cma_alloc-debug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm: cma: print cma name as well in cma_alloc debug
Date: Fri, 7 Jul 2023 00:03:34 +0530

CMA allocation can happen either from global cma or from dedicated cma
region.

Thus it is helpful to print cma name as well during initial
debugging to confirm cma regions were getting initialized or not.

Link: https://lkml.kernel.org/r/1688668414-12350-1-git-send-email-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Signed-off-by: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-print-cma-name-as-well-in-cma_alloc-debug
+++ a/mm/cma.c
@@ -436,8 +436,8 @@ struct page *cma_alloc(struct cma *cma,
 	if (!cma || !cma->count || !cma->bitmap)
 		goto out;
 
-	pr_debug("%s(cma %p, count %lu, align %d)\n", __func__, (void *)cma,
-		 count, align);
+	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
+		(void *)cma, cma->name, count, align);
 
 	if (!count)
 		goto out;
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are


