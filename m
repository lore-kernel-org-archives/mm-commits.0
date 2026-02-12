Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED9CF9C0
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 20:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770928503; cv=none; b=hwpYdnuBrvqQlQHK3KxCprJfI8gimMBC1Gs2l5w0yKAJaLM2JTS7N10i1t9BQkv/OtnQlzCxVBtIzTJTQXGjjspMGvEkhngdQEo9G7bWy4JbiuCJdfLmD1yo0z91GvMp4T+m5JmxYfVKw6eExpT+eanu59gq+RKMljrFUzVTETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770928503; c=relaxed/simple;
	bh=crcXBQC7kNq81yPDuLCVhCTUJup5bilYTbTUz02UxPw=;
	h=Date:To:From:Subject:Message-Id; b=oAXGvd7LH5Fdlr0tdp311QleELEPquvV6i2IUhe6e/E/1uvnGWjfLEEPyRMq1teLxFgciBU88QwTFAowaFNqabckJvURRFqL+rX0i75H9wbbEzJEQ3tzWC4erkFyPuboRev/L9NqnetpwKb5pScIFojj8LBrgHxLjlVst6SpiGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lVC7jNbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lVC7jNbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09C2C4CEF7;
	Thu, 12 Feb 2026 20:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770928502;
	bh=crcXBQC7kNq81yPDuLCVhCTUJup5bilYTbTUz02UxPw=;
	h=Date:To:From:Subject:From;
	b=lVC7jNbLcTDiOf+5fg+JmTItBZ6yZKIhUKkWD7KDvK2Cib7CjGydo/5YH7o5vhQSc
	 r1oQdAhTymtzzL/ii4I6z5Xh9A+dr2FV6m8KU5IO1q5kSiqw8Ae7VjybmvAn9FLo6I
	 tBAloNs8BCW0Bu/cIGn0q3eUCPITdPGvWG3MIPQE=
Date: Thu, 12 Feb 2026 12:35:02 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,hughd@google.com,graf@amazon.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memfd_luo-preserve-file-seals.patch removed from -mm tree
Message-Id: <20260212203502.C09C2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memfd_luo: preserve file seals
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-preserve-file-seals.patch

This patch was dropped because an updated version will be issued

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


