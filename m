Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376F9C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 14:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbiI2OEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiI2OEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 10:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF92A1577E5
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 07:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C0A61357
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 14:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B00C433D7;
        Thu, 29 Sep 2022 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664460249;
        bh=mGk/vcg34NZ18+HYhjhBYWyfiDADdl8BbxMuMALU8PE=;
        h=Date:To:From:Subject:From;
        b=TE7vv8c6MFf2jyu7RgPhI9B8n+YqYeIUASx/gZRcz3P0Zj6kttznBk86E8Sc1/L7c
         T3FYYpsyWlnlqWVsD59EHhyTCiuyRxxDQFck4Q596A3KxJOYOP+M+Ld8+t6g36zQwn
         5dEUUmC4INmCo5ro1MdErT41Cwf5/gocUFfn7Q5k=
Date:   Thu, 29 Sep 2022 07:04:08 -0700
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20220929140409.B7B00C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure.patch

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
Subject: nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure
Date: Thu, 29 Sep 2022 21:33:30 +0900

If creation or finalization of a checkpoint fails due to anomalies in the
checkpoint metadata on disk, a kernel warning is generated.

This patch replaces the WARN_ONs by nilfs_error, so that a kernel, booted
with panic_on_warn, does not panic.  A nilfs_error is appropriate here to
handle the abnormal filesystem condition.

This also replaces the detected error codes with an I/O error so that
neither of the internal error codes is returned to callers.

Link: https://lkml.kernel.org/r/20220929123330.19658-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+fbb3e0b24e8dae5a16ee@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nilfs2/segment.c~nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure
+++ a/fs/nilfs2/segment.c
@@ -875,9 +875,11 @@ static int nilfs_segctor_create_checkpoi
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else
-		WARN_ON(err == -EINVAL || err == -ENOENT);
-
+	} else if (err == -EINVAL || err == -ENOENT) {
+		nilfs_error(sci->sc_super,
+			    "checkpoint creation failed due to metadata corruption.");
+		err = -EIO;
+	}
 	return err;
 }
 
@@ -891,7 +893,11 @@ static int nilfs_segctor_fill_in_checkpo
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
-		WARN_ON(err == -EINVAL || err == -ENOENT);
+		if (err == -EINVAL || err == -ENOENT) {
+			nilfs_error(sci->sc_super,
+				    "checkpoint finalization failed due to metadata corruption.");
+			err = -EIO;
+		}
 		goto failed_ibh;
 	}
 	raw_cp->cp_snapshot_list.ssl_next = 0;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure.patch

