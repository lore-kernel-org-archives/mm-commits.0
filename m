Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F53BC7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjFJApo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjFJAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350BB3AA9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF6C1651CE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F8FC433D2;
        Sat, 10 Jun 2023 00:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357928;
        bh=TG5PHrPYBtW4KABXnUZ7xRIXTtxCwslzdqbC3ayPmrM=;
        h=Date:To:From:Subject:From;
        b=dJ+v75Q/Kd1I8FdBkVc+/OgGkxdU9ea7JwZfkthL5bcm1FHreF9t+sDYtI9uFufF0
         6Yr42OFkX2NyE/gSeVwbjvkZ4Cm3aQj7LPpdVyD0KKgQoItuzZ95raFelP5hTzy5p5
         Z/gGP41ZAsJbW1TkEF85mbkxdTMs1dCtjdsbSZu4=
Date:   Fri, 09 Jun 2023 17:45:27 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, rppt@kernel.org, peterz@infradead.org,
        paulmck@kernel.org, ndesaulniers@google.com, masahiroy@kernel.org,
        angus.chen@jaguarmicro.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-add-bdev-fs-printk-if-mount_block_root-failed.patch removed from -mm tree
Message-Id: <20230610004528.22F8FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init: add bdev fs printk if mount_block_root failed
has been removed from the -mm tree.  Its filename was
     init-add-bdev-fs-printk-if-mount_block_root-failed.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Angus Chen <angus.chen@jaguarmicro.com>
Subject: init: add bdev fs printk if mount_block_root failed
Date: Thu, 18 May 2023 11:53:21 +0800

Booting with the QEMU command line:
"qemu-system-x86_64 -append root=/dev/vda rootfstype=ext4 ..."
will panic if ext4 is not builtin and a request to load the ext4 module
fails.

[    1.729006] VFS: Cannot open root device "vda" or unknown-block(253,0): error -19
[    1.730603] Please append a correct "root=" boot option; here are the available partitions:
[    1.732323] fd00          256000 vda
[    1.732329]  driver: virtio_blk
[    1.734194] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(253,0)
[    1.734771] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.4.0-rc2+ #53
[    1.735194] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[    1.735772] Call Trace:
[    1.735950]  <TASK>
[    1.736113]  dump_stack_lvl+0x32/0x50
[    1.736367]  panic+0x108/0x310
[    1.736570]  mount_block_root+0x161/0x310
[    1.736849]  ? rdinit_setup+0x40/0x40
[    1.737088]  prepare_namespace+0x10c/0x180
[    1.737393]  kernel_init_freeable+0x354/0x450
[    1.737707]  ? rest_init+0xd0/0xd0
[    1.737945]  kernel_init+0x16/0x130
[    1.738196]  ret_from_fork+0x1f/0x30

As a hint, print all the bdev fstypes which are available.

[akpm@linux-foundation.org: fix spelling in printk message]
Link: https://lkml.kernel.org/r/20230518035321.1672-1-angus.chen@jaguarmicro.com
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/init/do_mounts.c~init-add-bdev-fs-printk-if-mount_block_root-failed
+++ a/init/do_mounts.c
@@ -427,8 +427,19 @@ retry:
 		printk("VFS: Cannot open root device \"%s\" or %s: error %d\n",
 				root_device_name, b, err);
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
-
 		printk_all_partitions();
+
+		if (root_fs_names)
+			num_fs = list_bdev_fs_names(fs_names, PAGE_SIZE);
+		if (!num_fs)
+			pr_err("Can't find any bdev filesystem to be used for mount!\n");
+		else {
+			pr_err("List of all bdev filesystems:\n");
+			for (i = 0, p = fs_names; i < num_fs; i++, p += strlen(p)+1)
+				pr_err(" %s", p);
+			pr_err("\n");
+		}
+
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 	if (!(flags & SB_RDONLY)) {
_

Patches currently in -mm which might be from angus.chen@jaguarmicro.com are


