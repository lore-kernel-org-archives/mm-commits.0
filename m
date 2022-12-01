Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C112C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiLAAEc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLAACq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2853F8C46D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DCDCB81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0556BC433D6;
        Thu,  1 Dec 2022 00:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852877;
        bh=7/LxvEdjL5L4cBDcQsA6r90fP/sR8VTzHttegavbahY=;
        h=Date:To:From:Subject:From;
        b=IkG3FflLUrt20pbfMv08NMTrv4z8YCPZgtaMwnM8GpcpqwyNcfsBD2Svg0mY/59Ub
         DvrItTgiyBua+lyI9QbEiU4v3qehTKlYsTC99CuXxFmWMQKNHVMpVgoLBPF+e8Uts5
         3b1E0GjRIMj5ynhNHCOMMPz8ESOT3vUjV0JfhCcU=
Date:   Wed, 30 Nov 2022 16:01:16 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        hughd@google.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch removed from -mm tree
Message-Id: <20221201000117.0556BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce 'encoded' page pointers with embedded extra bits
has been removed from the -mm tree.  Its filename was
     mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: introduce 'encoded' page pointers with embedded extra bits
Date: Wed, 9 Nov 2022 12:30:48 -0800

We already have this notion in parts of the MM code (see the mlock code
with the LRU_PAGE and NEW_PAGE bits), but I'm going to introduce a new
case, and I refuse to do the same thing we've done before where we just
put bits in the raw pointer and say it's still a normal pointer.

So this introduces a 'struct encoded_page' pointer that cannot be used for
anything else than to encode a real page pointer and a couple of extra
bits in the low bits.  That way the compiler can trivially track the state
of the pointer and you just explicitly encode and decode the extra bits.

Note that this makes the alignment of 'struct page' explicit even for the
case where CONFIG_HAVE_ALIGNED_STRUCT_PAGE is not set.  That is entirely
redundant in almost all cases, since the page structure already contains
several word-sized entries.

However, on m68k, the alignment of even 32-bit data is just 16 bits, and
as such in theory the alignment of 'struct page' could be too.  So let's
just make it very very explicit that the alignment needs to be at least 32
bits, giving us a guarantee of two unused low bits in the pointer.

Now, in practice, our page struct array is aligned much more than that
anyway, even on m68k, and our existing code in mm/mlock.c obviously
already depended on that.  But since the whole point of this change is to
be careful about the type system when hiding extra bits in the pointer,
let's also be explicit about the assumptions we make.

NOTE!  This is being very careful in another way too: it has a build-time
assertion that the 'flags' added to the page pointer actually fit in the
two bits.  That means that this helper must be inlined, and can only be
used in contexts where the compiler can statically determine that the
value fits in the available bits.

[akpm@linux-foundation.org: kerneldoc on a forward-declared struct confuses htmldocs]
Link: https://lore.kernel.org/all/Y2tKixpO4RO6DgW5@tuxmaker.boeblingen.de.ibm.com/
Link: https://lkml.kernel.org/r/20221109203051.1835763-1-torvalds@linux-foundation.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com> [s390]
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-introduce-encoded-page-pointers-with-embedded-extra-bits
+++ a/include/linux/mm_types.h
@@ -68,7 +68,7 @@ struct mem_cgroup;
 #ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
 #define _struct_page_alignment	__aligned(2 * sizeof(unsigned long))
 #else
-#define _struct_page_alignment
+#define _struct_page_alignment	__aligned(sizeof(unsigned long))
 #endif
 
 struct page {
@@ -251,6 +251,38 @@ struct page {
 #endif
 } _struct_page_alignment;
 
+/*
+ * struct encoded_page - a nonexistent type marking this pointer
+ *
+ * An 'encoded_page' pointer is a pointer to a regular 'struct page', but
+ * with the low bits of the pointer indicating extra context-dependent
+ * information. Not super-common, but happens in mmu_gather and mlock
+ * handling, and this acts as a type system check on that use.
+ *
+ * We only really have two guaranteed bits in general, although you could
+ * play with 'struct page' alignment (see CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+ * for more.
+ *
+ * Use the supplied helper functions to endcode/decode the pointer and bits.
+ */
+struct encoded_page;
+#define ENCODE_PAGE_BITS 3ul
+static __always_inline struct encoded_page *encode_page(struct page *page, unsigned long flags)
+{
+	BUILD_BUG_ON(flags > ENCODE_PAGE_BITS);
+	return (struct encoded_page *)(flags | (unsigned long)page);
+}
+
+static inline unsigned long encoded_page_flags(struct encoded_page *page)
+{
+	return ENCODE_PAGE_BITS & (unsigned long)page;
+}
+
+static inline struct page *encoded_page_ptr(struct encoded_page *page)
+{
+	return (struct page *)(~ENCODE_PAGE_BITS & (unsigned long)page);
+}
+
 /**
  * struct folio - Represents a contiguous set of bytes.
  * @flags: Identical to the page flags.
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are


