Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07153C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE48560F22
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhHKEZQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Aug 2021 00:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhHKEZP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Aug 2021 00:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DE760C51;
        Wed, 11 Aug 2021 04:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628655892;
        bh=q2ZhM4FwYX+9DrwlEbCjn7/Ue3tgf/rMXbIBWTdEIMM=;
        h=Date:From:To:Subject:From;
        b=UBfyzAUY1Z0zAsmYJOhqBL4hHU7fR7/7OJbEwEp/3zbq39wwSjQgH5wu2jcRp+7gd
         kvKrvCokGz6PCNc1b1lCIlVBZRXdy0fk/9HVxTor5p8rPK6OZy99jezNfsOThqXUkt
         5oLQSMwSrjSqyi7QEvsOAOzcLYO9sjkAQrej2p40=
Date:   Tue, 10 Aug 2021 21:24:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        peterz@infradead.org, bigeasy@linutronix.de
Subject:  +
 highmem-dont-disable-preemption-on-rt-in-kmap_atomic.patch added to -mm tree
Message-ID: <20210811042452.E55Jh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: don't disable preemption on RT in kmap_atomic()
has been added to the -mm tree.  Its filename is
     highmem-dont-disable-preemption-on-rt-in-kmap_atomic.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/highmem-dont-disable-preemption-on-rt-in-kmap_atomic.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/highmem-dont-disable-preemption-on-rt-in-kmap_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch
mm-slub-make-object_map_lock-a-raw_spinlock_t.patch
shmem-use-raw_spinlock_t-for-stat_lock.patch
highmem-dont-disable-preemption-on-rt-in-kmap_atomic.patch

