Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B52263892
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741717589; cv=none; b=IgvFWzGPf9vHJD3H/Xj0TiD9RhkLbs6LRb8Gy0lpj0b6y0M2+/78OHY5fOhy0Emy8rnKM6fFGa3V3z/MseR1Aew2AuOI3ui3AKXXbVroQ7SLBisMoR3IhubX+TXLiRkReuCnOvbW/vqvN6P0neZha6d5wcaXrW2+H4Mpqk0LQUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741717589; c=relaxed/simple;
	bh=wAEkTJcak+1D/sX787OFlppjNVxmysCZXMxLZf642lo=;
	h=Date:To:From:Subject:Message-Id; b=lFsb8sgHiDfJ2ErwaKVgachNamqEyimeUR0nS3cROxWfqFlXsiitBBV4XpDoTwXZwWeUA6yGHpz+d8zVcZ1ANZkmNv6inwsX/j+6ghypJ/fhaWWI5cCBKrhMuKkr18rnfhPO7EtXCx4ruy5OmOKhJRUz9RkHEPAGzpj4C7LFMjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TA4LI9Af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TA4LI9Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C58C4CEEA;
	Tue, 11 Mar 2025 18:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741717589;
	bh=wAEkTJcak+1D/sX787OFlppjNVxmysCZXMxLZf642lo=;
	h=Date:To:From:Subject:From;
	b=TA4LI9Afs6kdMWBh8iXu0uxVJj30Gy6ooz+nzQSzEDtUgvgJ1UG7RIk2uGffJdjUi
	 D22YJPe/lvYrwVhcGI5XhguNv5QijLy661EVwXGylN0tTQjKh1OxOmqxPvQolapR03
	 /inWDM4BTDoCkwkRKdVC22behtibV2p7ZWAb1vGk=
Date: Tue, 11 Mar 2025 11:26:28 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,enrico.bravi@polito.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-functions-documentation.patch added to mm-unstable branch
Message-Id: <20250311182629.33C58C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix functions documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-functions-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-functions-documentation.patch

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

mm-shmem-fix-functions-documentation.patch

