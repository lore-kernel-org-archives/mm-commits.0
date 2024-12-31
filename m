Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195A4A21
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605153; cv=none; b=AAVSH/bGDPKuq6NEHRm4SoOTacnWTQE+DAiguTjBQVQFkQPfkRVKi/7auVxwERw5nqU0FZQDhMiEsMoOi87lH3LUbrqTd1PfIwz5mMymuJWszDxD1xzIrpVrfuGkLhofcECxQHQJH+K9qLzNkpypzBeSc153JpM7bChmSYaxn9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605153; c=relaxed/simple;
	bh=3l2WaqQrVzg+z0LLyj3Q6VBbwt5nwZP7h6yOIcGvRtM=;
	h=Date:To:From:Subject:Message-Id; b=WLEm2lFboKYDCAv01g6mAlxTbFMNUhkVvRTkd30NC1qdlRUd5t4NUb49VrodM8JX9gWp3lErVuhVkoVNIbaFu7xu8KmR11vmF6XaTrIOq0ahXzWV6CkI+qlmr0Vrl+M67wrSTTs0bVwafw0cSblivUnwIg3CiSfrRLM1NwXvXG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnQTp5E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnQTp5E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85461C4CED0;
	Tue, 31 Dec 2024 00:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605152;
	bh=3l2WaqQrVzg+z0LLyj3Q6VBbwt5nwZP7h6yOIcGvRtM=;
	h=Date:To:From:Subject:From;
	b=RnQTp5E2QEL8sIsGSTF2ONcPYyBP0wIYBNs8e2ErCzaUll6KP+0fWqxQRpchQK21w
	 jLjjxluRbt3Wq0WwM4Np1D+Zvd40maTGybfu2jDG0t5T2Xm1wQ5ELjxShlgnf6rA5g
	 rnFD30cjep4OUXrIXSnUjLZRFB87TJVsRBGA3lj0=
Date: Mon, 30 Dec 2024 16:32:31 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-update-the-squashfs-filesystem-documentation.patch added to mm-nonmm-unstable branch
Message-Id: <20241231003232.85461C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: update the Squashfs filesystem documentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-update-the-squashfs-filesystem-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-update-the-squashfs-filesystem-documentation.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Documentation: update the Squashfs filesystem documentation
Date: Sun, 29 Dec 2024 23:37:51 +0000

This patch updates the following which are out of date.

- Zstd has been added to the compression algorithms supported.
- The filesystem mailing list (for the kernel code) is changed to
  linux-fsdevel rather than the now very little used Sourceforge
  mailing list.
- The Squashfs website has been changed to the Squashfs-tools github
  repository.
- The fact that Squashfs-tools is likely packaged by the linux
  distribution is mentioned.

Link: https://lkml.kernel.org/r/20241229233752.54481-4-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/squashfs.rst |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/Documentation/filesystems/squashfs.rst~documentation-update-the-squashfs-filesystem-documentation
+++ a/Documentation/filesystems/squashfs.rst
@@ -6,7 +6,7 @@ Squashfs 4.0 Filesystem
 
 Squashfs is a compressed read-only filesystem for Linux.
 
-It uses zlib, lz4, lzo, or xz compression to compress files, inodes and
+It uses zlib, lz4, lzo, xz or zstd compression to compress files, inodes and
 directories.  Inodes in the system are very small and all blocks are packed to
 minimise data overhead. Block sizes greater than 4K are supported up to a
 maximum of 1Mbytes (default block size 128K).
@@ -16,8 +16,8 @@ use (i.e. in cases where a .tar.gz file
 block device/memory systems (e.g. embedded systems) where low overhead is
 needed.
 
-Mailing list: squashfs-devel@lists.sourceforge.net
-Web site: www.squashfs.org
+Mailing list (kernel code): linux-fsdevel@vger.kernel.org
+Web site: github.com/plougher/squashfs-tools
 
 1. Filesystem Features
 ----------------------
@@ -58,11 +58,9 @@ inodes have different sizes).
 
 As squashfs is a read-only filesystem, the mksquashfs program must be used to
 create populated squashfs filesystems.  This and other squashfs utilities
-can be obtained from http://www.squashfs.org.  Usage instructions can be
-obtained from this site also.
-
-The squashfs-tools development tree is now located on kernel.org
-	git://git.kernel.org/pub/scm/fs/squashfs/squashfs-tools.git
+are very likely packaged by your linux distribution (called squashfs-tools).
+The source code can be obtained from github.com/plougher/squashfs-tools.
+Usage instructions can also be obtained from this site.
 
 2.1 Mount options
 -----------------
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-make-squashfs_cache_init-return-err_ptr-enomem.patch
squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch
documentation-update-the-squashfs-filesystem-documentation.patch
squashfs-update-kconfig-information.patch

