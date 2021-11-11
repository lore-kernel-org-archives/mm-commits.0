Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE8DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0A1C61354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhKKCqF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCp7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C9D61208;
        Thu, 11 Nov 2021 02:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598591;
        bh=qoJ/nhursfupYlslaHnYGiD+SYI0n66wDaqUiX3YG5Y=;
        h=Date:From:To:Subject:From;
        b=FfFZoUG5JqixeVlTabhZlzr7E1WwufvAz2fTqtvCC+FcdkbUrkV5uwLCZK32FFKHX
         urgUTk8GtctebQEElqSx2JzITyjSSIiyS6wUktiWXXD7PgM2BNFWeRcWVzddxQbpG8
         w3zXVO0QJs9Z4pwKniFLo4wN94jyLpwOIEqzTOEo=
Date:   Wed, 10 Nov 2021 18:43:10 -0800
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, ligang.bdlg@bytedance.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch removed from
 -mm tree
Message-ID: <20211111024310.ZFxoTf_xn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: use DECLARE_EVENT_CLASS and DEFINE_EVENT_FN
has been removed from the -mm tree.  Its filename was
     mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang Li <ligang.bdlg@bytedance.com>
Subject: mm: mmap_lock: use DECLARE_EVENT_CLASS and DEFINE_EVENT_FN

By using DECLARE_EVENT_CLASS and TRACE_EVENT_FN, we can save a lot of
space from duplicate code.

Link: https://lkml.kernel.org/r/20211009071243.70286-1-ligang.bdlg@bytedance.com
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap_lock.h |   44 +++++++----------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

--- a/include/trace/events/mmap_lock.h~mm-mmap_lock-use-declare_event_class-and-define_event_fn
+++ a/include/trace/events/mmap_lock.h
@@ -13,7 +13,7 @@ struct mm_struct;
 extern int trace_mmap_lock_reg(void);
 extern void trace_mmap_lock_unreg(void);
 
-TRACE_EVENT_FN(mmap_lock_start_locking,
+DECLARE_EVENT_CLASS(mmap_lock,
 
 	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write),
 
@@ -36,11 +36,19 @@ TRACE_EVENT_FN(mmap_lock_start_locking,
 		__entry->mm,
 		__get_str(memcg_path),
 		__entry->write ? "true" : "false"
-	),
-
-	trace_mmap_lock_reg, trace_mmap_lock_unreg
+	)
 );
 
+#define DEFINE_MMAP_LOCK_EVENT(name)                                    \
+	DEFINE_EVENT_FN(mmap_lock, name,                                \
+		TP_PROTO(struct mm_struct *mm, const char *memcg_path,  \
+			bool write),                                    \
+		TP_ARGS(mm, memcg_path, write),                         \
+		trace_mmap_lock_reg, trace_mmap_lock_unreg)
+
+DEFINE_MMAP_LOCK_EVENT(mmap_lock_start_locking);
+DEFINE_MMAP_LOCK_EVENT(mmap_lock_released);
+
 TRACE_EVENT_FN(mmap_lock_acquire_returned,
 
 	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write,
@@ -71,34 +79,6 @@ TRACE_EVENT_FN(mmap_lock_acquire_returne
 	),
 
 	trace_mmap_lock_reg, trace_mmap_lock_unreg
-);
-
-TRACE_EVENT_FN(mmap_lock_released,
-
-	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write),
-
-	TP_ARGS(mm, memcg_path, write),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct *, mm)
-		__string(memcg_path, memcg_path)
-		__field(bool, write)
-	),
-
-	TP_fast_assign(
-		__entry->mm = mm;
-		__assign_str(memcg_path, memcg_path);
-		__entry->write = write;
-	),
-
-	TP_printk(
-		"mm=%p memcg_path=%s write=%s",
-		__entry->mm,
-		__get_str(memcg_path),
-		__entry->write ? "true" : "false"
-	),
-
-	trace_mmap_lock_reg, trace_mmap_lock_unreg
 );
 
 #endif /* _TRACE_MMAP_LOCK_H */
_

Patches currently in -mm which might be from ligang.bdlg@bytedance.com are


