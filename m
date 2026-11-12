Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510690;
	b=un8wjHKzdbDynttTm06Y4ja9Wm0Ejzyw9wCo/QQGCjT6UvnYDeh82MAWx08c7R11SVGp
	 A5q3uCKg2IYPdfZB7f1AbEY+y3Ut0QjPI+03o1ECJoLZR7alP3fh9zAaTc/5uPS/mO0jY
	 ba3tVeEi111soUnyN6AolnZPMbTVszviIFuNg5huOE+kyl/61/fbyrJ4As6nPQSG1U6M0
	 SjOljoPxzNx1T7MBeNGnIBJxnWAZ9GqVNO672SewiN3f7JmPT27I4UHDkGyHt2K9ZxpCA
	 w1seQyLMNPn9fVzP6FeHpoQ9VOIrgLvIvQfBRLmfH+nDOEN7tnC5Cyi/jkxBUSEnD8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510690;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=p9MvuC/P5eEQtn2XJ3+R5V9OasaT9UUb2wBJ8NwkiWU=;
	b=1V26JlUjXef4uId1+5q+Q57Hsi9xEFk7SKI86QoKcrMOygLp5NEPQsu7GSVs93WhW5hM
	 98jJemg8jd1rXEnI6YVvj1peTQs5/Tu8zZB6P6J8YjNWuhA/tJYHLsylrNm6IjRVRb7zg
	 bwGXvjFhyj9UWp7qBAK1TNnQx0zncU1uWLqZ05ZVbVoU8jLp+FtaoPZgER+uGIMz6aKHt
	 /aRJLU7oaCUk4s5j9SYdCN1I6iMFuKdVnq7r4QfnLmB5ufJFJORMOV6Tq0iEjgMYnmGYs
	 k5hHi7CpaxuF+berj5rqkNNsshgJyCV0EcRHWb1wqndWjOh+fH17W5ry31qyCFanjXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p0gjZ758;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AD8606A895
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p0gjZ758
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EC21F000C5;
	Thu, 12 Nov 2026 19:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510690;
	bh=p9MvuC/P5eEQtn2XJ3+R5V9OasaT9UUb2wBJ8NwkiWU=;
	h=Date:To:From:Subject;
	b=p0gjZ758PgIwCbCFFljwB8GMBYiOPwE+Flr53Rnk6USs2aH/r9W9hjgrJvaybU5/w
	 73GdOi9avI7IP7EcIG/ovcWnX0XLLeCInCCE8OWncc17gPcqhyPRtuoF/4e5iAvWjz
	 J3fcOTffx8SiMj5jtgVovvgAXm6pGFl5NnmC+fsc=
Date: Thu, 12 Nov 2026 11:11:29 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191130.46EC21F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
Date: Wed, 11 Nov 2026 23:44:02 +0000

The previous commits in this patch-set now sanity check index before
squashfs_read_data() is called.  However, it is always wise to take
a belts and braces approach and sanity check at the lowest level to
trap any values that could slip through.

Link: https://lore.kernel.org/20261111234402.252354-23-phillip@squashfs.org.uk
Fixes: e2780ab159ac ("Squashfs: block operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

 fs/squashfs/block.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/squashfs/block.c~squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data
+++ a/fs/squashfs/block.c
@@ -297,6 +297,15 @@ int squashfs_read_data(struct super_bloc
 	int res;
 	int offset;
 
+	/*
+	 * Reject index values greater than possible filesystem size (S64_MAX).
+	 * This also ensures the index variable doesn't overflow in the function.
+	 */
+	if (index > S64_MAX) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (length) {
 		/*
 		 * Datablock.
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-convert-squashfs_compressed_-to-inline-functions.patch
squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch
squashfs-convert-squashfs_fragment_-to-inline-functions.patch
squashfs-convert-squashfs_lookup_-to-inline-functions.patch
squashfs-convert-squashfs_id_-to-inline-functions.patch
squashfs-convert-squashfs_xattr_-to-inline-functions.patch
squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-block-count.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

