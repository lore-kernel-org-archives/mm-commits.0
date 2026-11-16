Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808698;
	b=XsHEvpDyk0NZc2C6n1OXojv/EcQcs2NbcoKSxAVW5Dsw3qqmNcCePeOkyIHmxXdZy2Uu
	 jSLwA8AWxJ0rlu2in7+dUQu8+sb5neEZIitMycL7YG6nv4NnNSAvPb4fetvzHS3njFi1m
	 ffixtGviq/dFJbM1lh/ARz1GT1ajzKWjJXclQeQiXWE6ZAnSNCon+cLgzF+5ZhJPOKoxv
	 CCOmIwpoAIOo8m77xIF0/Xj67WqRpX7Ov9aEbI4uMesfYyp2qYZXleoT59cZDpbv62bh5
	 RTIaEFkpLx9Ll4MZhWt6DeJgaIPlQYnxcopdUymCX63N7Cc0N96/TOOvUE/PgDkgErQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808698;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cXv66eldltu4DcwoxfgbbKCa3pnjx7bR3G5hCEdCFag=;
	b=2/Eu/cNq9tkjv9pai4iYpsGQ2DTogxfcdmvFjjimGMdWZ7Timm6R9GYdZSbJUuxBnE0O
	 mKdZk5D37EG/ysq+zZmODVpWe2E8L6446W/GbYfKR2cDQAT29viZ/am8P50ptLfL7Sh62
	 XESZFqSGTpwLGM6SXJ9+D/aWnDg8tJYDRb3ENg9aStvqKC5npid266AOPmm71bFfDWNws
	 xtJ6up/O06aU0iz8iZJUffVSbI5v84jS1mH7wZQjKc2Ro106g5R7Um3TTG2MZbXc1DYhh
	 QPVLF74onZDVW4sdAHIIKXsCB+usJjvxXepSqBL3Lja17/tkHqJ6iGZdCMg+H9BCl0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=icaxRM5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E680A606A31C
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=icaxRM5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2511F000C4;
	Mon, 16 Nov 2026 05:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794808697;
	bh=cXv66eldltu4DcwoxfgbbKCa3pnjx7bR3G5hCEdCFag=;
	h=Date:To:From:Subject;
	b=icaxRM5pVybJqs6LQph97Vwawb/4mYGAtCjgkmQWpbTajzv7RRHwYpiwQtuOxLI1t
	 ojAtekXEyCuWqtmD0+3zgQzCu8YbKzHyDnirPbSKeyPfHQRUWHlfv9XXkHU9V03lfw
	 q7bEMsC9dcm7VQf6+QA4ICk++OeMtcAHbu6PBqWY=
Date: Sun, 15 Nov 2026 21:58:17 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	phillip.lougher@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261116055817.9B2511F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
Date: Sun Nov 15 09:54:43 PM PST 2026

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>

 fs/squashfs/namei.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
+++ a/fs/squashfs/namei.c
@@ -221,8 +221,10 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
-			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+			if (!squashfs_dir_space(dir, length, sizeof(*dire))) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

