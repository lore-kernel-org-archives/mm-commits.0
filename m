Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094C4C47E4B
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5C6561362
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhGOE3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E827C6128C;
        Thu, 15 Jul 2021 04:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323222;
        bh=E/hPjciFPdETfzSqNvWxfE+8yg//T/nkcBgjMHae9rk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=N8I6RWMc37zDgNmp1V+XoHsqIo9L8t687sz7qt+z9WxgDbAkFpOEqMb1Hqfav8K7O
         qAXBWM8HviPYcrV5RQRWrmPLtzC/GMpNzJdBIqsPBxfSEyN2pPePYNsTcJZXx7ewEz
         AVicbTHcp/0GPnJTXiRhL07VBMPCfY0pO/SLQ4rY=
Date:   Wed, 14 Jul 2021 21:27:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, desmondcheongzx@gmail.com,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, slava@dubeyko.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 10/13] hfs: add missing clean-up in hfs_fill_super
Message-ID: <20210715042701.RIM_Afm8q%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Subject: hfs: add missing clean-up in hfs_fill_super

Patch series "hfs: fix various errors", v2.

This series ultimately aims to address a lockdep warning in hfs_find_init
reported by Syzbot:
https://syzkaller.appspot.com/bug?id=f007ef1d7a31a469e3be7aeb0fde0769b18585db

The work done for this led to the discovery of another bug, and the
Syzkaller repro test also reveals an invalid memory access error after
clearing the lockdep warning.  Hence, this series is broken up into three
patches:

1. Add a missing call to hfs_find_exit for an error path in
   hfs_fill_super

2. Fix memory mapping in hfs_bnode_read by fixing calls to kmap

3. Add lock nesting notation to tell lockdep that the observed locking
   hierarchy is safe


This patch (of 3):

Before exiting hfs_fill_super, the struct hfs_find_data used in
hfs_find_init should be passed to hfs_find_exit to be cleaned up, and to
release the lock held on the btree.

The call to hfs_find_exit is missing from an error path.  We add it back
in by consolidating calls to hfs_find_exit for error paths.

Link: https://lkml.kernel.org/r/20210701030756.58760-1-desmondcheongzx@gmail.com
Link: https://lkml.kernel.org/r/20210701030756.58760-2-desmondcheongzx@gmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/hfs/super.c~hfs-add-missing-clean-up-in-hfs_fill_super
+++ a/fs/hfs/super.c
@@ -420,14 +420,12 @@ static int hfs_fill_super(struct super_b
 	if (!res) {
 		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
 			res =  -EIO;
-			goto bail;
+			goto bail_hfs_find;
 		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
 	}
-	if (res) {
-		hfs_find_exit(&fd);
-		goto bail_no_root;
-	}
+	if (res)
+		goto bail_hfs_find;
 	res = -EINVAL;
 	root_inode = hfs_iget(sb, &fd.search_key->cat, &rec);
 	hfs_find_exit(&fd);
@@ -443,6 +441,8 @@ static int hfs_fill_super(struct super_b
 	/* everything's okay */
 	return 0;
 
+bail_hfs_find:
+	hfs_find_exit(&fd);
 bail_no_root:
 	pr_err("get root inode failed\n");
 bail:
_
