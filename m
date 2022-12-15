Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FB2C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 20:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLOU1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiLOU1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 15:27:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3BB389FF
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 12:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB69B81C12
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 20:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7917AC433EF;
        Thu, 15 Dec 2022 20:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671136020;
        bh=1uese0KmD3DmR+inX3lID6EuA49Pn7svcwguhkmdR0U=;
        h=Date:To:From:Subject:From;
        b=PU17clQqMi6Ucr8jzHhKgj7ST783SRcQ2xZYy/Ye3UF9LIQ0Qd0fhZaJK2oTU8DSG
         Us9v5hH5+TeVo/nKnUen3g0I40jn+8Dus2S5BtzKSXNiJSmARHT27uxZQVa1UaxHPb
         ZTyd0wClMfZOXfKlaJVWfKwROCrOyTJviyOIW8C0=
Date:   Thu, 15 Dec 2022 12:26:59 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        willy@infradead.org, vbabka@suse.cz, ke.wang@unisoc.com,
        huangzhaoyang@gmail.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch removed from -mm tree
Message-Id: <20221215202700.7917AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch

This patch was dropped because it was folded into mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix
Date: Thu Oct 27 02:28:05 PM PDT 2022

fix build - remove now-unused __save_stack_trace()

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix
+++ a/mm/kmemleak.c
@@ -617,14 +617,6 @@ static inline depot_stack_handle_t set_t
 #endif
 
 /*
- * Save stack trace to the given array of MAX_TRACE size.
- */
-static int __save_stack_trace(unsigned long *trace)
-{
-	return stack_trace_save(trace, MAX_TRACE, 2);
-}
-
-/*
  * Create the metadata (struct kmemleak_object) corresponding to an allocated
  * memory block and add it to the object_list and object_tree_root (or
  * object_phys_tree_root).
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch

