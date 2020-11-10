Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CB7C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D332063A
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnSDhcDr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgKJUbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgKJUbl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 15:31:41 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F39752054F;
        Tue, 10 Nov 2020 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605040301;
        bh=6bM68zPWdZ5ik9Vt5GXA8a1boQXjfD/uoJ+dqO+ue8M=;
        h=Date:From:To:Subject:From;
        b=tnSDhcDrwcWXifDxIFMWjNIApcBOxr/6KIZb+dINGEy+gXR1NkxifCmsafq9qUlze
         NhHCRI02cdL5pRI9rN3BwFCzAWXPrUnv/ipca+02LSTwnn+45+0azEcRepM+lnbcS4
         eh6FE/kOmKgnb/xDzy/pCULVaW2vUyVlljvU8TVE=
Date:   Tue, 10 Nov 2020 12:31:40 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, anton@tuxera.com,
        mm-commits@vger.kernel.org
Subject:  + fs-ntfs-remove-unused-varibles.patch added to -mm tree
Message-ID: <20201110203140.WrAsQlG5F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs: remove unused varibles
has been added to the -mm tree.  Its filename is
     fs-ntfs-remove-unused-varibles.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-ntfs-remove-unused-varibles.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-ntfs-remove-unused-varibles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: fs/ntfs: remove unused varibles

We actually don't use these varibles, so remove them to avoid gcc warning:
fs/ntfs/file.c:326:14: warning: variable `base_ni' set but not used
[-Wunused-but-set-variable]
fs/ntfs/logfile.c:481:21: warning: variable `log_page_mask' set but not
used [-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/1604821092-54631-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c    |    5 +----
 fs/ntfs/logfile.c |    3 +--
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/fs/ntfs/file.c~fs-ntfs-remove-unused-varibles
+++ a/fs/ntfs/file.c
@@ -323,7 +323,7 @@ static ssize_t ntfs_prepare_file_for_wri
 	unsigned long flags;
 	struct file *file = iocb->ki_filp;
 	struct inode *vi = file_inode(file);
-	ntfs_inode *base_ni, *ni = NTFS_I(vi);
+	ntfs_inode *ni = NTFS_I(vi);
 	ntfs_volume *vol = ni->vol;
 
 	ntfs_debug("Entering for i_ino 0x%lx, attribute type 0x%x, pos "
@@ -365,9 +365,6 @@ static ssize_t ntfs_prepare_file_for_wri
 		err = -EOPNOTSUPP;
 		goto out;
 	}
-	base_ni = ni;
-	if (NInoAttr(ni))
-		base_ni = ni->ext.base_ntfs_ino;
 	err = file_remove_privs(file);
 	if (unlikely(err))
 		goto out;
--- a/fs/ntfs/logfile.c~fs-ntfs-remove-unused-varibles
+++ a/fs/ntfs/logfile.c
@@ -478,7 +478,7 @@ bool ntfs_check_logfile(struct inode *lo
 	u8 *kaddr = NULL;
 	RESTART_PAGE_HEADER *rstr1_ph = NULL;
 	RESTART_PAGE_HEADER *rstr2_ph = NULL;
-	int log_page_size, log_page_mask, err;
+	int log_page_size, err;
 	bool logfile_is_empty = true;
 	u8 log_page_bits;
 
@@ -501,7 +501,6 @@ bool ntfs_check_logfile(struct inode *lo
 		log_page_size = DefaultLogPageSize;
 	else
 		log_page_size = PAGE_SIZE;
-	log_page_mask = log_page_size - 1;
 	/*
 	 * Use ntfs_ffs() instead of ffs() to enable the compiler to
 	 * optimize log_page_size and log_page_bits into constants.
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-update-page-struct-member-in-comments.patch

