Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B646AC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjLGW1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbjLGW1l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:27:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BC61BF8
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:27:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7415C433C7;
        Thu,  7 Dec 2023 22:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701988042;
        bh=kDFHlbkOtC8xs8uteLGwj6w8HrHkTBbPBN/s0Njpcg8=;
        h=Date:To:From:Subject:From;
        b=1xLz/KWgw24ZBEr1Rt9BKiZD/t344AoTtoI7q8U7REt/uIawl2BwP4XSHa2Gj70V6
         1VJyodonyZAt9lhHrutqXt8h00i9XUzyBGV3MZ0OrVO9fKBG4UIW235ROnD9dVf9uc
         qwzkpjWB6wyk4v/JCptKxanXDUGFVBRoet/nbe2A=
Date:   Thu, 07 Dec 2023 14:27:22 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch added to mm-nonmm-unstable branch
Message-Id: <20231207222722.C7415C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: switch WARN_ONs to warning output in nilfs_sufile_do_free()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch

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
Subject: nilfs2: switch WARN_ONs to warning output in nilfs_sufile_do_free()
Date: Thu, 7 Dec 2023 13:57:30 +0900

nilfs_sufile_do_free(), which is called when log write fails or during GC,
uses WARN_ONs to check for abnormal status of metadata.  In the former
case, these WARN_ONs will not be fired, but in the latter case they don't
"never-happen".  It is possible to trigger these by intentionally
modifying the userland GC library to release segments that are not in the
expected state.

So, replace them with warning output using the dedicated macro
nilfs_warn().

This replaces two potentially triggered WARN_ONs with ones that use a
warning output macro.

Link: https://lkml.kernel.org/r/20231207045730.5205-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free
+++ a/fs/nilfs2/sufile.c
@@ -471,10 +471,15 @@ void nilfs_sufile_do_free(struct inode *
 		kunmap_atomic(kaddr);
 		return;
 	}
-	WARN_ON(nilfs_segment_usage_error(su));
-	WARN_ON(!nilfs_segment_usage_dirty(su));
+	if (unlikely(nilfs_segment_usage_error(su)))
+		nilfs_warn(sufile->i_sb, "free segment %llu marked in error",
+			   (unsigned long long)segnum);
 
 	sudirty = nilfs_segment_usage_dirty(su);
+	if (unlikely(!sudirty))
+		nilfs_warn(sufile->i_sb, "free unallocated segment %llu",
+			   (unsigned long long)segnum);
+
 	nilfs_segment_usage_set_clean(su);
 	kunmap_atomic(kaddr);
 	mark_buffer_dirty(su_bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch
nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch
nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch

