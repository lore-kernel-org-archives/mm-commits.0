Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD49BA21
	for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769209585; cv=none; b=cHeCwkhe7gTaQy3fQUUhJgWXYkosn6f0iBq8v2gJ7MgN4tx3HbHBCrSNy3Afxn0CGaT2h9L5GT3WL+ZvFxt7nmyXZGzd8u5V4BO54iAa/d8c1taSs4oCTSCsqbfz5QQvNH3U9Gi+XsjH+FwC3BPZtVx4Vr0prEkJCKqiHOs5sjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769209585; c=relaxed/simple;
	bh=GE0nt4BxYV6P/FnemHSPkyH88wY102nPdSnYyMP4K8w=;
	h=Date:To:From:Subject:Message-Id; b=q4V7JGSSxX58FRpThCfZO4OdsD/X8LTsN514f3jj14bD5xQ21YS9WaWEWaJgjJ8QFn39BxMRkAQyvWypOepjl+HiRU5rYc7K60BthtXAlMMf2tskiL34H1fXgdZyr9HoWJhenuqWIrPDNC6DPru2kpxXDGpQiqxqJ18j9JKDIzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3lR1i+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3lR1i+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B980AC4CEF1;
	Fri, 23 Jan 2026 23:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769209584;
	bh=GE0nt4BxYV6P/FnemHSPkyH88wY102nPdSnYyMP4K8w=;
	h=Date:To:From:Subject:From;
	b=C3lR1i+//ytis6ebOcPcrT00bZwnSAK9WF08FxvGr6WQ+lMFzSIFBe97o/FTYDfbm
	 SAZi82LannTK9aeYNu0ehpcWerQlLqWM2mdxMmbow9lo/tfuYUyv6JnL0g4wTysQ5x
	 ZF3pGNDyZ0BMQN6Jcejof5ecowrfRdSMinpZvkJE=
Date: Fri, 23 Jan 2026 15:06:24 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,hughd@google.com,graf@amazon.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-preserve-file-seals.patch added to mm-new branch
Message-Id: <20260123230624.B980AC4CEF1@smtp.kernel.org>
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
Date: Fri, 23 Jan 2026 10:58:51 +0100

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

Preserve the seals by introducing a new 8-bit-wide bitfield.  There are
currently only 6 possible seals but 2 extra bits are used to provide room
for future expansion.  Since the seals are UAPI, it is safe to use them
directly in the ABI.

Back the 8-bit field with a u64, leaving 56 unused bits.  This is done to
keep the struct nice and aligned.  The unused bits can be used to add new
flags later, potentially without even needing to bump the version number.

Since the serialization structure is changed, bump the version number to
"memfd-v2".

Link: https://lkml.kernel.org/r/20260123095854.535058-3-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/memfd.h |    9 ++++++++-
 mm/memfd_luo.c                |   23 +++++++++++++++++++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

--- a/include/linux/kho/abi/memfd.h~mm-memfd_luo-preserve-file-seals
+++ a/include/linux/kho/abi/memfd.h
@@ -60,6 +60,11 @@ struct memfd_luo_folio_ser {
  * struct memfd_luo_ser - Main serialization structure for a memfd.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
+ * @seals:     The seals present on the memfd. The seals are UAPI so it is safe
+ *             to directly use them in the ABI. Note: currently there are 6
+ *             seals possible but this field is 8 bits to leave room for future
+ *             expansion.
+ * @__reserved: Reserved bits. May be used later to add more flags.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct memfd_luo_folio_ser.
@@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
 struct memfd_luo_ser {
 	u64 pos;
 	u64 size;
+	u64 seals:8;
+	u64 __reserved:56;
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
@@ -234,8 +236,15 @@ static int memfd_luo_preserve(struct liv
 		goto err_unlock;
 	}
 
+	seals = memfd_get_seals(args->file);
+	if (seals < 0) {
+		err = seals;
+		goto err_free_ser;
+	}
+
 	ser->pos = args->file->f_pos;
 	ser->size = i_size_read(inode);
+	ser->seals = seals;
 
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -444,13 +453,23 @@ static int memfd_luo_retrieve(struct liv
 	if (!ser)
 		return -EINVAL;
 
-	file = memfd_alloc_file("", 0);
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

memfd-export-alloc_file.patch
mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch
mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

