Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F8726E6FA
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 20:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770928729; cv=none; b=TYrjSkBHV5+H0EyeSY+3v9dYKWz6g9qOBokgqzvEsBXm3wU3Xts/nq16t8RQjVGvUkDh6DL+HIYPsj2XxHqkezvlhepR94fai3Xwq4FT+mXahwStrysqpU8SG7ByafmNRxdLHPO8WN+Vndqe1eIOTet4dx4cZfClKiP5SG8wU7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770928729; c=relaxed/simple;
	bh=eRAOeBp8TDgxf2YiqVvwLlTjoBuLMmIxbwOjX5mQ/Uc=;
	h=Date:To:From:Subject:Message-Id; b=Cys6rr3y5lFaCiL2eGpHTu3f9cpGoXbk2mm14G318XYCh55AQeJT6pfiwMkgVJdlcUkOnPb8ZjdevipCtH1OHrLwRVlf0UACwULmpDWcoIiJfQ0/QUIi+E7MJveTFoi6oh+9f+lDz94+0MlGsgs8WO3G5/Dr9XDdU0MhSzdA8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2cuDPfED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2cuDPfED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F69BC4CEF7;
	Thu, 12 Feb 2026 20:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770928729;
	bh=eRAOeBp8TDgxf2YiqVvwLlTjoBuLMmIxbwOjX5mQ/Uc=;
	h=Date:To:From:Subject:From;
	b=2cuDPfEDo8bcP3cd9l43d/rprLr9wrI8kP81uBf3/ipNpHQKDkT0u3/vr65ysP3Ls
	 TcvXf0yjRHDydmTNp39caLa25/j1AhXn/PuzNBSLr0Ub1iB4oqHi00b+ODr+VLNmRn
	 bCYuCLo/x7V2VncdHARIQT0duP0FkUPK7DMrEZNY=
Date: Thu, 12 Feb 2026 12:38:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,k.lourenco@criteo.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,klourencodev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fadvise-validate-offset-in-generic_fadvise.patch added to mm-new branch
Message-Id: <20260212203849.2F69BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/fadvise: validate offset in generic_fadvise
has been added to the -mm mm-new branch.  Its filename is
     mm-fadvise-validate-offset-in-generic_fadvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fadvise-validate-offset-in-generic_fadvise.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Kevin Lourenco <klourencodev@gmail.com>
Subject: mm/fadvise: validate offset in generic_fadvise
Date: Mon, 22 Dec 2025 15:18:17 +0100

When converted to (u64) for page calculations, a negative offset can
produce extremely large page indices.  This may lead to issues in certain
advice modes (excessive readahead or cache invalidation).

Reject negative offsets with -EINVAL for consistent argument validation
and to avoid silent misbehavior.

POSIX and the man page do not clearly define behavior for negative
offset/len.  FreeBSD rejects negative offsets as well, so failing with
-EINVAL is consistent with existing practice.  The man page can be updated
separately to document the Linux behavior.

Link: https://lkml.kernel.org/r/20260208135738.18992-1-klourencodev@gmail.com
Link: https://lkml.kernel.org/r/20251222141817.13335-1-klourencodev@gmail.com
Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/fadvise.c~mm-fadvise-validate-offset-in-generic_fadvise
+++ a/mm/fadvise.c
@@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, l
 		return -ESPIPE;
 
 	mapping = file->f_mapping;
-	if (!mapping || len < 0)
+	if (!mapping || len < 0 || offset < 0)
 		return -EINVAL;
 
 	bdi = inode_to_bdi(mapping->host);
_

Patches currently in -mm which might be from klourencodev@gmail.com are

mm-fadvise-validate-offset-in-generic_fadvise.patch

