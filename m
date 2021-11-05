Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E59C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2CE361262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhKEUl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhKEUl4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D73961252;
        Fri,  5 Nov 2021 20:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144756;
        bh=t2MGmxM33Ivo+QEkc8LhpU9OZll/v//8O0tpkrCJWaQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ysWuXp0/FCL1LrSCPabwIQqJfRPescr8nmqA1GDlfvW+ZUK6D9DgXQ4DUVheSh0aQ
         hLuDkL3W23mcY/LTxnI0czSjgk659X9HpYpCueaYG9ggSK8OiEQGqjh6k13R3cfqQe
         7o6ehGLKa/C13I7AWilCWXn1csp+ewd7ZzQLNCwk=
Date:   Fri, 05 Nov 2021 13:39:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axelrasmussen@google.com,
        ligang.bdlg@bytedance.com, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 088/262] mm: mmap_lock: use DECLARE_EVENT_CLASS
 and DEFINE_EVENT_FN
Message-ID: <20211105203916.x6uvI3JuF%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
