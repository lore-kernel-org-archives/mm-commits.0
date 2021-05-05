Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A110FC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7317261078
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhEEBBQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhEEBBP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC13361078;
        Wed,  5 May 2021 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176419;
        bh=Fc7/EMufBZ6NQpWpLfaVcr9KC+86fp1plsQFo3T9LjA=;
        h=Date:From:To:Subject:From;
        b=ncoqq8yTBDEg8BR7tn2b7Nstt1FcoixC5AxV2I/fT8HSX20Q3YpiMbmWfbsdIvHWy
         skA9SSFaL0N+j+FgjPoJWKLXlZm6NJ/5nJyYMZm61digPFnKAPiHindZwiQMnsoZTf
         FgUDM+kQoVlDiLKZHSe0zZ26Y7Teu4/fWDPDf/Ao=
Date:   Tue, 04 May 2021 18:00:19 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-filemap-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010019.hMJ65iwx2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-filemap-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/filemap: minor coding style tweaks

Delete whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1614228936-22337-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemap-minor-coding-style-tweaks
+++ a/mm/filemap.c
@@ -3206,7 +3206,7 @@ const struct vm_operations_struct generi
 
 /* This is used for a general mmap of a disk file */
 
-int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct address_space *mapping = file->f_mapping;
 
@@ -3231,11 +3231,11 @@ vm_fault_t filemap_page_mkwrite(struct v
 {
 	return VM_FAULT_SIGBUS;
 }
-int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	return -ENOSYS;
 }
-int generic_file_readonly_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	return -ENOSYS;
 }
@@ -3663,7 +3663,7 @@ EXPORT_SYMBOL(generic_perform_write);
 ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space * mapping = file->f_mapping;
+	struct address_space *mapping = file->f_mapping;
 	struct inode 	*inode = mapping->host;
 	ssize_t		written = 0;
 	ssize_t		err;
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

