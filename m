Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556B5C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377816AbiATVYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377821AbiATVYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD4E60C72
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D3CC340E3;
        Thu, 20 Jan 2022 21:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713871;
        bh=P5J/20yD9lj7+luUc5qoz6GC+zY02bDAPa35+PB/89A=;
        h=Date:From:To:Subject:From;
        b=hCzhPpQBlAhR4S2qKN3LXDAZOGSeRcgbHmmadtDGJISo/uKIpr61tyroL6MR+RNoG
         OSZTcJrG/jKib1Uwk9hrL+JvIjw29TyzXYMuUevmaawgB/5Ko+L/1BOXoX+/f/MSVI
         3lroJzxn43DwJX9zyBGAI6sqjnCZ9AKIsFalbv4w=
Date:   Thu, 20 Jan 2022 13:24:30 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-fix-quarantine-conflicting-with-init_on_free.patch removed from -mm
 tree
Message-ID: <20220120212430.SM-HPh7pu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix quarantine conflicting with init_on_free
has been removed from the -mm tree.  Its filename was
     kasan-fix-quarantine-conflicting-with-init_on_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are


