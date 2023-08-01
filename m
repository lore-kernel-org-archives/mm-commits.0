Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D51DC001DF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjHASDb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjHASDb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05112100;
        Tue,  1 Aug 2023 11:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8178261666;
        Tue,  1 Aug 2023 18:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF68C433C8;
        Tue,  1 Aug 2023 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690913008;
        bh=umAAyNwUcyhKiUF7YUdwZLW4kbxYKPj9iFe7hGZ18UQ=;
        h=Date:To:From:Subject:From;
        b=uy2Dmb9jRAEcuilDv6QACbtm47GpL7V0itnWl7IrQZG73j4B0PThN+0R8zmwoGCgA
         tNv4qNsE0yzW2uU40biY/3uikSnEKtKkcZSKE082iufiBwkDw3g5V+3yWosFLwuBni
         wnJ/uoF8qAbYVj1bwCEA3IIodiuqHWzo//BFsJfw=
Date:   Tue, 01 Aug 2023 11:03:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        urezki@gmail.com, stable@vger.kernel.org,
        regressions@leemhuis.info, olsajiri@gmail.com,
        liushixin2@huawei.com, jolsa@kernel.org, efault@gmx.de,
        david@redhat.com, catalin.marinas@arm.com, bhe@redhat.com,
        axboe@kernel.dk, ardb@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions.patch added to mm-hotfixes-unstable branch
Message-Id: <20230801180328.CDF68C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: reinstate bounce buffer for KCORE_TEXT regions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: fs/proc/kcore: reinstate bounce buffer for KCORE_TEXT regions
Date: Mon, 31 Jul 2023 22:50:21 +0100

Some architectures do not populate the entire range categorised by
KCORE_TEXT, so we must ensure that the kernel address we read from is
valid.

Unfortunately there is no solution currently available to do so with a
purely iterator solution so reinstate the bounce buffer in this instance
so we can use copy_from_kernel_nofault() in order to avoid page faults
when regions are unmapped.

This change partly reverts commit 2e1c0170771e ("fs/proc/kcore: avoid
bounce buffer for ktext data"), reinstating the bounce buffer, but adapts
the code to continue to use an iterator.

Link: https://lkml.kernel.org/r/20230731215021.70911-1-lstoakes@gmail.com
Fixes: 2e1c0170771e ("fs/proc/kcore: avoid bounce buffer for ktext data")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Closes: https://lore.kernel.org/all/ZHc2fm+9daF6cgCE@krava
Tested-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Will Deacon <will@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions
+++ a/fs/proc/kcore.c
@@ -309,6 +309,8 @@ static void append_kcore_note(char *note
 
 static ssize_t read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
+	struct file *file = iocb->ki_filp;
+	char *buf = file->private_data;
 	loff_t *fpos = &iocb->ki_pos;
 	size_t phdrs_offset, notes_offset, data_offset;
 	size_t page_offline_frozen = 1;
@@ -555,10 +557,21 @@ static ssize_t read_kcore_iter(struct ki
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
+			 * Sadly we must use a bounce buffer here to be able to
+			 * make use of copy_from_kernel_nofault(), as these
+			 * memory regions might not always be mapped on all
+			 * architectures.
+			 */
+			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
+				if (iov_iter_zero(tsz, iter) != tsz) {
+					ret = -EFAULT;
+					goto out;
+				}
+			/*
 			 * We use _copy_to_iter() to bypass usermode hardening
 			 * which would otherwise prevent this operation.
 			 */
-			if (_copy_to_iter((char *)start, tsz, iter) != tsz) {
+			} else if (_copy_to_iter(buf, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -595,6 +608,10 @@ static int open_kcore(struct inode *inod
 	if (ret)
 		return ret;
 
+	filp->private_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!filp->private_data)
+		return -ENOMEM;
+
 	if (kcore_need_update)
 		kcore_update_ram();
 	if (i_size_read(inode) != proc_root_kcore->size) {
@@ -605,9 +622,16 @@ static int open_kcore(struct inode *inod
 	return 0;
 }
 
+static int release_kcore(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
 static const struct proc_ops kcore_proc_ops = {
 	.proc_read_iter	= read_kcore_iter,
 	.proc_open	= open_kcore,
+	.proc_release	= release_kcore,
 	.proc_lseek	= default_llseek,
 };
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions.patch
fs-proc-kcore-reinstate-bounce-buffer-for-kcore_text-regions-fix.patch

