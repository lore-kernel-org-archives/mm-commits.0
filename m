Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FA3C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D14560C3F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhHQAGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 20:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhHQAGk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 20:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F7F60EE4;
        Tue, 17 Aug 2021 00:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629158768;
        bh=X6u6Sjs9XC6W7tEUQxxor5ME8pWIGpxFw7fAZaBOeWM=;
        h=Date:From:To:Subject:From;
        b=BTMG+3bmuFCjMOMnEt9RZUdUwp9KRLX7Oj+fwvDnGgY+1PeCtDiDihGUFbhN3nAr6
         uuFTsdxoSoXVSL/dpyw8NLxnS2rdUnDxxzEbyP+1BPD3CAs6RpGOOeN9RpuqvPxYLp
         yCh85bCskBtfXxEF/zQisf+IQVssauiAt8MhiG6M=
Date:   Mon, 16 Aug 2021 17:06:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, pcc@google.com,
        rppt@linux.ibm.com
Subject:  +
 mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch
 added to -mm tree
Message-ID: <20210817000608.LBjyA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmflags.h: add missing __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON names
has been added to the -mm tree.  Its filename is
     mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mmflags.h: add missing __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON names

Add missing names of __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON flags to
__def_gfpflag_names.

Link: https://lkml.kernel.org/r/20210816133502.590-1-rppt@kernel.org
Fixes: 013bb59dbb7c ("arm64: mte: handle tags zeroing at page allocation time")
Fixes: c275c5c6d50a ("kasan: disable freed user page poisoning with HW tags")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/trace/events/mmflags.h~mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names
+++ a/include/trace/events/mmflags.h
@@ -48,7 +48,9 @@
 	{(unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
 	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
-	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"}\
+	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
+	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"},	\
+	{(unsigned long)__GFP_SKIP_KASAN_POISON,"__GFP_SKIP_KASAN_POISON"}\
 
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch
mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

