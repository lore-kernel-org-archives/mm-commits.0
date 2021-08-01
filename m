Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDD4C4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 20:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E4C61075
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 20:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhHAUMY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 16:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhHAUMY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 16:12:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABE6260D07;
        Sun,  1 Aug 2021 20:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627848736;
        bh=G9tY6L1DfqgN3E8KUW3nhsFNjHLqgCG6GbWuf0jWL+U=;
        h=Date:From:To:Subject:From;
        b=mYiwx5Rguy2v2jBVphAtKIddxYI1B+QDw6KhKqrFBQpcKKFYj/MsskTAlDheOV0c1
         j0Esiquc1jXvlHv3B1r0Cjtc7fMQJGOYndtkfNCjXLNY91Kan2iysT0Jdzugd7E9sP
         3UVM/DIkx06QkAqFjzsqmMAwQCLR5BuaYCfd6qgw=
Date:   Sun, 01 Aug 2021 13:12:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        vinmenon@codeaurora.org, vbabka@suse.cz, rppt@kernel.org,
        rientjes@google.com, nigupta@nvidia.com,
        mgorman@techsingularity.net, mcgrof@kernel.org,
        khalid.aziz@oracle.com, keescook@chromium.org,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        charante@codeaurora.org
Subject:  +
 mm-compaction-support-triggering-of-proactive-compaction-by-user.patch added
 to -mm tree
Message-ID: <20210801201213.Vna0G%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: support triggering of proactive compaction by user
has been added to the -mm tree.  Its filename is
     mm-compaction-support-triggering-of-proactive-compaction-by-user.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-support-triggering-of-proactive-compaction-by-user.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-support-triggering-of-proactive-compaction-by-user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm: compaction: support triggering of proactive compaction by user

The proactive compaction[1] gets triggered for every 500msec and run
compaction on the node for COMPACTION_HPAGE_ORDER (usually order-9) pages
based on the value set to sysctl.compaction_proactiveness.  Triggering the
compaction for every 500msec in search of COMPACTION_HPAGE_ORDER pages is
not needed for all applications, especially on the embedded system
usecases which may have few MB's of RAM.  Enabling the proactive
compaction in its state will endup in running almost always on such
systems.

Other side, proactive compaction can still be very much useful for getting
a set of higher order pages in some controllable manner(controlled by
using the sysctl.compaction_proactiveness).  So, on systems where enabling
the proactive compaction always may proove not required, can trigger the
same from user space on write to its sysctl interface.  As an example, say
app launcher decide to launch the memory heavy application which can be
launched fast if it gets more higher order pages thus launcher can prepare
the system in advance by triggering the proactive compaction from
userspace.

This triggering of proactive compaction is done on a write to
sysctl.compaction_proactiveness by user.

[1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=facdaa917c4d5a376d09d25865f5a863f906234a

Link: https://lkml.kernel.org/r/1627653207-12317-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 +
 include/linux/compaction.h              |    2 +
 include/linux/mmzone.h                  |    1 
 kernel/sysctl.c                         |    2 -
 mm/compaction.c                         |   38 ++++++++++++++++++++--
 5 files changed, 42 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-support-triggering-of-proactive-compaction-by-user
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -118,7 +118,8 @@ compaction_proactiveness
 
 This tunable takes a value in the range [0, 100] with a default value of
 20. This tunable determines how aggressively compaction is done in the
-background. Setting it to 0 disables proactive compaction.
+background. On write of non zero value to this tunable will immediately
+trigger the proactive compaction. Setting it to 0 disables proactive compaction.
 
 Note that compaction has a non-trivial system-wide impact as pages
 belonging to different processes are moved around, which could also lead
--- a/include/linux/compaction.h~mm-compaction-support-triggering-of-proactive-compaction-by-user
+++ a/include/linux/compaction.h
@@ -84,6 +84,8 @@ static inline unsigned long compact_gap(
 extern unsigned int sysctl_compaction_proactiveness;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos);
+extern int compaction_proactiveness_sysctl_handler(struct ctl_table *table,
+		int write, void *buffer, size_t *length, loff_t *ppos);
 extern int sysctl_extfrag_threshold;
 extern int sysctl_compact_unevictable_allowed;
 
--- a/include/linux/mmzone.h~mm-compaction-support-triggering-of-proactive-compaction-by-user
+++ a/include/linux/mmzone.h
@@ -846,6 +846,7 @@ typedef struct pglist_data {
 	enum zone_type kcompactd_highest_zoneidx;
 	wait_queue_head_t kcompactd_wait;
 	struct task_struct *kcompactd;
+	bool proactive_compact_trigger;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
--- a/kernel/sysctl.c~mm-compaction-support-triggering-of-proactive-compaction-by-user
+++ a/kernel/sysctl.c
@@ -2871,7 +2871,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_compaction_proactiveness,
 		.maxlen		= sizeof(sysctl_compaction_proactiveness),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= compaction_proactiveness_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &one_hundred,
 	},
--- a/mm/compaction.c~mm-compaction-support-triggering-of-proactive-compaction-by-user
+++ a/mm/compaction.c
@@ -2706,6 +2706,30 @@ static void compact_nodes(void)
  */
 unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
 
+int compaction_proactiveness_sysctl_handler(struct ctl_table *table, int write,
+		void *buffer, size_t *length, loff_t *ppos)
+{
+	int rc, nid;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
+	if (write && sysctl_compaction_proactiveness) {
+		for_each_online_node(nid) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+
+			if (pgdat->proactive_compact_trigger)
+				continue;
+
+			pgdat->proactive_compact_trigger = true;
+			wake_up_interruptible(&pgdat->kcompactd_wait);
+		}
+	}
+
+	return 0;
+}
+
 /*
  * This is the entry point for compacting all nodes via
  * /proc/sys/vm/compact_memory
@@ -2750,7 +2774,8 @@ void compaction_unregister_node(struct n
 
 static inline bool kcompactd_work_requested(pg_data_t *pgdat)
 {
-	return pgdat->kcompactd_max_order > 0 || kthread_should_stop();
+	return pgdat->kcompactd_max_order > 0 || kthread_should_stop() ||
+		pgdat->proactive_compact_trigger;
 }
 
 static bool kcompactd_node_suitable(pg_data_t *pgdat)
@@ -2901,9 +2926,16 @@ static int kcompactd(void *p)
 	while (!kthread_should_stop()) {
 		unsigned long pflags;
 
+		/*
+		 * Avoid the unnecessary wakeup for proactive compaction
+		 * when it is disabled.
+		 */
+		if (!sysctl_compaction_proactiveness)
+			timeout = MAX_SCHEDULE_TIMEOUT;
 		trace_mm_compaction_kcompactd_sleep(pgdat->node_id);
 		if (wait_event_freezable_timeout(pgdat->kcompactd_wait,
-			kcompactd_work_requested(pgdat), timeout)) {
+			kcompactd_work_requested(pgdat), timeout) &&
+			!pgdat->proactive_compact_trigger) {
 
 			psi_memstall_enter(&pflags);
 			kcompactd_do_work(pgdat);
@@ -2938,6 +2970,8 @@ static int kcompactd(void *p)
 				timeout =
 				   default_timeout << COMPACT_MAX_DEFER_SHIFT;
 		}
+		if (unlikely(pgdat->proactive_compact_trigger))
+			pgdat->proactive_compact_trigger = false;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-compaction-optimize-proactive-compaction-deferrals.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user.patch

