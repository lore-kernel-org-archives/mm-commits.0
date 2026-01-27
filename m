Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87E229A30E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482666; cv=none; b=szxZGlzbWBYRf1qK9GcuXd0X8pgrbe3CmgYH0lDiEU226JABa23KU6Km4f5OrvIWqMkHqw1n58bfh4HfXILK3/MTXjhiBmkLPw41KJZG7CdUWuScyEAzQl859DCXcng7RX/ihrFk1pt7lmeZG6c+Qj77embBc0wVkeV+6M1KK/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482666; c=relaxed/simple;
	bh=2RIOWbknYjNe9axuGA9mdvUXdWNeoEl8NGPuzJ8Wp+8=;
	h=Date:To:From:Subject:Message-Id; b=Y8fODTEEeS+U5IeKDBWZoH2AZBdDDW8ASMWPYRYPbU4EDhbsFIGwgKZEEySYNzn7fuc0lhW5ab+SOaqOhquw3Jy9FcrGRENTjcy6IYKGgUxolYZaDOwHc1lTq9/tIZzuJPQImHfzEGVUtDNSdAEU4+8MwQfGO+lVmvYZ1ftP0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aBEPrXM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aBEPrXM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0EDC116C6;
	Tue, 27 Jan 2026 02:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482665;
	bh=2RIOWbknYjNe9axuGA9mdvUXdWNeoEl8NGPuzJ8Wp+8=;
	h=Date:To:From:Subject:From;
	b=aBEPrXM1KuI8vhrqWQuwQgf1G9Dl5cfi+T/S9QH7HLcnNPA6NT0EFG8WJEPL+uv/i
	 iHtkJ06JCPFC2spq0/KmAPK8uWcbDSRPa5qLsNyXZnoVI/wAdH+0Jn4gF0vSpvOavZ
	 1x6cD+0d0Uhk+qA/O9Vhc3/giyU++J5+XE68K2W0=
Date: Mon, 26 Jan 2026 18:57:45 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,hughd@google.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch removed from -mm tree
Message-Id: <20260127025745.8A0EDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
Date: Thu, 22 Jan 2026 16:18:40 +0100

When restoring a memfd, the file is created using shmem_file_setup(). 
While memfd creation also calls this function to get the file, it also
does other things:

  1. The O_LARGEFILE flag is set on the file. If this is not done,
  writes on the memfd exceeding 2 GiB fail.

  2. FMODE_LSEEK, FMODE_PREAD, and FMODE_PWRITE are set on the file.
  This makes sure the file is seekable and can be used with pread() and
  pwrite().

  3. Initializes the security field for the inode and makes sure that
  inode creation is permitted by the security module.

Currently, none of those things are done.  This means writes above 2 GiB
fail, pread(), and pwrite() fail, and so on.  lseek() happens to work
because file_init_path() sets it because shmem defines fop->llseek.

Fix this by using memfd_alloc_file() to get the file to make sure the
initialization sequence for normal and preserved memfd is the same.

Link: https://lkml.kernel.org/r/20260122151842.4069702-3-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup
+++ a/mm/memfd_luo.c
@@ -78,6 +78,7 @@
 #include <linux/liveupdate.h>
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
+#include <linux/memfd.h>
 #include "internal.h"
 
 static int memfd_luo_preserve_folios(struct file *file,
@@ -443,8 +444,7 @@ static int memfd_luo_retrieve(struct liv
 	if (!ser)
 		return -EINVAL;
 
-	file = shmem_file_setup("", 0, VM_NORESERVE);
-
+	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
 		return PTR_ERR(file);
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch
liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

