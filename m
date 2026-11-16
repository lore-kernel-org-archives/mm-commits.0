Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794809294;
	b=jc/q87ZNPCEKeRKyyZsYfm2glSxvXUA52X+hnM2dowPkZoblzXimQs+98/kYDDnQbIL4
	 JUd9GlpRAULFM+0ldLX3Ttypl+G3ISRX9Pfj7AKyUZxQRLA78MwwNxS6mrE2kQG1YpdOr
	 thlDh+0jxfqiX8jfMQ1z7ZPdFqN713vdsX7+mka5QkkT1etpzgxGL/fDih/EWUcSw1us1
	 z8XNh1hiJ0LUvM5iXcgK/M/GfdTtoUj1BcHpXBvzxWyVYxo4l5V8Ae0WQVFIn+xjS2GA+
	 xTp9qHfAonWPh9W9fHliTperuM1lorCyaq1asL96jZZYCgmeuHBVnnF2U+18gtg1XqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794809294;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AvjINw0Ivt9DbFngvmJYfuFHivy+FewMspMiVasgWGk=;
	b=BtQ801xnXlwDDp5j97XsyPR+jVb8SHBmVRb3Gm/eMmG8V5sIlIT+y24/f8pVLdmkwc9W
	 IQuXgKteCnWNSwjk7XuIeaa1lJsaoWcNPoaKi9x7r5ZWcWyiOy3euMTokYmtfX0X5KyEQ
	 OzdQPHt9/tw/zMaedrd368IPKrf/e/u8r1gAvv85Yz2slx97ye4ah6NVybNW/fhiRwoYE
	 C/SBh96jX0GpZhB0H+/UMveDSrWuukZ9sG0LZCDsCaGKCOvs6Jqitw6sWTWRh9moMYlX2
	 vGc+SBXCfkPEgqmESwxn5qC/CLthZBy83Uw9DV7kwZAfLjkaMzjItRKqet+zZuu+pSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QXSiFu0I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B766D606A886
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 06:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QXSiFu0I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B8B1F000C4;
	Mon, 16 Nov 2026 06:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794809294;
	bh=AvjINw0Ivt9DbFngvmJYfuFHivy+FewMspMiVasgWGk=;
	h=Date:To:From:Subject;
	b=QXSiFu0IACRId6+cyz1nmSLl6zRg6c6yu4ES3QfTz/+MuKfibs6PDm7UWSnidAzlK
	 2+YyikrRej0woz2f/gTRLOZdjEySyeVhzYOhlCQLmaTSNtK1YliYya9HZI+YWBSs84
	 F3ZhJde+RvJct+miTpBUcJGcKlRXpSMYLOzS3lNQ=
Date: Sun, 15 Nov 2026 22:08:13 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	phillip.lougher@gmail.com,lkp@intel.com,error27@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261116060814.26B8B1F000C4@smtp.kernel.org>
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

fix smatch warnings

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>

 fs/squashfs/namei.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

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
@@ -236,8 +238,10 @@ static struct dentry *squashfs_lookup(st
 			if (size > SQUASHFS_NAME_LEN)
 				goto data_error;
 
-			if (!squashfs_dir_space(dir, length, size))
+			if (!squashfs_dir_space(dir, length, size)) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
 					&block, &offset, size);
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

