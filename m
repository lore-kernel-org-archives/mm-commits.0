Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE60C47082
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 01:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD4061287
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 01:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhFABqK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 21:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhFABqK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 21:46:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7C4610A0;
        Tue,  1 Jun 2021 01:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622511869;
        bh=7yIwz4PgZKkvaMAN3wlUNQadPjOHujIDH0SDG/rLTAk=;
        h=Date:From:To:Subject:From;
        b=Y8JiuqozV5/0aJWAJTBaLVD85+29UDS7XBU9aGwDN9ae5TmPP7Z8zQDo2TYaw14IM
         88pVdBRhXC3rnoBF4/UOHOeZmr4JPq/DdSDWzVX0U3vztVIRtewlW8qB/cTTnTNNR3
         vQGrrXRoBVLrFEAe/Xlc45vOfS5IalGd3OkHCRZ0=
Date:   Mon, 31 May 2021 18:44:28 -0700
From:   akpm@linux-foundation.org
To:     cuibixuan@huawei.com, david@redhat.com, ddstreet@ieee.org,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 mm-mmap_lock-remove-dead-code-for-config_tracing-configurations-fix.patch
 added to -mm tree
Message-ID: <20210601014428.X2vyY-zJo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap_lock: fix warning when CONFIG_TRACING is not defined
has been added to the -mm tree.  Its filename is
     mm-mmap_lock-remove-dead-code-for-config_tracing-configurations-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap_lock-remove-dead-code-for-config_tracing-configurations-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap_lock-remove-dead-code-for-config_tracing-configurations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bixuan Cui <cuibixuan@huawei.com>
Subject: mm/mmap_lock: fix warning when CONFIG_TRACING is not defined

Fix the warning: [-Wunused-function]
mm/mmap_lock.c:157:20: warning: `get_mm_memcg_path' defined but not used
 static const char *get_mm_memcg_path(struct mm_struct *mm)
                    ^~~~~~~~~~~~~~~~~

Move get_mm_memcg_path() into #ifdef CONFIG_TRACING.

Link: https://lkml.kernel.org/r/20210531033426.74031-1-cuibixuan@huawei.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |   60 ++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

--- a/mm/mmap_lock.c~mm-mmap_lock-remove-dead-code-for-config_tracing-configurations-fix
+++ a/mm/mmap_lock.c
@@ -142,6 +142,37 @@ static inline void put_memcg_path_buf(vo
 	rcu_read_unlock();
 }
 
+#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
+	do {                                                                   \
+		const char *memcg_path;                                        \
+		preempt_disable();                                             \
+		memcg_path = get_mm_memcg_path(mm);                            \
+		trace_mmap_lock_##type(mm,                                     \
+				       memcg_path != NULL ? memcg_path : "",   \
+				       ##__VA_ARGS__);                         \
+		if (likely(memcg_path != NULL))                                \
+			put_memcg_path_buf();                                  \
+		preempt_enable();                                              \
+	} while (0)
+
+#else /* !CONFIG_MEMCG */
+
+int trace_mmap_lock_reg(void)
+{
+	return 0;
+}
+
+void trace_mmap_lock_unreg(void)
+{
+}
+
+#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
+	trace_mmap_lock_##type(mm, "", ##__VA_ARGS__)
+
+#endif /* CONFIG_MEMCG */
+
+#ifdef CONFIG_TRACING
+#ifdef CONFIG_MEMCG
 /*
  * Write the given mm_struct's memcg path to a percpu buffer, and return a
  * pointer to it. If the path cannot be determined, or no buffer was available
@@ -175,37 +206,8 @@ out_put:
 out:
 	return buf;
 }
-
-#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
-	do {                                                                   \
-		const char *memcg_path;                                        \
-		preempt_disable();                                             \
-		memcg_path = get_mm_memcg_path(mm);                            \
-		trace_mmap_lock_##type(mm,                                     \
-				       memcg_path != NULL ? memcg_path : "",   \
-				       ##__VA_ARGS__);                         \
-		if (likely(memcg_path != NULL))                                \
-			put_memcg_path_buf();                                  \
-		preempt_enable();                                              \
-	} while (0)
-
-#else /* !CONFIG_MEMCG */
-
-int trace_mmap_lock_reg(void)
-{
-	return 0;
-}
-
-void trace_mmap_lock_unreg(void)
-{
-}
-
-#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
-	trace_mmap_lock_##type(mm, "", ##__VA_ARGS__)
-
 #endif /* CONFIG_MEMCG */
 
-#ifdef CONFIG_TRACING
 /*
  * Trace calls must be in a separate file, as otherwise there's a circular
  * dependency between linux/mmap_lock.h and trace/events/mmap_lock.h.
_

Patches currently in -mm which might be from cuibixuan@huawei.com are

mm-mmap_lock-remove-dead-code-for-config_tracing-configurations-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix.patch

