Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7CF14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908614; cv=none; b=HBT8yUbDf0jyLN0Ru4XePUxcEHWM3VgF7wh0XNmr8oMymv32XayorDWAH4ohaKCBBJA4XV7UFJwgJI0ZzJoq0fQmLxcijNya8HYueiomPdUe0cOagLBX9VIW1s1vyKISUjvX1GlzrmC6OzXT90agyp01U3gh+e+RN7PnQiNqvuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908614; c=relaxed/simple;
	bh=jYrafEdybpfRnbyLxLqeRL097XHF0Ff3mzDOO5eXHVw=;
	h=Date:To:From:Subject:Message-Id; b=klwOD0/mRh4Ss0wKldvLRijavvIIcvMOq8FtytQj0HfuFbTEAFbxEYpvNa6/KeZv44/Gl8SSsKmmcIa7oCdi8ffE0lvY03AIHUTH83t33d9uYlijwOppz5g513zscbY3b9I2dS5Yt+peuTEyyOvNbA9BtoHKfDHC/zfUvhEhvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W7s4NEw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7s4NEw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773A8C113D0;
	Wed, 12 Nov 2025 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908614;
	bh=jYrafEdybpfRnbyLxLqeRL097XHF0Ff3mzDOO5eXHVw=;
	h=Date:To:From:Subject:From;
	b=W7s4NEw3HKl9d+D/euXlilQ/i7UgMDt87ATjT/dB270A6NDTEzsjlpc/g0gf0J1tQ
	 TLvsubfa968m5y6a8PWHaDr6422iwwBnrKBTztngt+1uYSYmsLCSupMeLoQgdWIKsj
	 +FkqbTJSXhzxybs5xgG16MBVdrq2RIF4zaV7S/Lc=
Date: Tue, 11 Nov 2025 16:50:13 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user.patch removed from -mm tree
Message-Id: <20251112005014.773A8C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: replace vmalloc + copy_from_user with vmemdup_user
has been removed from the -mm tree.  Its filename was
     nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: nilfs2: replace vmalloc + copy_from_user with vmemdup_user
Date: Fri, 31 Oct 2025 00:46:43 +0900

Replace vmalloc() followed by copy_from_user() with vmemdup_user() to
improve nilfs_ioctl_clean_segments() and nilfs_ioctl_set_suinfo().  Use
kvfree() to free the buffers created by vmemdup_user().

Use u64_to_user_ptr() instead of manually casting the pointers and
remove the obsolete 'out_free' label.

No functional changes intended.

Link: https://lkml.kernel.org/r/20251030154700.7444-1-konishi.ryusuke@gmail.com
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

--- a/fs/nilfs2/ioctl.c~nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user
+++ a/fs/nilfs2/ioctl.c
@@ -49,7 +49,7 @@ static int nilfs_ioctl_wrap_copy(struct
 						   void *, size_t, size_t))
 {
 	void *buf;
-	void __user *base = (void __user *)(unsigned long)argv->v_base;
+	void __user *base = u64_to_user_ptr(argv->v_base);
 	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
@@ -836,7 +836,6 @@ static int nilfs_ioctl_clean_segments(st
 		sizeof(struct nilfs_bdesc),
 		sizeof(__u64),
 	};
-	void __user *base;
 	void *kbufs[5];
 	struct the_nilfs *nilfs;
 	size_t len, nsegs;
@@ -863,7 +862,7 @@ static int nilfs_ioctl_clean_segments(st
 	 * use kmalloc() for its buffer because the memory used for the
 	 * segment numbers is small enough.
 	 */
-	kbufs[4] = memdup_array_user((void __user *)(unsigned long)argv[4].v_base,
+	kbufs[4] = memdup_array_user(u64_to_user_ptr(argv[4].v_base),
 				     nsegs, sizeof(__u64));
 	if (IS_ERR(kbufs[4])) {
 		ret = PTR_ERR(kbufs[4]);
@@ -883,20 +882,14 @@ static int nilfs_ioctl_clean_segments(st
 			goto out_free;
 
 		len = argv[n].v_size * argv[n].v_nmembs;
-		base = (void __user *)(unsigned long)argv[n].v_base;
 		if (len == 0) {
 			kbufs[n] = NULL;
 			continue;
 		}
 
-		kbufs[n] = vmalloc(len);
-		if (!kbufs[n]) {
-			ret = -ENOMEM;
-			goto out_free;
-		}
-		if (copy_from_user(kbufs[n], base, len)) {
-			ret = -EFAULT;
-			vfree(kbufs[n]);
+		kbufs[n] = vmemdup_user(u64_to_user_ptr(argv[n].v_base), len);
+		if (IS_ERR(kbufs[n])) {
+			ret = PTR_ERR(kbufs[n]);
 			goto out_free;
 		}
 	}
@@ -928,7 +921,7 @@ static int nilfs_ioctl_clean_segments(st
 
 out_free:
 	while (--n >= 0)
-		vfree(kbufs[n]);
+		kvfree(kbufs[n]);
 	kfree(kbufs[4]);
 out:
 	mnt_drop_write_file(filp);
@@ -1181,7 +1174,6 @@ static int nilfs_ioctl_set_suinfo(struct
 	struct nilfs_transaction_info ti;
 	struct nilfs_argv argv;
 	size_t len;
-	void __user *base;
 	void *kbuf;
 	int ret;
 
@@ -1212,18 +1204,12 @@ static int nilfs_ioctl_set_suinfo(struct
 		goto out;
 	}
 
-	base = (void __user *)(unsigned long)argv.v_base;
-	kbuf = vmalloc(len);
-	if (!kbuf) {
-		ret = -ENOMEM;
+	kbuf = vmemdup_user(u64_to_user_ptr(argv.v_base), len);
+	if (IS_ERR(kbuf)) {
+		ret = PTR_ERR(kbuf);
 		goto out;
 	}
 
-	if (copy_from_user(kbuf, base, len)) {
-		ret = -EFAULT;
-		goto out_free;
-	}
-
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_sufile_set_suinfo(nilfs->ns_sufile, kbuf, argv.v_size,
 			argv.v_nmembs);
@@ -1232,8 +1218,7 @@ static int nilfs_ioctl_set_suinfo(struct
 	else
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 
-out_free:
-	vfree(kbuf);
+	kvfree(kbuf);
 out:
 	mnt_drop_write_file(filp);
 	return ret;
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


