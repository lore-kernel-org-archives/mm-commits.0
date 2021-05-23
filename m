Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBAEC2B9FB
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC9B6100A
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhEWAnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADBF3611AB;
        Sun, 23 May 2021 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730517;
        bh=FC0nVeOsbN/Gx418s9w8V/+WirPHgOkJCT6LD6MsUI4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dSiMfGtZo5CXL6AxsihSa4ADAr0t0XfMvVyi/25c+uSoPlmwua2CvKRmmq94UzjeB
         BnBuw4c10nvAxyd0u7Xmx/11I38khs5KJPyOiNeqc6GzAYk9bagxk88eDeLRVVMgoK
         QISrD+J/ad/P/WkdEbArBGmf/iSeH9ZSI27EKLUM=
Date:   Sat, 22 May 2021 17:41:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        aryabinin@virtuozzo.com, eberman@codeaurora.org, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com
Subject:  [patch 05/10] kasan: slab: always reset the tag in
 get_freepointer_safe()
Message-ID: <20210523004156.1-UnZ7NxI%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: kasan: slab: always reset the tag in get_freepointer_safe()

With CONFIG_DEBUG_PAGEALLOC enabled, the kernel should also untag the
object pointer, as done in get_freepointer().

Failing to do so reportedly leads to SLUB freelist corruptions that
manifest as boot-time crashes.

Link: https://lkml.kernel.org/r/20210514072228.534418-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Elliot Berman <eberman@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~kasan-slab-always-reset-the-tag-in-get_freepointer_safe
+++ a/mm/slub.c
@@ -301,6 +301,7 @@ static inline void *get_freepointer_safe
 	if (!debug_pagealloc_enabled_static())
 		return get_freepointer(s, object);
 
+	object = kasan_reset_tag(object);
 	freepointer_addr = (unsigned long)object + s->offset;
 	copy_from_kernel_nofault(&p, (void **)freepointer_addr, sizeof(p));
 	return freelist_ptr(s, p, freepointer_addr);
_
