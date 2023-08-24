Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED1CC3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbjHXXVH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbjHXXVE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836D8FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CA064509
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C7EC433C7;
        Thu, 24 Aug 2023 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919259;
        bh=usWKwTFgEvuCYmxJuBrkNt2KdTF7NkJ3GZ46fRnGg6s=;
        h=Date:To:From:Subject:From;
        b=RqVTkvQm0TFPVvxrGXX0RJeFTIqfltyynIvZoh1TA2nXDUq+y/1k3sCKszCBUIQfu
         VhsiCSCqk5ppcOKTt5/j5baq9eaYm8++jCOlolakxmcU2ac28bAlcS4i+gSxwfIpgd
         CjUhO5+9Pjtn8dSNB1l6tlVnXTCdkVcaFC4xp3rI=
Date:   Thu, 24 Aug 2023 16:20:59 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, lkp@intel.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-fix-mismerge.patch removed from -mm tree
Message-Id: <20230824232059.C6C7EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory.c: fix mismerge
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-mismerge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm/memory.c: fix mismerge
Date: Sat, 12 Aug 2023 16:56:25 +0100

Fix a build issue.

Link: https://lkml.kernel.org/r/ZNerqcNS4EBJA/2v@casper.infradead.org
Fixes: 4aaa60dad4d1 ("mm: allow per-VMA locks on file-backed VMAs")
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308121909.XNYBtqNI-lkp@intel.com/
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-fix-mismerge
+++ a/mm/memory.c
@@ -5457,7 +5457,7 @@ retry:
 	 * concurrent mremap() with MREMAP_DONTUNMAP could dissociate the VMA
 	 * from its anon_vma.
 	 */
-	if (unlikely(!vma->anon_vma && !vma_is_tcp(vma)))
+	if (vma_is_anonymous(vma) && !vma->anon_vma)
 		goto inval_end_read;
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are


