Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF497ECAAD8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 19:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIUToT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIUToS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 15:44:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD0A9F74A
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 12:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7471562D55
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 19:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97028C433C1;
        Wed, 21 Sep 2022 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663789456;
        bh=ZLYLYJ8DylfPVGnQPXEwvPWjWTmRwoJgxQHIjSCMWxE=;
        h=Date:To:From:Subject:From;
        b=GN2VPm3wA2mVbAADiu4vhRGi1jqKEK9pEqmeT9gPYeg7mjMu1jRX8cMXeqmtk4Lxr
         2vhP4dCirHwPta19Rr2jZmd+uGG414NEK67ytT+ARX3NbHXG0e/GwdO430KqR9PKlN
         rNUygtf2xcN9ANwoiAJi7a+xVfnEHSVteC2X+wE8=
Date:   Wed, 21 Sep 2022 12:44:15 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-mark-more-files-as-permanent.patch added to mm-nonmm-unstable branch
Message-Id: <20220921194416.97028C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: mark more files as permanent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-mark-more-files-as-permanent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-mark-more-files-as-permanent.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

proc-mark-more-files-as-permanent.patch

