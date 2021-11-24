Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BD3C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245672AbhKXWVu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245539AbhKXWVt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:21:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AFE61058;
        Wed, 24 Nov 2021 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637792318;
        bh=boQuEfbGxulgAuMtMX2PvJ06YI44EGZ6YPwhlQVcmPA=;
        h=Date:From:To:Subject:From;
        b=wE2AmTarUVdBdX8oQA0vxC0TA8u6Ndmo8L0dR5rtz8N/Zs+faK1DdWBphnOK1LB0C
         3UC+RG9xCwLKMhapk0J91Dg+d2TFz43/Y0yQu80ZJJRNbzRgd9BjAMGAHikVRCEIZb
         z/j+pPyBtK9XrBBT9nKBPMTiXPKJZRHgACPbptYU=
Date:   Wed, 24 Nov 2021 14:18:38 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [to-be-updated]
 fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch removed
 from -mm tree
Message-ID: <20211124221838.RS85GAQPC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: use DEFINE_PROC_SHOW_ATTRIBUTE() to simplify the code
has been removed from the -mm tree.  Its filename was
     fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

This patch was dropped because an updated version will be merged

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
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-store-pde-data-into-inode-i_private.patch
proc-remove-pde_data-completely.patch

