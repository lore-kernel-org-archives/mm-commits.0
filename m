Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBD6C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9F8207FC
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291209;
	bh=ph7JWk8ai7CJCeic8H2x04X8vWG0/WKUSsHyDt4yKIE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=M9KwfCDptdS1IP5bQQBWbB/05XdDwWvNArx5FScu4+kXtaCqk/BHWebK7SUlbpoVZ
	 cE4KfKS2mYZsS3vpXWwlz6ZpKydpC73RMIh/KeYfiH9VsKVvFSMn0YXYnaSo7/kAfi
	 1xQnuPVVVdDJtU9n9IbdNtSrMRp1P6l2bZI8W5OM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgGUA0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgGUA0s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:26:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B354120729;
        Tue, 21 Jul 2020 00:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291207;
        bh=ph7JWk8ai7CJCeic8H2x04X8vWG0/WKUSsHyDt4yKIE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Vnq+beDC506WQkT0THapaXEztuyScBVJeYenpu0HTC/O1rsvTTLPquO6b6X/HvEUQ
         6GPUNRt4X7hfgFOwbzvnuf8O/BrXLJMFUPNT/L/PdPpLd9VuE+/fjRBfr0fUpu9P7p
         orsZfOwNVQdaErwlfGF48q8qcmqK+CHVz0LoJC+U=
Date:   Mon, 20 Jul 2020 17:26:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anton@tuxera.com, luca.stefani.ge1@gmail.com,
        michalechner92@googlemail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject:  +
 ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type.patch
 added to -mm tree
Message-ID: <20200721002647.QdSOCbx24%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: fix ntfs_test_inode and ntfs_init_locked_inode function type
has been added to the -mm tree.  Its filename is
     ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luca Stefani <luca.stefani.ge1@gmail.com>
Subject: ntfs: fix ntfs_test_inode and ntfs_init_locked_inode function type

Clang's Control Flow Integrity (CFI) is a security mechanism that can help
prevent JOP chains, deployed extensively in downstream kernels used in
Android.

Its deployment is hindered by mismatches in function signatures.  For this
case, we make callbacks match their intended function signature, and cast
parameters within them rather than casting the callback when passed as a
parameter.

When running `mount -t ntfs ...` we observe the following trace:

Call trace:
__cfi_check_fail+0x1c/0x24
name_to_dev_t+0x0/0x404
iget5_locked+0x594/0x5e8
ntfs_fill_super+0xbfc/0x43ec
mount_bdev+0x30c/0x3cc
ntfs_mount+0x18/0x24
mount_fs+0x1b0/0x380
vfs_kern_mount+0x90/0x398
do_mount+0x5d8/0x1a10
SyS_mount+0x108/0x144
el0_svc_naked+0x34/0x38

Link: http://lkml.kernel.org/r/20200718112513.533800-1-luca.stefani.ge1@gmail.com
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
Tested-by: freak07 <michalechner92@googlemail.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/dir.c   |    2 +-
 fs/ntfs/inode.c |   27 ++++++++++++++-------------
 fs/ntfs/inode.h |    4 +---
 fs/ntfs/mft.c   |    4 ++--
 4 files changed, 18 insertions(+), 19 deletions(-)

--- a/fs/ntfs/dir.c~ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type
+++ a/fs/ntfs/dir.c
@@ -1503,7 +1503,7 @@ static int ntfs_dir_fsync(struct file *f
 	na.type = AT_BITMAP;
 	na.name = I30;
 	na.name_len = 4;
-	bmp_vi = ilookup5(vi->i_sb, vi->i_ino, (test_t)ntfs_test_inode, &na);
+	bmp_vi = ilookup5(vi->i_sb, vi->i_ino, ntfs_test_inode, &na);
 	if (bmp_vi) {
  		write_inode_now(bmp_vi, !datasync);
 		iput(bmp_vi);
--- a/fs/ntfs/inode.c~ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type
+++ a/fs/ntfs/inode.c
@@ -30,10 +30,10 @@
 /**
  * ntfs_test_inode - compare two (possibly fake) inodes for equality
  * @vi:		vfs inode which to test
- * @na:		ntfs attribute which is being tested with
+ * @data:	data which is being tested with
  *
  * Compare the ntfs attribute embedded in the ntfs specific part of the vfs
- * inode @vi for equality with the ntfs attribute @na.
+ * inode @vi for equality with the ntfs attribute @data.
  *
  * If searching for the normal file/directory inode, set @na->type to AT_UNUSED.
  * @na->name and @na->name_len are then ignored.
@@ -43,8 +43,9 @@
  * NOTE: This function runs with the inode_hash_lock spin lock held so it is not
  * allowed to sleep.
  */
-int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
+int ntfs_test_inode(struct inode *vi, void *data)
 {
+	ntfs_attr *na = (ntfs_attr *)data;
 	ntfs_inode *ni;
 
 	if (vi->i_ino != na->mft_no)
@@ -72,9 +73,9 @@ int ntfs_test_inode(struct inode *vi, nt
 /**
  * ntfs_init_locked_inode - initialize an inode
  * @vi:		vfs inode to initialize
- * @na:		ntfs attribute which to initialize @vi to
+ * @data:	data which to initialize @vi to
  *
- * Initialize the vfs inode @vi with the values from the ntfs attribute @na in
+ * Initialize the vfs inode @vi with the values from the ntfs attribute @data in
  * order to enable ntfs_test_inode() to do its work.
  *
  * If initializing the normal file/directory inode, set @na->type to AT_UNUSED.
@@ -87,8 +88,9 @@ int ntfs_test_inode(struct inode *vi, nt
  * NOTE: This function runs with the inode->i_lock spin lock held so it is not
  * allowed to sleep. (Hence the GFP_ATOMIC allocation.)
  */
-static int ntfs_init_locked_inode(struct inode *vi, ntfs_attr *na)
+static int ntfs_init_locked_inode(struct inode *vi, void *data)
 {
+	ntfs_attr *na = (ntfs_attr *)data;
 	ntfs_inode *ni = NTFS_I(vi);
 
 	vi->i_ino = na->mft_no;
@@ -131,7 +133,6 @@ static int ntfs_init_locked_inode(struct
 	return 0;
 }
 
-typedef int (*set_t)(struct inode *, void *);
 static int ntfs_read_locked_inode(struct inode *vi);
 static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi);
 static int ntfs_read_locked_index_inode(struct inode *base_vi,
@@ -164,8 +165,8 @@ struct inode *ntfs_iget(struct super_blo
 	na.name = NULL;
 	na.name_len = 0;
 
-	vi = iget5_locked(sb, mft_no, (test_t)ntfs_test_inode,
-			(set_t)ntfs_init_locked_inode, &na);
+	vi = iget5_locked(sb, mft_no, ntfs_test_inode,
+			ntfs_init_locked_inode, &na);
 	if (unlikely(!vi))
 		return ERR_PTR(-ENOMEM);
 
@@ -225,8 +226,8 @@ struct inode *ntfs_attr_iget(struct inod
 	na.name = name;
 	na.name_len = name_len;
 
-	vi = iget5_locked(base_vi->i_sb, na.mft_no, (test_t)ntfs_test_inode,
-			(set_t)ntfs_init_locked_inode, &na);
+	vi = iget5_locked(base_vi->i_sb, na.mft_no, ntfs_test_inode,
+			ntfs_init_locked_inode, &na);
 	if (unlikely(!vi))
 		return ERR_PTR(-ENOMEM);
 
@@ -280,8 +281,8 @@ struct inode *ntfs_index_iget(struct ino
 	na.name = name;
 	na.name_len = name_len;
 
-	vi = iget5_locked(base_vi->i_sb, na.mft_no, (test_t)ntfs_test_inode,
-			(set_t)ntfs_init_locked_inode, &na);
+	vi = iget5_locked(base_vi->i_sb, na.mft_no, ntfs_test_inode,
+			ntfs_init_locked_inode, &na);
 	if (unlikely(!vi))
 		return ERR_PTR(-ENOMEM);
 
--- a/fs/ntfs/inode.h~ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type
+++ a/fs/ntfs/inode.h
@@ -253,9 +253,7 @@ typedef struct {
 	ATTR_TYPE type;
 } ntfs_attr;
 
-typedef int (*test_t)(struct inode *, void *);
-
-extern int ntfs_test_inode(struct inode *vi, ntfs_attr *na);
+extern int ntfs_test_inode(struct inode *vi, void *data);
 
 extern struct inode *ntfs_iget(struct super_block *sb, unsigned long mft_no);
 extern struct inode *ntfs_attr_iget(struct inode *base_vi, ATTR_TYPE type,
--- a/fs/ntfs/mft.c~ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type
+++ a/fs/ntfs/mft.c
@@ -958,7 +958,7 @@ bool ntfs_may_write_mft_record(ntfs_volu
 		 * dirty code path of the inode dirty code path when writing
 		 * $MFT occurs.
 		 */
-		vi = ilookup5_nowait(sb, mft_no, (test_t)ntfs_test_inode, &na);
+		vi = ilookup5_nowait(sb, mft_no, ntfs_test_inode, &na);
 	}
 	if (vi) {
 		ntfs_debug("Base inode 0x%lx is in icache.", mft_no);
@@ -1019,7 +1019,7 @@ bool ntfs_may_write_mft_record(ntfs_volu
 		vi = igrab(mft_vi);
 		BUG_ON(vi != mft_vi);
 	} else
-		vi = ilookup5_nowait(sb, na.mft_no, (test_t)ntfs_test_inode,
+		vi = ilookup5_nowait(sb, na.mft_no, ntfs_test_inode,
 				&na);
 	if (!vi) {
 		/*
_

Patches currently in -mm which might be from luca.stefani.ge1@gmail.com are

ntfs-fix-ntfs_test_inode-and-ntfs_init_locked_inode-function-type.patch

