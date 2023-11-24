Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBC1C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjKXT4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjKXT4b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:56:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC810F6
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:56:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4F2C433C8;
        Fri, 24 Nov 2023 19:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700855797;
        bh=s2WQ+xZ/30y3FhBI5CY9HzUUP9Vy9HvfeA33+49IvkM=;
        h=Date:To:From:Subject:From;
        b=wj9wBvOCU0TyQDuxsXPM0Q+N0khNX13tXC1i1RkvoGPWi8OsjhruX5sSCy4xcDRsL
         l3J8Fr0UJ8Cq1JxQC5TNv5/WaXx/d+i1a7tnpEpRWLf9ol5x0zZMrlhMZuAFei91JM
         em7Tg/W+tBU6pq+D0WI17FKFln/jNq2+JiFDZ3+Q=
Date:   Fri, 24 Nov 2023 11:56:36 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, juntong.deng@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-improve-free-meta-storage-in-generic-kasan-v3.patch added to mm-unstable branch
Message-Id: <20231124195637.3A4F2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: Improve free meta storage in Generic KASAN
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-improve-free-meta-storage-in-generic-kasan-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-improve-free-meta-storage-in-generic-kasan-v3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Juntong Deng <juntong.deng@outlook.com>
Subject: kasan: Improve free meta storage in Generic KASAN
Date: Wed, 22 Nov 2023 18:46:31 +0000

When SLUB DEBUG is enabled, the previous free meta storage method
continues to be used.  Cancel the change to kasan_metadata_size().

Make kasan_metadata_size() adapt to the improved free meta storage

Link: https://lkml.kernel.org/r/VI1P193MB0752675D6E0A2D16CE656F8299BAA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/kasan/generic.c~kasan-improve-free-meta-storage-in-generic-kasan-v3
+++ a/mm/kasan/generic.c
@@ -407,19 +407,28 @@ void kasan_cache_create(struct kmem_cach
 	 *    be touched after it was freed, or
 	 * 2. Object has a constructor, which means it's expected to
 	 *    retain its content until the next allocation, or
+	 * 3. Object is too small and SLUB DEBUG is enabled. Avoid
+	 *    free meta that exceeds the object size corrupts the
+	 *    SLUB DEBUG metadata.
 	 * Otherwise cache->kasan_info.free_meta_offset = 0 is implied.
-	 * Even if the object is smaller than free meta, it is still
-	 * possible to store part of the free meta in the object.
+	 * If the object is smaller than the free meta and SLUB DEBUG
+	 * is not enabled, it is still possible to store part of the
+	 * free meta in the object.
 	 */
 	if ((cache->flags & SLAB_TYPESAFE_BY_RCU) || cache->ctor) {
 		cache->kasan_info.free_meta_offset = *size;
 		*size += sizeof(struct kasan_free_meta);
 	} else if (cache->object_size < sizeof(struct kasan_free_meta)) {
-		rem_free_meta_size = sizeof(struct kasan_free_meta) -
-								cache->object_size;
-		*size += rem_free_meta_size;
-		if (cache->kasan_info.alloc_meta_offset != 0)
-			cache->kasan_info.alloc_meta_offset += rem_free_meta_size;
+		if (__slub_debug_enabled()) {
+			cache->kasan_info.free_meta_offset = *size;
+			*size += sizeof(struct kasan_free_meta);
+		} else {
+			rem_free_meta_size = sizeof(struct kasan_free_meta) -
+									cache->object_size;
+			*size += rem_free_meta_size;
+			if (cache->kasan_info.alloc_meta_offset != 0)
+				cache->kasan_info.alloc_meta_offset += rem_free_meta_size;
+		}
 	}
 
 	/* If free meta doesn't fit, don't add it. */
_

Patches currently in -mm which might be from juntong.deng@outlook.com are

kasan-improve-free-meta-storage-in-generic-kasan.patch
kasan-improve-free-meta-storage-in-generic-kasan-v3.patch

