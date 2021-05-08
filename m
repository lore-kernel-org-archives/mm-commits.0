Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B99C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80A961402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhEHWp4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWp4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B5C6100C;
        Sat,  8 May 2021 22:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513894;
        bh=8fFO3P4Y/4llJLwxH2quaMn6JrbY0nwDhtQWlVZiTJg=;
        h=Date:From:To:Subject:From;
        b=iIn177C5ihEsdJcQ9j5XvORZxZyb27ftQntxqB7bvulS4tej4/E14Z1y5Q26+yVD7
         obOQZFbzwIHebACRBZc4T6x4YFrJ8i9jTD+CCzcWQDR0RDU0f5+86JIKTwq8L3Zeb7
         SaiNCzUPgDISW9nGRhYy8IW/t/bLNu1+QC9TS85o=
Date:   Sat, 08 May 2021 15:44:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, yuzhao@google.com
Subject:  [merged] mm-correctly-determine-last_cpupid_width.patch
 removed from -mm tree
Message-ID: <20210508224454.7O1s780jM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags-layout.h: correctly determine LAST_CPUPID_WIDTH
has been removed from the -mm tree.  Its filename was
     mm-correctly-determine-last_cpupid_width.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/page-flags-layout.h: correctly determine LAST_CPUPID_WIDTH

The naming convention used in include/linux/page-flags-layout.h:
  *_SHIFT: the number of bits trying to allocate
  *_WIDTH: the number of bits successfully allocated

So when it comes to LAST_CPUPID_WIDTH, we need to check whether all
previous *_WIDTH and LAST_CPUPID_SHIFT can fit into page flags. This
means we need to use NODES_WIDTH, not NODES_SHIFT.

Link: https://lkml.kernel.org/r/20210303071609.797782-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags-layout.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags-layout.h~mm-correctly-determine-last_cpupid_width
+++ a/include/linux/page-flags-layout.h
@@ -83,7 +83,7 @@
 #define KASAN_TAG_WIDTH 0
 #endif
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT+KASAN_TAG_WIDTH \
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_WIDTH+LAST_CPUPID_SHIFT+KASAN_TAG_WIDTH \
 	<= BITS_PER_LONG - NR_PAGEFLAGS
 #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
 #else
_

Patches currently in -mm which might be from yuzhao@google.com are


