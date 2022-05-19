Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349C8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbiESVDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiESVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:03:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861285BD3B
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 226826191A
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D14C385B8;
        Thu, 19 May 2022 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994226;
        bh=1wmFlqpbumYvd3QTQ2LbGhTgIkWF8RReJlVXKXhduUM=;
        h=Date:To:From:Subject:From;
        b=OiM87WXoAQTuMmS9RDr/KBHOyjvdHVWOT+HlLGSHK0rvMAPCHzKNoWItQRM/vY2r/
         MSonrW5y48G1N6BaI+gR8n8PIjmY4QsbS3OeH+jNfEp89Mb36Uu2YX3adnQwt7o+i5
         yh+i+0Jn2bkl8x1W0FRFwu+IhhKbpdez3Y8MsatQ=
Date:   Thu, 19 May 2022 14:03:45 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        luomeng12@huawei.com, hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch removed from -mm tree
Message-Id: <20220519210346.78D14C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch

This patch was dropped because it was folded into tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix
Date: Fri May 13 02:17:20 PM PDT 2022

Cc: Luo Meng <luomeng12@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix
+++ a/mm/shmem.c
@@ -3477,7 +3477,7 @@ static int shmem_reconfigure(struct fs_c
 	raw_spin_lock(&sbinfo->stat_lock);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
 	if (ctx->blocks > S64_MAX) {
-		err = "The number of blocks too large";
+		err = "Number of blocks too large";
 		goto out;
 	}
 	if ((ctx->seen & SHMEM_SEEN_BLOCKS) && ctx->blocks) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

