Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546EB7FD
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 00:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738109164; cv=none; b=W2YP3A/3UG8RjPWoVirz6TvaUNGde9m0nsDbEyO2D2cR1PKcw+Oao5QY9qKP1oW/Kiar3znFQ4YaOZMKYSC/i/oCP9cb0u/FZiFdKjEa9q5vKlZ4zOesWkpyBJLM0RcIrpKa4tlqISzSQjx6qZE1sEsdk4aqBCQBPm3sVB1zZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738109164; c=relaxed/simple;
	bh=RIJERIVt7CeH11GgPAF0V4ii+YiVy4NIBVlTAoQgApk=;
	h=Date:To:From:Subject:Message-Id; b=VxhJhuGow74SonDOcVbh6CtxaqCkokc5ImXVDI3ycxvuhnu6KwwAQtGMbyAaXypYNaKGEjA54Wk4SSt88UbuWTQ3N3CDLtGw/q6QC/Wbg9vCD87+mNo3m1WMfqiHLH98QocugEA+MahlpOguL51WV+ZUaFFq4gYCQWHyHg3UMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzvzDQl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzvzDQl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA720C4CED3;
	Wed, 29 Jan 2025 00:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738109163;
	bh=RIJERIVt7CeH11GgPAF0V4ii+YiVy4NIBVlTAoQgApk=;
	h=Date:To:From:Subject:From;
	b=MzvzDQl2jpcmOnW6a2/8FJrMvLPaaNEUIlMi/5GB3zXiDwLZl8OLIXZHqEyRb8foJ
	 QUvVg3a0VL+DElItAO2AEWyd2MmIcWePHpxtcsgto5m+TjlfxBI0xKDbdg+E8S+LMg
	 jdhIp5tJHT3o9YEYdK4uoyZQwaomUDrGToi8U8PI=
Date: Tue, 28 Jan 2025 16:06:02 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,qasdev00@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set.patch added to mm-unstable branch
Message-Id: <20250129000603.AA720C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix invalid PTR_ERR(NULL) call in shmem_xattr_handler_set()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set.patch

This patch will later appear in the mm-unstable branch at
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

mm-shmem-fix-invalid-ptr_errnull-call-in-shmem_xattr_handler_set.patch

