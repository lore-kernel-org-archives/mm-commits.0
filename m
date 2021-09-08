Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0714BC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FCA60555
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347404AbhIHC51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345895AbhIHC5R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DAD261102;
        Wed,  8 Sep 2021 02:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069770;
        bh=JTuuKuBB4TF3mceLklzO/aQuRqCoA7/73JGLwJCc8PM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CbXFv+KqMrNxYBKK09e9xUNCHj0cxglAEasb/VAlxvvj/FkIx5VhrJhgvLBixprvm
         LR4upxhfUf9Maix7bO+aSoRs8OtN2j1Mmp9J7LYE8wltXTb5JtSDtMyj3lcBPrTOBU
         iwvP2r/HEiFGD5ezomaeyozLtXnI2O06wC90iwnc=
Date:   Tue, 07 Sep 2021 19:56:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 057/147] highmem: don't disable preemption on RT
 in kmap_atomic()
Message-ID: <20210908025609.wt-dh5J3r%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: highmem: don't disable preemption on RT in kmap_atomic()

kmap_atomic() disables preemption and pagefaults for historical reasons. 
The conversion to kmap_local(), which only disables migration, cannot be
done wholesale because quite some call sites need to be updated to
accommodate with the changed semantics.

On PREEMPT_RT enabled kernels the kmap_atomic() semantics are problematic
due to the implicit disabling of preemption which makes it impossible to
acquire 'sleeping' spinlocks within the kmap atomic sections.

PREEMPT_RT replaces the preempt_disable() with a migrate_disable() for
more than a decade.  It could be argued that this is a justification to do
this unconditionally, but PREEMPT_RT covers only a limited number of
architectures and it disables some functionality which limits the coverage
further.

Limit the replacement to PREEMPT_RT for now.

Link: https://lkml.kernel.org/r/20210810091116.pocdmaatdcogvdso@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/include/linux/highmem-internal.h~highmem-dont-disable-preemption-on-rt-in-kmap_atomic
+++ a/include/linux/highmem-internal.h
@@ -90,7 +90,11 @@ static inline void __kunmap_local(void *
 
 static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 {
-	preempt_disable();
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		migrate_disable();
+	else
+		preempt_disable();
+
 	pagefault_disable();
 	return __kmap_local_page_prot(page, prot);
 }
@@ -102,7 +106,11 @@ static inline void *kmap_atomic(struct p
 
 static inline void *kmap_atomic_pfn(unsigned long pfn)
 {
-	preempt_disable();
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		migrate_disable();
+	else
+		preempt_disable();
+
 	pagefault_disable();
 	return __kmap_local_pfn_prot(pfn, kmap_prot);
 }
@@ -111,7 +119,10 @@ static inline void __kunmap_atomic(void
 {
 	kunmap_local_indexed(addr);
 	pagefault_enable();
-	preempt_enable();
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		migrate_enable();
+	else
+		preempt_enable();
 }
 
 unsigned int __nr_free_highpages(void);
@@ -179,7 +190,10 @@ static inline void __kunmap_local(void *
 
 static inline void *kmap_atomic(struct page *page)
 {
-	preempt_disable();
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		migrate_disable();
+	else
+		preempt_disable();
 	pagefault_disable();
 	return page_address(page);
 }
@@ -200,7 +214,10 @@ static inline void __kunmap_atomic(void
 	kunmap_flush_on_unmap(addr);
 #endif
 	pagefault_enable();
-	preempt_enable();
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		migrate_enable();
+	else
+		preempt_enable();
 }
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
_
