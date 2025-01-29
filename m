Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D63233987
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 05:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738129032; cv=none; b=KplG//Ja93c4T3N7cn5M6Bw8hwHy9WUbWcKbmAAYLpMPmuCSq4/nvXPFbCLyKHLd9gXq0f8uvFgGMALVzAE0YCeL2GVVLgRVDtYw3+hj7aX2JKmxbhYby55QQMeXGRpnt9rs3zNgG+J64ywgkZbYhOS5Tv7akgMWCCGhDJHSCSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738129032; c=relaxed/simple;
	bh=7Anfg6GId4YjCHJl5tkXIuAgLpllBf6WhbgJtYHMUu8=;
	h=Date:To:From:Subject:Message-Id; b=c+LCCz/FKttGMSBDRs/xiDY1qWOwMqoUH+kQFG6JMdXiVIC3794W1U/7j/5iz6/r7S0/bTitNJ4L9mcOIZ90hEE/Yvg89vJxhVqpl+x8QoOAWui/FLNBaqZIav4gipu+N1yWoM9YeagsN8138zFQbyBJyf1XYJgOKqEFvDeDbC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KzihJkul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KzihJkul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A10C4CED3;
	Wed, 29 Jan 2025 05:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738129031;
	bh=7Anfg6GId4YjCHJl5tkXIuAgLpllBf6WhbgJtYHMUu8=;
	h=Date:To:From:Subject:From;
	b=KzihJkulVLYxOeKufiIfbLxLRmjdbbRoOlPSsqZQva/rplSu3sYsmPtrChcNA4LHV
	 0dBh/gAQIJM4rnz0+hlrrFFb8UBk04N75x4G0RMr5S/RIpaoy/o/8cUga3TSv5P/L+
	 2zsj1ApbnSJEoVQTAv3Lc61dI7wt7d0zGFNb1hZg=
Date: Tue, 28 Jan 2025 21:37:10 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,qasdev00@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set.patch removed from -mm tree
Message-Id: <20250129053711.68A10C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix invalid PTR_ERR(NULL) call in shmem_xattr_handler_set()
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Qasim Ijaz <qasdev00@gmail.com>
Subject: mm/shmem: fix invalid PTR_ERR(NULL) call in shmem_xattr_handler_set()
Date: Tue, 28 Jan 2025 23:54:08 +0000

In shmem_xattr_handler_set() if simple_xattr_set() succeeds and the
pointer returned is not an error pointer, then old_xattr will be set to
NULL in the body of the following if statement:

    if (!IS_ERR(old_xattr))

Later on shmem_xattr_handler_set() calls:

    return PTR_ERR(old_xattr);

The PTR_ERR macro is used to extract an error code from an error pointer
and NULL is not an error pointer, PTR_ERR(NULL) simply results in 0.

To improve correctness and readability, refactor the error handling to
have an explicit default return value of 0 (success) in "ret".  If
simple_xattr_set() returns an error pointer, store its error code in
"ret".

Link: https://lkml.kernel.org/r/20250128235408.11229-1-qasdev00@gmail.com
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Cc: Hugh Dickens <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set
+++ a/mm/shmem.c
@@ -4301,6 +4301,7 @@ static int shmem_xattr_handler_set(const
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct simple_xattr *old_xattr;
 	size_t ispace = 0;
+	int ret = 0;
 
 	name = xattr_full_name(handler, name);
 	if (value && sbinfo->max_inodes) {
@@ -4316,7 +4317,9 @@ static int shmem_xattr_handler_set(const
 	}
 
 	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
-	if (!IS_ERR(old_xattr)) {
+	if (IS_ERR(old_xattr)) {
+		ret = PTR_ERR(old_xattr);
+	} else {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
 			ispace = simple_xattr_space(old_xattr->name,
@@ -4326,12 +4329,13 @@ static int shmem_xattr_handler_set(const
 		inode_set_ctime_current(inode);
 		inode_inc_iversion(inode);
 	}
+
 	if (ispace) {
 		raw_spin_lock(&sbinfo->stat_lock);
 		sbinfo->free_ispace += ispace;
 		raw_spin_unlock(&sbinfo->stat_lock);
 	}
-	return PTR_ERR(old_xattr);
+	return ret;
 }
 
 static const struct xattr_handler shmem_security_xattr_handler = {
_

Patches currently in -mm which might be from qasdev00@gmail.com are


