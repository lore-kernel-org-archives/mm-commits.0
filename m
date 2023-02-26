Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6ACDC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 22:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBZWfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBZWfU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 17:35:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C06C14F
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 14:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94ECD60C0B
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 22:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5572C433D2;
        Sun, 26 Feb 2023 22:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677450918;
        bh=O9ETYbbzzAdS1a80k9KDt/KLIqXefISmfoTmb/Exi2A=;
        h=Date:To:From:Subject:From;
        b=CtTcN1pxQfN/JV318hcSLMIqQEHapzMPUG5rYqT/TBybtzeLpkPQSRcUPrQHoq2OI
         fVa2UD1DiCuS2HXeDc98Ab4W5RFqfWBLAzgstow0a9sNxa8DCmIiCTYTn+mk8bV7Hi
         Wn5bFHiDeBGhAh9nKs2a4FhwguO94MfHYXBo5p+E=
Date:   Sun, 26 Feb 2023 14:35:17 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, chao@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-remove-mark_inode_dirty-in-setattr.patch added to mm-nonmm-unstable branch
Message-Id: <20230226223517.E5572C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove mark_inode_dirty() in .setattr()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-remove-mark_inode_dirty-in-setattr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-remove-mark_inode_dirty-in-setattr.patch

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


diff --git a/fs/proc/base.c~proc-remove-mark_inode_dirty-in-setattr b/fs/proc/base.c
--- a/fs/proc/base.c~proc-remove-mark_inode_dirty-in-setattr
+++ b/fs/proc/base.c
@@ -700,7 +700,6 @@ int proc_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		return error;
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
-	mark_inode_dirty(inode);
 	return 0;
 }
 
diff --git a/fs/proc/generic.c~proc-remove-mark_inode_dirty-in-setattr b/fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-mark_inode_dirty-in-setattr
+++ b/fs/proc/generic.c
@@ -127,7 +127,6 @@ static int proc_notify_change(struct mnt_idmap *idmap,
 		return error;
 
 	setattr_copy(&nop_mnt_idmap, inode, iattr);
-	mark_inode_dirty(inode);
 
 	proc_set_user(de, inode->i_uid, inode->i_gid);
 	de->mode = inode->i_mode;
diff --git a/fs/proc/proc_sysctl.c~proc-remove-mark_inode_dirty-in-setattr b/fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~proc-remove-mark_inode_dirty-in-setattr
+++ b/fs/proc/proc_sysctl.c
@@ -841,7 +841,6 @@ static int proc_sys_setattr(struct mnt_idmap *idmap,
 		return error;
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
-	mark_inode_dirty(inode);
 	return 0;
 }
 
_

Patches currently in -mm which might be from chao@kernel.org are

proc-remove-mark_inode_dirty-in-setattr.patch

