Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DFD34CDC
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t7PHalol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E87BC433C7;
	Fri,  5 Jan 2024 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478481;
	bh=uAHp8+OlYMbpRcyNCatq4xoHNRZMcXaqIuN2GnjDDA4=;
	h=Date:To:From:Subject:From;
	b=t7PHalolKVZbQLdqGadoJJ9JiZE+lVuBmNnAcLyEQAVdUMj1jvzypXJdUUBdie6K4
	 1TuQw/UyrKxw7KJ6Kzvdrm/v2FUhYKeJXDSuV1uMZqrgRunWR0Ltjw4acCyx/Em7yf
	 A+N92yZA9XXBm85d4ZC7OQ9uy3LYVA6ST9v0YeJU=
Date: Fri, 05 Jan 2024 10:14:40 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-stop-leaking-stack-trace-handles-fix.patch removed from -mm tree
Message-Id: <20240105181441.6E87BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan-stop-leaking-stack-trace-handles-fix
has been removed from the -mm tree.  Its filename was
     kasan-stop-leaking-stack-trace-handles-fix.patch

This patch was dropped because it was folded into kasan-stop-leaking-stack-trace-handles.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-stop-leaking-stack-trace-handles-fix
Date: Wed Dec 27 01:21:02 PM PST 2023

make release_free_meta() and release_alloc_meta)( static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312280213.6j147JJb-lkp@intel.Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/generic.c~kasan-stop-leaking-stack-trace-handles-fix
+++ a/mm/kasan/generic.c
@@ -503,7 +503,7 @@ void kasan_init_object_meta(struct kmem_
 	 */
 }
 
-void release_alloc_meta(struct kasan_alloc_meta *meta)
+static void release_alloc_meta(struct kasan_alloc_meta *meta)
 {
 	/* Evict the stack traces from stack depot. */
 	stack_depot_put(meta->alloc_track.stack);
@@ -514,7 +514,7 @@ void release_alloc_meta(struct kasan_all
 	__memset(meta, 0, sizeof(*meta));
 }
 
-void release_free_meta(const void *object, struct kasan_free_meta *meta)
+static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
 	/* Check if free meta is valid. */
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-stop-leaking-stack-trace-handles.patch

