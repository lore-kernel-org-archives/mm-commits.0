From: akpm@linux-foundation.org
Subject: + brlocks-lglocks-cleanups-fix.patch added to -mm tree
Date: Wed, 14 Mar 2012 15:45:25 -0700
Message-ID: <20120314224525.BCE4DA0414@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56655 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab2CNWp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 18:45:28 -0400
Received: by bkcjm19 with SMTP id jm19so98864bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 15:45:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: fix dup_mnt_ns
has been added to the -mm tree.  Its filename is
     brlocks-lglocks-cleanups-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: vfs: fix dup_mnt_ns

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
brlocks-lglocks-cleanups-fix.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch

