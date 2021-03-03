Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7B8C4360C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6752D64F02
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241546AbhCDA7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382303AbhCDALk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:11:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E957C64F10;
        Wed,  3 Mar 2021 23:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614813379;
        bh=qHlUn/vdnBm8z4Z293WaMsd6OZMxdgM6aw4FmoqBpkA=;
        h=Date:From:To:Subject:From;
        b=Xk0KA/JBTjDyuWT2L2w3bauN+BMJ8gr1IGFZ2dD92gNlgUl5pO07dQdZPCU500RSM
         cqIdClnLPJP+wjl6sEg1yaXDt05Y6s8lB5qML/5u17HZdr1SdjjLAEiObeZ+E3xOvZ
         avkit1hNunCAGp9HHjI/pjkAeH3uVUF/Ofd8gsqQ=
Date:   Wed, 03 Mar 2021 15:16:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, yuzhao@google.com
Subject:  + mm-correctly-determine-last_cpupid_width.patch added to
 -mm tree
Message-ID: <20210303231618.lzY235mS2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags-layout.h: correctly determine LAST_CPUPID_WIDTH
has been added to the -mm tree.  Its filename is
     mm-correctly-determine-last_cpupid_width.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-correctly-determine-last_cpupid_width.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-correctly-determine-last_cpupid_width.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-correctly-determine-last_cpupid_width.patch
mm-clean-up-include-linux-page-flags-layouth.patch

