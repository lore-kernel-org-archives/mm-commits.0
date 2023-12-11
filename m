Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1982346BE
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XeXH4LxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7874C433C8;
	Mon, 11 Dec 2023 00:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256105;
	bh=u3sIAaDQM9kN+BomxixjIGUh3seIrT+UyAFmRfkbDkQ=;
	h=Date:To:From:Subject:From;
	b=XeXH4LxAKSSuqqCmD4oiN9sWNoW9VAbC8V+bDOWtRGexp9csuZT7tNBt8RdsoxXPm
	 EopZfgOUHLRAFDOm6+rSJrgUNeG2uw0xpjNaMS7q4eMfKJLNg2G+O17DsfnsBrqttP
	 ktZcGdJp7z+aFj4bbGOyFfQh9BYDWNu0x28wT4C8=
Date: Sun, 10 Dec 2023 16:55:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,feng.tang@intel.com,eugenis@google.com,elver@google.com,dvyukov@google.com,42.hyeyoo@gmail.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning.patch removed from -mm tree
Message-Id: <20231211005505.D7874C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slub, kasan: improve interaction of KASAN and slub_debug poisoning
has been removed from the -mm tree.  Its filename was
     slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: slub, kasan: improve interaction of KASAN and slub_debug poisoning
Date: Thu, 23 Nov 2023 00:12:02 +0100

When both KASAN and slub_debug are enabled, when a free object is being
prepared in setup_object, slub_debug poisons the object data before KASAN
initializes its per-object metadata.

Right now, in setup_object, KASAN only initializes the alloc metadata,
which is always stored outside of the object.  slub_debug is aware of this
and it skips poisoning and checking that memory area.

However, with the following patch in this series, KASAN also starts
initializing its free medata in setup_object.  As this metadata might be
stored within the object, this initialization might overwrite the
slub_debug poisoning.  This leads to slub_debug reports.

Thus, skip checking slub_debug poisoning of the object data area that
overlaps with the in-object KASAN free metadata.

Also make slub_debug poisoning of tail kmalloc redzones more precise when
KASAN is enabled: slub_debug can still poison and check the tail kmalloc
allocation area that comes after the KASAN free metadata.

Link: https://lkml.kernel.org/r/20231122231202.121277-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

--- a/mm/slub.c~slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning
+++ a/mm/slub.c
@@ -870,20 +870,20 @@ static inline void set_orig_size(struct
 				void *object, unsigned int orig_size)
 {
 	void *p = kasan_reset_tag(object);
+	unsigned int kasan_meta_size;
 
 	if (!slub_debug_orig_size(s))
 		return;
 
-#ifdef CONFIG_KASAN_GENERIC
 	/*
-	 * KASAN could save its free meta data in object's data area at
-	 * offset 0, if the size is larger than 'orig_size', it will
-	 * overlap the data redzone in [orig_size+1, object_size], and
-	 * the check should be skipped.
+	 * KASAN can save its free meta data inside of the object at offset 0.
+	 * If this meta data size is larger than 'orig_size', it will overlap
+	 * the data redzone in [orig_size+1, object_size]. Thus, we adjust
+	 * 'orig_size' to be as at least as big as KASAN's meta data.
 	 */
-	if (kasan_metadata_size(s, true) > orig_size)
-		orig_size = s->object_size;
-#endif
+	kasan_meta_size = kasan_metadata_size(s, true);
+	if (kasan_meta_size > orig_size)
+		orig_size = kasan_meta_size;
 
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
@@ -1192,7 +1192,7 @@ static int check_object(struct kmem_cach
 {
 	u8 *p = object;
 	u8 *endobject = object + s->object_size;
-	unsigned int orig_size;
+	unsigned int orig_size, kasan_meta_size;
 
 	if (s->flags & SLAB_RED_ZONE) {
 		if (!check_bytes_and_report(s, slab, object, "Left Redzone",
@@ -1222,12 +1222,23 @@ static int check_object(struct kmem_cach
 	}
 
 	if (s->flags & SLAB_POISON) {
-		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON) &&
-			(!check_bytes_and_report(s, slab, p, "Poison", p,
-					POISON_FREE, s->object_size - 1) ||
-			 !check_bytes_and_report(s, slab, p, "End Poison",
-				p + s->object_size - 1, POISON_END, 1)))
-			return 0;
+		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON)) {
+			/*
+			 * KASAN can save its free meta data inside of the
+			 * object at offset 0. Thus, skip checking the part of
+			 * the redzone that overlaps with the meta data.
+			 */
+			kasan_meta_size = kasan_metadata_size(s, true);
+			if (kasan_meta_size < s->object_size - 1 &&
+			    !check_bytes_and_report(s, slab, p, "Poison",
+					p + kasan_meta_size, POISON_FREE,
+					s->object_size - kasan_meta_size - 1))
+				return 0;
+			if (kasan_meta_size < s->object_size &&
+			    !check_bytes_and_report(s, slab, p, "End Poison",
+					p + s->object_size - 1, POISON_END, 1))
+				return 0;
+		}
 		/*
 		 * check_pad_bytes cleans up on its own.
 		 */
_

Patches currently in -mm which might be from andreyknvl@google.com are


