Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9F71D7E4F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274639; cv=none; b=szk3K0VrkziJvJ8z1lfUSvHxPjOMPho1/OfROAxhVWj7gjb3ERHpzFrYwOKbORw8A4dvCyr3TJAMJQ4SRgo/VBW2ommxeKlPz8pD7yHLORu8W3xn4bt2NDBCMX+W0vOvJ2EZNsAe9uubSbtb9mqDKFHPbeoXMGIrHm03VaaI8gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274639; c=relaxed/simple;
	bh=iH2DHuKyCj+uPA+s9H6HFPHeKlnOK93WQF2z26Oo6AE=;
	h=Date:To:From:Subject:Message-Id; b=r4vw//mkl+Z1s/iHRIgxKrNJ9l97pHF+nnmCQYAPbu38OFBsKcSK4szpgXzQX7eoHrWy5sGLbWtBNIDO0aN5iuT1MCp6ZdY1MpAHqgNfAlA9n44w3Cz3VCiT9akxnfy+vaxGQkx4ZLhQJFLFhnwVOqow64U0PvvdpJQP/OPjljU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TgeJ7nW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TgeJ7nW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1134FC4CEDD;
	Tue, 18 Mar 2025 05:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274639;
	bh=iH2DHuKyCj+uPA+s9H6HFPHeKlnOK93WQF2z26Oo6AE=;
	h=Date:To:From:Subject:From;
	b=TgeJ7nW4oFnMKohJIjjvHIZp+899XB+HfSu6Nt+Uv+Pyd27/KuYDn4cI/l3s2FYmX
	 tR9dJnUNXmpmtxXR1RQsQYboj/KkziZa2+N/INCfK2xL0bXmVtbe0nEs5Y8a75kJW+
	 owsoJ1Mz9fawiWZ8+CRGULmRdERLflp/97/Femiw=
Date: Mon, 17 Mar 2025 22:10:38 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,enrico.bravi@polito.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-functions-documentation.patch removed from -mm tree
Message-Id: <20250318051039.1134FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix functions documentation
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-functions-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enrico Bravi <enrico.bravi@polito.it>
Subject: mm/shmem: fix functions documentation
Date: Mon, 10 Mar 2025 12:25:37 +0100

Add missing parenthesis in @name parameter description.

Link: https://lkml.kernel.org/r/20250310112535.84754-1-enrico.bravi@polito.it
Signed-off-by: Enrico Bravi <enrico.bravi@polito.it>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-functions-documentation
+++ a/mm/shmem.c
@@ -5841,7 +5841,7 @@ static struct file *__shmem_file_setup(s
  * 	underlying inode.  So users of this interface must do LSM checks at a
  *	higher layer.  The users are the big_key and shm implementations.  LSM
  *	checks are provided at the key or shm level rather than the inode.
- * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
@@ -5853,7 +5853,7 @@ EXPORT_SYMBOL_GPL(shmem_kernel_file_setu
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
- * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
@@ -5866,7 +5866,7 @@ EXPORT_SYMBOL_GPL(shmem_file_setup);
 /**
  * shmem_file_setup_with_mnt - get an unlinked file living in tmpfs
  * @mnt: the tmpfs mount where the file will be created
- * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
_

Patches currently in -mm which might be from enrico.bravi@polito.it are


