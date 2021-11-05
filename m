Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DABC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BA561279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhKEUig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEUie (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E53F8611C0;
        Fri,  5 Nov 2021 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144554;
        bh=gX87Amf+PVnytwD7lQr6QutoFY5VcSy+n6KZz8x7OyM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1706hhnPNBVGScm7AIY7L1lLMQC6lbVfC9UQQMKtcwGTj8CbTKo05gDMaiQ6cia7X
         4Z/Db2KWpykaJxX/e5SYD1eCPVAxNZkaXVqJVw+OVDXfvdInVsWxnzq4oNYy0Nj8yi
         WcHBQurkQtcnt1amPinOvlP3hdJwPS98rJFeTUzY=
Date:   Fri, 05 Nov 2021 13:35:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 025/262] kasan: fix tag for large allocations when
 using CONFIG_SLAB
Message-ID: <20211105203553.dTwQoHYqA%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: kasan: fix tag for large allocations when using CONFIG_SLAB

If an object is allocated on a tail page of a multi-page slab, kasan will
get the wrong tag because page->s_mem is NULL for tail pages.  I'm not
quite sure what the user-visible effect of this might be.

Link: https://lkml.kernel.org/r/20211001024105.3217339-1-willy@infradead.org
Fixes: 7f94ffbc4c6a ("kasan: add hooks implementation for tag-based mode")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-fix-tag-for-large-allocations-when-using-config_slab
+++ a/mm/kasan/common.c
@@ -298,7 +298,7 @@ static inline u8 assign_tag(struct kmem_
 	/* For caches that either have a constructor or SLAB_TYPESAFE_BY_RCU: */
 #ifdef CONFIG_SLAB
 	/* For SLAB assign tags based on the object index in the freelist. */
-	return (u8)obj_to_index(cache, virt_to_page(object), (void *)object);
+	return (u8)obj_to_index(cache, virt_to_head_page(object), (void *)object);
 #else
 	/*
 	 * For SLUB assign a random tag during slab creation, otherwise reuse
_
