Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560640;
	b=JrN1CM5zOa4trgawYi1/anQ2XTbfXT5BfuM3jx+ONGH9p/XZnNQ4pQGwQcQR2vqMixyz
	 QQAJGVa/aoEE1P8TE2cwB+YSjGf3TjRkoi84iieivrofQ4UP09mXtHho6d8vXkPcLetuE
	 eGGHcVmRDGOCqjvVor1/EtnAOy6HCSCy5urzBbnetiOeWf4UChS7J9qIUM5bwinrn+wCL
	 DfNw3PuKqf/PHy2F/GzHLhnAJrM3xAsyE9OhXiZcnXO7+ZA0yowH7WLBRId9orXyYw57i
	 3bkkIlN0KErMLTPIz/g3LlMpzfHv1RbYUSFMn4kdEJs9cx+ighOiigRjR64Ij4kKfWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560640;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=B68cDTzt0QZ2PjXHkT2zoovS/zHB/mAW8r4GNhlsuFs=;
	b=aopOMO3A9FVWwLFfhuX9cxDroRnVj+hiISQSxhVj9h/9h1iMM4n6XR9ntqPMuKaTsrTh
	 FyPsn7KXPnlTg4XfZhwvFarbFxYwosUDBQhMSbN1DZlFuh7/3LD7NtTlJrUiq66ycV4mH
	 pANb3AHXD1zkkESuE2fAvzTIa5ALEC44o54domPdyMcyfcJA+bc/Z+bLu7qEvBqOMRFTm
	 SGbsgxFajuGGSqPUR9xFu79Voe6QoWwUjam/VEfzwW4DETSp/eLgdNovxDEJXpMss/Jev
	 k06FC5CRvzqOL881k9eU3Xm+V+fTp/3m2cKEChiq5de/gjrsn2TidTaLEqfGXp46iAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mmDCPQ9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B88606A319;
	Wed, 21 Oct 2026 05:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mmDCPQ9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396ED1F000CA;
	Wed, 21 Oct 2026 05:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560639;
	bh=B68cDTzt0QZ2PjXHkT2zoovS/zHB/mAW8r4GNhlsuFs=;
	h=Date:To:From:Subject;
	b=mmDCPQ9j77B/TdLCWMYWslWyTHxgbJ7ZAKST0ktmtgSGKPksqQwBoqslO2UhZ81i0
	 ANGBAcMIulClEL974q65PAK5KI5ga55/y4BDwW7dFzRSYfxI8vpsNFRWwgSjLT3oA+
	 MFcijiuBFM8ud4Xu2PbgapQs+BsSvVIbfT7P64og=
Date: Tue, 20 Oct 2026 22:30:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,ghe@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch removed from -mm tree
Message-Id: <20261021053039.396ED1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: publish the filecheck owner before adding sysfs attributes
has been removed from the -mm tree.  Its filename was
     ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


