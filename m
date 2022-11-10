Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B70C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 01:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiKJBRY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKJBRX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 20:17:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A382529C
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 17:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1C80B81F31
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 01:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EA1C433D6;
        Thu, 10 Nov 2022 01:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668043039;
        bh=rrmLSD1CznvpqjAYOO7eoD2OG4Qn1k7BzctmXYXE3Ek=;
        h=Date:To:From:Subject:From;
        b=P8f6rS/FFpmJ3RgHM81hWdOUH3/iD3lCTDneDSorIcVUnN4yk3osxqOziGNo7yUyI
         i+FPjq6Kwy1p8sg0wsjOZLIbzzJlJInvDX5EQL4EqWnTfkOzbwr0OeYV1GGn83/xxo
         l8CeoADk699FzB18InQKed0OqwKhT7bwTli9dkCA=
Date:   Wed, 09 Nov 2022 17:17:18 -0800
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        lizetao1@huawei.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch added to mm-nonmm-unstable branch
Message-Id: <20221110011719.55EA1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix memory leak in ocfs2_mount_volume()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

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
From: Li Zetao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix memory leak in ocfs2_mount_volume()
Date: Wed, 9 Nov 2022 15:46:27 +0800

There is a memory leak reported by kmemleak:

  unreferenced object 0xffff88810cc65e60 (size 32):
    comm "mount.ocfs2", pid 23753, jiffies 4302528942 (age 34735.105s)
    hex dump (first 32 bytes):
      10 00 00 00 00 00 00 00 00 01 01 01 01 01 01 01  ................
      01 01 01 01 01 01 01 01 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff8170f73d>] __kmalloc+0x4d/0x150
      [<ffffffffa0ac3f51>] ocfs2_compute_replay_slots+0x121/0x330 [ocfs2]
      [<ffffffffa0b65165>] ocfs2_check_volume+0x485/0x900 [ocfs2]
      [<ffffffffa0b68129>] ocfs2_mount_volume.isra.0+0x1e9/0x650 [ocfs2]
      [<ffffffffa0b7160b>] ocfs2_fill_super+0xe0b/0x1740 [ocfs2]
      [<ffffffff818e1fe2>] mount_bdev+0x312/0x400
      [<ffffffff819a086d>] legacy_get_tree+0xed/0x1d0
      [<ffffffff818de82d>] vfs_get_tree+0x7d/0x230
      [<ffffffff81957f92>] path_mount+0xd62/0x1760
      [<ffffffff81958a5a>] do_mount+0xca/0xe0
      [<ffffffff81958d3c>] __x64_sys_mount+0x12c/0x1a0
      [<ffffffff82f26f15>] do_syscall_64+0x35/0x80
      [<ffffffff8300006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

This call stack is related to two problems.  Firstly, the ocfs2 super uses
"replay_map" to trace online/offline slots, in order to recover offline
slots during recovery and mount.  But when ocfs2_truncate_log_init()
returns an error in ocfs2_mount_volume(), the memory of "replay_map" will
not be freed in error handling path.  Secondly, the memory of "replay_map"
will not be freed if d_make_root() returns an error in ocfs2_fill_super().
But the memory of "replay_map" will be freed normally when completing
recovery and mount in ocfs2_complete_mount_recovery().

Fix the first problem by adding error handling path to free "replay_map"
when ocfs2_truncate_log_init() fails.  And fix the second problem by
calling ocfs2_free_replay_slots(osb) in the error handling path
"out_dismount".  In addition, since ocfs2_free_replay_slots() is static,
it is necessary to remove its static attribute and declare it in header
file.

Link: https://lkml.kernel.org/r/20221109074627.2303950-1-lizetao1@huawei.com
Fixes: 9140db04ef18 ("ocfs2: recover orphans in offline slots during recovery and mount")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 +-
 fs/ocfs2/journal.h |    1 +
 fs/ocfs2/super.c   |    5 ++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-memory-leak-in-ocfs2_mount_volume
+++ a/fs/ocfs2/journal.c
@@ -157,7 +157,7 @@ static void ocfs2_queue_replay_slots(str
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
--- a/fs/ocfs2/journal.h~ocfs2-fix-memory-leak-in-ocfs2_mount_volume
+++ a/fs/ocfs2/journal.h
@@ -150,6 +150,7 @@ int ocfs2_recovery_init(struct ocfs2_sup
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
+void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
--- a/fs/ocfs2/super.c~ocfs2-fix-memory-leak-in-ocfs2_mount_volume
+++ a/fs/ocfs2/super.c
@@ -1159,6 +1159,7 @@ static int ocfs2_fill_super(struct super
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
+	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1822,12 +1823,14 @@ static int ocfs2_mount_volume(struct sup
 	status = ocfs2_truncate_log_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_system_inodes;
+		goto out_check_volume;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
+out_check_volume:
+	ocfs2_free_replay_slots(osb);
 out_system_inodes:
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

