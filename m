Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A1F32A3FD;
	Thu,  9 Apr 2026 20:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775767221; cv=none; b=cT+3W13+kEtGPCwP2mXbEm0ZKKXaxb5HnskuG1EtCo5ZQ1K0Z8qgmkbKlr1n+IAA3ok6lpRKnh3mpoPTWsX+LKeRS+5s0h1GR6zt9EbyTgMBCe6MN3R4InmVagYMPhlk4Ryhqk4g6+7vrhwPijMczG7PbVl5ViUmQ4pWCVODXfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775767221; c=relaxed/simple;
	bh=V0o/FTGvKqjzGci4Qq76DzWfDylmgHq07EHcvk1ksBU=;
	h=Date:To:From:Subject:Message-Id; b=JewY5jn64v9D2spTGpDTcGSKB55T2RYwbLFtjMyZWSI/D66OEl2O23R8Ja68XQFP5o0ZcZSIHgkQcfpdIs+gJKVvZqvTJT8kcrF+KFw7EJN3Bdk+kPw4jc5R6Ttna9nk8bSZSKUs/7/kkn0gsv3Kxs3NGRUAJsC5DbwL3Htsw48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tBgUk8hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tBgUk8hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BA6C4CEF7;
	Thu,  9 Apr 2026 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775767221;
	bh=V0o/FTGvKqjzGci4Qq76DzWfDylmgHq07EHcvk1ksBU=;
	h=Date:To:From:Subject:From;
	b=tBgUk8hIc0NqmqSXM0vKKAhNKPahEEIIgVrEQzGuOAzSoSFC6fiw37j8kErosrN5G
	 wWjVvODH0UllejqQKhbPcc/lamE9y3Bomxu64DCEKgBMfSc/kkNnlh8WE+2isCnDt6
	 oWX2LgWDojqoZhKQOfzRJAkAGFNjPc4rbOjkCZfs=
Date: Thu, 09 Apr 2026 13:40:20 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,ljs@kernel.org,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,harry@kernel.org,brauner@kernel.org,komlomal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-allow-registration-of-ranges-below-mmap_min_addr.patch added to mm-unstable branch
Message-Id: <20260409204021.41BA6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: allow registration of ranges below mmap_min_addr
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-allow-registration-of-ranges-below-mmap_min_addr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-allow-registration-of-ranges-below-mmap_min_addr.patch

This patch will later appear in the mm-unstable branch at
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
From: "Denis M. Karpov" <komlomal@gmail.com>
Subject: userfaultfd: allow registration of ranges below mmap_min_addr
Date: Thu, 9 Apr 2026 13:33:45 +0300

The current implementation of validate_range() in fs/userfaultfd.c
performs a hard check against mmap_min_addr.  This is redundant because
UFFDIO_REGISTER operates on memory ranges that must already be backed by a
VMA.

Enforcing mmap_min_addr or capability checks again in userfaultfd is
unnecessary and prevents applications like binary compilers from using
UFFD for valid memory regions mapped by application.

Remove the redundant check for mmap_min_addr.

We started using UFFD instead of the classic mprotect approach in the
binary translator to track application writes.  During development, we
encountered this bug.  The translator cannot control where the translated
application chooses to map its memory and if the app requires a
low-address area, UFFD fails, whereas mprotect would work just fine.  I
believe this is a genuine logic bug rather than an improvement, and I
would appreciate including the fix in stable.

Link: https://lkml.kernel.org/r/20260409103345.15044-1-komlomal@gmail.com
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-allow-registration-of-ranges-below-mmap_min_addr
+++ a/fs/userfaultfd.c
@@ -1238,8 +1238,6 @@ static __always_inline int validate_unal
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (start < mmap_min_addr)
-		return -EINVAL;
 	if (start >= task_size)
 		return -EINVAL;
 	if (len > task_size - start)
_

Patches currently in -mm which might be from komlomal@gmail.com are

userfaultfd-allow-registration-of-ranges-below-mmap_min_addr.patch

