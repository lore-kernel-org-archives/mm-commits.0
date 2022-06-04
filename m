Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF67C43334
	for <mm-commits@archiver.kernel.org>; Sat,  4 Jun 2022 18:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbiFDStb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Jun 2022 14:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbiFDSta (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Jun 2022 14:49:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A67E37BF6
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 11:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 385A4B802C6
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 18:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD353C385B8;
        Sat,  4 Jun 2022 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654368567;
        bh=xxFR65BKhnLRjRbfxhzMj4dyLqKhtpi1VPy2LkPs0Fk=;
        h=Date:To:From:Subject:From;
        b=sFroNPN3PbTnzFeBpkOahS9rsCWyHBt3b4cnSrqzAQT71huHi5+lBd9ixnQTBzNUq
         8HEsD974RrFR7f1oEMpHE3epHi3IwrnruCQBSakTJ+tkgtWax5psMCNdD95ZAj56US
         ILPsrLGVXhC1tzropOsW2VuW4yveeALnyLv09hss=
Date:   Sat, 04 Jun 2022 11:49:26 -0700
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-support-cow-in-fsdax-mode-fix.patch added to mm-unstable branch
Message-Id: <20220604184926.DD353C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs-support-cow-in-fsdax-mode-fix
has been added to the -mm mm-unstable branch.  Its filename is
     xfs-support-cow-in-fsdax-mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-support-cow-in-fsdax-mode-fix.patch

This patch will later appear in the mm-unstable branch at
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

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch

