Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D13C04E69
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjHLWGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjHLWGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2970419A4
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1E81620D2
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1506DC433C9;
        Sat, 12 Aug 2023 22:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877968;
        bh=XWUAWgWTcA9NI1Xi+5Idvb+QUpZs5xdxNvzxnoprnq0=;
        h=Date:To:From:Subject:From;
        b=N7p4yNBxpxaL6NHREuAdvF1NYk7Cioe4hxGIEIWhipYLSYz/vcGArBL8eWwEJbrUj
         QGQRNycDekd/dDzI7hIsuEcWPPl+iWZzsMxxmoXHLJmepiUuluuS5dt0qRcoIzV5ut
         VlwS/pnieKTinVWqeuFdXFYEYP8kvFd6eV9pMKqE=
Date:   Sat, 12 Aug 2023 15:06:07 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        kurt.hackel@oracle.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, artem.chernyshev@red-soft.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ocfs2-namei-check-return-value-of-ocfs2_add_entry.patch removed from -mm tree
Message-Id: <20230812220608.1506DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: ocfs2: namei: check return value of ocfs2_add_entry()
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-namei-check-return-value-of-ocfs2_add_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Subject: fs: ocfs2: namei: check return value of ocfs2_add_entry()
Date: Thu, 3 Aug 2023 17:54:17 +0300

Process result of ocfs2_add_entry() in case we have an error
value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20230803145417.177649-1-artem.chernyshev@red-soft.ru
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/namei.c~fs-ocfs2-namei-check-return-value-of-ocfs2_add_entry
+++ a/fs/ocfs2/namei.c
@@ -1535,6 +1535,10 @@ static int ocfs2_rename(struct mnt_idmap
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
 					 OCFS2_I(old_inode)->ip_blkno,
 					 new_dir_bh, &target_insert);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 	}
 
 	old_inode->i_ctime = current_time(old_inode);
_

Patches currently in -mm which might be from artem.chernyshev@red-soft.ru are


