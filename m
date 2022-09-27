Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EAAC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiI0Cs4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiI0Crv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B955961DB8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 502E1B81901
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D8AC433B5;
        Tue, 27 Sep 2022 02:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246867;
        bh=OclJEYoI3lncGnGs2NYpyOQbNAkp1lTvrZBzT+tRUB8=;
        h=Date:To:From:Subject:From;
        b=ylQUsRkYk4WwWVYUGb3irhDcAgTtclnWkX3sef3reVdphSttScO+NvykCRY+qO3A7
         XFcg70ofwaTuU/sc1Ub4Szxp9TiQ78pXZd7SyedNXm6uPxd61o5jGa2GN/BTyKfBD/
         nV6LbSvJebXw1s5LKn3ZR0G9SMjDd4H7tE9iXd1U=
Date:   Mon, 26 Sep 2022 19:47:46 -0700
To:     mm-commits@vger.kernel.org, wang.yong12@zte.com.cn,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, cgel.zte@gmail.com,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] delayacct-support-re-entrance-detection-of-thrashing-accounting.patch removed from -mm tree
Message-Id: <20220927024747.03D8AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: delayacct: support re-entrance detection of thrashing accounting
has been removed from the -mm tree.  Its filename was
     delayacct-support-re-entrance-detection-of-thrashing-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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
@@ -944,6 +944,10 @@ struct task_struct {
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


