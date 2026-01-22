Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001E392B91
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769095897; cv=none; b=et1Uv0dnoMG2pGUvSf/FpY/iNEK0ayg4re32szyEzTy1fy3oojsOzfBdxr/BRKv8mCZOXCGkkW7FZhnyxIHrmFRXVDnCMWLNQKYLoB8O5aDFDIp7P57qKeae/nHBQTBqcG10JtGWaLWZdqKqNqCzdlKyf9MN6kmj9s3VCeZAa/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769095897; c=relaxed/simple;
	bh=vX7AwfLYGjlojjVefq/KP4Apr6hRiBqE/nne8TiaF54=;
	h=Date:To:From:Subject:Message-Id; b=Eyek0U0HQWbmCrFzUvVqJCZxxvILafcMqP0+SX3L9wwg2mWZUt8588J8s+YIeHtQZQZIqkWaaUSkQCAFTAQinJ7HwL3Wn5MxK0lS6DpONMQ52yQFTDcRP0T9Sb0O4BpaMRlhJH2eC6ZoWOckVporkY1zPOTv45fFQfMTbs8Nju0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17o/FC/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17o/FC/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECB3C116C6;
	Thu, 22 Jan 2026 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769095897;
	bh=vX7AwfLYGjlojjVefq/KP4Apr6hRiBqE/nne8TiaF54=;
	h=Date:To:From:Subject:From;
	b=17o/FC/f7mUYki+RfUDhE4vVkI8SDzG8PgQOI4YOklCKcs3xZiFYgHgL2J0YvSgTz
	 FxCaiujdUMYTSJfPf05yg5tUcR4M2hM1IojNZzqbeuVHJJ+i6rR44+f2x/mU2efD1h
	 rH3NuAy0wh6sFPehyMAow/FBglLBdRBc6YNv6eXM=
Date: Thu, 22 Jan 2026 07:31:36 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,hughd@google.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-export-alloc_file.patch added to mm-hotfixes-unstable branch
Message-Id: <20260122153137.2ECB3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memfd: export alloc_file()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memfd-export-alloc_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-export-alloc_file.patch

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
Subject: memfd: export alloc_file()
Date: Thu, 22 Jan 2026 16:18:39 +0100

Patch series "mm: memfd_luo hotfixes".

This series contains a couple of fixes for memfd preservation using LUO.


This patch (of 3):

The Live Update Orchestrator's (LUO) memfd preservation works by
preserving all the folios of a memfd, re-creating an empty memfd on the
next boot, and then inserting back the preserved folios.

Currently it creates the file by directly calling shmem_file_setup(). 
This leaves out other work done by alloc_file() like setting up the file
mode, flags, or calling the security hooks.

Export alloc_file() to let memfd_luo use it.  Rename it to
memfd_alloc_file() since it is no longer private and thus needs a
subsystem prefix.

Link: https://lkml.kernel.org/r/20260122151842.4069702-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260122151842.4069702-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |    6 ++++++
 mm/memfd.c            |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/memfd.h~memfd-export-alloc_file
+++ a/include/linux/memfd.h
@@ -17,6 +17,7 @@ struct folio *memfd_alloc_folio(struct f
  * to by vm_flags_ptr.
  */
 int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
+struct file *memfd_alloc_file(const char *name, unsigned int flags);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -31,6 +32,11 @@ static inline int memfd_check_seals_mmap
 {
 	return 0;
 }
+
+static inline struct file *memfd_alloc_file(const char *name, unsigned int flags)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
--- a/mm/memfd.c~memfd-export-alloc_file
+++ a/mm/memfd.c
@@ -456,7 +456,7 @@ err_name:
 	return ERR_PTR(error);
 }
 
-static struct file *alloc_file(const char *name, unsigned int flags)
+struct file *memfd_alloc_file(const char *name, unsigned int flags)
 {
 	unsigned int *file_seals;
 	struct file *file;
@@ -520,5 +520,5 @@ SYSCALL_DEFINE2(memfd_create,
 		return PTR_ERR(name);
 
 	fd_flags = (flags & MFD_CLOEXEC) ? O_CLOEXEC : 0;
-	return FD_ADD(fd_flags, alloc_file(name, flags));
+	return FD_ADD(fd_flags, memfd_alloc_file(name, flags));
 }
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-alloc_file.patch
mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch
mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

