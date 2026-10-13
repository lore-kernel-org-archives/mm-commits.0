Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35ED472F65;
	Tue, 13 Oct 2026 02:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791859527; cv=none; b=ViEPupLTBmQYSg5FSHePKawVbJbEOOtRVQUGyud4YpkWyiY+teCaMTsLHy8/WI6p0C+wazo2nAh2JBr4A/55xOcV4IRAX4t54HmdoqlFDvJ3V6QicL0DKC5GHB306m2B98CtdXA0TL8KNfEWj8iFV+TGkMyEfINYPp4XRLk6Kic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791859527; c=relaxed/simple;
	bh=WeehgmvqQnP25MuVHW11H3D9E7AtzSWp/Eej5Xiqnu8=;
	h=Date:To:From:Subject:Message-Id; b=VwaLDLg6+ZAYu84tBImQy2zqzZm7+LRc7HUndeW+2YuDu+MsEfqBYv/Us1iZ+FY11f8311ARgoSpM05WjOi2etZby9KpyCLZ7WyljNvIrBZ/3sXw6p0f77k03X9H3633urz2nV0vEum4aA2Wc95vPWHsM8uvVGD+CntUps1O0dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icPC7ZY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icPC7ZY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5431F000FF;
	Tue, 13 Oct 2026 02:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791859525;
	bh=V4afKLdFxWirfZ4LA1N4o2DSZ//qZVuqWnEFtGG6cPY=;
	h=Date:To:From:Subject;
	b=icPC7ZY3LfuJJO3JvhuXwC5HrtAGuSGUI8FT+SJUXwTR2B3z+fT2iazSx2J0GHnAR
	 ftWzECcFAhe9Vi6UusZVDEDU3d5ARklvequTjLNxJaIsxv+AkftWdRDZNJiDcqvMT1
	 badoLUWljizTndjpuJx1BpffHiFuzKAy2TwbpJHc=
Date: Mon, 12 Oct 2026 19:45:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,ghe@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch added to mm-nonmm-unstable branch
Message-Id: <20261013024525.8F5431F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: publish the filecheck owner before adding sysfs attributes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: publish the filecheck owner before adding sysfs attributes
Date: Tue, 13 Oct 2026 09:58:58 +0800

ocfs2_filecheck_create_sysfs() initializes the filecheck allocation before
calling kobject_init_and_add(), but assigns entry->fs_fcheck only after
that call returns.  The default attribute group can already be visible
while registration is in progress.  A concurrent read can therefore enter
ocfs2_filecheck_attr_show() with a NULL fs_fcheck and try to lock its
fc_lock.

Assign the initialized owner before adding the kobject, so every activated
attribute has valid state.  Clear the pointer when addition fails,
preserving the existing teardown guard and error cleanup.

A controlled probe-instrumented test kernel with the original OCFS2
registration ordering produced this Oops during a concurrent sysfs read:

  KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
  RIP: 0010:kasan_byte_accessible+0x15/0x30
  Call Trace:
   <TASK>
   __kasan_check_byte+0x13/0x50
   lock_acquire+0x113/0x300
   _raw_spin_lock+0x31/0x40
   ocfs2_filecheck_attr_show+0x138/0x5f0
   ocfs2_filecheck_show+0x5d/0x90
   sysfs_kf_seq_show+0x1d3/0x360
   seq_read_iter+0x480/0x1110
   kernfs_fop_read_iter+0x419/0x5a0
   vfs_read+0x7d2/0xc20
   ksys_read+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0086-v4-1b3a3c5fd05c1fb41df9@gmail.com
Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Gang He <ghe@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/filecheck.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/filecheck.c~ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes
+++ a/fs/ocfs2/filecheck.c
@@ -179,17 +179,20 @@ int ocfs2_filecheck_create_sysfs(struct
 	fcheck->fc_size = 0;
 	fcheck->fc_done = 0;
 
+	/* Publish the initialized owner before activating its sysfs callbacks. */
+	entry->fs_fcheck = fcheck;
 	entry->fs_kobj.kset = osb->osb_dev_kset;
 	init_completion(&entry->fs_kobj_unregister);
 	ret = kobject_init_and_add(&entry->fs_kobj, &ocfs2_ktype_filecheck,
 					NULL, "filecheck");
 	if (ret) {
+		/* Mount failure still calls ocfs2_filecheck_remove_sysfs(). */
+		entry->fs_fcheck = NULL;
 		kobject_put(&entry->fs_kobj);
 		kfree(fcheck);
 		return ret;
 	}
 
-	entry->fs_fcheck = fcheck;
 	return 0;
 }
 
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch
ocfs2-initialize-status-waiters-before-publishing-them.patch
ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch

