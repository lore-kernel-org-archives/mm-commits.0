Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C72BC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377941AbiATVbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377947AbiATVbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67B6C06173F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 761C9618CD
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8531C340E0;
        Thu, 20 Jan 2022 21:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714279;
        bh=4Z/oFclvA1/NaZhTF/37vuLvL+GGnQoa15GunOpDhrg=;
        h=Date:From:To:Subject:From;
        b=ZULqd5M5pMa6Pa3xS4/S2+xKSuWqvka4WJvqCaCAjmvEdKACKwEKBJB9IGL2fz/Wg
         5cO32YgwGLmww69eMXwAxLE+shL7kVts+fh2HECmrisN9hH8hJMuUTDCKTQJ6oM9UF
         uUuCSvyLA82c1f9WHgiRH/F1uwXZfSzloXQF0Jy4=
Date:   Thu, 20 Jan 2022 13:31:19 -0800
From:   akpm@linux-foundation.org
To:     chi.minghao@zte.com.cn, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, jack@suse.cz,
        mm-commits@vger.kernel.org, zealci@zte.com.cm
Subject:  [merged]
 fs-adfs-remove-unneeded-variable-make-code-cleaner.patch removed from -mm
 tree
Message-ID: <20220120213119.WsNC_6YVE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs: remove unneeded variable make code cleaner
has been removed from the -mm tree.  Its filename was
     fs-adfs-remove-unneeded-variable-make-code-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: fs/adfs: remove unneeded variable make code cleaner

Return value directly instead of taking this in a variable.

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

ipc-sem-do-not-sleep-with-a-spin-lock-held.patch

