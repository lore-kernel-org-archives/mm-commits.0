Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CDCECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 00:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiHaAn3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiHaAnM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 20:43:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B4A2AE1
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 17:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2247AB81CCF
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 00:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10D6C433C1;
        Wed, 31 Aug 2022 00:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661906447;
        bh=H0bVKbVy604ZDxES+YBiwLezSje+pSLOxFdXta6rN8o=;
        h=Date:To:From:Subject:From;
        b=EgavTIe1GTJO7aI3I4Y8y9QQ8M0q+2dH1b3HMq/zAxCzmEC/2h3rlilxoKuXmmrCp
         /FRs3IRhPb0q1wzNjxgsTdedPKObBfDLpRuAySG1dffPuZ3VihGfKJ69Sgmw0ovTdK
         T9KkfvkY1GEAMrP+gx+mdMYyXeDbTVgzZD26PY5E=
Date:   Tue, 30 Aug 2022 17:40:46 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        xu.xin16@zte.com.cn, willy@infradead.org, ran.xiaokai@zte.com.cn,
        izik.eidus@ravellosystems.com, hughd@google.com,
        bagasdotme@gmail.com, adobriyan@gmail.com, cgel.zte@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-count-allocated-ksm-rmap_items-for-each-process.patch added to mm-unstable branch
Message-Id: <20220831004047.D10D6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: count allocated ksm rmap_items for each process
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-count-allocated-ksm-rmap_items-for-each-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-count-allocated-ksm-rmap_items-for-each-process.patch

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
From: xu xin <cgel.zte@gmail.com>
Subject: ksm: count allocated ksm rmap_items for each process
Date: Tue, 30 Aug 2022 14:38:38 +0000

Patch series "ksm: count allocated rmap_items and update documentation",
v5.

KSM can save memory by merging identical pages, but also can consume
additional memory, because it needs to generate rmap_items to save each
scanned page's brief rmap information.

To determine how beneficial the ksm-policy (like madvise), they are using
brings, so we add a new interface /proc/<pid>/ksm_stat for each process
The value "ksm_rmap_items" in it indicates the total allocated ksm
rmap_items of this process.

The detailed description can be seen in the following patches' commit
message.


This patch (of 2):

KSM can save memory by merging identical pages, but also can consume
additional memory, because it needs to generate rmap_items to save each
scanned page's brief rmap information.  Some of these pages may be merged,
but some may not be abled to be merged after being checked several times,
which are unprofitable memory consumed.

The information about whether KSM save memory or consume memory in
system-wide range can be determined by the comprehensive calculation of
pages_sharing, pages_shared, pages_unshared and pages_volatile.  A simple
approximate calculation:

	profit =~ pages_sharing * sizeof(page) - (all_rmap_items) *
	         sizeof(rmap_item);

where all_rmap_items equals to the sum of pages_sharing, pages_shared,
pages_unshared and pages_volatile.

But we cannot calculate this kind of ksm profit inner single-process wide
because the information of ksm rmap_item's number of a process is lacked. 
For user applications, if this kind of information could be obtained, it
helps upper users know how beneficial the ksm-policy (like madvise) they
are using brings, and then optimize their app code.  For example, one
application madvise 1000 pages as MERGEABLE, while only a few pages are
really merged, then it's not cost-efficient.

So we add a new interface /proc/<pid>/ksm_stat for each process in which
the value of ksm_rmap_itmes is only shown now and so more values can be
added in future.

So similarly, we can calculate the ksm profit approximately for a single
process by:

	profit =~ ksm_merging_pages * sizeof(page) - ksm_rmap_items *
		 sizeof(rmap_item);

where ksm_merging_pages is shown at /proc/<pid>/ksm_merging_pages, and
ksm_rmap_items is shown in /proc/<pid>/ksm_stat.

Link: https://lkml.kernel.org/r/20220830143731.299702-1-xu.xin16@zte.com.cn
Link: https://lkml.kernel.org/r/20220830143838.299758-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c           |   15 +++++++++++++++
 include/linux/mm_types.h |    5 +++++
 mm/ksm.c                 |    2 ++
 3 files changed, 22 insertions(+)

--- a/fs/proc/base.c~ksm-count-allocated-ksm-rmap_items-for-each-process
+++ a/fs/proc/base.c
@@ -3199,6 +3199,19 @@ static int proc_pid_ksm_merging_pages(st
 
 	return 0;
 }
+static int proc_pid_ksm_stat(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	struct mm_struct *mm;
+
+	mm = get_task_mm(task);
+	if (mm) {
+		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
+		mmput(mm);
+	}
+
+	return 0;
+}
 #endif /* CONFIG_KSM */
 
 #ifdef CONFIG_STACKLEAK_METRICS
@@ -3334,6 +3347,7 @@ static const struct pid_entry tgid_base_
 #endif
 #ifdef CONFIG_KSM
 	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+	ONE("ksm_stat",  S_IRUSR, proc_pid_ksm_stat),
 #endif
 };
 
@@ -3671,6 +3685,7 @@ static const struct pid_entry tid_base_s
 #endif
 #ifdef CONFIG_KSM
 	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+	ONE("ksm_stat",  S_IRUSR, proc_pid_ksm_stat),
 #endif
 };
 
--- a/include/linux/mm_types.h~ksm-count-allocated-ksm-rmap_items-for-each-process
+++ a/include/linux/mm_types.h
@@ -655,6 +655,11 @@ struct mm_struct {
 		 * merging.
 		 */
 		unsigned long ksm_merging_pages;
+		/*
+		 * Represent how many pages are checked for ksm merging
+		 * including merged and not merged.
+		 */
+		unsigned long ksm_rmap_items;
 #endif
 #ifdef CONFIG_LRU_GEN
 		struct {
--- a/mm/ksm.c~ksm-count-allocated-ksm-rmap_items-for-each-process
+++ a/mm/ksm.c
@@ -387,6 +387,7 @@ static inline struct rmap_item *alloc_rm
 static inline void free_rmap_item(struct rmap_item *rmap_item)
 {
 	ksm_rmap_items--;
+	rmap_item->mm->ksm_rmap_items--;
 	rmap_item->mm = NULL;	/* debug safety */
 	kmem_cache_free(rmap_item_cache, rmap_item);
 }
@@ -2234,6 +2235,7 @@ static struct rmap_item *get_next_rmap_i
 	if (rmap_item) {
 		/* It has already been zeroed */
 		rmap_item->mm = mm_slot->mm;
+		rmap_item->mm->ksm_rmap_items++;
 		rmap_item->address = addr;
 		rmap_item->rmap_list = *rmap_list;
 		*rmap_list = rmap_item;
_

Patches currently in -mm which might be from cgel.zte@gmail.com are

ksm-count-allocated-ksm-rmap_items-for-each-process.patch
ksm-add-profit-monitoring-documentation.patch

