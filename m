Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE6AC433E5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1862074F
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595879820;
	bh=KbcLNAQWo/tLJ9AsGj3ZJ/cQ2Ipiik10XuuCHdoVMkw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YE2b6nFgsDusE1LPz5+O6T7L9tTdxg0nduBOvKwaL057deVd75dvQmaO0G2FX5AQw
	 X0q1JpFMfSdHa7qlwxr+b4gyNn36U1g5QHJ032ZXgs62jvitMaef9NYoZRJ1hL3mVK
	 qbYDyOyQwo2WmxG0/GIfWuTqVvjuo/gcK5MxUojA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgG0T5A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0T47 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 15:56:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E02822072E;
        Mon, 27 Jul 2020 19:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879819;
        bh=KbcLNAQWo/tLJ9AsGj3ZJ/cQ2Ipiik10XuuCHdoVMkw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OTsOQJSw4XC5R6T3i5wzKE5te58zTXMvW0oIQJRL8ROKtWw0EWwSw48Qdp8xhKPJO
         zItoQm3wtJ8PjpcuTRQ4+GF3H13dD/BTYCcxh52fMAt5mwoQNGfCrUADfqE+wMNUJg
         DQ/p/scnPQCV8R05RReuQ3RWAOj/C7BSs/M0NZwo=
Date:   Mon, 27 Jul 2020 12:56:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ebiggers@google.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  + nilfs2-only-call-unlock_new_inode-if-i_new.patch added
 to -mm tree
Message-ID: <20200727195658.EiBuTien_%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: only call unlock_new_inode() if I_NEW
has been added to the -mm tree.  Its filename is
     nilfs2-only-call-unlock_new_inode-if-i_new.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-only-call-unlock_new_inode-if-i_new.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-only-call-unlock_new_inode-if-i_new.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: nilfs2: only call unlock_new_inode() if I_NEW

Patch series "nilfs2 updates".


This patch (of 3):

unlock_new_inode() is only meant to be called after a new inode has
already been inserted into the hash table.  But nilfs_new_inode() can call
it even before it has inserted the inode, triggering the WARNING in
unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
inode has the I_NEW flag set, indicating that it's in the table.

Link: http://lkml.kernel.org/r/1595860111-3920-1-git-send-email-konishi.ryusuke@gmail.com
Link: http://lkml.kernel.org/r/1595860111-3920-2-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c~nilfs2-only-call-unlock_new_inode-if-i_new
+++ a/fs/nilfs2/inode.c
@@ -388,7 +388,8 @@ struct inode *nilfs_new_inode(struct ino
 
  failed_after_creation:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
 	iput(inode);  /*
 		       * raw_inode will be deleted through
 		       * nilfs_evict_inode().
_

Patches currently in -mm which might be from ebiggers@google.com are

fs-minix-check-return-value-of-sb_getblk.patch
fs-minix-dont-allow-getting-deleted-inodes.patch
fs-minix-reject-too-large-maximum-file-size.patch
fs-minix-set-s_maxbytes-correctly.patch
fs-minix-fix-block-limit-check-for-v1-filesystems.patch
fs-minix-remove-expected-error-message-in-block_to_path.patch
nilfs2-only-call-unlock_new_inode-if-i_new.patch

