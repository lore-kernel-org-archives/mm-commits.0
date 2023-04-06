Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C3AC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbjDFCxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbjDFCxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B363C2D7F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F97563D89
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789EFC433D2;
        Thu,  6 Apr 2023 02:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749578;
        bh=REihvTjoSstF4w898VvDedPoVoELujoZa1mLvJpEAZ0=;
        h=Date:To:From:Subject:From;
        b=Q3yvCpvktfgJg0B/3nkdhEBM3IbwviRu8A/HHMy13mE4bL/IOPR6w311eJZ4jbw+d
         C2rctguVSxwkudX6CKXHqhT3ehO2cml5bTL5+AWMtI/rRyvx26dzA45sa63r6wSaqq
         K9ld1cBAmaznX17NCqX3kkheVcJwkxkTi2hg6kyY=
Date:   Wed, 05 Apr 2023 19:52:57 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, chao@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-remove-mark_inode_dirty-in-setattr.patch removed from -mm tree
Message-Id: <20230406025258.789EFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: remove mark_inode_dirty() in .setattr()
has been removed from the -mm tree.  Its filename was
     proc-remove-mark_inode_dirty-in-setattr.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chao Yu <chao@kernel.org>
Subject: proc: remove mark_inode_dirty() in .setattr()
Date: Tue, 31 Jan 2023 23:08:40 +0800

procfs' .setattr() has updated i_uid, i_gid and i_mode into proc dirent,
we don't need to call mark_inode_dirty() for delayed update, remove it.

Link: https://lkml.kernel.org/r/20230131150840.34726-1-chao@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |    1 -
 fs/proc/generic.c     |    1 -
 fs/proc/proc_sysctl.c |    1 -
 3 files changed, 3 deletions(-)

--- a/fs/proc/base.c~proc-remove-mark_inode_dirty-in-setattr
+++ a/fs/proc/base.c
@@ -699,7 +699,6 @@ int proc_setattr(struct mnt_idmap *idmap
 		return error;
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
-	mark_inode_dirty(inode);
 	return 0;
 }
 
--- a/fs/proc/generic.c~proc-remove-mark_inode_dirty-in-setattr
+++ a/fs/proc/generic.c
@@ -127,7 +127,6 @@ static int proc_notify_change(struct mnt
 		return error;
 
 	setattr_copy(&nop_mnt_idmap, inode, iattr);
-	mark_inode_dirty(inode);
 
 	proc_set_user(de, inode->i_uid, inode->i_gid);
 	de->mode = inode->i_mode;
--- a/fs/proc/proc_sysctl.c~proc-remove-mark_inode_dirty-in-setattr
+++ a/fs/proc/proc_sysctl.c
@@ -841,7 +841,6 @@ static int proc_sys_setattr(struct mnt_i
 		return error;
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
-	mark_inode_dirty(inode);
 	return 0;
 }
 
_

Patches currently in -mm which might be from chao@kernel.org are


