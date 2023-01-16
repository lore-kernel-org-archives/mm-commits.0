Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FA1C46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbjAPUTl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjAPUTk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:19:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC7515575
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:19:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CB06B80E1A
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2633C433F1;
        Mon, 16 Jan 2023 20:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673900375;
        bh=/pDy7qo+Um2HufLALJF1AT452Y6MjDWJXOgNNnZstDE=;
        h=Date:To:From:Subject:From;
        b=PVC/VcFhwQKth0cRRsuQhzS+ynr0hGawOg9TYMTwdsitOWJKcfxdcdw2NVq3vsRTm
         gDKo0cXsniU5gBImWPg7Uk0A0V1x2NjTQ2dsGMmDamzhSQn5b4hGW7wIw/aFtnpm6G
         exE8R54Jj6yPLtZM78EmgxA6ajzsJeeXUiXXcjjQ=
Date:   Mon, 16 Jan 2023 12:19:35 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, shy828301@gmail.com, rientjes@google.com,
        naoya.horiguchi@nec.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-memory-failure-stats-to-sysfs.patch added to mm-unstable branch
Message-Id: <20230116201935.D2633C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: sdd memory failure stats to sysfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-add-memory-failure-stats-to-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-memory-failure-stats-to-sysfs.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm: memory-failure: sdd memory failure stats to sysfs
Date: Mon, 16 Jan 2023 19:39:00 +0000

Patch series "Introduce per NUMA node memory error statistics".

Background
==========

In the RFC for Kernel Support of Memory Error Detection [1], one advantage
of software-based scanning over hardware patrol scrubber is the ability to
make statistics visible to system administrators.  The statistics include
2 categories:

* Memory error statistics, for example, how many memory error are
  encountered, how many of them are recovered by the kernel.  Note these
  memory errors are non-fatal to kernel: during the machine check
  exception (MCE) handling kernel already classified MCE's severity to be
  unnecessary to panic (but either action required or optional).

* Scanner statistics, for example how many times the scanner have fully
  scanned a NUMA node, how many errors are first detected by the scanner.

The memory error statistics are useful to userspace and actually not
specific to scanner detected memory errors, and are the focus of this RFC.

Motivation
==========

Memory error stats are important to userspace but insufficient in kernel
today.  Datacenter administrators can better monitor a machine's memory
health with the visible stats.  For example, while memory errors are
inevitable on servers with 10+ TB memory, starting server maintenance when
there are only 1~2 recovered memory errors could be overreacting; in cloud
production environment maintenance usually means live migrate all the
workload running on the server and this usually causes nontrivial
disruption to the customer.  Providing insight into the scope of memory
errors on a system helps to determine the appropriate follow-up action. 
In addition, the kernel's existing memory error stats need to be
standardized so that userspace can reliably count on their usefulness.

Today kernel provides following memory error info to userspace, but they
are not sufficient or have disadvantages:

* HardwareCorrupted in /proc/meminfo: number of bytes poisoned in total,
  not per NUMA node stats though

* ras:memory_failure_event: only available after explicitly enabled

* /dev/mcelog provides many useful info about the MCEs, but doesn't
  capture how memory_failure recovered memory MCEs

* kernel logs: userspace needs to process log text

Exposing memory error stats is also a good start for the in-kernel memory
error detector.  Today the data source of memory error stats are either
direct memory error consumption, or hardware patrol scrubber detection
(when signaled as UCNA; these signaled as SRAO are not handled by
memory_failure).  Once in-kernel memory scanner is implemented, it will be
the main source as it is usually configured to scan memory DIMMs
constantly and faster than hardware patrol scrubber.

How Implemented
===============

As Naoya pointed out [2], exposing memory error statistics to userspace is
useful independent of software or hardware scanner.  Therefore we
implement the memory error statistics independent of the in-kernel memory
error detector.  It exposes the following per NUMA node memory error
counters:

  /sys/devices/system/node/node${X}/memory_failure/pages_poisoned
  /sys/devices/system/node/node${X}/memory_failure/pages_recovered
  /sys/devices/system/node/node${X}/memory_failure/pages_ignored
  /sys/devices/system/node/node${X}/memory_failure/pages_failed
  /sys/devices/system/node/node${X}/memory_failure/pages_delayed

These counters describe how many raw pages are poisoned and after the
attempted recoveries by the kernel, their resolutions: how many are
recovered, ignored, failed, or delayed respectively.  This approach can be
easier to extend for future use cases than /proc/meminfo, trace event, and
log.  The following math holds for the statistics:

* pages_poisoned = pages_recovered + pages_ignored + pages_failed +
  pages_delayed

* pages_poisoned * page_size = /proc/meminfo/HardwareCorrupted These
  memory error stats are reset during machine boot.

The 1st commit introduces these sysfs entries.  The 2nd commit populates
memory error stats every time memory_failure finishes memory error
recovery.  The 3rd commit adds documentations for introduced stats.

[1] https://lore.kernel.org/linux-mm/7E670362-C29E-4626-B546-26530D54F937@gmail.com/T/#mc22959244f5388891c523882e61163c6e4d703af
[2] https://lore.kernel.org/linux-mm/7E670362-C29E-4626-B546-26530D54F937@gmail.com/T/#m52d8d7a333d8536bd7ce74253298858b1c0c0ac6


This patch (of 3):

Today kernel provides following memory error info to userspace, but each
has its own disadvantage

* HardwareCorrupted in /proc/meminfo: number of bytes poisoned in total,
  not per NUMA node stats though
* ras:memory_failure_event: only available after explicitly enabled
* /dev/mcelog provides many useful info about the MCEs, but
  doesn't capture how memory_failure recovered memory MCEs
* kernel logs: userspace needs to process log text

Exposes per NUMA node memory error stats as sysfs entries:

  /sys/devices/system/node/node${X}/memory_failure/pages_poisoned
  /sys/devices/system/node/node${X}/memory_failure/pages_recovered
  /sys/devices/system/node/node${X}/memory_failure/pages_ignored
  /sys/devices/system/node/node${X}/memory_failure/pages_failed
  /sys/devices/system/node/node${X}/memory_failure/pages_delayed

These counters describe how many raw pages are poisoned and after the
attempted recoveries by the kernel, their resolutions: how many are
recovered, ignored, failed, or delayed respectively.

The following math holds for the statistics:
* pages_poisoned = pages_recovered + pages_ignored + pages_failed +
                   pages_delayed
* pages_poisoned * PAGE_SIZE = /proc/meminfo/HardwareCorrupted

Link: https://lkml.kernel.org/r/20230116193902.1315236-1-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20230116193902.1315236-2-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/base/node.c~mm-memory-failure-add-memory-failure-stats-to-sysfs
+++ a/drivers/base/node.c
@@ -587,6 +587,9 @@ static const struct attribute_group *nod
 #ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
 	&arch_node_dev_group,
 #endif
+#ifdef CONFIG_MEMORY_FAILURE
+	&memory_failure_attr_group,
+#endif
 	NULL
 };
 
--- a/include/linux/mm.h~mm-memory-failure-add-memory-failure-stats-to-sysfs
+++ a/include/linux/mm.h
@@ -3455,6 +3455,11 @@ enum mf_action_page_type {
 	MF_MSG_UNKNOWN,
 };
 
+/*
+ * Sysfs entries for memory failure handling statistics.
+ */
+extern const struct attribute_group memory_failure_attr_group;
+
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr_hint,
--- a/include/linux/mmzone.h~mm-memory-failure-add-memory-failure-stats-to-sysfs
+++ a/include/linux/mmzone.h
@@ -1221,6 +1221,31 @@ struct deferred_split {
 };
 #endif
 
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Per NUMA node memory failure handling statistics.
+ */
+struct memory_failure_stats {
+	/*
+	 * Number of pages poisoned.
+	 * Cases not accounted: memory outside kernel control, offline page,
+	 * arch-specific memory_failure (SGX), and hwpoison_filter()
+	 * filtered error events.
+	 */
+	unsigned long pages_poisoned;
+	/*
+	 * Recovery results of poisoned pages handled by memory_failure,
+	 * in sync with mf_result.
+	 * pages_poisoned = pages_ignored + pages_failed +
+	 *		    pages_delayed + pages_recovered
+	 */
+	unsigned long pages_ignored;
+	unsigned long pages_failed;
+	unsigned long pages_delayed;
+	unsigned long pages_recovered;
+};
+#endif
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1366,6 +1391,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_NUMA
 	struct memory_tier __rcu *memtier;
 #endif
+#ifdef CONFIG_MEMORY_FAILURE
+	struct memory_failure_stats mf_stats;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
--- a/mm/memory-failure.c~mm-memory-failure-add-memory-failure-stats-to-sysfs
+++ a/mm/memory-failure.c
@@ -87,6 +87,41 @@ inline void num_poisoned_pages_sub(unsig
 		memblk_nr_poison_sub(pfn, i);
 }
 
+/**
+ * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
+ * @_name: name of the file in the per NUMA sysfs directory.
+ */
+#define MF_ATTR_RO(_name)					\
+static ssize_t _name##_show(struct device *dev,		\
+			    struct device_attribute *attr,	\
+			    char *buf)				\
+{								\
+	struct memory_failure_stats *mf_stats =			\
+		&NODE_DATA(dev->id)->mf_stats;			\
+	return sprintf(buf, "%lu\n", mf_stats->_name);		\
+}								\
+static DEVICE_ATTR_RO(_name)
+
+MF_ATTR_RO(pages_poisoned);
+MF_ATTR_RO(pages_ignored);
+MF_ATTR_RO(pages_failed);
+MF_ATTR_RO(pages_delayed);
+MF_ATTR_RO(pages_recovered);
+
+static struct attribute *memory_failure_attr[] = {
+	&dev_attr_pages_poisoned.attr,
+	&dev_attr_pages_ignored.attr,
+	&dev_attr_pages_failed.attr,
+	&dev_attr_pages_delayed.attr,
+	&dev_attr_pages_recovered.attr,
+	NULL,
+};
+
+const struct attribute_group memory_failure_attr_group = {
+	.name = "memory_failure",
+	.attrs = memory_failure_attr,
+};
+
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch
mm-memory-failure-add-memory-failure-stats-to-sysfs.patch
mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch
mm-memory-failure-document-memory-failure-stats.patch

