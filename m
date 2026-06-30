Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC632D7393
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 03:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782791998; cv=none; b=FFYpWg+Pst3xBPnOD7I3iZ5gdgm00aglkHra1cw0nPI6+zBJIEykaNAhjNlLxLf/AzmYhtAXu2sV2WFA/JnlwsQqw04XEijIFp4Hpaficl3c4wDOH8j2g/qYyiThdSWgCMtspwc6apb91ABdQr5Y2tM9cShEsKxTbO/OVicPtvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782791998; c=relaxed/simple;
	bh=KEy8XjBurvHtkBYhFOeuU8oR6khktyF3fAIRNRfgj8E=;
	h=Date:To:From:Subject:Message-Id; b=gv50QFq14c88E6vOX7VVywQQxB1rx6Y0N7ZhRvl9A6AFsNb7c6hCNCh92e5Vvdi8B7T94yCKn+uXZi4+k7gmF63+M0RAx9GNHJKT4QbA6jfaBbFbyfYYSjC36yujf5/u0lAG48lrfZZG5fNBhRZJH1E57QIZ2V8STomT6YDO9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=isKt7wHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="isKt7wHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BCB1F000E9;
	Tue, 30 Jun 2026 03:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782791996;
	bh=ruI/3/rHoC+SDlNtcWi90XAA66yMtks5PItSERg5wJE=;
	h=Date:To:From:Subject;
	b=isKt7wHY5NIqDRInPQ7mJmcXMbEf3BHxTop96ny9kZzvtbLHHiPZt/oG9MG2V84mx
	 B8+EPOB5NXso0a8rFuP4u9367CugMaA66TuQdJjUVmzYCj3rlBgsYvDiq9Ab3MAA0j
	 9frr+vT9hf2lvNT26xrEKbFuG/boY+yBML/YiwXE=
Date: Mon, 29 Jun 2026 20:59:56 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,ljs@kernel.org,liam@infradead.org,brauner@kernel.org,daniel@thingy.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-ramfs-let-memfd_create-work-on-nommu.patch added to mm-nonmm-unstable branch
Message-Id: <20260630035956.C9BCB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs/ramfs: let memfd_create() work on nommu
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tmpfs-ramfs-let-memfd_create-work-on-nommu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-ramfs-let-memfd_create-work-on-nommu.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Daniel Palmer <daniel@thingy.jp>
Subject: tmpfs/ramfs: let memfd_create() work on nommu
Date: Sat, 23 May 2026 22:04:45 +0900

Currently trying to use memfd_create() on nommu returns an error with
errno set to EFBIG.  The manpage memfd_create() doesn't have EFBIG as a
possible error value.

Doing some digging this is coming from 0 getting passed as newsize to
ramfs_nommu_expand_for_mapping() and that getting into get_order() and
there "The result is undefined if the size is 0".

Whatever comes out of get_order() is then used in the following logic and
that results in the EFBIG that causes the syscall to fail and the errno in
userspace.

If newsize is 0 there is nothing to do so just return.

Roughly tested on m68k nommu by creating a process, creating an memfd,
forking another process, mmap()ing the memfd in the child, writing into
the mapping, then mmap()ing in the parent and checking that the right data
is there.

Link: https://lore.kernel.org/20260523130445.1101818-1-daniel@thingy.jp
Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ramfs/file-nommu.c~tmpfs-ramfs-let-memfd_create-work-on-nommu
+++ a/fs/ramfs/file-nommu.c
@@ -69,6 +69,9 @@ int ramfs_nommu_expand_for_mapping(struc
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 
 	/* make various checks */
+	if (!newsize)
+		return 0;
+
 	order = get_order(newsize);
 	if (unlikely(order > MAX_PAGE_ORDER))
 		return -EFBIG;
_

Patches currently in -mm which might be from daniel@thingy.jp are

tmpfs-ramfs-let-memfd_create-work-on-nommu.patch

