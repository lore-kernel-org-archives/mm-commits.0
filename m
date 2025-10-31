Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4902C11E6
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 02:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761878047; cv=none; b=loBR6Z2FKm8itQ4LwDTrXwUYDeEoEiC8pmkhs6uTthmGnHwcgLxubWaS8YFF/Sjh3fwfjvYpnOHqf+htYz+zDjCSYdpOAYSasVSkpKMURxN/h2ijRbsilFCzzN0MfiLRaaBIh5h+1lMICxud4tVw7viHate3XmbGLifXQp6uruY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761878047; c=relaxed/simple;
	bh=+XA2rhVltKCrjEbjSTYqjHIHUqBL5qn8+6p6L6M3068=;
	h=Date:To:From:Subject:Message-Id; b=kAsKzLtKJb1vrlq8BRqLoCTuL9BRnvOBzj2oTjyeQboiG6ekQ8wTpcUPpdvwaM4tcU1uJAWmFW52PcDC95rPo+q3mNT1alEAgsgQ7F3kQm34NLl7a1zwDiCp4cvxq9maymWL+KXQtB9xNLNA4ZXVtuHhIZVA1iUiqKfd68uSTy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5Tk066p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5Tk066p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7889C4CEF1;
	Fri, 31 Oct 2025 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761878046;
	bh=+XA2rhVltKCrjEbjSTYqjHIHUqBL5qn8+6p6L6M3068=;
	h=Date:To:From:Subject:From;
	b=u5Tk066psvMG8plg/RD8TrmhbNku8sXxkHQOrev83jvPRUuvpGCsHzDbxkpP7ki51
	 YwExmrIHiaOVxidBWMbkX2t5/p40DCLOtubGKvOgWtkIcj/I31P9JhQbxS3H0p+bAO
	 YHR7XwsjqWnlAdLdBB7EDm9tTYzONLoMo+9gKKvg=
Date: Thu, 30 Oct 2025 19:34:06 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user.patch added to mm-nonmm-unstable branch
Message-Id: <20251031023406.D7889C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: replace vmalloc + copy_from_user with vmemdup_user
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user.patch

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

nilfs2-replace-vmalloc-copy_from_user-with-vmemdup_user.patch

