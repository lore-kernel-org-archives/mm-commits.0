Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA994A21
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605154; cv=none; b=ijVNns3geQwOwat1eVvJ4jeFV0zzzOyO7nrn5Q16u70arpe08r4bdnjxYRZYco5RIcacM8FNj/9IWVWqEtmwABB61CLEbKPwT1psitabsSWtSqMnCjlD/vqyb+c7PRZtY+qyZY2GhJVUMvR2gAnU1ipM2FN7AiBWwzkAhV9jND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605154; c=relaxed/simple;
	bh=qFlTH/pYsnAYjvILIcDrN7BproVAe+vKvfWb1TLQlvw=;
	h=Date:To:From:Subject:Message-Id; b=FhjzfXS4NvmgW4DzH7KTBkpBnL7yRcaOhvlG2l9ApvECr6IJu0e6gmGpkWjFxNJ/F62i1lom6icbbdJOmlgAOw6xxmDwgSx04N5wJD+JIp40jqb2EhrWavOQuobd/ho5F3f2lxQYR4uD+nwNn6kY/DSA5y78IMybl8QPsqy9AL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jcp3okeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jcp3okeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA8DC4CED0;
	Tue, 31 Dec 2024 00:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605154;
	bh=qFlTH/pYsnAYjvILIcDrN7BproVAe+vKvfWb1TLQlvw=;
	h=Date:To:From:Subject:From;
	b=jcp3okeOsmFh7JL5gbwvZ+NkdJLymyPPXneBrDs1jFlLy4aZueBZoWf2pPh76KrCJ
	 C3cz/bf8KB9SUlFElnrrZuMNmB3c+fsJP27N1RjuuWWAnW6Io/k832WDnuq2a/39Cg
	 Q2e78CrQ7Fvs7Df8Q2Og/GhL7z2HQBVZmGmgEerQ=
Date: Mon, 30 Dec 2024 16:32:33 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-update-kconfig-information.patch added to mm-nonmm-unstable branch
Message-Id: <20241231003234.4BA8DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: update Kconfig information
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-update-kconfig-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-update-kconfig-information.patch

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
Subject: squashfs: update Kconfig information
Date: Sun, 29 Dec 2024 23:37:52 +0000

Update the compression algorithms supported, and the Squashfs website
location.

Link: https://lkml.kernel.org/r/20241229233752.54481-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/Kconfig~squashfs-update-kconfig-information
+++ a/fs/squashfs/Kconfig
@@ -5,8 +5,8 @@ config SQUASHFS
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
-	  filesystem for Linux.  It uses zlib, lzo or xz compression to
-	  compress both files, inodes and directories.  Inodes in the system
+	  filesystem for Linux.  It uses zlib, lz4, lzo, xz or zstd compression
+	  to compress both files, inodes and directories.  Inodes in the system
 	  are very small and all blocks are packed to minimise data overhead.
 	  Block sizes greater than 4K are supported up to a maximum of 1 Mbytes
 	  (default block size 128K).  SquashFS 4.0 supports 64 bit filesystems
@@ -16,7 +16,7 @@ config SQUASHFS
 	  Squashfs is intended for general read-only filesystem use, for
 	  archival use (i.e. in cases where a .tar.gz file may be used), and in
 	  embedded systems where low overhead is needed.  Further information
-	  and tools are available from http://squashfs.sourceforge.net.
+	  and tools are available from github.com/plougher/squashfs-tools.
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-make-squashfs_cache_init-return-err_ptr-enomem.patch
squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch
documentation-update-the-squashfs-filesystem-documentation.patch
squashfs-update-kconfig-information.patch

