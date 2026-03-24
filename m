Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7379E364029
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388556; cv=none; b=Xm6Fe+eZzF1aV9yiVX+bgCuKDIBpiUiuNBCrUtRZg/FpVfIu5NxHJExZXCVCjU0RCJ8LpCzV19qdo8TlDXHZ0cMokne/Z4ju3Rpvi7ae6sY3BBocozKxhPJCiOthGrluuNGbnxb/CsCPSmvPDyZehOnb3OxFLKQn3oYKE31MK/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388556; c=relaxed/simple;
	bh=yRA9mAh/GQQYgNlFjdt1H2Nm68p0v6rf0h38kZYEjmk=;
	h=Date:To:From:Subject:Message-Id; b=lqq4tOJtMNDDnAauEKy3O7YncnVbfmnY6+Jl0cT5xrsYXoIO7d6KKsUrJEFbcEG5+8NjM26QqpWyfZRHqZeIzuLUmyV4pbJXRHxDPqrM2jfJQTzqe3hgZGmEoS++5mJRr+ZQuBS7Es1kYbxsf1cxPOqef/3nbzTfHbizKouGJNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hhaZ7syV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hhaZ7syV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46122C19424;
	Tue, 24 Mar 2026 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388556;
	bh=yRA9mAh/GQQYgNlFjdt1H2Nm68p0v6rf0h38kZYEjmk=;
	h=Date:To:From:Subject:From;
	b=hhaZ7syVy57Pdn3B8qyDzo6dSQ0a8Qbs5Z6KuUYAZ1Fzs+36I1WaN3PzHkt7warFN
	 GvjZNBvOrYnF5Zaj7zd+9zzQ3wh4HKxfSOkUcN2De2iXygLZeURzc0HD2w+DZLPuzy
	 +TypuyAPzdH8LuSmNAYDYTqZm9S7/zKugUQMX5hQ=
Date: Tue, 24 Mar 2026 14:42:35 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,hughd@google.com,graf@amazon.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memfd-export-memfd_addget_seals.patch removed from -mm tree
Message-Id: <20260324214236.46122C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: export memfd_{add,get}_seals()
has been removed from the -mm tree.  Its filename was
     memfd-export-memfd_addget_seals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch
kho-drop-restriction-on-maximum-page-order.patch

