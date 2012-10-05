From: akpm@linux-foundation.org
Subject: [merged] proc-return-enomem-when-inode-allocation-failed.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:51 -0700
Message-ID: <20121005201952.59DAA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60462 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:55 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98926lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, rmallon@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: return -ENOMEM when inode allocation failed
has been removed from the -mm tree.  Its filename was
     proc-return-enomem-when-inode-allocation-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yan <clouds.yan@gmail.com>
Subject: proc: return -ENOMEM when inode allocation failed

If proc_get_inode() returns NULL then presumably it encountered memory
exhaustion.  proc_lookup_de() should return -ENOMEM in this case, not
-EINVAL.

Signed-off-by: yan <clouds.yan@gmail.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/generic.c~proc-return-enomem-when-inode-allocation-failed fs/proc/generic.c
--- a/fs/proc/generic.c~proc-return-enomem-when-inode-allocation-failed
+++ a/fs/proc/generic.c
@@ -427,7 +427,7 @@ struct dentry *proc_lookup_de(struct pro
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
-			error = -EINVAL;
+			error = -ENOMEM;
 			inode = proc_get_inode(dir->i_sb, de);
 			goto out_unlock;
 		}
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

origin.patch
fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch

