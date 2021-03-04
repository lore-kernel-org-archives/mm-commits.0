Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1C5C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0022A64E76
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhCDA7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381718AbhCDAKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:10:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C796064F8A;
        Thu,  4 Mar 2021 00:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816595;
        bh=VM6g3Aw5qbJ7kG3CDzyrZFc8mpD9ewU7FqnvfdAv9PE=;
        h=Date:From:To:Subject:From;
        b=cR93za6d0JVzQLRHrahktIV4flZThXSMx/wczHigUTSjTJLYMw9QtS+Fr91QaGvVN
         zKur2qe+81mmq4KWC570tSyVkFY9hOmNWOSlysWlVdjnjy719IrIJg5pUGmfG3ZjGH
         PG/BXWOYfc+WxELo3Dkj620mHznUhFQV7XZ0LleM=
Date:   Wed, 03 Mar 2021 16:09:55 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-filemap-minor-coding-style-tweaks.patch added to -mm
 tree
Message-ID: <20210304000955.vowk65BZG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-filemap-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3215,7 +3215,7 @@ const struct vm_operations_struct generi
 
 /* This is used for a general mmap of a disk file */
 
-int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct address_space *mapping = file->f_mapping;
 
@@ -3240,11 +3240,11 @@ vm_fault_t filemap_page_mkwrite(struct v
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
@@ -3672,7 +3672,7 @@ EXPORT_SYMBOL(generic_perform_write);
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

mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-memremap-fixes-improper-spdx-comment-style.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch

