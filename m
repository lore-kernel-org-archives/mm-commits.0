Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D44BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C20160F23
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhJJVQg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhJJVQf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D10AA60F38;
        Sun, 10 Oct 2021 21:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633900477;
        bh=NmFBNYD9U4EYZgXCH3oarq4aKL6Ix6/UJzDpY4RK7/M=;
        h=Date:From:To:Subject:From;
        b=E8JUBKePSZkmeptJKymO8vUV2xS/NazWR2hQsMLZbKjQJK0HxGS6y6D6rwBoJG1ii
         xZWdlL+7llJtF3+++icJm2euiI6orIGPYpOshDcPOhcb5Y6Zr3GRSn2VzKCdwXzbqg
         t6xtoBUKET0Soce4Vo6BP3yCZ0o0Upj3Ttj0BuIQ=
Date:   Sun, 10 Oct 2021 14:14:36 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, ligang.bdlg@bytedance.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        vbabka@suse.cz
Subject:  +
 mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch added to -mm
 tree
Message-ID: <20211010211436.I8Ano3Jkj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: use DECLARE_EVENT_CLASS and DEFINE_EVENT_FN
has been added to the -mm tree.  Its filename is
     mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang Li <ligang.bdlg@bytedance.com>
Subject: mm: mmap_lock: use DECLARE_EVENT_CLASS and DEFINE_EVENT_FN

By using DECLARE_EVENT_CLASS and TRACE_EVENT_FN, we can save a lot of
space from duplicate code.

Link: https://lkml.kernel.org/r/20211009071243.70286-1-ligang.bdlg@bytedance.com
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch
mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch

