Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD2CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 17:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244393AbhLJRQf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 12:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244392AbhLJRQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 12:16:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44CFC0617A1
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 09:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78BF9CE2C3E
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 17:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9602C00446;
        Fri, 10 Dec 2021 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639156375;
        bh=KVXVyN3huw/5DsIYBu5ioZFzCocog2aHMsOI5MmEFJ4=;
        h=Date:From:To:Subject:From;
        b=kYIttPbV8yc4RRAwzbjDCQVCmNtLU4q95yWCxT+eiFcjH1Oo0ptym2oMYgrSD/Nxm
         xOrN0yrzf8N3eS4DtK/Hu5yyrof46vQ7vfLmbHWWS6uYsoFt6uuzxpSepcgN5uklz6
         v7HXrc0xAodiiRlpkkyGwdGrG+4ZJGAN8IyDSdi4=
Date:   Fri, 10 Dec 2021 09:12:55 -0800
From:   akpm@linux-foundation.org
To:     chi.minghao@zte.com.cn, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, jack@suse.cz,
        mm-commits@vger.kernel.org, zealci@zte.com.cm
Subject:  +
 fs-adfs-remove-unneeded-variable-make-code-cleaner.patch added to -mm tree
Message-ID: <20211210171255.47FhZgLdX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs: remove unneeded variable make code cleaner
has been added to the -mm tree.  Its filename is
     fs-adfs-remove-unneeded-variable-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-adfs-remove-unneeded-variable-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-adfs-remove-unneeded-variable-make-code-cleaner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: cgel.zte@gmail.com
Subject: fs/adfs: remove unneeded variable make code cleaner


return value form directly instead of
taking this in another redundant variable.

Link: https://lkml.kernel.org/r/20211210023211.424609-1-chi.minghao@zte.com.cn
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cm>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/adfs/inode.c~fs-adfs-remove-unneeded-variable-make-code-cleaner
+++ a/fs/adfs/inode.c
@@ -355,7 +355,6 @@ int adfs_write_inode(struct inode *inode
 {
 	struct super_block *sb = inode->i_sb;
 	struct object_info obj;
-	int ret;
 
 	obj.indaddr	= ADFS_I(inode)->indaddr;
 	obj.name_len	= 0;
@@ -365,6 +364,5 @@ int adfs_write_inode(struct inode *inode
 	obj.attr	= ADFS_I(inode)->attr;
 	obj.size	= inode->i_size;
 
-	ret = adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
-	return ret;
+	return adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
 }
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

mm-remove-unneeded-variable.patch
selftests-vm-use-swap-to-make-code-cleaner.patch
fs-adfs-remove-unneeded-variable-make-code-cleaner.patch

