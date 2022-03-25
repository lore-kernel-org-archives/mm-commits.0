Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AACC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiCYWoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4449D20A3BB
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5650614DE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36570C340ED;
        Fri, 25 Mar 2022 22:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248121;
        bh=CQMzFUkf9i7o9mBYwVnQTVJfW0ezHk3u0TSaWYIjSls=;
        h=Date:To:From:Subject:From;
        b=tVOyJiJLU3zYox0jec33I59k6GOwmEY1/y2xWdEvhvP+paMWXKOlB9ATEr8b+z1yT
         FNq3qfu/ZikE0MhniOs9tZMUA2EpJ55QEDcpRQVGzmdJQwTH9MwpduKOPrCZ9cY0lc
         BDgUN0rYx+HY0zxm/bFGIzUagPFNXRhlCvJskVOs=
Date:   Fri, 25 Mar 2022 15:42:00 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-clarify-__gfp_zerotags-comment.patch removed from -mm tree
Message-Id: <20220325224201.36570C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify __GFP_ZEROTAGS comment
has been removed from the -mm tree.  Its filename was
     mm-clarify-__gfp_zerotags-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm: clarify __GFP_ZEROTAGS comment

__GFP_ZEROTAGS is intended as an optimization: if memory is zeroed during
allocation, it's possible to set memory tags at the same time with little
performance impact.

Clarify this intention of __GFP_ZEROTAGS in the comment.

Link: https://lkml.kernel.org/r/cdffde013973c5634a447513e10ec0d21e8eee29.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-clarify-__gfp_zerotags-comment
+++ a/include/linux/gfp.h
@@ -232,8 +232,10 @@ struct vm_area_struct;
  *
  * %__GFP_ZERO returns a zeroed page on success.
  *
- * %__GFP_ZEROTAGS returns a page with zeroed memory tags on success, if
- * __GFP_ZERO is set.
+ * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
+ * is being zeroed (either via __GFP_ZERO or via init_on_alloc). This flag is
+ * intended for optimization: setting memory tags at the same time as zeroing
+ * memory has minimal additional performace impact.
  *
  * %__GFP_SKIP_KASAN_POISON returns a page which does not need to be poisoned
  * on deallocation. Typically used for userspace pages. Currently only has an
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

