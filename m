Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EFBC7618A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjCOTiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCOTiv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598C549C3
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01637B81F16
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14EEC433EF;
        Wed, 15 Mar 2023 19:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909126;
        bh=crT9JgQ0trzGM5DAG9i4Xmq6+VBkjmODLUikoleGo+U=;
        h=Date:To:From:Subject:From;
        b=RdzBzHi5aWcSK3zFpG6iiwhGLF1wskxXuwWLO7d3yUWRnttWodai605H4lsnh+d9i
         V44WU6ENUTLdGq1UATaYVYC+u01NaKpkSoTBfXQU3E8YU9iy9sCUmDsLzU+a6jPlnp
         mqiop3m54ry6fr7ST+7yR+JjxAF9Nj5974Odg3Nk=
Date:   Wed, 15 Mar 2023 12:38:46 -0700
To:     mm-commits@vger.kernel.org, efremov@linux.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + floppy-fix-max_order-usage.patch added to mm-unstable branch
Message-Id: <20230315193846.B14EEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: floppy: fix MAX_ORDER usage
has been added to the -mm mm-unstable branch.  Its filename is
     floppy-fix-max_order-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/floppy-fix-max_order-usage.patch

This patch will later appear in the mm-unstable branch at
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

sparc-mm-fix-max_order-usage-in-tsb_grow.patch
um-fix-max_order-usage-in-linux_main.patch
floppy-fix-max_order-usage.patch
drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch
genwqe-fix-max_order-usage.patch
perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch
mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch
mm-slub-fix-max_order-usage-in-calculate_order.patch
iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch
mm-treewide-redefine-max_order-sanely.patch

