Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EDEC77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 20:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjERUDJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 16:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjERUDJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 16:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4316910D9
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 13:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4B73651ED
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 20:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2415FC433EF;
        Thu, 18 May 2023 20:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684440165;
        bh=dXs4bAWA/rwt2yFA3zeh758usrBlSOP0pDq6eBLv/uc=;
        h=Date:To:From:Subject:From;
        b=Yl2Wx3QummjatlRvqCeILzFKrokkBIYH+M7hgEajT2W12Tq468BYlJoqntCinYVu5
         p0vqFeeeN/EryPRV+cZgtHZ4ArFYD56OA/BjbJBXszC1WLAK3p2tbzz3qTUdxtQ0CL
         JH5z+DQ07QFKWz1Bd6E11RdlC+ieL3YLpb+QyaMI=
Date:   Thu, 18 May 2023 13:02:44 -0700
To:     mm-commits@vger.kernel.org, angus.chen@jaguarmicro.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230518200245.2415FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init-add-bdev-fs-printk-if-mount_block_root-failed-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-add-bdev-fs-printk-if-mount_block_root-failed-fix
Date: Thu May 18 12:58:30 PM PDT 2023

fix spelling in printk message

Cc: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts.c~init-add-bdev-fs-printk-if-mount_block_root-failed-fix
+++ a/init/do_mounts.c
@@ -434,7 +434,7 @@ retry:
 		if (!num_fs)
 			pr_err("Can't find any bdev filesystem to be used for mount!\n");
 		else {
-			pr_err("List of all bdev filesystem:\n");
+			pr_err("List of all bdev filesystems:\n");
 			for (i = 0, p = fs_names; i < num_fs; i++, p += strlen(p)+1)
 				pr_err(" %s", p);
 			pr_err("\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

