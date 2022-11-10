Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A1CC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKJAJV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiKJAJU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:09:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5A365EC
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B95C2B81F40
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C6CC433C1;
        Thu, 10 Nov 2022 00:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668038955;
        bh=L4L7ZztNdNLFvQpg+YRXhQXjs3F4vinjVikgAdrprKo=;
        h=Date:To:From:Subject:From;
        b=K+1stAG2qOtMp7Hjoyh+qc6Uq4z7slddmkSxcSNpC4x8c0KzyszX0AY8ga+ipYUqp
         rA6EaQ1WC3h7PReDuHL6ufjtDmn+As0aDmNr3J6jK2/iUO9tcq6MI9SaIsFzCrPfMZ
         OLXR7eWfASantb2C3tn4ErrnPPh+Z96uBfBmDj68=
Date:   Wed, 09 Nov 2022 16:09:14 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        hughd@google.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch added to mm-unstable branch
Message-Id: <20221110000915.57C6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce 'encoded' page pointers with embedded extra bits
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch

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

Link: https://lore.kernel.org/all/Y2tKixpO4RO6DgW5@tuxmaker.boeblingen.de.ibm.com/
Link: https://lkml.kernel.org/r/20221109203051.1835763-1-torvalds@linux-foundation.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
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
@@ -252,6 +252,38 @@ struct page {
 } _struct_page_alignment;
 
 /**
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
+/**
  * struct folio - Represents a contiguous set of bytes.
  * @flags: Identical to the page flags.
  * @lru: Least Recently Used list; tracks how recently this folio was used.
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch
mm-teach-release_pages-to-take-an-array-of-encoded-page-pointers-too.patch
mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed.patch

