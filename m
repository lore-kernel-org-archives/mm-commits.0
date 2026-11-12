Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450647;
	b=gr9bgEV8R+ZGMaMlIiwXe3j6/23m98vRvgTizfktyc5z6xDzou5O/DFxr6KlQhfY9O10
	 3j+ERw7EqeD5fgdh4rykZjMnDXet2A89VSW8Pp06DMpnzBrIb0+EWfu1XrmWNt2hTvYlv
	 vZvGmiJAmuYGLD7XkuPOJHciqcYEtYDxxqsPHLkKGSi8rRp6r1EMipClIqznB7j2XzKmR
	 YEOnsQPbS84A6NIWMRp+kYmUN5ml6QEtIFEal1W5NlLSbm/U+yrclQFzxcKP7Jyy94d6/
	 A7P9AJJRENZq1w95LFYu9RIeyCyotCY66Pnw9jPHaWcCoTEZG221LU1n5Nc/kBa3UQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450647;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=clxJX8TlCEcgM3Kq8OAfdTdsOfmWUARKt4Dd/Z6LiuQ=;
	b=jHahIHJb4mNjG+1QWFlC/45mCGdUpu0k1GvhTaSOZq1CULC4VRXV+B1FYZV/KxRfap4y
	 0lkK9zHWON06XjTBi7dtY7e8a68cAs0Q07toghK9WFiEAc9x2Fc0w0OiUpWdxi9lSRluQ
	 hLDtIS+WMn9/MH1fwiD0rhXRRnqHebchcog8eHm5U+qWhjWZGSfiBUr1LhjxZxLw1l2R7
	 zdsIor6xfz36MkjndG7LSznjrBDTxy+FJwfx1Hizl5D5Wf4mkca5TEjKfihg9DpMMnnZZ
	 Y+Vspv5lD6ihrZbxpa9aucuOgpLgc3Ad2HXZpYv8DcOqK48froKn3pnMjRD32Z1lB/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lEaUkeBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CE4606A31C
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lEaUkeBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD0E1F00A05;
	Thu, 12 Nov 2026 02:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450647;
	bh=clxJX8TlCEcgM3Kq8OAfdTdsOfmWUARKt4Dd/Z6LiuQ=;
	h=Date:To:From:Subject;
	b=lEaUkeBq58crKMR1rUDqfSSb6XtbIX6QRdIYrmgtPwB57G4EdREcT9ftVSkoGqLux
	 8HRjOXw6dFD9N6IMWiBKtdp3Jww3CWjTJkJ3hSBucuoBC1ORGlofj/f/7LUtWnQ2CT
	 9HCfQWXqxToiOj5R9n1Vf7F9yv+mKTMPRutExMUY=
Date: Wed, 11 Nov 2026 18:30:46 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch added to mm-unstable branch
Message-Id: <20261112023046.DCD0E1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zsmalloc: encode 1-based obj_idx so valid obj is never 0
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: encode 1-based obj_idx so valid obj is never 0
Date: Wed, 11 Nov 2026 15:46:31 +0900

The next patch embeds struct zs_handle into zram and zswap entries, and a
handle is considered allocated when its obj is not 0.  But obj can be 0:
object 0 of a zspage whose first page is PFN 0 encodes to 0, and some
platforms do give PFN 0 to the page allocator.

Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a separate
tag bit, this doesn't take any bits from obj.  zsmalloc did the same
before handles moved to handle_cachep, see commit 67296874eb1c ("staging:
zsmalloc: Ensure handle is never 0 on success").

Link: https://lore.kernel.org/20261111064707.2568433-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 mm/zsmalloc.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0
+++ a/mm/zsmalloc.c
@@ -61,7 +61,8 @@
  * Object location (<PFN>, <obj_idx>) is encoded as
  * a single (unsigned long) handle value.
  *
- * Note that object index <obj_idx> starts from 0.
+ * Note that object index <obj_idx> starts from 0, and is encoded as
+ * <obj_idx> + 1 so that a valid encoded obj value is never 0.
  *
  * This is made more complicated by various memory models and PAE.
  */
@@ -169,9 +170,6 @@
 static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
 	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
 
-/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
-#define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -189,6 +187,11 @@ static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGE
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
+#define _ZS_MIN_ALLOC_RAW \
+	DIV_ROUND_UP(ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT, ZS_OBJ_IDX_MASK)
+#define ZS_MIN_ALLOC_SIZE \
+	MIN(ZS_MAX_ALLOC_SIZE, \
+	    MAX(32UL, ALIGN(_ZS_MIN_ALLOC_RAW, ZS_ALIGN)))
 #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
 				      ZS_SIZE_CLASS_DELTA) + 1)
 
@@ -794,8 +797,10 @@ static struct zpdesc *get_next_zpdesc(st
 static void obj_to_location(unsigned long obj, struct zpdesc **zpdesc,
 				unsigned int *obj_idx)
 {
+	VM_WARN_ON_ONCE(!(obj & ZS_OBJ_IDX_MASK));
+
 	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
-	*obj_idx = (obj & ZS_OBJ_IDX_MASK);
+	*obj_idx = (obj & ZS_OBJ_IDX_MASK) - 1;
 }
 
 static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
@@ -814,9 +819,11 @@ static unsigned long location_to_obj(str
 {
 	unsigned long obj;
 
+	VM_WARN_ON_ONCE(obj_idx + 1 > ZS_OBJ_IDX_MASK);
+
 	obj  = zpdesc_pfn(zpdesc) << ZS_OBJ_PFN_SHIFT;
 	obj |= (unsigned long)(class_idx & ZS_OBJ_CLASS_MASK) << ZS_OBJ_IDX_BITS;
-	obj |= obj_idx & ZS_OBJ_IDX_MASK;
+	obj |= (obj_idx + 1) & ZS_OBJ_IDX_MASK;
 
 	return obj;
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch
zram-drop-stale-comment-in-write_incompressible_page.patch
zram-drop-get_slot_handle-and-set_slot_handle.patch
zsmalloc-return-handle-from-obj_allocated.patch
zsmalloc-switch-handle-type-to-struct-zs_handle.patch
zram-check-mem_limit-before-allocating-zsmalloc-object.patch
zram-allocate-zsmalloc-object-under-slot-lock.patch
zswap-do-not-free-the-entry-if-its-pool-is-null.patch
zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch
zsmalloc-embed-struct-zs_handle-into-zram-and-zswap-entries.patch
zsmalloc-fold-zs_obj_write-into-zs_store.patch
zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch
zram-fix-quadratic-writeback-bitmap-search.patch

