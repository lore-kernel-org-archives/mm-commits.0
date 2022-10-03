Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA06C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJCVJg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJCVIC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C614E872
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC5FDB815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88843C433D6;
        Mon,  3 Oct 2022 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831166;
        bh=zcCDXeeDTzHpz4i2pXXwoZBqfbn7XddaaEVMbXRVz2M=;
        h=Date:To:From:Subject:From;
        b=GGt+cZdA+K/9zzS5QkhhjpKJyNZ1YgIDO1wt8WJhM2yRcxHYD/SsflEqkZus05UDa
         Nl32+p1ofki1ST75FTsbNZ+IHiBg5uRwQQ506jdxQhUJ3S3U37+lu6pHtcG9/ylcwy
         8aW6WSinbE4ZPaRu3xF7iS4e7ECkeFu2SHEAPwiU=
Date:   Mon, 03 Oct 2022 14:06:05 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-only-define-metadata-structs-for-generic-mode.patch removed from -mm tree
Message-Id: <20221003210606.88843C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: only define metadata structs for Generic mode
has been removed from the -mm tree.  Its filename was
     kasan-only-define-metadata-structs-for-generic-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: only define metadata structs for Generic mode
Date: Mon, 5 Sep 2022 23:05:32 +0200

Hide the definitions of kasan_alloc_meta and kasan_free_meta under an
ifdef CONFIG_KASAN_GENERIC check, as these structures are now only used
when the Generic mode is enabled.

Link: https://lkml.kernel.org/r/8d2aabff8c227c444a3f62edf87d5630beb77640.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/kasan/kasan.h~kasan-only-define-metadata-structs-for-generic-mode
+++ a/mm/kasan/kasan.h
@@ -193,14 +193,12 @@ struct kasan_track {
 	depot_stack_handle_t stack;
 };
 
+#ifdef CONFIG_KASAN_GENERIC
+
 struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
-	/* Generic mode stores free track in kasan_free_meta. */
-#ifdef CONFIG_KASAN_GENERIC
+	/* Free track is stored in kasan_free_meta. */
 	depot_stack_handle_t aux_stack[2];
-#else
-	struct kasan_track free_track;
-#endif
 };
 
 struct qlist_node {
@@ -219,12 +217,12 @@ struct qlist_node {
  * After that, slab allocator stores the freelist pointer in the object.
  */
 struct kasan_free_meta {
-#ifdef CONFIG_KASAN_GENERIC
 	struct qlist_node quarantine_link;
 	struct kasan_track free_track;
-#endif
 };
 
+#endif /* CONFIG_KASAN_GENERIC */
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 /* Used in KUnit-compatible KASAN tests. */
 struct kunit_kasan_status {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

