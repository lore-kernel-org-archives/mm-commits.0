Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536AAC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A4322475
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgLODE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60819 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgLODEu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:50 -0500
Date:   Mon, 14 Dec 2020 19:03:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001436;
        bh=mFfAp7kTSMxpRo15TtzXC4BMilzX3c3CqhVozstlkg4=;
        h=From:To:Subject:In-Reply-To:From;
        b=onfIWUrZmwgybZXqQyXD0QoUjuwev9gdlSe+fd6MyNZpAXhFn8MBOf07VJaCWyOct
         zYAHYY+eEjpcKVQVFv5TB4gUA9RtiT24IlHSAR2aJsB4CLM6QCcyx22FyhV9uuLfsF
         SgX9ohtbFH4QY9d5jSbT8Nw8okqWJkohu6VE2ANk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org,
        alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com,
        bp@alien8.de, bp@suse.de, christian.koenig@amd.com, cl@linux.com,
        daniel.vetter@ffwll.ch, daniel@ffwll.ch, gustavo@padovan.org,
        iamjoonsoo.kim@lge.com, james.morse@arm.com, jasowang@redhat.com,
        linus.walleij@linaro.org, linux-mm@kvack.org,
        maarten.lankhorst@linux.intel.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, mripard@kernel.org, mst@redhat.com,
        penberg@kernel.org, perex@perex.cz, rientjes@google.com,
        rric@kernel.org, sumit.semwal@linaro.org, tiwai@suse.com,
        tiwai@suse.de, tony.luck@intel.com, torvalds@linux-foundation.org,
        tzimmermann@suse.de, vbabka@suse.cz
Subject:  [patch 013/200] mm: slab: provide krealloc_array()
Message-ID: <20201215030355.O2qo3ozcX%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: mm: slab: provide krealloc_array()

When allocating an array of elements, users should check for
multiplication overflow or preferably use one of the provided helpers
like: kmalloc_array().

There's no krealloc_array() counterpart but there are many users who use
regular krealloc() to reallocate arrays.  Let's provide an actual
krealloc_array() implementation.

While at it: add some documentation regarding krealloc.

Link: https://lkml.kernel.org/r/20201109110654.12547-3-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Robert Richter <rric@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-allocation.rst |    4 +++
 include/linux/slab.h                         |   18 +++++++++++++++++
 2 files changed, 22 insertions(+)

--- a/Documentation/core-api/memory-allocation.rst~mm-slab-provide-krealloc_array
+++ a/Documentation/core-api/memory-allocation.rst
@@ -147,6 +147,10 @@ The address of a chunk allocated with `k
 ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
 alignment is also guaranteed to be at least the respective size.
 
+Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
+to kmalloc_array(): a helper for resizing arrays is provided in the form of
+krealloc_array().
+
 For large allocations you can use vmalloc() and vzalloc(), or directly
 request pages from the page allocator. The memory allocated by `vmalloc`
 and related functions is not physically contiguous.
--- a/include/linux/slab.h~mm-slab-provide-krealloc_array
+++ a/include/linux/slab.h
@@ -593,6 +593,24 @@ static inline void *kmalloc_array(size_t
 }
 
 /**
+ * krealloc_array - reallocate memory for an array.
+ * @p: pointer to the memory chunk to reallocate
+ * @new_n: new number of elements to alloc
+ * @new_size: new size of a single member of the array
+ * @flags: the type of memory to allocate (see kmalloc)
+ */
+static __must_check inline void *
+krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
+		return NULL;
+
+	return krealloc(p, bytes, flags);
+}
+
+/**
  * kcalloc - allocate memory for an array. The memory is set to zero.
  * @n: number of elements.
  * @size: element size.
_
