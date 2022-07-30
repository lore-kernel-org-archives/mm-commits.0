Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5209C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiG3BN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiG3BNR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADCD10579
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15FF861D45
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EBDC433D6;
        Sat, 30 Jul 2022 01:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143595;
        bh=o9yauA7kEz8R15pEKdfQcWQQrZFODWiaVgOEOGWmp34=;
        h=Date:To:From:Subject:From;
        b=rgnM2avWqZHFbomrKhFa30li+slpNUIz8Xc5lYDfCwflgZWcoGFxwckfGT36aR/T/
         FeuemHgLZ01rQ5LU+uNzGNBAk75StjTbvwfts++uuLmpYAohr6KgehgusvKrXguj0r
         XlXrhQ4oGPpohxqr3HDcd+ysK7976Ud42efU15qM=
Date:   Fri, 29 Jul 2022 18:13:14 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-add-some-hopefully-insightful-comments.patch removed from -mm tree
Message-Id: <20220730011315.64EBDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: add some (hopefully) insightful comments
has been removed from the -mm tree.  Its filename was
     proc-add-some-hopefully-insightful-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: add some (hopefully) insightful comments
Date: Sat, 23 Jul 2022 20:09:07 +0300

* /proc/${pid}/net status
* removing PDE vs last close stuff (again!)
* random small stuff

Link: https://lkml.kernel.org/r/YtwrM6sDC0OQ53YB@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c    |    4 ++++
 fs/proc/inode.c    |   17 ++++++++++++-----
 fs/proc/proc_net.c |    6 ++++++
 fs/proc/root.c     |    5 +++++
 4 files changed, 27 insertions(+), 5 deletions(-)

--- a/fs/proc/array.c~proc-add-some-hopefully-insightful-comments
+++ a/fs/proc/array.c
@@ -99,6 +99,10 @@ void proc_task_name(struct seq_file *m,
 {
 	char tcomm[64];
 
+	/*
+	 * Test before PF_KTHREAD because all workqueue worker threads are
+	 * kernel threads.
+	 */
 	if (p->flags & PF_WQ_WORKER)
 		wq_worker_comm(tcomm, sizeof(tcomm), p);
 	else if (p->flags & PF_KTHREAD)
--- a/fs/proc/inode.c~proc-add-some-hopefully-insightful-comments
+++ a/fs/proc/inode.c
@@ -212,7 +212,15 @@ static void unuse_pde(struct proc_dir_en
 		complete(pde->pde_unload_completion);
 }
 
-/* pde is locked on entry, unlocked on exit */
+/*
+ * At most 2 contexts can enter this function: the one doing the last
+ * close on the descriptor and whoever is deleting PDE itself.
+ *
+ * First to enter calls ->proc_release hook and signals its completion
+ * to the second one which waits and then does nothing.
+ *
+ * PDE is locked on entry, unlocked on exit.
+ */
 static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
 	__releases(&pde->pde_unload_lock)
 {
@@ -222,9 +230,6 @@ static void close_pdeo(struct proc_dir_e
 	 *
 	 * rmmod (remove_proc_entry() et al) can't delete an entry and proceed:
 	 * "struct file" needs to be available at the right moment.
-	 *
-	 * Therefore, first process to enter this function does ->release() and
-	 * signals its completion to the other process which does nothing.
 	 */
 	if (pdeo->closing) {
 		/* somebody else is doing that, just wait */
@@ -238,10 +243,12 @@ static void close_pdeo(struct proc_dir_e
 
 		pdeo->closing = true;
 		spin_unlock(&pde->pde_unload_lock);
+
 		file = pdeo->file;
 		pde->proc_ops->proc_release(file_inode(file), file);
+
 		spin_lock(&pde->pde_unload_lock);
-		/* After ->release. */
+		/* Strictly after ->proc_release, see above. */
 		list_del(&pdeo->lh);
 		c = pdeo->c;
 		spin_unlock(&pde->pde_unload_lock);
--- a/fs/proc/proc_net.c~proc-add-some-hopefully-insightful-comments
+++ a/fs/proc/proc_net.c
@@ -350,6 +350,12 @@ static __net_init int proc_net_ns_init(s
 	kgid_t gid;
 	int err;
 
+	/*
+	 * This PDE acts only as an anchor for /proc/${pid}/net hierarchy.
+	 * Corresponding inode (PDE(inode) == net->proc_net) is never
+	 * instantiated therefore blanket zeroing is fine.
+	 * net->proc_net_stat inode is instantiated normally.
+	 */
 	err = -ENOMEM;
 	netd = kmem_cache_zalloc(proc_dir_entry_cache, GFP_KERNEL);
 	if (!netd)
--- a/fs/proc/root.c~proc-add-some-hopefully-insightful-comments
+++ a/fs/proc/root.c
@@ -302,6 +302,11 @@ void __init proc_root_init(void)
 	proc_mkdir("bus", NULL);
 	proc_sys_init();
 
+	/*
+	 * Last things last. It is not like userspace processes eager
+	 * to open /proc files exist at this point but register last
+	 * anyway.
+	 */
 	register_filesystem(&proc_fs_type);
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are


