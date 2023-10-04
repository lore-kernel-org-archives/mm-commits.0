Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BF2E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbjJDURY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBBB93
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CF8C433C8;
        Wed,  4 Oct 2023 20:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450639;
        bh=7i/8VvZKxWSj8xw5YsIKTJq8gaZXhZtCgnFq9lswpNM=;
        h=Date:To:From:Subject:From;
        b=ExiXJFtw5c3zDW/C1ivPEKIYNZnGzNzHOA5FSe0P+ijvsbq6+zyljwff2wOlng4xg
         GjFY/aa+XjuxSO4MlOqcuQeg1HKCrdj8BhRDpLHsyhW7Gh7UsRyZbHqdsU2FArM8f4
         JNQ5E6LeNmogMBKr7Op+Ih3b27labUTAY2VjfRmI=
Date:   Wed, 04 Oct 2023 13:17:17 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rppt@kernel.org,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memblock-pass-memblock_type-to-memblock_setclr_flag-fix.patch removed from -mm tree
Message-Id: <20231004201719.35CF8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memblock: add missing argument definition
has been removed from the -mm tree.  Its filename was
     memblock-pass-memblock_type-to-memblock_setclr_flag-fix.patch

This patch was dropped because it was folded into memblock-pass-memblock_type-to-memblock_setclr_flag.patch

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: memblock: add missing argument definition
Date: Mon, 18 Sep 2023 10:06:57 +0100

Description of argument memblock_type was missing in the commit that
introduced it.

Link: https://lkml.kernel.org/r/20230918090657.220463-1-usama.arif@bytedance.com
Fixes: 70083e1c8ab4 ("memblock: pass memblock_type to memblock_setclr_flag")
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memblock.c~memblock-pass-memblock_type-to-memblock_setclr_flag-fix
+++ a/mm/memblock.c
@@ -892,6 +892,7 @@ int __init_memblock memblock_physmem_add
 
 /**
  * memblock_setclr_flag - set or clear flag for a memory region
+ * @type: memblock type to set/clear flag for
  * @base: base address of the region
  * @size: size of the region
  * @set: set or clear the flag
_

Patches currently in -mm which might be from usama.arif@bytedance.com are

mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch
memblock-pass-memblock_type-to-memblock_setclr_flag.patch
memblock-introduce-memblock_rsrv_noinit-flag.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo.patch

