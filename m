Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C043C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB1F61469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbhGABHT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238272AbhGABHS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6625161424;
        Thu,  1 Jul 2021 01:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101488;
        bh=zJqsCCdLRKBVZQUY2a9g2SJT7PtjThz9+rB1xPyl3Qs=;
        h=Date:From:To:Subject:From;
        b=y06VsvGWvEtE2bUU1LuX4zACyVsrv4FOOlIGkgwRa2lJJtm0Q5D5k+nxzUUX6PcC7
         31SgzVWoYDKNlE7WgU0+iDpGDGIV0trrj67uNaNDQQSdG8XbNff8PJHF7zCw6tOcpf
         GEPMJAmS/mk6m+TVb4P7Pr/xWB5soYYuRvvUqR9s=
Date:   Wed, 30 Jun 2021 18:04:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yukuai3@huawei.com
Subject:  [folded-merged]
 lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch removed
 from -mm tree
Message-ID: <20210701010448.oFgKxezf9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-decompressors-remove-set-but-not-used-variabled-level-fix
has been removed from the -mm tree.  Its filename was
     lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch

This patch was dropped because it was folded into lib-decompressors-remove-set-but-not-used-variabled-level.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-decompressors-remove-set-but-not-used-variabled-level-fix

warning: value computed is not used

Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_unlzo.c~lib-decompressors-remove-set-but-not-used-variabled-level-fix
+++ a/lib/decompress_unlzo.c
@@ -64,7 +64,7 @@ STATIC inline long INIT parse_header(u8
 	version = get_unaligned_be16(parse);
 	parse += 7;
 	if (version >= 0x0940)
-		*parse++;
+		parse++;
 	if (get_unaligned_be32(parse) & HEADER_HAS_FILTER)
 		parse += 8; /* flags + filter info */
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-decompressors-remove-set-but-not-used-variabled-level.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

