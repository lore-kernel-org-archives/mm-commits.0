Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F991369
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJBQ6cBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9174FC433C8;
	Mon, 11 Dec 2023 00:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255515;
	bh=YOKXwDcLUhte7A7C+emWTH9zSeOP2sceF2lfPU0zO1E=;
	h=Date:To:From:Subject:From;
	b=AJBQ6cBdgcl+de1QdivryqnfobpHQNrhNaoQQ7//rkIMPL2fc9xJ6uPw0V/XU1eCl
	 Q5pCoTAIYcNtWOdfUT6biOlZOFIrWhfpy5B+HTHzqg7p/fQkapUiY7+JgoJZpO0Lxp
	 KvhFjc3i5Bto0qGJbxndGa4dfBxokqq6V4q96KqY=
Date: Sun, 10 Dec 2023 16:45:15 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,juntong.deng@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-improve-free-meta-storage-in-generic-kasan-v3.patch removed from -mm tree
Message-Id: <20231211004515.9174FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: Improve free meta storage in Generic KASAN
has been removed from the -mm tree.  Its filename was
     kasan-improve-free-meta-storage-in-generic-kasan-v3.patch

This patch was dropped because it was folded into kasan-improve-free-meta-storage-in-generic-kasan.patch

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
kasan-record-and-report-more-information.patch

