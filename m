Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A66DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiANWFF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBEFC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:05:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B565B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81664C36AEC;
        Fri, 14 Jan 2022 22:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197901;
        bh=aeiP0CVAOuboe4A0auBtbJ4KY6uC/wCHZee0BbxwxYM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A7+MhyY250/zaYyqloMogsYsYiswp3PoDmfdrCzmzVXEWslLBcDkns9D96XDUUGaN
         ytYvf+tqepS4DAPRsXRu79Q6dBUNaVvCvCnCfpgyM+YNYY7VyhLd+cUGVen5iKWEjD
         2ZMa8EUGhzH+6fEhBZnphvWk0c66PMaOUPZJCISQ=
Date:   Fri, 14 Jan 2022 14:05:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 039/146] kasan: fix quarantine conflicting with
 init_on_free
Message-ID: <20220114220501.Y1H1AtuvM%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix quarantine conflicting with init_on_free

KASAN's quarantine might save its metadata inside freed objects.  As this
happens after the memory is zeroed by the slab allocator when init_on_free
is enabled, the memory coming out of quarantine is not properly zeroed.

This causes lib/test_meminit.c tests to fail with Generic KASAN.

Zero the metadata when the object is removed from quarantine.

Link: https://lkml.kernel.org/r/2805da5df4b57138fdacd671f5d227d58950ba54.1640037083.git.andreyknvl@google.com
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/kasan/quarantine.c~kasan-fix-quarantine-conflicting-with-init_on_free
+++ a/mm/kasan/quarantine.c
@@ -132,12 +132,23 @@ static void *qlink_to_object(struct qlis
 static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
+	struct kasan_free_meta *meta = kasan_get_free_meta(cache, object);
 	unsigned long flags;
 
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
 	/*
+	 * If init_on_free is enabled and KASAN's free metadata is stored in
+	 * the object, zero the metadata. Otherwise, the object's memory will
+	 * not be properly zeroed, as KASAN saves the metadata after the slab
+	 * allocator zeroes the object.
+	 */
+	if (slab_want_init_on_free(cache) &&
+	    cache->kasan_info.free_meta_offset == 0)
+		memzero_explicit(meta, sizeof(*meta));
+
+	/*
 	 * As the object now gets freed from the quarantine, assume that its
 	 * free track is no longer valid.
 	 */
_
