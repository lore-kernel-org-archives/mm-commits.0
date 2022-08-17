Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61165C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbiHQTHa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbiHQTHT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF09798D3A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7736144A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981EBC433D7;
        Wed, 17 Aug 2022 19:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763237;
        bh=CkDyllfGVGdVTw+TO7gphmQt9+vH412jd2zdpnJN1DI=;
        h=Date:To:From:Subject:From;
        b=cRzfB6K5CVtSupwQxb4lxXVkibKUUN/gMkR4d2OKS8iQi7rhIb3me1RqHFHH1Stig
         NeliygkRQQS/kz+OBny7qgYLga+PB3XzMxH8ZFEvMo98sw5rVn8XazOxczwx+cgM0e
         nfmzIRpmymdSbOhCWggBGT4hh/o4inY/vYCvPzhE=
Date:   Wed, 17 Aug 2022 12:07:16 -0700
To:     mm-commits@vger.kernel.org, wang.yong12@zte.com.cn,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, cgel.zte@gmail.com,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-support-re-entrance-detection-of-thrashing-accounting.patch added to mm-unstable branch
Message-Id: <20220817190717.981EBC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: support re-entrance detection of thrashing accounting
has been added to the -mm mm-unstable branch.  Its filename is
     delayacct-support-re-entrance-detection-of-thrashing-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-support-re-entrance-detection-of-thrashing-accounting.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: delayacct: support re-entrance detection of thrashing accounting
Date: Mon, 15 Aug 2022 07:11:35 +0000

Once upon a time, we only support accounting thrashing of page cache. 
Then Joonsoo introduced workingset detection for anonymous pages and we
gained the ability to account thrashing of them[1].

For page cache thrashing accounting, there is no suitable place to do it
in fs level likes swap_readpage().  So we have to do it in
folio_wait_bit_common().

Then for anonymous pages thrashing accounting, we have to do it in both
swap_readpage() and folio_wait_bit_common().  This likes PSI, so we should
let thrashing accounting supports re-entrance detection.

This patch is to prepare complete thrashing accounting, and is based on
patch "filemap: make the accounting of thrashing more consistent".

[1] commit aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")

Link: https://lkml.kernel.org/r/20220815071134.74551-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: wangyong <wang.yong12@zte.com.cn>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h |   16 ++++++++--------
 include/linux/sched.h     |    4 ++++
 kernel/delayacct.c        |   13 +++++++++++--
 mm/filemap.c              |   10 ++++++----
 4 files changed, 29 insertions(+), 14 deletions(-)

--- a/include/linux/delayacct.h~delayacct-support-re-entrance-detection-of-thrashing-accounting
+++ a/include/linux/delayacct.h
@@ -73,8 +73,8 @@ extern int delayacct_add_tsk(struct task
 extern __u64 __delayacct_blkio_ticks(struct task_struct *);
 extern void __delayacct_freepages_start(void);
 extern void __delayacct_freepages_end(void);
-extern void __delayacct_thrashing_start(void);
-extern void __delayacct_thrashing_end(void);
+extern void __delayacct_thrashing_start(bool *in_thrashing);
+extern void __delayacct_thrashing_end(bool *in_thrashing);
 extern void __delayacct_swapin_start(void);
 extern void __delayacct_swapin_end(void);
 extern void __delayacct_compact_start(void);
@@ -143,22 +143,22 @@ static inline void delayacct_freepages_e
 		__delayacct_freepages_end();
 }
 
-static inline void delayacct_thrashing_start(void)
+static inline void delayacct_thrashing_start(bool *in_thrashing)
 {
 	if (!static_branch_unlikely(&delayacct_key))
 		return;
 
 	if (current->delays)
-		__delayacct_thrashing_start();
+		__delayacct_thrashing_start(in_thrashing);
 }
 
-static inline void delayacct_thrashing_end(void)
+static inline void delayacct_thrashing_end(bool *in_thrashing)
 {
 	if (!static_branch_unlikely(&delayacct_key))
 		return;
 
 	if (current->delays)
-		__delayacct_thrashing_end();
+		__delayacct_thrashing_end(in_thrashing);
 }
 
 static inline void delayacct_swapin_start(void)
@@ -237,9 +237,9 @@ static inline void delayacct_freepages_s
 {}
 static inline void delayacct_freepages_end(void)
 {}
-static inline void delayacct_thrashing_start(void)
+static inline void delayacct_thrashing_start(bool *in_thrashing)
 {}
-static inline void delayacct_thrashing_end(void)
+static inline void delayacct_thrashing_end(bool *in_thrashing)
 {}
 static inline void delayacct_swapin_start(void)
 {}
--- a/include/linux/sched.h~delayacct-support-re-entrance-detection-of-thrashing-accounting
+++ a/include/linux/sched.h
@@ -948,6 +948,10 @@ struct task_struct {
 #ifdef	CONFIG_CPU_SUP_INTEL
 	unsigned			reported_split_lock:1;
 #endif
+#ifdef CONFIG_TASK_DELAY_ACCT
+	/* delay due to memory thrashing */
+	unsigned                        in_thrashing:1;
+#endif
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
--- a/kernel/delayacct.c~delayacct-support-re-entrance-detection-of-thrashing-accounting
+++ a/kernel/delayacct.c
@@ -214,13 +214,22 @@ void __delayacct_freepages_end(void)
 		      &current->delays->freepages_count);
 }
 
-void __delayacct_thrashing_start(void)
+void __delayacct_thrashing_start(bool *in_thrashing)
 {
+	*in_thrashing = !!current->in_thrashing;
+	if (*in_thrashing)
+		return;
+
+	current->in_thrashing = 1;
 	current->delays->thrashing_start = local_clock();
 }
 
-void __delayacct_thrashing_end(void)
+void __delayacct_thrashing_end(bool *in_thrashing)
 {
+	if (*in_thrashing)
+		return;
+
+	current->in_thrashing = 0;
 	delayacct_end(&current->delays->lock,
 		      &current->delays->thrashing_start,
 		      &current->delays->thrashing_delay,
--- a/mm/filemap.c~delayacct-support-re-entrance-detection-of-thrashing-accounting
+++ a/mm/filemap.c
@@ -1222,10 +1222,11 @@ static inline int folio_wait_bit_common(
 	wait_queue_entry_t *wait = &wait_page.wait;
 	bool thrashing = false;
 	unsigned long pflags;
+	bool in_thrashing;
 
 	if (bit_nr == PG_locked &&
 	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
-		delayacct_thrashing_start();
+		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
 		thrashing = true;
 	}
@@ -1325,7 +1326,7 @@ repeat:
 	finish_wait(q, wait);
 
 	if (thrashing) {
-		delayacct_thrashing_end();
+		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
 	}
 
@@ -1374,12 +1375,13 @@ void migration_entry_wait_on_locked(swp_
 	wait_queue_entry_t *wait = &wait_page.wait;
 	bool thrashing = false;
 	unsigned long pflags;
+	bool in_thrashing;
 	wait_queue_head_t *q;
 	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
 
 	q = folio_waitqueue(folio);
 	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
-		delayacct_thrashing_start();
+		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
 		thrashing = true;
 	}
@@ -1426,7 +1428,7 @@ void migration_entry_wait_on_locked(swp_
 	finish_wait(q, wait);
 
 	if (thrashing) {
-		delayacct_thrashing_end();
+		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
 	}
 }
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch
filemap-make-the-accounting-of-thrashing-more-consistent.patch
mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch
delayacct-support-re-entrance-detection-of-thrashing-accounting.patch
mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

