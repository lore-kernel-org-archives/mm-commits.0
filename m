Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B4CC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 19:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjDRT1K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDRT1J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 15:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC7310E2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 12:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40B7762D4B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 19:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C53EC433EF;
        Tue, 18 Apr 2023 19:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681846025;
        bh=kJrYdYp3xsC2z4tPGra71tmO3xofrankkZFW5se7kY8=;
        h=Date:To:From:Subject:From;
        b=gb4Izf7ylB55pi+onAJ8FrI4FLVffdf28TiSPZ5LkenWHqgMcwZ+JKMXVHG4nGnLI
         Ur7qdYmswUG/Xwxa6twnDC+e4P+zPHu/sBnrtSLF3yBKIvKFinyYJqclkBtR7lV3kl
         QSAEHhHGGEZ6urtpStwsKpx2uU+NNg0d0MZF1DXA=
Date:   Tue, 18 Apr 2023 12:27:05 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, mhocko@suse.com,
        hannes@cmpxchg.org, david@redhat.com, bagasdotme@gmail.com,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-new-ksm-process-and-sysfs-knobs.patch added to mm-unstable branch
Message-Id: <20230418192705.9C53EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add new KSM process and sysfs knobs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-new-ksm-process-and-sysfs-knobs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-new-ksm-process-and-sysfs-knobs.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add new KSM process and sysfs knobs
Date: Mon, 17 Apr 2023 22:13:41 -0700

This adds the general_profit KSM sysfs knob and the process profit metric
knobs to ksm_stat.

1) expose general_profit metric

   The documentation mentions a general profit metric, however this
   metric is not calculated.  In addition the formula depends on the size
   of internal structures, which makes it more difficult for an
   administrator to make the calculation.  Adding the metric for a better
   user experience.

2) document general_profit sysfs knob

3) calculate ksm process profit metric

   The ksm documentation mentions the process profit metric and how to
   calculate it.  This adds the calculation of the metric.

4) mm: expose ksm process profit metric in ksm_stat

   This exposes the ksm process profit metric in /proc/<pid>/ksm_stat.
   The documentation mentions the formula for the ksm process profit
   metric, however it does not calculate it.  In addition the formula
   depends on the size of internal structures.  So it makes sense to
   expose it.

5) document new procfs ksm knobs

Link: https://lkml.kernel.org/r/20230418051342.1919757-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-ksm |    8 ++++++
 Documentation/admin-guide/mm/ksm.rst          |    5 +++
 fs/proc/base.c                                |    3 ++
 include/linux/ksm.h                           |    5 +++
 mm/ksm.c                                      |   21 ++++++++++++++++
 5 files changed, 41 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-ksm~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-ksm
@@ -51,3 +51,11 @@ Description:	Control merging pages acros
 
 		When it is set to 0 only pages from the same node are merged,
 		otherwise pages from all nodes can be merged together (default).
+
+What:		/sys/kernel/mm/ksm/general_profit
+Date:		April 2023
+KernelVersion:  6.4
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Measure how effective KSM is.
+		general_profit: how effective is KSM. The formula for the
+		calculation is in Documentation/admin-guide/mm/ksm.rst.
--- a/Documentation/admin-guide/mm/ksm.rst~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -157,6 +157,8 @@ stable_node_chains_prune_millisecs
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
 
+general_profit
+        how effective is KSM. The calculation is explained below.
 pages_shared
         how many shared pages are being used
 pages_sharing
@@ -207,7 +209,8 @@ several times, which are unprofitable me
 			  ksm_rmap_items * sizeof(rmap_item).
 
    where ksm_merging_pages is shown under the directory ``/proc/<pid>/``,
-   and ksm_rmap_items is shown in ``/proc/<pid>/ksm_stat``.
+   and ksm_rmap_items is shown in ``/proc/<pid>/ksm_stat``. The process profit
+   is also shown in ``/proc/<pid>/ksm_stat`` as ksm_process_profit.
 
 From the perspective of application, a high ratio of ``ksm_rmap_items`` to
 ``ksm_merging_pages`` means a bad madvise-applied policy, so developers or
--- a/fs/proc/base.c~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/fs/proc/base.c
@@ -96,6 +96,7 @@
 #include <linux/time_namespace.h>
 #include <linux/resctrl.h>
 #include <linux/cn_proc.h>
+#include <linux/ksm.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -3207,6 +3208,8 @@ static int proc_pid_ksm_stat(struct seq_
 	mm = get_task_mm(task);
 	if (mm) {
 		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
+		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
+		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
 		mmput(mm);
 	}
 
--- a/include/linux/ksm.h~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/include/linux/ksm.h
@@ -68,6 +68,11 @@ void folio_migrate_ksm(struct folio *new
 void collect_procs_ksm(struct page *page, struct list_head *to_kill,
 		       int force_early);
 #endif
+
+#ifdef CONFIG_PROC_FS
+long ksm_process_profit(struct mm_struct *);
+#endif /* CONFIG_PROC_FS */
+
 #else  /* !CONFIG_KSM */
 
 static inline void ksm_add_vma(struct vm_area_struct *vma)
--- a/mm/ksm.c~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/mm/ksm.c
@@ -3007,6 +3007,14 @@ static void wait_while_offlining(void)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+#ifdef CONFIG_PROC_FS
+long ksm_process_profit(struct mm_struct *mm)
+{
+	return mm->ksm_merging_pages * PAGE_SIZE -
+		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
+}
+#endif /* CONFIG_PROC_FS */
+
 #ifdef CONFIG_SYSFS
 /*
  * This all compiles without CONFIG_SYSFS, but is a waste of space.
@@ -3271,6 +3279,18 @@ static ssize_t pages_volatile_show(struc
 }
 KSM_ATTR_RO(pages_volatile);
 
+static ssize_t general_profit_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	long general_profit;
+
+	general_profit = ksm_pages_sharing * PAGE_SIZE -
+				ksm_rmap_items * sizeof(struct ksm_rmap_item);
+
+	return sysfs_emit(buf, "%ld\n", general_profit);
+}
+KSM_ATTR_RO(general_profit);
+
 static ssize_t stable_node_dups_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
@@ -3335,6 +3355,7 @@ static struct attribute *ksm_attrs[] = {
 	&stable_node_dups_attr.attr,
 	&stable_node_chains_prune_millisecs_attr.attr,
 	&use_zero_pages_attr.attr,
+	&general_profit_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-add-new-api-to-enable-ksm-per-process.patch
mm-add-new-ksm-process-and-sysfs-knobs.patch
selftests-mm-add-new-selftests-for-ksm.patch

