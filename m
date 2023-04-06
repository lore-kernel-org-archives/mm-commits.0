Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58C8C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjDFCpI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjDFCoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFCE9025
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8ECF642A9
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C956C433D2;
        Thu,  6 Apr 2023 02:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749072;
        bh=DWu97Yu6o1ZqYCIqlZq3I2EU49xYZVMkmh1z6PFwGtw=;
        h=Date:To:From:Subject:From;
        b=P6G2oERY/EGyaBobOgAV7D/KA91YMRoCr86430BZB+tsPd4pEAC6bapGvGLOqkyj5
         mSezZypBpn/xyMKGYHkYI+l4QNsieQArsyHdQpEkO0mLlwclLHxn36fdph9gGD993R
         ta/ynfUyDWB2kh8KwFcixvLLPgv74T15+u9pVG78=
Date:   Wed, 05 Apr 2023 19:44:31 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, efremov@linux.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] floppy-fix-max_order-usage.patch removed from -mm tree
Message-Id: <20230406024432.3C956C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: floppy: fix MAX_ORDER usage
has been removed from the -mm tree.  Its filename was
     floppy-fix-max_order-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: floppy: fix MAX_ORDER usage
Date: Wed, 15 Mar 2023 14:31:26 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in floppy code.

Also allocation buffer exactly PAGE_SIZE << MAX_ORDER bytes is okay. Fix
MAX_LEN check.

Link: https://lkml.kernel.org/r/20230315113133.11326-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Denis Efremov <efremov@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/floppy.c~floppy-fix-max_order-usage
+++ a/drivers/block/floppy.c
@@ -3079,7 +3079,7 @@ static void raw_cmd_free(struct floppy_r
 	}
 }
 
-#define MAX_LEN (1UL << MAX_ORDER << PAGE_SHIFT)
+#define MAX_LEN (1UL << (MAX_ORDER - 1) << PAGE_SHIFT)
 
 static int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
@@ -3108,7 +3108,7 @@ loop:
 	ptr->resultcode = 0;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
-		if (ptr->length <= 0 || ptr->length >= MAX_LEN)
+		if (ptr->length <= 0 || ptr->length > MAX_LEN)
 			return -EINVAL;
 		ptr->kernel_data = (char *)fd_dma_mem_alloc(ptr->length);
 		fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


