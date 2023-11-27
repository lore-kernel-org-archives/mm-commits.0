Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B68C07D5A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjK0RWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbjK0RHn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:07:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C5C10D1
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:07:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF58CC433C8;
        Mon, 27 Nov 2023 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104869;
        bh=dOD6s75oBGWD7wwN14Lb/h+6j/2mJitehuXz54YRTb8=;
        h=Date:To:From:Subject:From;
        b=ZCp5ODlyAhpk34DTtdlYPoPFC3lQw6KR+ihayHHhP+kadLC7ZRT0rWRkT8I66JMas
         /fF8oi+0YgHAftlkhTmg2MXHuGlxQYnFxQQ89StcxH0imN2B2Vtx/b4FevWo1WggRl
         ljeYJXFusaTI6TBqWkF4TJV+S69bJafqreBR+XKc=
Date:   Mon, 27 Nov 2023 09:07:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170748.DF58CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: eliminate staggered calls to kunmap in nilfs_rename
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch

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
Subject: nilfs2: eliminate staggered calls to kunmap in nilfs_rename
Date: Mon, 27 Nov 2023 23:30:21 +0900

In nilfs_rename(), calls to nilfs_put_page() to release pages obtained
with nilfs_find_entry() or nilfs_dotdot() are alternated in the normal
path.

When replacing the kernel memory mapping method from kmap to
kmap_local_{page,folio}, this violates the constraint on the calling order
of kunmap_local().

Swap the order of nilfs_put_page calls where the kmap sections of multiple
pages overlap so that they are nested, allowing direct replacement of
nilfs_put_page() -> unmap_and_put_page().

Without this reordering, that replacement will cause a kernel WARNING in
kunmap_local_indexed() on architectures with high memory mapping.

Link: https://lkml.kernel.org/r/20231127143036.2425-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/namei.c~nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename
+++ a/fs/nilfs2/namei.c
@@ -411,13 +411,14 @@ static int nilfs_rename(struct mnt_idmap
 	inode_set_ctime_current(old_inode);
 
 	nilfs_delete_entry(old_de, old_page);
-	nilfs_put_page(old_page);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		nilfs_put_page(dir_page);
 		drop_nlink(old_dir);
 	}
+	nilfs_put_page(old_page);
+
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch
nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch

