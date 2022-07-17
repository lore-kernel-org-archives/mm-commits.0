Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5416C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiGQX05 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQX04 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21733120BD
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C3460EEB
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEA2C3411E;
        Sun, 17 Jul 2022 23:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100415;
        bh=6AmWKWuBRs6iETgus7eBhsLKpzqtNgOEzu5LESkaYmQ=;
        h=Date:To:From:Subject:From;
        b=Tf0wirjnKqmNx5+XMeJiaF2DKqI10EWWmf98ZGP/mDIezQUMc7DclCMoYPeJ+lnhJ
         vxHSSqfVl/RkaBrEi/DT5XAdTnWV2y5LHxbu0aJVsQ6oxuRhfcHEb2hHvgrkAt31nM
         LuAkHuWTXadTkl05jhEC9dvaHz6lpAvdNWThavbU=
Date:   Sun, 17 Jul 2022 16:26:54 -0700
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] xfs-support-cow-in-fsdax-mode-fix.patch removed from -mm tree
Message-Id: <20220717232655.0FEA2C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs-support-cow-in-fsdax-mode-fix
has been removed from the -mm tree.  Its filename was
     xfs-support-cow-in-fsdax-mode-fix.patch

This patch was dropped because it was folded into xfs-support-cow-in-fsdax-mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xfs-support-cow-in-fsdax-mode-fix
Date: Sat Jun  4 11:45:10 AM PDT 2022

make xfs_dax_fault() static

Reported-by: kernel test robot <lkp@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_file.c~xfs-support-cow-in-fsdax-mode-fix
+++ a/fs/xfs/xfs_file.c
@@ -1256,7 +1256,7 @@ xfs_file_llseek(
 }
 
 #ifdef CONFIG_FS_DAX
-int
+static int
 xfs_dax_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size,
@@ -1269,7 +1269,7 @@ xfs_dax_fault(
 				&xfs_read_iomap_ops);
 }
 #else
-int
+static int
 xfs_dax_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

xfs-support-cow-in-fsdax-mode.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

