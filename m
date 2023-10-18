Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 202B0CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbjJRPks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjJRPkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:40:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FC611C
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:40:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7F8C433C7;
        Wed, 18 Oct 2023 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643645;
        bh=DB5vEAzj4ykfnjST0ZjKSIkwEBLwWmoH0JJJTGR+XnM=;
        h=Date:To:From:Subject:From;
        b=hNMzzRMWoAEJ7XtxLzdVy3meYHtzzLxDcogH+P7Rli7Lfww/fTEX8l+Q0D/nI+vOF
         D5YDcEvZsCl5jhHaK+7+Flqfu1a9VNsE/X/9LmyfCwsvsiog+zkm81leXUiaD8VO7M
         WEDbd0vMtnenTavVyRNXD/xPI5uL6kObhhEBs9T0=
Date:   Wed, 18 Oct 2023 08:40:44 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, liushixin2@huawei.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20231018154045.5B7F8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch

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
Subject: mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes
Date: Wed Oct 18 08:40:15 AM PDT 2023


ERROR: "foo * bar" should be "foo *bar"
#39: FILE: mm/kmemleak.c:626:
+static struct kmemleak_object * __alloc_object(gfp_t gfp)

total: 1 errors, 0 warnings, 99 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-kmemleak-split-__create_object-into-two-functions.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes
+++ a/mm/kmemleak.c
@@ -623,7 +623,7 @@ static noinline depot_stack_handle_t set
 	return trace_handle;
 }
 
-static struct kmemleak_object * __alloc_object(gfp_t gfp)
+static struct kmemleak_object *__alloc_object(gfp_t gfp)
 {
 	struct kmemleak_object *object;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

