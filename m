Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F6CC0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJYXhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJYXhB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:37:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE47713A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:36:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF56C433C8;
        Wed, 25 Oct 2023 23:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277019;
        bh=GW1Vx/J74k9/7Ox5TbfSAc2HaNI6tlxieuzpV+sYx5A=;
        h=Date:To:From:Subject:From;
        b=gElD+S+KvVnzMIzoCnw6c/DHGhNsyhqNnaJ3BHw8ajRej3ymJEiBEZfhVQOVg57UH
         ojhBjKwGAVp7ICgRE6snYdP21wVNDlIcdee8dDm3qtWIpKMtqZbuYeCWfgM5iCHIHv
         A/GgFmWDZsa410gMENvrrwQCR/FH6S27zW2fLXN4=
Date:   Wed, 25 Oct 2023 16:36:58 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, liushixin2@huawei.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20231025233659.6CF56C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-kmemleak-split-__create_object-into-two-functions.patch

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
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch

