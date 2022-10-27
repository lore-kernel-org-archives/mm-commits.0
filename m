Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B655ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 19:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiJ0Tps (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiJ0Tpp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 15:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7160080BC7
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 12:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00513624CC
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 19:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474CAC433C1;
        Thu, 27 Oct 2022 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666899941;
        bh=Jm0pLgHXxN0X8P6cdWL1+DjETRbNQc2E1POGDB7f9q8=;
        h=Date:To:From:Subject:From;
        b=e43PPatwJ+idODd91kGxqoSnF6lkUTH8W7hq9V5EH3rbK4Y3l7mGgIiG/XAXqj5Xh
         PFo9VNF+tzQUhyYRRONU8GiI472WRSwIKelQAGkQhmy+rarue3g5VbmGc4ymOwcSNf
         /dUhp07Z7ulquS1zDw5tn6te50gfjQITqU/ZU5Ck=
Date:   Thu, 27 Oct 2022 12:45:40 -0700
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch added to mm-nonmm-unstable branch
Message-Id: <20221027194541.474CAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix shift-out-of-bounds due to too large exponent of block size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix shift-out-of-bounds due to too large exponent of block size
Date: Thu, 27 Oct 2022 13:43:06 +0900

If field s_log_block_size of superblock data is corrupted and too large,
init_nilfs() and load_nilfs() still can trigger a shift-out-of-bounds
warning followed by a kernel panic (if panic_on_warn is set):

 shift exponent 38973 is too large for 32-bit type 'int'
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ubsan_epilogue+0xb/0x50
  __ubsan_handle_shift_out_of_bounds.cold.12+0x17b/0x1f5
  init_nilfs.cold.11+0x18/0x1d [nilfs2]
  nilfs_mount+0x9b5/0x12b0 [nilfs2]
  ...

This fixes the issue by adding and using a new helper function for getting
block size with sanity check.

Link: https://lkml.kernel.org/r/20221027044306.42774-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size
+++ a/fs/nilfs2/the_nilfs.c
@@ -194,6 +194,34 @@ static int nilfs_store_log_cursor(struct
 }
 
 /**
+ * nilfs_get_blocksize - get block size from raw superblock data
+ * @sb: super block instance
+ * @sbp: superblock raw data buffer
+ * @blocksize: place to store block size
+ *
+ * nilfs_get_blocksize() calculates the block size from the block size
+ * exponent information written in @sbp and stores it in @blocksize,
+ * or aborts with an error message if it's too large.
+ *
+ * Return Value: On success, 0 is returned. If the block size is too
+ * large, -EINVAL is returned.
+ */
+static int nilfs_get_blocksize(struct super_block *sb,
+			       struct nilfs_super_block *sbp, int *blocksize)
+{
+	unsigned int shift_bits = le32_to_cpu(sbp->s_log_block_size);
+
+	if (unlikely(shift_bits >
+		     ilog2(NILFS_MAX_BLOCK_SIZE) - BLOCK_SIZE_BITS)) {
+		nilfs_err(sb, "too large filesystem blocksize: 2 ^ %u KiB",
+			  shift_bits);
+		return -EINVAL;
+	}
+	*blocksize = BLOCK_SIZE << shift_bits;
+	return 0;
+}
+
+/**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
  * @sb: super block instance used to recover past segment
@@ -246,11 +274,15 @@ int load_nilfs(struct the_nilfs *nilfs,
 		nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
 
 		/* verify consistency between two super blocks */
-		blocksize = BLOCK_SIZE << le32_to_cpu(sbp[0]->s_log_block_size);
+		err = nilfs_get_blocksize(sb, sbp[0], &blocksize);
+		if (err)
+			goto scan_error;
+
 		if (blocksize != nilfs->ns_blocksize) {
 			nilfs_warn(sb,
 				   "blocksize differs between two super blocks (%d != %d)",
 				   blocksize, nilfs->ns_blocksize);
+			err = -EINVAL;
 			goto scan_error;
 		}
 
@@ -609,9 +641,11 @@ int init_nilfs(struct the_nilfs *nilfs,
 	if (err)
 		goto failed_sbh;
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
-	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
-	    blocksize > NILFS_MAX_BLOCK_SIZE) {
+	err = nilfs_get_blocksize(sb, sbp, &blocksize);
+	if (err)
+		goto failed_sbh;
+
+	if (blocksize < NILFS_MIN_BLOCK_SIZE) {
 		nilfs_err(sb,
 			  "couldn't mount because of unsupported filesystem blocksize %d",
 			  blocksize);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-shift-out-of-bounds-overflow-in-nilfs_sb2_bad_offset.patch
nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch

