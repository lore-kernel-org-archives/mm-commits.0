Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9FFC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1AAE614A7
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhD3GBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhD3GBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBC261482;
        Fri, 30 Apr 2021 06:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762465;
        bh=wzVyx2/gTrUjjUh8rGUXc+QlgaMi+bgMIaKp6BLi97s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pV4f6NbmTIwCW08s4G6QDFIN051E6iSYMKbLVjVnsU4UzO5YIwBLfQ93Wv7L2LD5k
         53fwjR4oESr+hYgqvOupRtqPJ/+2n2acFEStr7n4cvV9f36pq9rcsGXfX2umy4/m4Q
         UQeQlLlW3S4iulnpN4OAk9c5+mZlhwRjLu2GZQQ8=
Date:   Thu, 29 Apr 2021 23:01:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 153/178] include/linux/page-flags-layout.h:
 correctly determine LAST_CPUPID_WIDTH
Message-ID: <20210430060104.JdsGwn9H0%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
