Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AA9C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5A0761481
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhC1VGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231349AbhC1VFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 17:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53C16193F;
        Sun, 28 Mar 2021 21:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616965539;
        bh=y5QM709cnQOcbHUYpyvrILcHIAbIqMItxrzRqcteDyQ=;
        h=Date:From:To:Subject:From;
        b=BpSzJmdknVE7qts479xCTEQtcntluU+TitzTCrKKmEsopyVRTQ0qgEMxNcSCyHbEj
         f8jxH9qYK4c7aiKpLyKURuxsgMf5EigpxiwV8E4FbXOwoWrs0thm2gzppCl0P3QbvZ
         hWseeYDXWg82yc3msRDtRYE1lRc7u9pUgKgn9+ic=
Date:   Sun, 28 Mar 2021 14:05:38 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, jhubbard@nvidia.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [to-be-updated] mm-cma-support-sysfs-fix.patch removed
 from -mm tree
Message-ID: <20210328210538.xPAa2mic4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix potential null dereference on pointer cma
has been removed from the -mm tree.  Its filename was
     mm-cma-support-sysfs-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm: cma: fix potential null dereference on pointer cma

At the start of the function there is a null pointer check on cma and then
branch to error handling label 'out'.  The subsequent call to
cma_sysfs_fail_pages_count dereferences cma, hence there is a potential
null pointer deference issue.  Fix this by only calling
cma_sysfs_fail_pages_count if cma is not null.

Addresses-Coverity: ("Dereference after null check")

Link: https://lkml.kernel.org/r/20210316100433.17665-1-colin.king@canonical.com
Fixes: dc4764f7e9ac ("mm: cma: support sysfs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-support-sysfs-fix
+++ a/mm/cma.c
@@ -512,7 +512,8 @@ out:
 		cma_sysfs_alloc_pages_count(cma, count);
 	} else {
 		count_vm_event(CMA_ALLOC_FAIL);
-		cma_sysfs_fail_pages_count(cma, count);
+		if (cma)
+			cma_sysfs_fail_pages_count(cma, count);
 	}
 
 	return page;
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-vmalloc-hugepage-vmalloc-mappings-fix.patch
proc-fix-incorrect-pde_is_permanent-check.patch
mm-slab-fix-spelling-mistake-disired-desired.patch

