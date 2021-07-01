Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2FEC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3578E61474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbhGAB4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19706105A;
        Thu,  1 Jul 2021 01:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104431;
        bh=bVIvW+JLqWb4sQiz+oLgqfnUcl0MzXt8nuqEgyFuraw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Fpegt29Lw33bUM+pZSYkP6wq8SAznOgPxMkG3Ukx6gvkUVflnOERCsktZKw1YWjHq
         BOoGi8oKc3sfOajnowxsn+Eux1xZtHQjzsviLn596dTNavy7MC02kx+zjqdwZ7b8iz
         192azhzHjW0XnfE9um7qg9gCJcdiqXxnGuPZ/jkk=
Date:   Wed, 30 Jun 2021 18:53:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cuibixuan@huawei.com, david@redhat.com,
        ddstreet@ieee.org, linux-mm@kvack.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 125/192] mm/mmap_lock: remove dead code for
 !CONFIG_TRACING configurations
Message-ID: <20210701015350.3lXiOCAeh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/mmap_lock: remove dead code for !CONFIG_TRACING configurations

make W=1 generates the following warning in mmap_lock.c for allnoconfig

  mm/mmap_lock.c:213:6: warning: no previous prototype for `__mmap_lock_do_trace_start_locking' [-Wmissing-prototypes]
   void __mmap_lock_do_trace_start_locking(struct mm_struct *mm, bool write)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/mmap_lock.c:219:6: warning: no previous prototype for `__mmap_lock_do_trace_acquire_returned' [-Wmissing-prototypes]
   void __mmap_lock_do_trace_acquire_returned(struct mm_struct *mm, bool write,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/mmap_lock.c:226:6: warning: no previous prototype for `__mmap_lock_do_trace_released' [-Wmissing-prototypes]
   void __mmap_lock_do_trace_released(struct mm_struct *mm, bool write)

On !CONFIG_TRACING configurations, the code is dead so put it behind an
#ifdef.

[cuibixuan@huawei.com: fix warning when CONFIG_TRACING is not defined]
  Link: https://lkml.kernel.org/r/20210531033426.74031-1-cuibixuan@huawei.com
Link: https://lkml.kernel.org/r/20210520084809.8576-13-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |   59 +++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

--- a/mm/mmap_lock.c~mm-mmap_lock-remove-dead-code-for-config_tracing-configurations
+++ a/mm/mmap_lock.c
@@ -153,6 +153,37 @@ static inline void put_memcg_path_buf(vo
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
@@ -187,33 +218,6 @@ out:
 	return buf;
 }
 
-#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
-	do {                                                                   \
-		const char *memcg_path;                                        \
-		local_lock(&memcg_paths.lock);				       \
-		memcg_path = get_mm_memcg_path(mm);                            \
-		trace_mmap_lock_##type(mm,                                     \
-				       memcg_path != NULL ? memcg_path : "",   \
-				       ##__VA_ARGS__);                         \
-		if (likely(memcg_path != NULL))                                \
-			put_memcg_path_buf();                                  \
-		local_unlock(&memcg_paths.lock);			       \
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
 
 /*
@@ -239,3 +243,4 @@ void __mmap_lock_do_trace_released(struc
 	TRACE_MMAP_LOCK_EVENT(released, mm, write);
 }
 EXPORT_SYMBOL(__mmap_lock_do_trace_released);
+#endif /* CONFIG_TRACING */
_
