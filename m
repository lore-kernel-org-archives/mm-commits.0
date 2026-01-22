Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2369C3933FA
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769095900; cv=none; b=PPdEDhZnWsCGjAILSRDhx8oFZgw4sQ40eP76SoK7oZWvE1UBqyiDOzZSR4ejq7jFNtVWYXp2rGjtmOIywxH0LLbdWMO75/K40rj3EoUQkmY6r01AeNBag2SS30mOc+C6Jps6GMa9lM/SvAUxGKAjmCB6xnE2FdrAxOZnI3ulTpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769095900; c=relaxed/simple;
	bh=dOohnFkK6wE4YDyPd3VYWiR8e8r6luoMbRkj7fe4Zr4=;
	h=Date:To:From:Subject:Message-Id; b=sv2OzOkvrSWPEsP/NgZBPyKqR2+g0ecUyMEYz4ZAWL0WJZgmlwP+hpQQ+XiB34mVflhZdawpz11v0uUeDljX/wcxdw2gWYsXcAqN1sb0FBbPUiDhrGEf8cTYimGWYmdZsap0hMpAw1forrBvSOt3QFxBZLBaGHWhW6b1OtzzyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WnNMX2fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WnNMX2fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1A1C116D0;
	Thu, 22 Jan 2026 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769095899;
	bh=dOohnFkK6wE4YDyPd3VYWiR8e8r6luoMbRkj7fe4Zr4=;
	h=Date:To:From:Subject:From;
	b=WnNMX2fM1wpMcLDbunDHFqejsmwkg1VRw185DIY8avtCYlUNczLqMPIAaCqq6uBLv
	 5VIJE2HOq0t11Py4IJeGJvjgrQhFiz6Vickuam/3vAVrLzBi9SjI+h67RbdKDxA4x8
	 lrlP7znaCftLZeiFB9PYs96tcPLO7mwBWQJDZ2cQ=
Date: Thu, 22 Jan 2026 07:31:39 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,hughd@google.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch added to mm-hotfixes-unstable branch
Message-Id: <20260122153139.AE1A1C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
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

memfd-export-alloc_file.patch
mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch
mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

