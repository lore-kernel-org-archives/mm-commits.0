Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45815853B
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548904; cv=none; b=S76fkTWaUXYjPXAzsHrJIZBG1FQ37pu4B/UxI+KdPxs7/da/YPFLYtrj3srwK3JpwUdfffYNpwTbFb8B9DjIgY+JBo7dbXVV4gm6wZaa4PxDbNIpWse5oVVOS/jPQNekSDufKiuW0Y5z6YS4ywqH9/kqHwK1OPhSAJQFN+MEeIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548904; c=relaxed/simple;
	bh=619bMyWeXyUIyxv9Y+uLHhmlGKRuKXNRNhbGX51QrcY=;
	h=Date:To:From:Subject:Message-Id; b=DG9UT6rgCNoq5PwFfb7qGrIQBMZHIm4C3pDPmDb3MUHFNxkH08x6Mk5lVghLCV3Gzs8xxpwrD74hmetDs4xFV/WW2K6MJNP+w0NQizNrrHkr1R3M31UvwhhtJ7KfOMIw/sgehprvTzfi5MfDvhHJWfondxEU2AHEVaDY2D8aqog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2sHB7Ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2sHB7Ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0990DC4CEF7;
	Fri, 20 Feb 2026 00:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771548904;
	bh=619bMyWeXyUIyxv9Y+uLHhmlGKRuKXNRNhbGX51QrcY=;
	h=Date:To:From:Subject:From;
	b=b2sHB7KsyTS87XC6QXDVzjYei/F88pfKsPoCTgOOzkfnqd6o5jf1F7i+qZVt3yYlp
	 2/rgm+T6TR/GkCeCWB6c3LzkuKNozWh6SEsAAZR2Wjv5pK/ERStmEujuWotTKFYXPh
	 7byboavMVMABHraRuZJKsvb5licps9pt9yniiSx4=
Date: Thu, 19 Feb 2026 16:55:03 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,hughd@google.com,graf@amazon.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-preserve-file-seals.patch added to mm-new branch
Message-Id: <20260220005504.0990DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memfd_luo: preserve file seals
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-preserve-file-seals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-preserve-file-seals.patch

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
Subject: mm: memfd_luo: preserve file seals
Date: Mon, 16 Feb 2026 19:59:33 +0100

File seals are used on memfd for making shared memory communication with
untrusted peers safer and simpler.  Seals provide a guarantee that certain
operations won't be allowed on the file such as writes or truncations. 
Maintaining these guarantees across a live update will help keeping such
use cases secure.

These guarantees will also be needed for IOMMUFD preservation with LUO. 
Normally when IOMMUFD maps a memfd, it pins all its pages to make sure any
truncation operations on the memfd don't lead to IOMMUFD using freed
memory.  This doesn't work with LUO since the preserved memfd might have
completely different pages after a live update, and mapping them back to
the IOMMUFD will cause all sorts of problems.  Using and preserving the
seals allows IOMMUFD preservation logic to trust the memfd.

Since the uABI defines seals as an int, preserve them by introducing a new
u32 field.  There are currently only 6 possible seals, so the extra bits
are unused and provide room for future expansion.  Since the seals are
uABI, it is safe to use them directly in the ABI.  While at it, also add a
u32 flags field.  It makes sure the struct is nicely aligned, and can be
used later to support things like MFD_CLOEXEC.

Since the serialization structure is changed, bump the version number to
"memfd-v2".

It is important to note that the memfd-v2 version only supports seals that
existed when this version was defined.  This set is defined by
MEMFD_LUO_ALL_SEALS.  Any new seal might bring a completely different
semantic with it and the parser for memfd-v2 cannot be expected to deal
with that.  If there are any future seals added, they will need another
version bump.

Link: https://lkml.kernel.org/r/20260216185946.1215770-3-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Tested-by: Samiullah Khawaja <skhawaja@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/memfd.h |   18 +++++++++++++++-
 mm/memfd_luo.c                |   35 ++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

--- a/include/linux/kho/abi/memfd.h~mm-memfd_luo-preserve-file-seals
+++ a/include/linux/kho/abi/memfd.h
@@ -56,10 +56,24 @@ struct memfd_luo_folio_ser {
 	u64 index;
 } __packed;
 
+/*
+ * The set of seals this version supports preserving. If support for any new
+ * seals is needed, add it here and bump version.
+ */
+#define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
+			     F_SEAL_SHRINK | \
+			     F_SEAL_GROW | \
+			     F_SEAL_WRITE | \
+			     F_SEAL_FUTURE_WRITE | \
+			     F_SEAL_EXEC)
+
 /**
  * struct memfd_luo_ser - Main serialization structure for a memfd.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
+ * @seals:     The seals present on the memfd. The seals are uABI so it is safe
+ *             to directly use them in the ABI.
+ * @flags:     Flags for the file. Unused flag bits must be set to 0.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct memfd_luo_folio_ser.
@@ -67,11 +81,13 @@ struct memfd_luo_folio_ser {
 struct memfd_luo_ser {
 	u64 pos;
 	u64 size;
+	u32 seals;
+	u32 flags;
 	u64 nr_folios;
 	struct kho_vmalloc folios;
 } __packed;
 
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
--- a/mm/memfd_luo.c~mm-memfd_luo-preserve-file-seals
+++ a/mm/memfd_luo.c
@@ -79,6 +79,8 @@
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/memfd.h>
+#include <uapi/linux/memfd.h>
+
 #include "internal.h"
 
 static int memfd_luo_preserve_folios(struct file *file,
@@ -222,7 +224,7 @@ static int memfd_luo_preserve(struct liv
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 	u64 nr_folios;
-	int err = 0;
+	int err = 0, seals;
 
 	inode_lock(inode);
 	shmem_freeze(inode, true);
@@ -234,8 +236,21 @@ static int memfd_luo_preserve(struct liv
 		goto err_unlock;
 	}
 
+	seals = memfd_get_seals(args->file);
+	if (seals < 0) {
+		err = seals;
+		goto err_free_ser;
+	}
+
+	/* Make sure the file only has the seals supported by this version. */
+	if (seals & ~MEMFD_LUO_ALL_SEALS) {
+		err = -EOPNOTSUPP;
+		goto err_free_ser;
+	}
+
 	ser->pos = args->file->f_pos;
 	ser->size = i_size_read(inode);
+	ser->seals = seals;
 
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -449,13 +464,29 @@ static int memfd_luo_retrieve(struct liv
 	if (!ser)
 		return -EINVAL;
 
-	file = memfd_alloc_file("", 0);
+	/* Make sure the file only has seals supported by this version. */
+	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+		err = -EOPNOTSUPP;
+		goto free_ser;
+	}
+
+	/*
+	 * The seals are preserved. Allow sealing here so they can be added
+	 * later.
+	 */
+	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
 		err = PTR_ERR(file);
 		goto free_ser;
 	}
 
+	err = memfd_add_seals(file, ser->seals);
+	if (err) {
+		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
+		goto put_file;
+	}
+
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	file->f_inode->i_size = ser->size;
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch

