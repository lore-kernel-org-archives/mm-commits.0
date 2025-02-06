Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28781FDA8C
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827752; cv=none; b=eb2P41PqvSl7UQFTPdT5KvP4WSjdWWBIGfINwrgAH/V9H6DUoJw0AB/mq3pdDcLO0M4fWGYXapAuklW2harAY+ipPvOdA71e/OERgklQbYxF5rDfAw2QsV/X1HwtQqs/eJc4aR2FGnqlFwyfwwRWN/zKjcv4FiZs/Fu5lf/nsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827752; c=relaxed/simple;
	bh=wMertulFtF23DAzjvu/MkDbjF3MWZuuF63tZWayQR2M=;
	h=Date:To:From:Subject:Message-Id; b=VvzNPRKSy6uUjV5PDIVVHFgE1EbHlXm56uUCS/4otPY+PC2yZAaRSWnyWT7UE4UHLRjuJby+E6bUSiEG1oEODgSLLdTyoZpZZqmsxFDqlX6ag3VzrnlXJ7MyVRL6DdFHa7OmIuFe75OfJ34SFX9Lawfs1lGjbTOJV/v32wxJorc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ymQnKe6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ymQnKe6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EFAC4CEDD;
	Thu,  6 Feb 2025 07:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827751;
	bh=wMertulFtF23DAzjvu/MkDbjF3MWZuuF63tZWayQR2M=;
	h=Date:To:From:Subject:From;
	b=ymQnKe6uZdwCEpGniqZ5ygTXOsVgEl3UFO/MnV9/Lvj6pclGYIMRefnblTcqxP46U
	 fN44Xgxap8DZeUT3Uve7BL388n8ONk54qIk44RXRy04HFI3wDO6ff63jAlNxuFgVwp
	 lHONzLR0/YYoLt+HOHWteM9h9k5cQES+k+Zu5VWI=
Date: Wed, 05 Feb 2025 23:42:30 -0800
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-fix-spelling-and-grammatical-issues.patch added to mm-unstable branch
Message-Id: <20250206074231.86EFAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: fix spelling and grammatical issues
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-fix-spelling-and-grammatical-issues.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-fix-spelling-and-grammatical-issues.patch

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
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/memfd: fix spelling and grammatical issues
Date: Thu, 6 Feb 2025 14:09:58 +0800

The comment "If a private mapping then writability is irrelevant" contains
a typo.  It should be "If a private mapping then writability is
irrelevant".  The comment "SEAL_EXEC implys SEAL_WRITE, making W^X from
the start." contains a typo.  It should be "SEAL_EXEC implies SEAL_WRITE,
making W^X from the start."

Link: https://lkml.kernel.org/r/20250206060958.98010-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~mm-memfd-fix-spelling-and-grammatical-issues
+++ a/mm/memfd.c
@@ -259,7 +259,7 @@ static int memfd_add_seals(struct file *
 	}
 
 	/*
-	 * SEAL_EXEC implys SEAL_WRITE, making W^X from the start.
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
 	 */
 	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
 		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
@@ -337,7 +337,7 @@ static int check_write_seal(unsigned lon
 	unsigned long vm_flags = *vm_flags_ptr;
 	unsigned long mask = vm_flags & (VM_SHARED | VM_WRITE);
 
-	/* If a private matting then writability is irrelevant. */
+	/* If a private mapping then writability is irrelevant. */
 	if (!(mask & VM_SHARED))
 		return 0;
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memfd-fix-spelling-and-grammatical-issues.patch

