Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB2EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 07:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443263AbiAYHV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 02:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443783AbiAYHQz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 02:16:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4F5C068092
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D08CF60E77
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B428C340E0;
        Tue, 25 Jan 2022 06:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091966;
        bh=FdcnhYXxAhMKTyfKkvS3YI1IQNv+1ncE+GbHWCZb51c=;
        h=Date:From:To:Subject:From;
        b=mSnB1CUxS47KW7vwUrPgpls1ty93k/bG7EBcMuyOwd3kDawBEXMPHZ4pcnp9jCl6N
         nXF5BFI2IqGEWYT3U4Hy1QbcCTUPYOTL9URf7PNwg+7K4NdYXLefpAVvEbIWkBNXaf
         B/f00RsmCkD+hjh1YZvb54WheZtnKnW0XbcJCo7c=
Date:   Mon, 24 Jan 2022 22:26:05 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, lkp@intel.com, mm-commits@vger.kernel.org,
        surenb@google.com
Subject:  +
 psi-fix-defined-but-not-used-warnings-when-config_proc_fs=n.patch added to
 -mm tree
Message-ID: <20220125062605.TIfq9tVHW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: psi: fix "defined but not used" warnings when CONFIG_PROC_FS=n
has been added to the -mm tree.  Its filename is
     psi-fix-defined-but-not-used-warnings-when-config_proc_fs=n.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/psi-fix-defined-but-not-used-warnings-when-config_proc_fs%3Dn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/psi-fix-defined-but-not-used-warnings-when-config_proc_fs%3Dn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from surenb@google.com are

psi-fix-no-previous-prototype-warnings-when-config_cgroups=n.patch
psi-fix-defined-but-not-used-warnings-when-config_proc_fs=n.patch

