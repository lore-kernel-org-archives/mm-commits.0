Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0569813B7AE
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548902; cv=none; b=IIrWjBSeAGMJiStJrIJpCxTzU5IKTMAC2J46KW/ZdwJCzsj6+tMO7sqvvf484H9ce0E7COazMDj+T2TnpFthImehbCWsBfgI9v8Yg3YfymKkIDUOGgsH4LwuEW+8UZc7U5qeLK7G+HA2MwLVpcscimowbxCFBQJE0QpOdGAbX9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548902; c=relaxed/simple;
	bh=JMNyxXoOiMPnQgMW5E0AylT5VF3um4ntyzRQQkNvHBQ=;
	h=Date:To:From:Subject:Message-Id; b=O1REBfIXdaHtBWMXVrIrujM9eHx8Z7J2Scqmu3x1Ktn8ApdgJW62tXGr/RmW6O605K95yTqMigNd+15294cyT7WY6YEF8JJiWX9URmKljQOCHNS8Kwt/IV/2gVUKpc5i9rvM/HPtcKIyMQHrwc7ih3WTuQD9WpvOEsimvsJf7AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUI8NEhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUI8NEhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6DFC4CEF7;
	Fri, 20 Feb 2026 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771548901;
	bh=JMNyxXoOiMPnQgMW5E0AylT5VF3um4ntyzRQQkNvHBQ=;
	h=Date:To:From:Subject:From;
	b=lUI8NEhWc+quH7J4Q9R5bXkvdDwZN8FURT3u6SXoKduLLyPuYEzIDWcolGMHEcjCD
	 qlygPAxA1mrnI8E50aKwkZj2b4xnGpKrQMCuU1aSDHjxprKJLodyOowKzp0Myo9JVC
	 X0HFWdJond8r2WdG701Z4F902eutmjoDcLJMK/fA=
Date: Thu, 19 Feb 2026 16:55:00 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,hughd@google.com,graf@amazon.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-export-memfd_addget_seals.patch added to mm-new branch
Message-Id: <20260220005501.7D6DFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memfd: export memfd_{add,get}_seals()
has been added to the -mm mm-new branch.  Its filename is
     memfd-export-memfd_addget_seals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-export-memfd_addget_seals.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: memfd: export memfd_{add,get}_seals()
Date: Mon, 16 Feb 2026 19:59:32 +0100

Patch series "mm: memfd_luo: preserve file seals", v2.

This series adds support for preserving file seals when preserving a memfd
using LUO.  Patch 1 exports some memfd seal manipulation functions and
patch 2 adds support for preserving them.  Since it makes changes to the
serialized data structure for memfd, it also bumps the version number.


This patch (of 2):

Support for preserving file seals will be added to memfd preservation
using the Live Update Orchestrator (LUO).  Export memfd_{add,get}_seals)()
so memfd_luo can use them to manipulate the seals.

Link: https://lkml.kernel.org/r/20260216185946.1215770-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260216185946.1215770-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Samiullah Khawaja <skhawaja@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |   12 ++++++++++++
 mm/memfd.c            |    4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/include/linux/memfd.h~memfd-export-memfd_addget_seals
+++ a/include/linux/memfd.h
@@ -18,6 +18,8 @@ struct folio *memfd_alloc_folio(struct f
  */
 int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
 struct file *memfd_alloc_file(const char *name, unsigned int flags);
+int memfd_get_seals(struct file *file);
+int memfd_add_seals(struct file *file, unsigned int seals);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -37,6 +39,16 @@ static inline struct file *memfd_alloc_f
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline int memfd_get_seals(struct file *file)
+{
+	return -EINVAL;
+}
+
+static inline int memfd_add_seals(struct file *file, unsigned int seals)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
--- a/mm/memfd.c~memfd-export-memfd_addget_seals
+++ a/mm/memfd.c
@@ -227,7 +227,7 @@ static unsigned int *memfd_file_seals_pt
 		     F_SEAL_WRITE | \
 		     F_SEAL_FUTURE_WRITE)
 
-static int memfd_add_seals(struct file *file, unsigned int seals)
+int memfd_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
 	unsigned int *file_seals;
@@ -309,7 +309,7 @@ unlock:
 	return error;
 }
 
-static int memfd_get_seals(struct file *file)
+int memfd_get_seals(struct file *file)
 {
 	unsigned int *seals = memfd_file_seals_ptr(file);
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch

