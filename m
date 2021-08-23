Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B0BC4320E
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5D761391
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhHWSY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhHWSYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Aug 2021 14:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE7B613A5;
        Mon, 23 Aug 2021 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743052;
        bh=bvmV5Lil/A6z8WYHHo0AtO8v6xb2bvyACsZnQrkofHQ=;
        h=Date:From:To:Subject:From;
        b=a8ccYnc6Wst3+ksUB/76l0NO27H+vJuC6xsjKnAlnFG4PtTtCC1qLE4QKyF8ymvc9
         nsPko022vZN+Y/gBSum6SmE6faomK/KyXuCfDwo8//yYp8IK6nTA7whg1hUF3iNKGs
         8fIuXY56xxVKZiykSq2wQxWBDdxkxJmxEKFcNMQM=
Date:   Mon, 23 Aug 2021 11:24:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pcc@google.com, rostedt@goodmis.org,
        rppt@linux.ibm.com
Subject:  [merged]
 mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch
 removed from -mm tree
Message-ID: <20210823182412.9_z8M13VF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmflags.h: add missing __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON names
has been removed from the -mm tree.  Its filename was
     mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mmflags.h: add missing __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON names

printk("%pGg") outputs these two flags as hexadecimal number, rather
than as a string, e.g:

	GFP_KERNEL|0x1800000

Fix this by adding missing names of __GFP_ZEROTAGS and
__GFP_SKIP_KASAN_POISON flags to __def_gfpflag_names.

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

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
memblock-make-memblock_find_in_range-method-private.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

