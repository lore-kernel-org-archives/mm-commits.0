Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4135725761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742245; cv=none; b=rKUWA9xMrD90ePEykH1fTTh9CFAJDep1vpHCxG4HzHsL2n8br0ro9i4Dv66ZzKW9T8l5KAHTdnBh+B2tHOBCDNgu3mXniH/oieV60mdi+g+TF8vVpBhw68at5F2UOFet3Gcv4hvj0E+bBhJ9gnLyuSnKZcZwM6yCAORZqVvgJMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742245; c=relaxed/simple;
	bh=pxfd1qy0kz047oajl/enkQ02mf2tFtzJN/lzP4K1lfM=;
	h=Date:To:From:Subject:Message-Id; b=WQgfzZUzSVnAYHBd61um9LqusRHsM3Lsqt5AdoAwTp4xYgZM9L5Bv+4jI5mxiZBMDcbRGZIEYLgkmsRkS+WxfQ54+GqRqszguNeh2GItDiVGEuBK0gComoibPi6QewCqSbfKTj2PTHTgND2KjbckzQT47QvXxxaCQvg4fnEJ510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1U3tY2VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1U3tY2VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CDDC4CED6;
	Mon, 13 Jan 2025 04:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742245;
	bh=pxfd1qy0kz047oajl/enkQ02mf2tFtzJN/lzP4K1lfM=;
	h=Date:To:From:Subject:From;
	b=1U3tY2VYjOKEoTBVx0+5nZ9gTykoeX1Qct/4xiyuLUcWUuGB9mlOfVGclBj2NOdSf
	 H8OcMR+ezJTOQ9gGAV8MELslU9Musu6wDVZJU/o230RGZYyvC47YmuKPgwzrvdDqfT
	 sUeDZd6vUQn5Z4LGBbagPHJ4bz0UgrB2YzpIV+Eg=
Date: Sun, 12 Jan 2025 20:24:04 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-update-the-squashfs-filesystem-documentation.patch removed from -mm tree
Message-Id: <20250113042405.18CDDC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: update the Squashfs filesystem documentation
has been removed from the -mm tree.  Its filename was
     documentation-update-the-squashfs-filesystem-documentation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


