Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D4DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354192AbiE0Qfg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354164AbiE0QfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F0A53704
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3840361C36
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D832C385B8;
        Fri, 27 May 2022 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669317;
        bh=qUnVVooVyE6dshK+3LXGXnttLzPEWlujf4PCB6e6gII=;
        h=Date:To:From:Subject:From;
        b=rBfTqG/vj6V6W4X5FsDo5YAm+MYt2yqcY9pvv15+eAJ1Evdd1gtJhpCnVOAjGvT0C
         +KICs1LxrB7v1y0nPIEcU4LadY0NVJ1JyLa3Km76TMHYaFwW796VVeMbwveuHUWnzQ
         mIz5SIg28ShLReIR4uHriiVDcBxl4zNQspkXxKQE=
Date:   Fri, 27 May 2022 09:35:16 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, jrtc27@jrtc27.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmemc-suppress-shift-warning.patch removed from -mm tree
Message-Id: <20220527163517.8D832C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem.c: suppress shift warning
has been removed from the -mm tree.  Its filename was
     mm-shmemc-suppress-shift-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/shmem.c: suppress shift warning
Date: Wed May 25 03:17:09 PM PDT 2022

mm/shmem.c:1948 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?

On i386, so an unsigned long is 32-bit, but i_blocks is a 64-bit blkcnt_t.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Jessica Clarke <jrtc27@jrtc27.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmemc-suppress-shift-warning
+++ a/mm/shmem.c
@@ -1945,7 +1945,7 @@ alloc_nohuge:
 
 	spin_lock_irq(&info->lock);
 	info->alloced += folio_nr_pages(folio);
-	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
+	inode->i_blocks += (blkcnt_t)BLOCKS_PER_PAGE << folio_order(folio);
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 	alloced = true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

