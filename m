Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9E9C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43E912177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781137;
	bh=qQTtSDa6o1vI/6AAveAi9Qdhgiu0qNk/FT0N/qiTuVw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SwKUaTmUVyI7Yg4C01YUhHgvACc7Q7P32esp/1yoQcxOJDK4rJaQhLKYKZsBGzkhF
	 Oq3ByzpFxgvytz9QrDKqtQp/KvRGv3VBlsLTijxQclLzvBJMfEkBdScBt3yo1P6jUo
	 q+XuyQlhTHYaF9l12033d/tOEwpqBeNB8ePDcE9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGS5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGS4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7FD22CAF;
        Fri,  7 Aug 2020 06:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781136;
        bh=qQTtSDa6o1vI/6AAveAi9Qdhgiu0qNk/FT0N/qiTuVw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=px2oTUnbsROli+QWpZEZIMiEfw/nCl+NmAtvrT9IV0woEh3eoXhzgn5igw0hqzV+a
         GPBANSUtwFnb6xe2P+xuNFQ3lKXEdh1z5OWyR1i+l4SvKn34iz7Oi4fGMnBxOGzMxt
         mg2cUcs5ycZHP2QaO8PsCFvZtt4ovRAIkYopL6S4=
Date:   Thu, 06 Aug 2020 23:18:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [patch 034/163] mm, slub: introduce
 kmem_cache_debug_flags()
Message-ID: <20200807061855.wsvIYh1Qy%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: introduce kmem_cache_debug_flags()

There are few places that call kmem_cache_debug(s) (which tests if any of
debug flags are enabled for a cache) immediately followed by a test for a
specific flag.  The compiler can probably eliminate the extra check, but
we can make the code nicer by introducing kmem_cache_debug_flags() that
works like kmem_cache_debug() (including the static key check) but tests
for specific flag(s).  The next patches will add more users.

[vbabka@suse.cz: change return from int to bool, per Kees.  Add VM_WARN_ON_ONCE() for invalid flags, per Roman]
  Link: http://lkml.kernel.org/r/949b90ed-e0f0-07d7-4d21-e30ec0958a7c@suse.cz
Link: http://lkml.kernel.org/r/20200610163135.17364-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-introduce-kmem_cache_debug_flags
+++ a/mm/slub.c
@@ -122,18 +122,29 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabl
 #endif
 #endif
 
-static inline int kmem_cache_debug(struct kmem_cache *s)
+/*
+ * Returns true if any of the specified slub_debug flags is enabled for the
+ * cache. Use only for flags parsed by setup_slub_debug() as it also enables
+ * the static key.
+ */
+static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 #ifdef CONFIG_SLUB_DEBUG
 	if (static_branch_unlikely(&slub_debug_enabled))
-		return s->flags & SLAB_DEBUG_FLAGS;
+		return s->flags & flags;
 #endif
-	return 0;
+	return false;
+}
+
+static inline bool kmem_cache_debug(struct kmem_cache *s)
+{
+	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
 }
 
 void *fixup_red_left(struct kmem_cache *s, void *p)
 {
-	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE)
+	if (kmem_cache_debug_flags(s, SLAB_RED_ZONE))
 		p += s->red_left_pad;
 
 	return p;
@@ -4060,7 +4071,7 @@ void __check_heap_object(const void *ptr
 	offset = (ptr - page_address(page)) % s->size;
 
 	/* Adjust for redzone and reject if within the redzone. */
-	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE) {
+	if (kmem_cache_debug_flags(s, SLAB_RED_ZONE)) {
 		if (offset < s->red_left_pad)
 			usercopy_abort("SLUB object in left red zone",
 				       s->name, to_user, offset, n);
_
