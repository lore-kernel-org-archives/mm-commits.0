Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDDBC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 02:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbhLACzi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241462AbhLACzh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 21:55:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69E7C061574
        for <mm-commits@vger.kernel.org>; Tue, 30 Nov 2021 18:52:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E02D2CE1D63
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 02:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AD7C53FCB;
        Wed,  1 Dec 2021 02:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638327133;
        bh=4/3cGTYNz2m+CDs5+0bUClp55M38m/UxT4AO/YLXq28=;
        h=Date:From:To:Subject:From;
        b=wM6a/QQGLQ5IUeXmvZiLcUwSC9CsmF6L3YdC1doW2a3Bfzqn9UIPrx6EzAn6fZC8J
         oj0oiKuUzy8aQqEzeum2c9PEiGLDBjoAdGX/NDPag+LCtWg0af85xa5afk8G3LO9PW
         5GK3DaOLq6xLeGaGmclVImMW+wICxkfYcP7bCyDU=
Date:   Tue, 30 Nov 2021 18:52:13 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  + proc-remove-pde_data-completely-fix.patch added to -mm
 tree
Message-ID: <20211201025213.ZTprXL2ki%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-remove-pde_data-completely-fix
has been added to the -mm tree.  Its filename is
     proc-remove-pde_data-completely-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-remove-pde_data-completely-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-pde_data-completely-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-remove-pde_data-completely-fix

fix naming clash in drivers/nubus/proc.c

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nubus/proc.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/nubus/proc.c~proc-remove-pde_data-completely-fix
+++ a/drivers/nubus/proc.c
@@ -93,30 +93,30 @@ struct nubus_proc_pde_data {
 static struct nubus_proc_pde_data *
 nubus_proc_alloc_pde_data(unsigned char *ptr, unsigned int size)
 {
-	struct nubus_proc_pde_data *pde_data;
+	struct nubus_proc_pded *pded;
 
-	pde_data = kmalloc(sizeof(*pde_data), GFP_KERNEL);
-	if (!pde_data)
+	pded = kmalloc(sizeof(*pded), GFP_KERNEL);
+	if (!pded)
 		return NULL;
 
-	pde_data->res_ptr = ptr;
-	pde_data->res_size = size;
-	return pde_data;
+	pded->res_ptr = ptr;
+	pded->res_size = size;
+	return pded;
 }
 
 static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 {
 	struct inode *inode = m->private;
-	struct nubus_proc_pde_data *pde_data;
+	struct nubus_proc_pde_data *pded;
 
-	pde_data = pde_data(inode);
-	if (!pde_data)
+	pded = pde_data(inode);
+	if (!pded)
 		return 0;
 
-	if (pde_data->res_size > m->size)
+	if (pded->res_size > m->size)
 		return -EFBIG;
 
-	if (pde_data->res_size) {
+	if (pded->res_size) {
 		int lanes = (int)proc_get_parent_data(inode);
 		struct nubus_dirent ent;
 
@@ -124,11 +124,11 @@ static int nubus_proc_rsrc_show(struct s
 			return 0;
 
 		ent.mask = lanes;
-		ent.base = pde_data->res_ptr;
+		ent.base = pded->res_ptr;
 		ent.data = 0;
-		nubus_seq_write_rsrc_mem(m, &ent, pde_data->res_size);
+		nubus_seq_write_rsrc_mem(m, &ent, pded->res_size);
 	} else {
-		unsigned int data = (unsigned int)pde_data->res_ptr;
+		unsigned int data = (unsigned int)pded->res_ptr;
 
 		seq_putc(m, data >> 16);
 		seq_putc(m, data >> 8);
@@ -142,18 +142,18 @@ void nubus_proc_add_rsrc_mem(struct proc
 			     unsigned int size)
 {
 	char name[9];
-	struct nubus_proc_pde_data *pde_data;
+	struct nubus_proc_pde_data *pded;
 
 	if (!procdir)
 		return;
 
 	snprintf(name, sizeof(name), "%x", ent->type);
 	if (size)
-		pde_data = nubus_proc_alloc_pde_data(nubus_dirptr(ent), size);
+		pded = nubus_proc_alloc_pde_data(nubus_dirptr(ent), size);
 	else
-		pde_data = NULL;
+		pded = NULL;
 	proc_create_single_data(name, S_IFREG | 0444, procdir,
-			nubus_proc_rsrc_show, pde_data);
+			nubus_proc_rsrc_show, pded);
 }
 
 void nubus_proc_add_rsrc(struct proc_dir_entry *procdir,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

