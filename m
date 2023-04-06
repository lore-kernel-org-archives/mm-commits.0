Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD856C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjDFWGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjDFWGv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:06:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C96CA5CB
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBE9764CCE
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B64C433D2;
        Thu,  6 Apr 2023 22:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680818806;
        bh=AHR3+lD5SNJwZHKEOr30IulmhqfPinuy0IKQeT2IOSY=;
        h=Date:To:From:Subject:From;
        b=zCSqC6zAYCeQoGX/9M2YWt6uL2fAdRHEU5HKQGyvZoV5c+bQT30stG4MDjnx7Bfko
         3GZB4XABRlhYr/VSgKbSLQoiCMR6mXlgjx4JkQARPt4zDGYwNTGxbDA5y35RCyAPsl
         bGElNF6mkUbSW4ZhinFLkxafNOpAyYIdvN25/OaI=
Date:   Thu, 06 Apr 2023 15:06:45 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, mhocko@suse.com,
        hannes@cmpxchg.org, david@redhat.com, bagasdotme@gmail.com,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-new-ksm-process-and-sysfs-knobs.patch added to mm-unstable branch
Message-Id: <20230406220646.43B64C433D2@smtp.kernel.org>
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
Date: Thu, 6 Apr 2023 09:53:38 -0700

This adds the general_profit KSM sysfs knob and the process profit metric
and process merge type knobs to ksm_stat.

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

4) add ksm_merge_type() function

   This adds the ksm_merge_type function.  The function returns the
   merge type for the process.  For madvise it returns "madvise", for
   prctl it returns "process" and otherwise it returns "none".

5) mm: expose ksm process profit metric and merge type in ksm_stat

   This exposes the ksm process profit metric in /proc/<pid>/ksm_stat.
   The name of the value is ksm_merge_type.  The documentation mentions
   the formula for the ksm process profit metric, however it does not
   calculate it.  In addition the formula depends on the size of internal
   structures.  So it makes sense to expose it.

6) document new procfs ksm knobs

Link: https://lkml.kernel.org/r/20230406165339.1017597-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-ksm |    8 ++++
 Documentation/admin-guide/mm/ksm.rst          |    8 +++-
 fs/proc/base.c                                |    5 ++
 include/linux/ksm.h                           |    5 ++
 mm/ksm.c                                      |   32 ++++++++++++++++
 5 files changed, 57 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-ksm~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-ksm
@@ -51,3 +51,11 @@ Description:	Control merging pages acros
 
 		When it is set to 0 only pages from the same node are merged,
 		otherwise pages from all nodes can be merged together (default).
+
+What:		/sys/kernel/mm/ksm/general_profit
+Date:		January 2023
+KernelVersion:  6.1
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
@@ -218,6 +221,9 @@ so if the ``ksm_rmap_items/ksm_merging_p
 or exceeds 128 on 32-bit CPU, then the app's madvise policy should be dropped,
 because the ksm profit is approximately zero or negative.
 
+The ksm_merge_type in ``/proc/<pid>/ksm_stat`` shows the merge type of the
+process. Valid values are ``none``, ``madvise`` and ``process``.
+
 Monitoring KSM events
 =====================
 
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
@@ -3199,6 +3200,7 @@ static int proc_pid_ksm_merging_pages(st
 
 	return 0;
 }
+
 static int proc_pid_ksm_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
@@ -3207,6 +3209,9 @@ static int proc_pid_ksm_stat(struct seq_
 	mm = get_task_mm(task);
 	if (mm) {
 		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
+		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
+		seq_printf(m, "ksm_merge_type %s\n", ksm_merge_type(mm));
+		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
 		mmput(mm);
 	}
 
--- a/include/linux/ksm.h~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/include/linux/ksm.h
@@ -60,6 +60,11 @@ struct page *ksm_might_need_to_copy(stru
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
 
+#ifdef CONFIG_PROC_FS
+long ksm_process_profit(struct mm_struct *);
+const char *ksm_merge_type(struct mm_struct *mm);
+#endif /* CONFIG_PROC_FS */
+
 #else  /* !CONFIG_KSM */
 
 static inline int ksm_add_mm(struct mm_struct *mm)
--- a/mm/ksm.c~mm-add-new-ksm-process-and-sysfs-knobs
+++ a/mm/ksm.c
@@ -2959,6 +2959,25 @@ static void wait_while_offlining(void)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+#ifdef CONFIG_PROC_FS
+long ksm_process_profit(struct mm_struct *mm)
+{
+	return (long)mm->ksm_merging_pages * PAGE_SIZE -
+		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
+}
+
+/* Return merge type name as string. */
+const char *ksm_merge_type(struct mm_struct *mm)
+{
+	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags))
+		return "process";
+	else if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
+		return "madvise";
+	else
+		return "none";
+}
+#endif /* CONFIG_PROC_FS */
+
 #ifdef CONFIG_SYSFS
 /*
  * This all compiles without CONFIG_SYSFS, but is a waste of space.
@@ -3223,6 +3242,18 @@ static ssize_t pages_volatile_show(struc
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
@@ -3287,6 +3318,7 @@ static struct attribute *ksm_attrs[] = {
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

