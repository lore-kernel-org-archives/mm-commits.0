Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9F0C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353214AbiA2VlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353231AbiA2VlY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AC6C061714
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 13:41:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F65CB827BE
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E3CC340E5;
        Sat, 29 Jan 2022 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492481;
        bh=qiiPLcJDCvroI2CEDMWEyetqrPr+ZDm2TqZ0wuS3Nmk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eFYRc2JSOxhNO65z250KjssW/KiUzDLrrDlrpPK8XgwJSZEWg47Sb3tBG07pxTWbK
         V3hDP+HEpXUPu/CmY3xV/ZBjB05F+PF1s7DUImrTKglaZwX0SlACVSLfb0pTFnaza7
         1jeYDqu9HoL6qKyLH22xYDMXFxwq8xy1vC6KLpHE=
Date:   Sat, 29 Jan 2022 13:41:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        lkp@intel.com, mm-commits@vger.kernel.org, surenb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 10/12] psi: fix "defined but not used" warnings
 when CONFIG_PROC_FS=n
Message-ID: <20220129214120.5sK4dAVTd%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>
Subject: psi: fix "defined but not used" warnings when CONFIG_PROC_FS=n

When CONFIG_PROC_FS is disabled psi code generates the following warnings:

kernel/sched/psi.c:1364:30: warning: 'psi_cpu_proc_ops' defined but not used [-Wunused-const-variable=]
    1364 | static const struct proc_ops psi_cpu_proc_ops = {
         |                              ^~~~~~~~~~~~~~~~
kernel/sched/psi.c:1355:30: warning: 'psi_memory_proc_ops' defined but not used [-Wunused-const-variable=]
    1355 | static const struct proc_ops psi_memory_proc_ops = {
         |                              ^~~~~~~~~~~~~~~~~~~
kernel/sched/psi.c:1346:30: warning: 'psi_io_proc_ops' defined but not used [-Wunused-const-variable=]
    1346 | static const struct proc_ops psi_io_proc_ops = {
         |                              ^~~~~~~~~~~~~~~

Make definitions of these structures and related functions conditional on
CONFIG_PROC_FS config.

Link: https://lkml.kernel.org/r/20220119223940.787748-3-surenb@google.com
Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/psi.c |   79 ++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 38 deletions(-)

--- a/kernel/sched/psi.c~psi-fix-defined-but-not-used-warnings-when-config_proc_fs=n
+++ a/kernel/sched/psi.c
@@ -1082,44 +1082,6 @@ int psi_show(struct seq_file *m, struct
 	return 0;
 }
 
-static int psi_io_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_IO);
-}
-
-static int psi_memory_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_MEM);
-}
-
-static int psi_cpu_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_CPU);
-}
-
-static int psi_open(struct file *file, int (*psi_show)(struct seq_file *, void *))
-{
-	if (file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
-
-	return single_open(file, psi_show, NULL);
-}
-
-static int psi_io_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_io_show);
-}
-
-static int psi_memory_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_memory_show);
-}
-
-static int psi_cpu_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_cpu_show);
-}
-
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res)
 {
@@ -1278,6 +1240,45 @@ __poll_t psi_trigger_poll(void **trigger
 	return ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int psi_io_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_IO);
+}
+
+static int psi_memory_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_MEM);
+}
+
+static int psi_cpu_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_CPU);
+}
+
+static int psi_open(struct file *file, int (*psi_show)(struct seq_file *, void *))
+{
+	if (file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+
+	return single_open(file, psi_show, NULL);
+}
+
+static int psi_io_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_io_show);
+}
+
+static int psi_memory_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_memory_show);
+}
+
+static int psi_cpu_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_cpu_show);
+}
+
 static ssize_t psi_write(struct file *file, const char __user *user_buf,
 			 size_t nbytes, enum psi_res res)
 {
@@ -1392,3 +1393,5 @@ static int __init psi_proc_init(void)
 	return 0;
 }
 module_init(psi_proc_init);
+
+#endif /* CONFIG_PROC_FS */
_
