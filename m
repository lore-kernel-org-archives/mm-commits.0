From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:32:07 -0700
Message-ID: <53960bb7.4PKCilxLesG3MzDk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, fabf@skynet.be

Subject: [merged] fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch removed from -mm tree
To: fabf@skynet.be,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:07 -0700


The patch titled
     Subject: fs/hfsplus/wrapper.c: replace min/casting by min_t
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus/wrapper.c: replace min/casting by min_t

Also add * before function comments (it was not detected by kernel-doc)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/wrapper.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/wrapper.c~fs-hfsplus-wrapperc-replace-min-casting-by-min_t fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~fs-hfsplus-wrapperc-replace-min-casting-by-min_t
+++ a/fs/hfsplus/wrapper.c
@@ -24,8 +24,8 @@ struct hfsplus_wd {
 	u16 embed_count;
 };
 
-/*
- * hfsplus_submit_bio - Perfrom block I/O
+/**
+ * hfsplus_submit_bio - Perform block I/O
  * @sb: super block of volume for I/O
  * @sector: block to read or write, for blocks of HFSPLUS_SECTOR_SIZE bytes
  * @buf: buffer for I/O
@@ -234,7 +234,7 @@ reread:
 	sbi->alloc_blksz_shift = 0;
 	while ((blocksize >>= 1) != 0)
 		sbi->alloc_blksz_shift++;
-	blocksize = min(sbi->alloc_blksz, (u32)PAGE_SIZE);
+	blocksize = min_t(u32, sbi->alloc_blksz, PAGE_SIZE);
 
 	/*
 	 * Align block size to block offset.
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

