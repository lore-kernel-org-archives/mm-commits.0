Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6371CDB472
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjJKR4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjJKR4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:56:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7548F
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:56:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3186C433C7;
        Wed, 11 Oct 2023 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697047002;
        bh=SUe8rwon478mmM/gFVlEo+8aktWfwpBx2Oe5IzL9/Yc=;
        h=Date:To:From:Subject:From;
        b=2vj91JAuA5uYAOupyGr3KT8p6FhJ+UAhJIfBXE7Hn4j8uDq9mvZyRX646Pw1Kt6Mz
         aynL9C2mq3yeR4BT/u1PKmmotoTjHwDt/ZuakeGZTZ4KtfOqfM1zWIxK2Tg3HeNjgV
         onE/sPl7nvKZQ9bi1iA37anbZT5pvX5pVy1rwCU4=
Date:   Wed, 11 Oct 2023 10:56:29 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mark-stuff-as-__ro_after_init-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20231011175639.E3186C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mark-stuff-as-__ro_after_init-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mark-stuff-as-__ro_after_init-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mark-stuff-as-__ro_after_init-fix.patch

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
Subject: mark-stuff-as-__ro_after_init-fix
Date: Wed Oct 11 10:46:42 AM PDT 2023

revert sysctl_nr_open_min sysctl_nr_open_max changes due to arm warning

arm allnoconfig:

fs/file_table.c:137:35: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  137 |                 .extra1         = &sysctl_nr_open_min,
      |                                   ^
fs/file_table.c:138:35: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  138 |                 .extra2         = &sysctl_nr_open_max,
      |                                   ^

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c            |    4 ++--
 include/linux/file.h |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/file.c~mark-stuff-as-__ro_after_init-fix
+++ a/fs/file.c
@@ -25,10 +25,10 @@
 #include "internal.h"
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
-const unsigned int sysctl_nr_open_min = BITS_PER_LONG;
+unsigned int sysctl_nr_open_min = BITS_PER_LONG;
 /* our min() is unusable in constant expressions ;-/ */
 #define __const_min(x, y) ((x) < (y) ? (x) : (y))
-const unsigned int sysctl_nr_open_max =
+unsigned int sysctl_nr_open_max =
 	__const_min(INT_MAX, ~(size_t)0/sizeof(void *)) & -BITS_PER_LONG;
 
 static void __free_fdtable(struct fdtable *fdt)
--- a/include/linux/file.h~mark-stuff-as-__ro_after_init-fix
+++ a/include/linux/file.h
@@ -113,7 +113,6 @@ int receive_fd_replace(int new_fd, struc
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
 
-extern const unsigned int sysctl_nr_open_min;
-extern const unsigned int sysctl_nr_open_max;
+extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
 
 #endif /* __LINUX_FILE_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

