Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE3EC77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjDUVxq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbjDUVxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7247530F5
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0589561363
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602F1C4339B;
        Fri, 21 Apr 2023 21:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113979;
        bh=J0HDyTyyj7rbDByTjgRdg8tUzF07IJrP4mva93LSm7k=;
        h=Date:To:From:Subject:From;
        b=Z4ORo/r242xiU3njZGuwT4COgVwMf+ZTqm+xU/hjgaewTCRu3YHuEH3b6IrggGVhK
         nXKpLi4TuReF/tH9TpF2OQTauIBpz1AoC+92CaVDMIM6lgG4Ojro4WtQxCKDbzpf19
         H0XevWkkSy9ceCJVk4k1nnPrta27xcO14lm5Cjws=
Date:   Fri, 21 Apr 2023 14:52:58 -0700
To:     mm-commits@vger.kernel.org, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparse-remove-unnecessary-0-values-from-rc.patch removed from -mm tree
Message-Id: <20230421215259.602F1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: : sparse: remove unnecessary 0 values from rc
has been removed from the -mm tree.  Its filename was
     sparse-remove-unnecessary-0-values-from-rc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: : sparse: remove unnecessary 0 values from rc
Date: Sat, 22 Apr 2023 05:47:33 +0800

rc is assigned first, so it does not need to initialize the
assignment.

Link: https://lkml.kernel.org/r/20230421214733.2909-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~sparse-remove-unnecessary-0-values-from-rc
+++ a/mm/sparse.c
@@ -832,7 +832,7 @@ static struct page * __meminit section_a
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	int rc = 0;
+	int rc;
 
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
_

Patches currently in -mm which might be from zeming@nfschina.com are


