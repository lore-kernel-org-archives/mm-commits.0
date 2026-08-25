Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0EB33F8DC
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622826; cv=none; b=ILLukV5++0d93eXxQtczcJ8OH+mVqR2qFZeDHtFAaxGW7HLqOdYHaji/YepaVAPUcDseLshH3AVzJIBtFxrni8JGED1zaKg465UWyWxEDAOPzXIOB8QhLnLCZ6uYY76Hu7aSgnc8uGJxLL/6N1cPpYal5rX1Z0Hf4VXmqSvtJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622826; c=relaxed/simple;
	bh=dFd5bAe9ftZ8ZlppJozIXn9GuW4yOzZTOHU/qJDD8eg=;
	h=Date:To:From:Subject:Message-Id; b=bqQvwmD/mU6sIQvgYbm+QwBRpszB2NG3oZ9ERlLDhfo7PEtivQ9qLds/Fq9TK8HLsBUXzZfpbn9ThpxzF5EePyyWkzKJas/b8CuPz2WwJ1joC/hSmoELWbwUDBOXFsxRyir7jTsnYL2EjPSyLSO+apGFHpu8FrMLL9hYDKx0+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vA2++SrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vA2++SrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415901F000E9;
	Tue, 25 Aug 2026 01:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622823;
	bh=Zgt9ojPO4oViS+FibAsmEA8UfFmKItu+5CfaNVCWqRE=;
	h=Date:To:From:Subject;
	b=vA2++SrJlecN2ALg2sOdtoPV9abUsGlyVS2ey5O7rqMiYOrRVljW9IQ2PGBCLqX54
	 L2jO72SeLGEc7zyH3ReitUk+pYVoqujpulWyf/vGbaxoRSgTBp1xzGCdNWZ2LQb29n
	 x97uB6xGfG2DLE7aUIMwP9PznncfELqdgp2XsxNY=
Date: Mon, 24 Aug 2026 18:53:42 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,ljs@kernel.org,liam@infradead.org,brauner@kernel.org,daniel@thingy.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tmpfs-ramfs-let-memfd_create-work-on-nommu.patch removed from -mm tree
Message-Id: <20260825015343.415901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tmpfs/ramfs: let memfd_create() work on nommu
has been removed from the -mm tree.  Its filename was
     tmpfs-ramfs-let-memfd_create-work-on-nommu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


