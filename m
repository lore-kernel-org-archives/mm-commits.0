Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7247C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiAVBWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:22:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:22:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9143961A9C
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C437AC340E1;
        Sat, 22 Jan 2022 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814539;
        bh=qcBvS6YyaigPreMhtfnXzvtnrnEvbXG0wyt/dijlyRQ=;
        h=Date:From:To:Subject:From;
        b=tANlcudcQH3kxy9pAnCuzPdcybNnJAYMvmgbAlsHOuVqAYrDyrmgfHSlgYk7WZSRq
         JyvQgcxigHy/VTBnr+zazdvdJTU59MvRcxfTfCaI7wVjwRmtCddDCgqvYCjPztueEe
         KUVG0x4IsrpJsvt6RsEvIje+zmA8ynI1w6Nm9y14=
Date:   Fri, 21 Jan 2022 17:22:18 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [folded-merged] proc-remove-pde_data-completely-fix.patch
 removed from -mm tree
Message-ID: <20220122012218.jylar3UJU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-remove-pde_data-completely-fix
has been removed from the -mm tree.  Its filename was
     proc-remove-pde_data-completely-fix.patch

This patch was dropped because it was folded into proc-remove-pde_data-completely.patch

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

proc-remove-pde_data-completely.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

