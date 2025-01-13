Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4692325761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742246; cv=none; b=n5y7k29Mw3M6gkGOcuH7dbis44pFmbA1TlB/WSAW4uukQ7L7vq97Lnwc9GpzMp5kMsqgBGEp1lirRxRxT0ME2pIXQ4iQ5Ka44mqyFH9i1NEGiMHYxUVYQ4uIZuXJQNjDx62dRmqPTBqSQVFoZDJkfYRpQ5hX037V0Cv5X4xGJEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742246; c=relaxed/simple;
	bh=QG3cJhd4YKUGanwLaG1iwY3PO9rHGVJSfoPqpOEauII=;
	h=Date:To:From:Subject:Message-Id; b=cbBhpCGGSBNfEDHcx95WlnZmpY7i+9aCYl6/D+I/IMwhuPAm+TSZGNFYOsR5icPvewg1L+rztZ1GIE6uqG7RBsd4b/OUB6ndON08ZEM0DMEwz+Ws/C6L1aKhDoRvkKxtrsdHrn9tpQ3/eeosLuxbs4jKyNpQnd1a1AmjGvjcVz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e5Mve9TZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e5Mve9TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1A4C4CED6;
	Mon, 13 Jan 2025 04:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742246;
	bh=QG3cJhd4YKUGanwLaG1iwY3PO9rHGVJSfoPqpOEauII=;
	h=Date:To:From:Subject:From;
	b=e5Mve9TZFpnZf74WHlA4YvwcdvsUa1udit4oCliDC1xASb7Ygd3GsR1ZFjvNT2mmx
	 yrd6dHrxDY4y0vQajp6hR3wVI3kPeVY8JOX6RS3hSNiIB3vDkC8hiLfgdGtmL2z5hc
	 fMdzpgSihk+v2ecN0IJHaYjywDWL/fQSD2WM4mvQ=
Date: Sun, 12 Jan 2025 20:24:05 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-update-kconfig-information.patch removed from -mm tree
Message-Id: <20250113042406.1D1A4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: update Kconfig information
has been removed from the -mm tree.  Its filename was
     squashfs-update-kconfig-information.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


