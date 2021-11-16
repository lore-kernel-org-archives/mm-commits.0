Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3849C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A945061A6C
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhKPFPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhKPFM4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 00:12:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BC561BF9;
        Tue, 16 Nov 2021 05:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637039399;
        bh=QUNo7Q4Pv039PW7qpRZXYAihX+coIbGxoGzlXNVUuLc=;
        h=Date:From:To:Subject:From;
        b=MeVNdJsSviVWqFvWALQAXrES76rkOQFyrVjJ7eKkgyEtEJE3wMiuynUSkBMAiZkOn
         xJ/9e4mxp46YEya9fEgIP99KFZDvX/lFfXqYgUi6dIoCtVJHqM9t5DMf3D6OtsNCpU
         kcc/YAdQfc4eH5KzSDskQm2+yMlJBibPkeNESyjg=
Date:   Mon, 15 Nov 2021 21:09:59 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  +
 fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch added to
 -mm tree
Message-ID: <20211116050959.16xUi0UM3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: use DEFINE_PROC_SHOW_ATTRIBUTE() to simplify the code
has been added to the -mm tree.  Its filename is
     fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: proc: use DEFINE_PROC_SHOW_ATTRIBUTE() to simplify the code

DEFINE_PROC_SHOW_ATTRIBUTE() can be used here to simplify the code.

Link: https://lkml.kernel.org/r/20211101093518.86845-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_debug.c |   17 ++---------------
 fs/nfsd/stats.c      |   15 ++-------------
 net/sunrpc/stats.c   |   15 ++-------------
 3 files changed, 6 insertions(+), 41 deletions(-)

--- a/fs/cifs/cifs_debug.c~fs-proc-use-define_proc_show_attribute-to-simplify-the-code
+++ a/fs/cifs/cifs_debug.c
@@ -1007,7 +1007,7 @@ static const struct proc_ops cifs_securi
 };
 
 /* To make it easier to debug, can help to show mount params */
-static int cifs_mount_params_proc_show(struct seq_file *m, void *v)
+static int cifs_mount_params_show(struct seq_file *m, void *v)
 {
 	const struct fs_parameter_spec *p;
 	const char *type;
@@ -1035,20 +1035,7 @@ static int cifs_mount_params_proc_show(s
 
 	return 0;
 }
-
-static int cifs_mount_params_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cifs_mount_params_proc_show, NULL);
-}
-
-static const struct proc_ops cifs_mount_params_proc_ops = {
-	.proc_open	= cifs_mount_params_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
-	/* No need for write for now */
-	/* .proc_write	= cifs_mount_params_proc_write, */
-};
+DEFINE_PROC_SHOW_ATTRIBUTE(cifs_mount_params);
 
 #else
 inline void cifs_proc_init(void)
--- a/fs/nfsd/stats.c~fs-proc-use-define_proc_show_attribute-to-simplify-the-code
+++ a/fs/nfsd/stats.c
@@ -32,7 +32,7 @@ struct svc_stat		nfsd_svcstats = {
 	.program	= &nfsd_program,
 };
 
-static int nfsd_proc_show(struct seq_file *seq, void *v)
+static int nfsd_show(struct seq_file *seq, void *v)
 {
 	int i;
 
@@ -71,18 +71,7 @@ static int nfsd_proc_show(struct seq_fil
 
 	return 0;
 }
-
-static int nfsd_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nfsd_proc_show, NULL);
-}
-
-static const struct proc_ops nfsd_proc_ops = {
-	.proc_open	= nfsd_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
-};
+DEFINE_PROC_SHOW_ATTRIBUTE(nfsd);
 
 int nfsd_percpu_counters_init(struct percpu_counter counters[], int num)
 {
--- a/net/sunrpc/stats.c~fs-proc-use-define_proc_show_attribute-to-simplify-the-code
+++ a/net/sunrpc/stats.c
@@ -34,7 +34,7 @@
 /*
  * Get RPC client stats
  */
-static int rpc_proc_show(struct seq_file *seq, void *v) {
+static int rpc_show(struct seq_file *seq, void *v) {
 	const struct rpc_stat	*statp = seq->private;
 	const struct rpc_program *prog = statp->program;
 	unsigned int i, j;
@@ -63,18 +63,7 @@ static int rpc_proc_show(struct seq_file
 	}
 	return 0;
 }
-
-static int rpc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rpc_proc_show, inode->i_private);
-}
-
-static const struct proc_ops rpc_proc_ops = {
-	.proc_open	= rpc_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
-};
+DEFINE_PROC_SHOW_ATTRIBUTE(rpc);
 
 /*
  * Get RPC server stats
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch
fs-proc-store-pde-data-into-inode-i_private.patch
fs-proc-replace-pde_datainode-with-inode-i_private.patch
fs-proc-remove-pde_data.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

