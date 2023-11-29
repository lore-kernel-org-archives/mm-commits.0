Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EAEC4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 02:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjK2CvD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 21:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjK2CvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 21:51:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC4E1988
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 18:51:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A463DC433C7;
        Wed, 29 Nov 2023 02:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701226268;
        bh=e5O01ivMNPaneqtJ8xznJegReBzKI7yXt84Ij+6BtGA=;
        h=Date:To:From:Subject:From;
        b=qL2GgzUyma4pb9J/SQbzYpUEgzZjEl8ZfC55lPCV84H++8dB9J8rGuqWkYCy7ZI5Z
         eerTOdx1/Yt6md35kV+VINicmuPyrKAEGQLvYS+SOWAgxTtwJ4U3+JWlxgtDVCNXnq
         wMDWGZH2uMc9bUB18WjiCaM9lGW4O1JpSnU4Prn4=
Date:   Tue, 28 Nov 2023 18:51:08 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, juntong.deng@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-record-and-report-more-information.patch added to mm-unstable branch
Message-Id: <20231129025108.A463DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: record and report more information
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-record-and-report-more-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-record-and-report-more-information.patch

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
From: Juntong Deng <juntong.deng@outlook.com>
Subject: kasan: record and report more information
Date: Mon, 27 Nov 2023 21:17:31 +0000

Record and report more information to help us find the cause of the bug
and to help us correlate the error with other system events.

This patch adds recording and showing CPU number and timestamp at
allocation and free (controlled by CONFIG_KASAN_EXTRA_INFO).  The
timestamps in the report use the same format and source as printk.

Error occurrence timestamp is already implicit in the printk log, and CPU
number is already shown by dump_stack_lvl, so there is no need to add it.

In order to record CPU number and timestamp at allocation and free,
corresponding members need to be added to the relevant data structures,
which will lead to increased memory consumption.

In Generic KASAN, members are added to struct kasan_track.  Since in most
cases, alloc meta is stored in the redzone and free meta is stored in the
object or the redzone, memory consumption will not increase much.

In SW_TAGS KASAN and HW_TAGS KASAN, members are added to struct
kasan_stack_ring_entry.  Memory consumption increases as the size of
struct kasan_stack_ring_entry increases (this part of the memory is
allocated by memblock), but since this is configurable, it is up to the
user to choose.

Link: https://lkml.kernel.org/r/VI1P193MB0752BD991325D10E4AB1913599BDA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan      |   21 +++++++++++++++++++++
 mm/kasan/common.c      |    8 ++++++++
 mm/kasan/kasan.h       |    8 ++++++++
 mm/kasan/report.c      |   12 ++++++++++++
 mm/kasan/report_tags.c |   15 +++++++++++++++
 mm/kasan/tags.c        |   15 +++++++++++++++
 6 files changed, 79 insertions(+)

--- a/lib/Kconfig.kasan~kasan-record-and-report-more-information
+++ a/lib/Kconfig.kasan
@@ -207,4 +207,25 @@ config KASAN_MODULE_TEST
 	  A part of the KASAN test suite that is not integrated with KUnit.
 	  Incompatible with Hardware Tag-Based KASAN.
 
+config KASAN_EXTRA_INFO
+	bool "Record and report more information"
+	depends on KASAN
+	help
+	  Record and report more information to help us find the cause of the
+	  bug and to help us correlate the error with other system events.
+
+	  Currently, the CPU number and timestamp are additionally
+	  recorded for each heap block at allocation and free time, and
+	  8 bytes will be added to each metadata structure that records
+	  allocation or free information.
+
+	  In Generic KASAN, each kmalloc-8 and kmalloc-16 object will add
+	  16 bytes of additional memory consumption, and each kmalloc-32
+	  object will add 8 bytes of additional memory consumption, not
+	  affecting other larger objects.
+
+	  In SW_TAGS KASAN and HW_TAGS KASAN, depending on the stack_ring_size
+	  boot parameter, it will add 8 * stack_ring_size bytes of additional
+	  memory consumption.
+
 endif # KASAN
--- a/mm/kasan/common.c~kasan-record-and-report-more-information
+++ a/mm/kasan/common.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/sched/task_stack.h>
 #include <linux/slab.h>
 #include <linux/stackdepot.h>
@@ -49,6 +50,13 @@ depot_stack_handle_t kasan_save_stack(gf
 
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
 {
+#ifdef CONFIG_KASAN_EXTRA_INFO
+	u32 cpu = raw_smp_processor_id();
+	u64 ts_nsec = local_clock();
+
+	track->cpu = cpu;
+	track->timestamp = ts_nsec >> 3;
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 	track->pid = current->pid;
 	track->stack = kasan_save_stack(flags,
 			STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_GET);
--- a/mm/kasan/kasan.h~kasan-record-and-report-more-information
+++ a/mm/kasan/kasan.h
@@ -187,6 +187,10 @@ static inline bool kasan_requires_meta(v
 struct kasan_track {
 	u32 pid;
 	depot_stack_handle_t stack;
+#ifdef CONFIG_KASAN_EXTRA_INFO
+	u64 cpu:20;
+	u64 timestamp:44;
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 };
 
 enum kasan_report_type {
@@ -278,6 +282,10 @@ struct kasan_stack_ring_entry {
 	u32 pid;
 	depot_stack_handle_t stack;
 	bool is_free;
+#ifdef CONFIG_KASAN_EXTRA_INFO
+	u64 cpu:20;
+	u64 timestamp:44;
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 };
 
 struct kasan_stack_ring {
--- a/mm/kasan/report.c~kasan-record-and-report-more-information
+++ a/mm/kasan/report.c
@@ -262,7 +262,19 @@ static void print_error_description(stru
 
 static void print_track(struct kasan_track *track, const char *prefix)
 {
+#ifdef CONFIG_KASAN_EXTRA_INFO
+	u64 ts_nsec = track->timestamp;
+	unsigned long rem_usec;
+
+	ts_nsec <<= 3;
+	rem_usec = do_div(ts_nsec, NSEC_PER_SEC) / 1000;
+
+	pr_err("%s by task %u on cpu %d at %lu.%06lus:\n",
+			prefix, track->pid, track->cpu,
+			(unsigned long)ts_nsec, rem_usec);
+#else
 	pr_err("%s by task %u:\n", prefix, track->pid);
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 	if (track->stack)
 		stack_depot_print(track->stack);
 	else
--- a/mm/kasan/report_tags.c~kasan-record-and-report-more-information
+++ a/mm/kasan/report_tags.c
@@ -27,6 +27,15 @@ static const char *get_common_bug_type(s
 	return "invalid-access";
 }
 
+#ifdef CONFIG_KASAN_EXTRA_INFO
+static void kasan_complete_extra_report_info(struct kasan_track *track,
+					 struct kasan_stack_ring_entry *entry)
+{
+	track->cpu = entry->cpu;
+	track->timestamp = entry->timestamp;
+}
+#endif /* CONFIG_KASAN_EXTRA_INFO */
+
 void kasan_complete_mode_report_info(struct kasan_report_info *info)
 {
 	unsigned long flags;
@@ -73,6 +82,9 @@ void kasan_complete_mode_report_info(str
 
 			info->free_track.pid = entry->pid;
 			info->free_track.stack = entry->stack;
+#ifdef CONFIG_KASAN_EXTRA_INFO
+			kasan_complete_extra_report_info(&info->free_track, entry);
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 			free_found = true;
 
 			/*
@@ -88,6 +100,9 @@ void kasan_complete_mode_report_info(str
 
 			info->alloc_track.pid = entry->pid;
 			info->alloc_track.stack = entry->stack;
+#ifdef CONFIG_KASAN_EXTRA_INFO
+			kasan_complete_extra_report_info(&info->alloc_track, entry);
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 			alloc_found = true;
 
 			/*
--- a/mm/kasan/tags.c~kasan-record-and-report-more-information
+++ a/mm/kasan/tags.c
@@ -13,6 +13,7 @@
 #include <linux/memblock.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
+#include <linux/sched/clock.h>
 #include <linux/stackdepot.h>
 #include <linux/static_key.h>
 #include <linux/string.h>
@@ -93,6 +94,17 @@ void __init kasan_init_tags(void)
 	}
 }
 
+#ifdef CONFIG_KASAN_EXTRA_INFO
+static void save_extra_info(struct kasan_stack_ring_entry *entry)
+{
+	u32 cpu = raw_smp_processor_id();
+	u64 ts_nsec = local_clock();
+
+	entry->cpu = cpu;
+	entry->timestamp = ts_nsec >> 3;
+}
+#endif /* CONFIG_KASAN_EXTRA_INFO */
+
 static void save_stack_info(struct kmem_cache *cache, void *object,
 			gfp_t gfp_flags, bool is_free)
 {
@@ -128,6 +140,9 @@ next:
 	entry->pid = current->pid;
 	entry->stack = stack;
 	entry->is_free = is_free;
+#ifdef CONFIG_KASAN_EXTRA_INFO
+	save_extra_info(entry);
+#endif /* CONFIG_KASAN_EXTRA_INFO */
 
 	entry->ptr = object;
 
_

Patches currently in -mm which might be from juntong.deng@outlook.com are

kasan-improve-free-meta-storage-in-generic-kasan.patch
kasan-improve-free-meta-storage-in-generic-kasan-v3.patch
kasan-record-and-report-more-information.patch

