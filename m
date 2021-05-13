Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBDBC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DF861405
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhEMWfA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 18:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234097AbhEMWea (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 18:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9943613CD;
        Thu, 13 May 2021 22:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620945197;
        bh=DqXP3iQdWzlGnA9k9WMvbbezsLMbrAuE5mcDBe77zJg=;
        h=Date:From:To:Subject:From;
        b=1gSCwczT6gpCr50AvHfJnuqE2TFsn1KQsJVJ63At161EmKGHrIxR/TjSGsbAYcus4
         fJSPqGveeoZbqLKwVj4dqGIz3uGgA4DsJiXv3KSL0hrJLE/Z0X9LaU1TJS/GF+PoFF
         R70/uMd/qoVfXWNBzltFd99I2+2HlgzpiyEsuIpc=
Date:   Thu, 13 May 2021 15:33:16 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, elver@google.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch
 added to -mm tree
Message-ID: <20210513223316.sZxb-W_De%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: change run-time assertion in kmalloc_index() to compile-time
has been added to the -mm tree.  Its filename is
     mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, slub: change run-time assertion in kmalloc_index() to compile-time

Currently when size is not supported by kmalloc_index, compiler will
generate a run-time BUG() while compile-time error is also possible, and
better.  So change BUG to BUILD_BUG_ON_MSG to make compile-time check
possible.

Also remove code that allocates more than 32MB because current
implementation supports only up to 32MB.

Link: https://lkml.kernel.org/r/20210511173448.GA54466@hyeyoo
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    7 +++++--
 mm/slab_common.c     |    7 +++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/slab.h~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/include/linux/slab.h
@@ -346,6 +346,9 @@ static __always_inline enum kmalloc_cach
  * 1 =  65 .. 96 bytes
  * 2 = 129 .. 192 bytes
  * n = 2^(n-1)+1 .. 2^n
+ *
+ * Note: there's no need to optimize kmalloc_index because it's evaluated
+ * in compile-time.
  */
 static __always_inline unsigned int kmalloc_index(size_t size)
 {
@@ -382,8 +385,8 @@ static __always_inline unsigned int kmal
 	if (size <=  8 * 1024 * 1024) return 23;
 	if (size <=  16 * 1024 * 1024) return 24;
 	if (size <=  32 * 1024 * 1024) return 25;
-	if (size <=  64 * 1024 * 1024) return 26;
-	BUG();
+
+	BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
 
 	/* Will never be reached. Needed because the compiler may complain */
 	return -1;
--- a/mm/slab_common.c~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/mm/slab_common.c
@@ -755,8 +755,8 @@ struct kmem_cache *kmalloc_slab(size_t s
 
 /*
  * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
- * kmalloc_index() supports up to 2^26=64MB, so the final entry of the table is
- * kmalloc-67108864.
+ * kmalloc_index() supports up to 2^25=32MB, so the final entry of the table is
+ * kmalloc-32M.
  */
 const struct kmalloc_info_struct kmalloc_info[] __initconst = {
 	INIT_KMALLOC_INFO(0, 0),
@@ -784,8 +784,7 @@ const struct kmalloc_info_struct kmalloc
 	INIT_KMALLOC_INFO(4194304, 4M),
 	INIT_KMALLOC_INFO(8388608, 8M),
 	INIT_KMALLOC_INFO(16777216, 16M),
-	INIT_KMALLOC_INFO(33554432, 32M),
-	INIT_KMALLOC_INFO(67108864, 64M)
+	INIT_KMALLOC_INFO(33554432, 32M)
 };
 
 /*
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch
mm-fix-typos-and-grammar-error-in-comments.patch

