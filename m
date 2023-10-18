Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F859CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJRVmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjJRVl7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:41:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C549D112
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:41:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6454BC433C8;
        Wed, 18 Oct 2023 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665317;
        bh=rdwMkeILViBTtNAaFy19eXWM5owXuy9rmSb3QlMrt44=;
        h=Date:To:From:Subject:From;
        b=w65yy3MyA6bBmXL8t796hXjZ42sZARdFZdZGFTbEfvO/y0B7gTmwk0Vd1EA5hVmNa
         IaDMCOLQcQXjL5xzmwRlzAqnlA69yhsapzvxfgm07Xpg1HNww4BM/66QYterBffqD+
         fnKWpa4/ZK9svN5HHYGxSFKfcvfLJ52sE4wiwo+0=
Date:   Wed, 18 Oct 2023 14:41:56 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mark-stuff-as-__ro_after_init-fix.patch removed from -mm tree
Message-Id: <20231018214157.6454BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mark-stuff-as-__ro_after_init-fix
has been removed from the -mm tree.  Its filename was
     mark-stuff-as-__ro_after_init-fix.patch

This patch was dropped because it was folded into mark-stuff-as-__ro_after_init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mark-stuff-as-__ro_after_init-fix
Date: Wed Oct 11 10:46:42 AM PDT 2023

revert sysctl_nr_open_min, sysctl_nr_open_max changes due to arm warning

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
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init.patch

