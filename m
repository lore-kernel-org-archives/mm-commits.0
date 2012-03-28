From: akpm@linux-foundation.org
Subject: [folded] brlocks-lglocks-cleanups-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 15:13:10 -0700
Message-ID: <20120328221310.355D4A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36700 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab2C1WNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 18:13:11 -0400
Received: by yenq2 with SMTP id q2so197078yen.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 15:13:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: fix dup_mnt_ns
has been removed from the -mm tree.  Its filename was
     brlocks-lglocks-cleanups-fix.patch

This patch was dropped because it was folded into brlocks-lglocks-cleanups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: vfs: fix dup_mnt_ns

Commit f8b88187 ("brlocks/lglocks: cleanups") has accidently dropped the
assignment of the new root into the mnt_fs.

This leads to NULL dereferences since ->root is assumed to be always non-NULL.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/namespace.c~brlocks-lglocks-cleanups-fix fs/namespace.c
--- a/fs/namespace.c~brlocks-lglocks-cleanups-fix
+++ a/fs/namespace.c
@@ -2250,6 +2250,7 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
+	new_ns->root = new;
 	br_write_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new->mnt_list);
 	br_write_unlock(&vfsmount_lock);
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
linux-next.patch
brlocks-lglocks-cleanups.patch

