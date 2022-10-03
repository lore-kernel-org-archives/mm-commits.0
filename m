Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A077C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiJCVaa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJCV35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E13751A18
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 472C2B810A8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10BFC433D6;
        Mon,  3 Oct 2022 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832168;
        bh=f2ZUSx/q3zAcmSR5sCt6IJ1TMidHqLwAlh+FcteDco4=;
        h=Date:To:From:Subject:From;
        b=f6J7oTgnNE4tKCuucrlMq/wq4CXY2DHEibvsjpsSkBmz3PO94Cw0BjdEJFKkxInWe
         8l31VLmFZMqsxzL5TZtX6qIfU1bRih2lFfbuHwNsbrtDcQoFqDoeMUwCQho7bw0nQm
         BUMTc837bhUJmEbgIa4SWorxwMkejz6K5sgDQJAw=
Date:   Mon, 03 Oct 2022 14:22:47 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-mark-more-files-as-permanent.patch removed from -mm tree
Message-Id: <20221003212247.E10BFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: mark more files as permanent
has been removed from the -mm tree.  Its filename was
     proc-mark-more-files-as-permanent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: mark more files as permanent
Date: Tue, 20 Sep 2022 20:35:23 +0300

Mark
	/proc/devices
	/proc/kpagecount
	/proc/kpageflags
	/proc/kpagecgroup
	/proc/loadavg
	/proc/meminfo
	/proc/softirqs
	/proc/uptime
	/proc/version

as permanent /proc entries, saving alloc/free and some list/spinlock ops
per use.

These files are never removed by the kernel so it is OK to mark them.

Link: https://lkml.kernel.org/r/Yyn527DzDMa+r0Yj@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/devices.c  |    6 +++++-
 fs/proc/internal.h |    5 +++++
 fs/proc/loadavg.c  |    6 +++++-
 fs/proc/meminfo.c  |    5 ++++-
 fs/proc/page.c     |    3 +++
 fs/proc/softirqs.c |    6 +++++-
 fs/proc/uptime.c   |    6 +++++-
 fs/proc/version.c  |    6 +++++-
 8 files changed, 37 insertions(+), 6 deletions(-)

--- a/fs/proc/devices.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/devices.c
@@ -4,6 +4,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
+#include "internal.h"
 
 static int devinfo_show(struct seq_file *f, void *v)
 {
@@ -54,7 +55,10 @@ static const struct seq_operations devin
 
 static int __init proc_devices_init(void)
 {
-	proc_create_seq("devices", 0, NULL, &devinfo_ops);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_seq("devices", 0, NULL, &devinfo_ops);
+	pde_make_permanent(pde);
 	return 0;
 }
 fs_initcall(proc_devices_init);
--- a/fs/proc/internal.h~proc-mark-more-files-as-permanent
+++ a/fs/proc/internal.h
@@ -79,6 +79,11 @@ static inline bool pde_is_permanent(cons
 	return pde->flags & PROC_ENTRY_PERMANENT;
 }
 
+static inline void pde_make_permanent(struct proc_dir_entry *pde)
+{
+	pde->flags |= PROC_ENTRY_PERMANENT;
+}
+
 extern struct kmem_cache *proc_dir_entry_cache;
 void pde_free(struct proc_dir_entry *pde);
 
--- a/fs/proc/loadavg.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/loadavg.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/seqlock.h>
 #include <linux/time.h>
+#include "internal.h"
 
 static int loadavg_proc_show(struct seq_file *m, void *v)
 {
@@ -27,7 +28,10 @@ static int loadavg_proc_show(struct seq_
 
 static int __init proc_loadavg_init(void)
 {
-	proc_create_single("loadavg", 0, NULL, loadavg_proc_show);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_single("loadavg", 0, NULL, loadavg_proc_show);
+	pde_make_permanent(pde);
 	return 0;
 }
 fs_initcall(proc_loadavg_init);
--- a/fs/proc/meminfo.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/meminfo.c
@@ -162,7 +162,10 @@ static int meminfo_proc_show(struct seq_
 
 static int __init proc_meminfo_init(void)
 {
-	proc_create_single("meminfo", 0, NULL, meminfo_proc_show);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_single("meminfo", 0, NULL, meminfo_proc_show);
+	pde_make_permanent(pde);
 	return 0;
 }
 fs_initcall(proc_meminfo_init);
--- a/fs/proc/page.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/page.c
@@ -91,6 +91,7 @@ static ssize_t kpagecount_read(struct fi
 }
 
 static const struct proc_ops kpagecount_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_lseek	= mem_lseek,
 	.proc_read	= kpagecount_read,
 };
@@ -268,6 +269,7 @@ static ssize_t kpageflags_read(struct fi
 }
 
 static const struct proc_ops kpageflags_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_lseek	= mem_lseek,
 	.proc_read	= kpageflags_read,
 };
@@ -322,6 +324,7 @@ static ssize_t kpagecgroup_read(struct f
 }
 
 static const struct proc_ops kpagecgroup_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_lseek	= mem_lseek,
 	.proc_read	= kpagecgroup_read,
 };
--- a/fs/proc/softirqs.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/softirqs.c
@@ -3,6 +3,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include "internal.h"
 
 /*
  * /proc/softirqs  ... display the number of softirqs
@@ -27,7 +28,10 @@ static int show_softirqs(struct seq_file
 
 static int __init proc_softirqs_init(void)
 {
-	proc_create_single("softirqs", 0, NULL, show_softirqs);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_single("softirqs", 0, NULL, show_softirqs);
+	pde_make_permanent(pde);
 	return 0;
 }
 fs_initcall(proc_softirqs_init);
--- a/fs/proc/uptime.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/uptime.c
@@ -7,6 +7,7 @@
 #include <linux/time.h>
 #include <linux/time_namespace.h>
 #include <linux/kernel_stat.h>
+#include "internal.h"
 
 static int uptime_proc_show(struct seq_file *m, void *v)
 {
@@ -39,7 +40,10 @@ static int uptime_proc_show(struct seq_f
 
 static int __init proc_uptime_init(void)
 {
-	proc_create_single("uptime", 0, NULL, uptime_proc_show);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_single("uptime", 0, NULL, uptime_proc_show);
+	pde_make_permanent(pde);
 	return 0;
 }
 fs_initcall(proc_uptime_init);
--- a/fs/proc/version.c~proc-mark-more-files-as-permanent
+++ a/fs/proc/version.c
@@ -5,6 +5,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/utsname.h>
+#include "internal.h"
 
 static int version_proc_show(struct seq_file *m, void *v)
 {
@@ -17,7 +18,10 @@ static int version_proc_show(struct seq_
 
 static int __init proc_version_init(void)
 {
-	proc_create_single("version", 0, NULL, version_proc_show);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_single("version", 0, NULL, version_proc_show);
+	pde_make_permanent(pde);
 	return 0;
 }
 fs_initcall(proc_version_init);
_

Patches currently in -mm which might be from adobriyan@gmail.com are


