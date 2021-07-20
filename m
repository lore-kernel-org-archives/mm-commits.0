Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8FEC636C8
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4ABF60FF1
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhGTWWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhGTWVg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 18:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14BC360FE7;
        Tue, 20 Jul 2021 23:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626822130;
        bh=iPc8/mQ+Qw9C6ouXW/qLi25xJ4hO96y9u8dQogCeHKE=;
        h=Date:From:To:Subject:From;
        b=RdHgdfetJ0Pasz9n5WLzsYnB7jnKSRIjUeqpj3l4pgIDfeCBTrSWoOGfSq890JOJS
         fc5DKwYms83vjaZ7EWAyJIcKHqC/WHElHvIViij5+OssVcmLvdViIH6fVLBtx2Xpms
         kJy6XRXkcxYFBVsWigdVLpQIITL5AGmn2x5sg/j0=
Date:   Tue, 20 Jul 2021 16:02:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        tanxin.ctf@gmail.com, shy828301@gmail.com, shakeelb@google.com,
        linmiaohe@huawei.com, hughd@google.com, apopple@nvidia.com,
        xiyuyang19@fudan.edu.cn
Subject:  +
 mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch added
 to -mm tree
Message-ID: <20210720230209.JBAUW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: convert from atomic_t to refcount_t on anon_vma->refcount
has been added to the -mm tree.  Its filename is
     mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: mm/rmap: convert from atomic_t to refcount_t on anon_vma->refcount

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Link: https://lkml.kernel.org/r/1626665029-49104-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: <yuanxzhang@fudan.edu.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    8 +++++---
 mm/rmap.c            |   14 +++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount
+++ a/include/linux/rmap.h
@@ -12,6 +12,8 @@
 #include <linux/memcontrol.h>
 #include <linux/highmem.h>
 
+#include <linux/refcount.h>
+
 /*
  * The anon_vma heads a list of private "related" vmas, to scan if
  * an anonymous page pointing to this anon_vma needs to be unmapped:
@@ -36,7 +38,7 @@ struct anon_vma {
 	 * the reference is responsible for clearing up the
 	 * anon_vma if they are the last user on release
 	 */
-	atomic_t refcount;
+	refcount_t refcount;
 
 	/*
 	 * Count of child anon_vmas and VMAs which points to this anon_vma.
@@ -100,14 +102,14 @@ enum ttu_flags {
 #ifdef CONFIG_MMU
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
-	atomic_inc(&anon_vma->refcount);
+	refcount_inc(&anon_vma->refcount);
 }
 
 void __put_anon_vma(struct anon_vma *anon_vma);
 
 static inline void put_anon_vma(struct anon_vma *anon_vma)
 {
-	if (atomic_dec_and_test(&anon_vma->refcount))
+	if (refcount_dec_and_test(&anon_vma->refcount))
 		__put_anon_vma(anon_vma);
 }
 
--- a/mm/rmap.c~mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount
+++ a/mm/rmap.c
@@ -88,7 +88,7 @@ static inline struct anon_vma *anon_vma_
 
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 	if (anon_vma) {
-		atomic_set(&anon_vma->refcount, 1);
+		refcount_set(&anon_vma->refcount, 1);
 		anon_vma->degree = 1;	/* Reference for first vma */
 		anon_vma->parent = anon_vma;
 		/*
@@ -103,7 +103,7 @@ static inline struct anon_vma *anon_vma_
 
 static inline void anon_vma_free(struct anon_vma *anon_vma)
 {
-	VM_BUG_ON(atomic_read(&anon_vma->refcount));
+	VM_BUG_ON(refcount_read(&anon_vma->refcount));
 
 	/*
 	 * Synchronize against page_lock_anon_vma_read() such that
@@ -445,7 +445,7 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	init_rwsem(&anon_vma->rwsem);
-	atomic_set(&anon_vma->refcount, 0);
+	refcount_set(&anon_vma->refcount, 0);
 	anon_vma->rb_root = RB_ROOT_CACHED;
 }
 
@@ -495,7 +495,7 @@ struct anon_vma *page_get_anon_vma(struc
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
+	if (!refcount_inc_not_zero(&anon_vma->refcount)) {
 		anon_vma = NULL;
 		goto out;
 	}
@@ -554,7 +554,7 @@ struct anon_vma *page_lock_anon_vma_read
 	}
 
 	/* trylock failed, we got to sleep */
-	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
+	if (!refcount_inc_not_zero(&anon_vma->refcount)) {
 		anon_vma = NULL;
 		goto out;
 	}
@@ -569,7 +569,7 @@ struct anon_vma *page_lock_anon_vma_read
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
-	if (atomic_dec_and_test(&anon_vma->refcount)) {
+	if (refcount_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
 		 * and bail -- can't simply use put_anon_vma() because
@@ -2221,7 +2221,7 @@ void __put_anon_vma(struct anon_vma *ano
 	struct anon_vma *root = anon_vma->root;
 
 	anon_vma_free(anon_vma);
-	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
+	if (root != anon_vma && refcount_dec_and_test(&root->refcount))
 		anon_vma_free(root);
 }
 
_

Patches currently in -mm which might be from xiyuyang19@fudan.edu.cn are

mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch
mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch

