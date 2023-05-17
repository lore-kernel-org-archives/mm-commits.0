Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6480EC77B75
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 23:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjEQXFJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 19:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjEQXFJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 19:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96426E9D
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 16:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF1B664BB1
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 23:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228A7C433EF;
        Wed, 17 May 2023 23:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684364632;
        bh=VvUzu69C7sPi5YIqCjWX7e5oBZ2+H2ZBECeTmF4KtL0=;
        h=Date:To:From:Subject:From;
        b=VxlvUeKi9vcNgnx3eG2nMycw0FEAFiS4Lx8N31QJqir/zz9veOtTSS8+fPVzIPAI6
         gt62F9mCqtBOm2OES9wMgC6pVHdtZYQocutGb+k6ceV5T3HQRub2PTnwK9JEVGWb4V
         3Sho1XhD5YpK0Bfpbw4zoK1Cgh+zyXIfiSbstaik=
Date:   Wed, 17 May 2023 16:03:51 -0700
To:     mm-commits@vger.kernel.org, vincent.whitchurch@axis.com,
        phillip@squashfs.org.uk, hch@lst.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-cache-partial-compressed-blocks-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230517230352.228A7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs-cache-partial-compressed-blocks-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-cache-partial-compressed-blocks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-cache-partial-compressed-blocks-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-cache-partial-compressed-blocks-fix
Date: Wed May 17 04:01:12 PM PDT 2023

fs/squashfs/block.c needs linux/pagemap.h

fs/squashfs/block.c: In function 'squashfs_bio_read_cached':
fs/squashfs/block.c:143:27: error: implicit declaration of function 'add_to_page_cache_lru' [-Werror=implicit-function-declaration]
  143 |                 int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
      |                           ^~~~~~~~~~~~~~~~~~~~~
fs/squashfs/block.c:148:25: error: implicit declaration of function 'unlock_page'; did you mean 'alloc_page'? [-Werror=implicit-function-declaration]
  148 |                         unlock_page(head_to_cache);
      |                         ^~~~~~~~~~~
      |                         alloc_page
fs/squashfs/block.c: In function 'squashfs_bio_read':
fs/squashfs/block.c:193:32: error: implicit declaration of function 'find_get_page'; did you mean 'find_get_pid'? [-Werror=implicit-function-declaration]
  193 |                         page = find_get_page(cache_mapping,
      |                                ^~~~~~~~~~~~~
      |                                find_get_pid
fs/squashfs/block.c:193:30: error: assignment to 'struct page *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
  193 |                         page = find_get_page(cache_mapping,
      |                              ^
cc1: all warnings being treated as errors
make[3]: *** [scripts/Makefile.build:252: fs/squashfs/block.o] Error 1
make[2]: *** [scripts/Makefile.build:494: fs/squashfs] Error 2
make[1]: *** [scripts/Makefile.build:494: fs] Error 2
make: *** [Makefile:2026: .] Error 2

Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks-fix
+++ a/fs/squashfs/block.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
+#include <linux/pagemap.h>
 #include <linux/string.h>
 #include <linux/bio.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch

