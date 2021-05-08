Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8734EC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D523613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWo6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhEHWo6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF04E61415;
        Sat,  8 May 2021 22:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513836;
        bh=W6frtunQMTw6/4lH6cS7aT2/UEMat2OM6BU7ykmTntE=;
        h=Date:From:To:Subject:From;
        b=wgEtK4HyMRxPjyi+Zhs7m1iT3sPcmIq+wgzZYV7GWOq1N4tmkC1sAywoOCYKxzQWV
         CEG7voAuc87I5JFdUZz9EOIEFvAIRtYpXi/8mUn9MVlbEnoEfhWtDlbWWj0GfFsOG1
         g99zHYe3HNHteo2qx+3+w7EIt+PlhbgX0TAcdcWM=
Date:   Sat, 08 May 2021 15:43:55 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, hch@infradead.org, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch removed from -mm
 tree
Message-ID: <20210508224355.vAAQpCUVe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: initialize shadow to TAG_INVALID for SW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: initialize shadow to TAG_INVALID for SW_TAGS

Currently, KASAN_SW_TAGS uses 0xFF as the default tag value for
unallocated memory.  The underlying idea is that since that memory hasn't
been allocated yet, it's only supposed to be dereferenced through a
pointer with the native 0xFF tag.

While this is a good idea in terms on consistency, practically it doesn't
bring any benefit.  Since the 0xFF pointer tag is a match-all tag, it
doesn't matter what tag the accessed memory has.  No accesses through
0xFF-tagged pointers are considered buggy by KASAN.

This patch changes the default tag value for unallocated memory to 0xFE,
which is the tag KASAN uses for inaccessible memory.  This doesn't affect
accesses through 0xFF-tagged pointer to this memory, but this allows KASAN
to detect wild and large out-of-bounds invalid memory accesses through
otherwise-tagged pointers.

This is a prepatory patch for the next one, which changes the tag-based
KASAN modes to not poison the boot memory.

Link: https://lkml.kernel.org/r/c8e93571c18b3528aac5eb33ade213bf133d10ad.1613692950.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/kasan.h~kasan-initialize-shadow-to-tag_invalid-for-sw_tags
+++ a/include/linux/kasan.h
@@ -30,7 +30,8 @@ struct kunit_kasan_expectation {
 /* Software KASAN implementations use shadow memory. */
 
 #ifdef CONFIG_KASAN_SW_TAGS
-#define KASAN_SHADOW_INIT 0xFF
+/* This matches KASAN_TAG_INVALID. */
+#define KASAN_SHADOW_INIT 0xFE
 #else
 #define KASAN_SHADOW_INIT 0
 #endif
_

Patches currently in -mm which might be from andreyknvl@google.com are


