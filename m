Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD10C77B73
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 20:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjERUdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 16:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjERUdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 16:33:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E1310D0
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 13:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 779D9651FF
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 20:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC0BC433D2;
        Thu, 18 May 2023 20:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684442019;
        bh=PsoTUk12KrIs2uAqmJKSA+9CNvfdCbZ6LMcZVpe+SwA=;
        h=Date:To:From:Subject:From;
        b=pXupTkclHRkkjuHs2iK3XK/OeSB99wLZ1bvCO/7LaMTTdKY+3nPOs4L3nPpLjKb//
         F4AvMT96SU95hdgDIql6rXOL6KkwMrJtosIoaGDwSDTB65H1s3/ehXeU9RVRdsmcec
         v6nTVUEaqV/is7MCgP+/YWMrtd3KbwXlpryhfce0=
Date:   Thu, 18 May 2023 13:33:39 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch added to mm-unstable branch
Message-Id: <20230518203339.CBC0BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix
Date: Thu May 18 01:30:35 PM PDT 2023

suppress smatch "if (unsigned < 0)" warning

Cc: Oscar Salvador <osalvador@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305182345.LTMlWG84-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix
+++ a/lib/stackdepot.c
@@ -541,9 +541,8 @@ int stack_print(struct seq_file *m, void
 	int ret = 0;
 	struct stack_record *stack = v;
 
-	if (!stack->size || stack->size < 0 ||
-	    stack->size > PAGE_SIZE || stack->handle.valid != 1 ||
-	    refcount_read(&stack->count) < 1)
+	if (stack->size <= 0 || stack->size > PAGE_SIZE ||
+	    stack->handle.valid != 1 || refcount_read(&stack->count) < 1)
 		return 0;
 
 	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

