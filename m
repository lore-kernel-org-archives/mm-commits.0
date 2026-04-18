Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA00372EF0;
	Sat, 18 Apr 2026 07:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499157; cv=none; b=sRX0md4BEEs2hT3NkBt/X4Wm/Xa8itP3UdjppU2WmM+5VBQT7yXPfL8xa4z5CQkPQo2K/ppp8YLE9IByOpT1lV7v7YYm85yGdJbZj7Qsik00raBbClS7GudZDeKlYAgTkpF/ydDljf0Y0fhnPixSefYG+YxD6edtV02nSW/LViY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499157; c=relaxed/simple;
	bh=cUDNqbfCRXoOJijhfC+7sSfNpMkw2/5SN4nm52/XnUA=;
	h=Date:To:From:Subject:Message-Id; b=S5+2jkVhfdRxCyTHLKCTft8OobMSC3xb9YmSIyLy76JlQ+UvqIKdukPU1/Y2nNFZiA4g20JO0IS2AyVr7lZjBXZEjsAUJL+trs9JZiIyC98mnkp+osldkK9gE4nZwUNcBNpYNWzv5ypNlKd/Bkb8VndRcEWGEmgh+ONCGIYYek0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqXt1ow+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqXt1ow+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F48C19424;
	Sat, 18 Apr 2026 07:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499157;
	bh=cUDNqbfCRXoOJijhfC+7sSfNpMkw2/5SN4nm52/XnUA=;
	h=Date:To:From:Subject:From;
	b=lqXt1ow+ZwGFYO6y7LYSea97cceb+cTZggwTvRnkOH7Y2rx1etuyk4HU5GRV4Ev2X
	 jWOweroDB8jD+md98RnI8BjBSkyPUk5o5LcPl6JUyU9XPpt2vBS5N1Ic/iTDWcS00v
	 EvFXl1dleRbwNAXhewV4/s66jINinaLhfiT51g7s=
Date: Sat, 18 Apr 2026 00:59:11 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,ljs@kernel.org,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,harry@kernel.org,brauner@kernel.org,komlomal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-allow-registration-of-ranges-below-mmap_min_addr.patch removed from -mm tree
Message-Id: <20260418075916.51F48C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: allow registration of ranges below mmap_min_addr
has been removed from the -mm tree.  Its filename was
     userfaultfd-allow-registration-of-ranges-below-mmap_min_addr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260409103345.15044-1-komlomal@gmail.com
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


