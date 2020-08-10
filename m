Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759B2C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D9D206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026907;
	bh=cqRB6zaQua85NNdqj9lLmHbi3oKVCQkgK7wY9FVFPmo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LrRxrm++hsqTg3uAgu+F3C6fSG1qX9YSLo+90yiHem4bsNWMPcVL9ELVvxnMLER1h
	 zqM3IuMQ4CnYs23qnEY86Sk9NkDhG7KFckVNaF9iDFHDwTYvBPEnkP7CUCaFoePSH2
	 GbmaUqcUyAWjmyYaKrujrYmck/V4KFQLVG1lgd84=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B31B9206E9;
        Mon, 10 Aug 2020 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026906;
        bh=cqRB6zaQua85NNdqj9lLmHbi3oKVCQkgK7wY9FVFPmo=;
        h=Date:From:To:Subject:From;
        b=HoBHoWoYdjU1cOKIQOTuKJr/Hk/UrT+gdqTMMUQgaZeHksjSrPDCvgptEGRBGasLO
         phaqnmB1ZFTMrOZiXxDo7ordcynHO2zmrPY0TIn7NYTJ43nteF7p7tUNhSyIzHFTj/
         w1InzTQJvbtZdpBDHFTnt4weU6ivtiqczhvBPUQc=
Date:   Sun, 09 Aug 2020 19:35:05 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-introduce-static-key-for-slub_debug.patch removed from -mm tree
Message-ID: <20200810023505.nlADCiw0V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: introduce static key for slub_debug()
has been removed from the -mm tree.  Its filename was
     mm-slub-introduce-static-key-for-slub_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: introduce static key for slub_debug()

One advantage of CONFIG_SLUB_DEBUG is that a generic distro kernel can be
built with the option enabled, but it's inactive until simply enabled on
boot, without rebuilding the kernel.  With a static key, we can further
eliminate the overhead of checking whether a cache has a particular debug
flag enabled if we know that there are no such caches (slub_debug was not
enabled during boot).  We use the same mechanism also for e.g. 
page_owner, debug_pagealloc or kmemcg functionality.

This patch introduces the static key and makes the general check for
per-cache debug flags kmem_cache_debug() use it.  This benefits several
call sites, including (slow path but still rather frequent) __slab_free().
The next patches will add more uses.

Link: http://lkml.kernel.org/r/20200610163135.17364-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-introduce-static-key-for-slub_debug
+++ a/mm/slub.c
@@ -114,13 +114,21 @@
  * 			the fast path and disables lockless freelists.
  */
 
+#ifdef CONFIG_SLUB_DEBUG
+#ifdef CONFIG_SLUB_DEBUG_ON
+DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
+#else
+DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
+#endif
+#endif
+
 static inline int kmem_cache_debug(struct kmem_cache *s)
 {
 #ifdef CONFIG_SLUB_DEBUG
-	return unlikely(s->flags & SLAB_DEBUG_FLAGS);
-#else
-	return 0;
+	if (static_branch_unlikely(&slub_debug_enabled))
+		return s->flags & SLAB_DEBUG_FLAGS;
 #endif
+	return 0;
 }
 
 void *fixup_red_left(struct kmem_cache *s, void *p)
@@ -1389,6 +1397,8 @@ static int __init setup_slub_debug(char
 		slub_debug_string = saved_str;
 	}
 out:
+	if (slub_debug != 0 || slub_debug_string)
+		static_branch_enable(&slub_debug_enabled);
 	if ((static_branch_unlikely(&init_on_alloc) ||
 	     static_branch_unlikely(&init_on_free)) &&
 	    (slub_debug & SLAB_POISON))
_

Patches currently in -mm which might be from vbabka@suse.cz are


