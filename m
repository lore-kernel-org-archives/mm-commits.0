Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE10F9C0
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 20:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770928502; cv=none; b=XCkFScYDdyaJ+XrRUTp16iCD0quuJFlP7q5pSZ9hqOkr9p26EPaV/iG5eQ17ec131Zo5lKDEjBO1Fckab5EZSM1D2sN2bPDzJdd0E7UylFck1R+WdN0cLD064nvzpTRAg33MXnClnJHXqii7GBa9q9BWYlkTATy4JvhzgCIcWH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770928502; c=relaxed/simple;
	bh=RnL05tNtRVgbJ2Oickh5fXzp6n14Ul1WENW7m15Pb7A=;
	h=Date:To:From:Subject:Message-Id; b=OlRvWwDl95Gm9bdzih1wK4eKFjP2dk93EM9kXi3iZIzi7fxlnOeToiOp2qtA2QaCpsxGNM7fQbL1XiViGY4dnziLFqO06wIEHKuD72r9JpgXajgihq6mTAV5WUOT68E26TjaYqimTh0FsxUJcQcC1L14vKCVVVgwTljP8DJNnDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZPZI7fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZPZI7fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68373C4CEF7;
	Thu, 12 Feb 2026 20:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770928501;
	bh=RnL05tNtRVgbJ2Oickh5fXzp6n14Ul1WENW7m15Pb7A=;
	h=Date:To:From:Subject:From;
	b=AZPZI7flPvieqeCzKsPfMq1fqjYf+WnVllhJPdmTH3yWHGffNyLQ2CyM9TYfShJIH
	 xQERat7j5ZXV0Z+K6pipMOwKFV+W/nvMlmX1Z0/mSuTnts6k5vBLxzamGFbricgUXJ
	 2upe96/lJZ5Qp9psR6OuOMq8s4tGxPlGOlEwcdh8=
Date: Thu, 12 Feb 2026 12:35:00 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,hughd@google.com,graf@amazon.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memfd-export-memfd_addget_seals.patch removed from -mm tree
Message-Id: <20260212203501.68373C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: export memfd_{add,get}_seals()
has been removed from the -mm tree.  Its filename was
     memfd-export-memfd_addget_seals.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: memfd: export memfd_{add,get}_seals()
Date: Fri, 23 Jan 2026 10:58:50 +0100

Patch series "mm: memfd_luo: preserve file seals".

This series adds support for preserving file seals when preserving a memfd
using LUO.  Patch 1 exports some memfd seal manipulation functions and
patch 2 adds support for preserving them.  Since it makes changes to the
serialized data structure for memfd, it also bumps the version number.


This patch (of 2):

Support for preserving file seals will be added to memfd preservation
using the Live Update Orchestrator (LUO).  Export memfd_{add,get}_seals)()
so memfd_luo can use them to manipulate the seals.

Link: https://lkml.kernel.org/r/20260123095854.535058-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260123095854.535058-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
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

mm-memfd_luo-preserve-file-seals.patch

