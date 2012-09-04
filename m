From: akpm@linux-foundation.org
Subject: + proc-return-enomem-when-inode-allocation-failed.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:42:15 -0700
Message-ID: <20120904224216.09F0D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:62210 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757824Ab2IDWmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:42:19 -0400
Received: by lagw12 with SMTP id w12so373934lag.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:42:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com, rmallon@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     Subject: proc: return -ENOMEM when inode allocation failed
has been added to the -mm tree.  Its filename is
     proc-return-enomem-when-inode-allocation-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

proc-return-enomem-when-inode-allocation-failed.patch

