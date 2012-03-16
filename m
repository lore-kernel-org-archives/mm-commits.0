From: akpm@linux-foundation.org
Subject: + nilfs2-fix-null-pointer-dereference-in-nilfs_load_super_block.patch added to -mm tree
Date: Fri, 16 Mar 2012 14:28:23 -0700
Message-ID: <20120316212823.30702A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:42811 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031327Ab2CPV2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 17:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, slicky.dvl@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix NULL pointer dereference in nilfs_load_super_block()
has been added to the -mm tree.  Its filename is
     nilfs2-fix-null-pointer-dereference-in-nilfs_load_super_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

According to the report from Slicky Devil, nilfs caused kernel oops at
nilfs_load_super_block function during mount after he shrank the partition
without resizing the filesystem:

 BUG: unable to handle kernel NULL pointer dereference at 00000048
 IP: [<d0d7a08e>] nilfs_load_super_block+0x17e/0x280 [nilfs2]
 *pde = 00000000
 Oops: 0000 [#1] PREEMPT SMP
 ...
 Call Trace:
  [<d0d7a87b>] init_nilfs+0x4b/0x2e0 [nilfs2]
  [<d0d6f707>] nilfs_mount+0x447/0x5b0 [nilfs2]
  [<c01f33a4>] ? pcpu_alloc+0x714/0x810
  [<c02d2add>] ? ida_get_new_above+0x1ad/0x230
  [<c02d2add>] ? ida_get_new_above+0x1ad/0x230
  [<c0226636>] mount_fs+0x36/0x180
  [<c01f34af>] ? __alloc_percpu+0xf/0x20
  [<c023d961>] vfs_kern_mount+0x51/0xa0
  [<c023ddae>] do_kern_mount+0x3e/0xe0
  [<c023f189>] do_mount+0x169/0x700
  [<c01eeb29>] ? strndup_user+0x49/0x70
  [<c023fa9b>] sys_mount+0x6b/0xa0
  [<c04abd1f>] sysenter_do_call+0x12/0x28
 Code: 53 18 8b 43 20 89 4b 18 8b 4b 24 89 53 1c 89 43 24 89 4b 20 8b 43
 20 c7 43 2c 00 00 00 00 23 75 e8 8b 50 68 89 53 28 8b 54 b3 20 <8b> 72
 48 8b 7a 4c 8b 55 08 89 b3 84 00 00 00 89 bb 88 00 00 00
 EIP: [<d0d7a08e>] nilfs_load_super_block+0x17e/0x280 [nilfs2] SS:ESP 0068:ca9bbdcc
 CR2: 0000000000000048

This turned out due to a defect in an error path which runs if the
calculated location of the secondary super block was invalid.

This patch fixes it and eliminates the reported oops.

Reported-by: Slicky Devil <slicky.dvl@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Slicky Devil <slicky.dvl@gmail.com>
Cc: <stable@vger.kernel.org>	[2.6.30+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nilfs2/the_nilfs.c~nilfs2-fix-null-pointer-dereference-in-nilfs_load_super_block fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-null-pointer-dereference-in-nilfs_load_super_block
+++ a/fs/nilfs2/the_nilfs.c
@@ -521,6 +521,7 @@ static int nilfs_load_super_block(struct
 		brelse(sbh[1]);
 		sbh[1] = NULL;
 		sbp[1] = NULL;
+		valid[1] = 0;
 		swp = 0;
 	}
 	if (!valid[swp]) {
_
Subject: Subject: nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-clamp-ns_r_segments_percentage-to.patch
nilfs2-fix-null-pointer-dereference-in-nilfs_load_super_block.patch
linux-next.patch

