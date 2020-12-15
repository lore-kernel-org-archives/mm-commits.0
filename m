Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B971C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384B8224D4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgLODEV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgLODEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:12 -0500
Date:   Mon, 14 Dec 2020 19:03:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001411;
        bh=JYhWyyqVqjgd0yMU2RXhuM6QiJjOhcMMj8T1gXd0Xd4=;
        h=From:To:Subject:In-Reply-To:From;
        b=Qsz2ZdRKsUhz/+uSxD6UP73YXiJQX2sBqWmaLJ0N7hGsyVVsVRRpYJdY3KqWbgQAp
         GpFm4ZN/6mZGGDyr2Pf2VYXeipGlxMhnjZNDKvDGJ24H+KSfzIPE+ci6l+vR6GErdD
         gHkCkdyFMu6RwD021M4XyPrqQ5B32vF61Xg7i2Tc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        anton@tuxera.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 006/200] fs/ntfs: remove unused varibles
Message-ID: <20201215030331.lz-Coke8-%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
