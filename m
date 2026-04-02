Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB535B62A
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775152758; cv=none; b=Lb/CXc1RxcCQss5x4gM5L3FYPRi8D0xAQAZfyzxw7VHzIyl7foEf6kRG+xKx2qxc97YIii5yaPio/qgU9a7iCGWhg+I5yi/sJxsjLFvNYP2KgO65l8/+Pcd5pWk8MVDzZ1zwBwOZ0DnepuKtkswmkuyU/7+V8MMKePw8bULGJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775152758; c=relaxed/simple;
	bh=3aRkeQVvGd011KM64nNC2nXr2La5mSy9n7GrowXVPZ4=;
	h=Date:To:From:Subject:Message-Id; b=QlG1p/p0cLFe97LHSmEnFjO61b8Dy0+hGqXt+gpoLp2Vvg40uAZvDyFfy0jsHdSUFHEVNzmRxwtxhVxoLWuBCvDVBttaIScXd96c848kFm7ofQ73LqxMeQ/lii11bdGvsssuJcZw5UGZwsTEVfGOh1WdWL/JB57BMshIOeLWZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RAXpTjeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RAXpTjeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF9AC19423;
	Thu,  2 Apr 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775152757;
	bh=3aRkeQVvGd011KM64nNC2nXr2La5mSy9n7GrowXVPZ4=;
	h=Date:To:From:Subject:From;
	b=RAXpTjePo9gZXxPc7c/ubqj9rGZai8Ny64BzGNZI4ACJ9OzFv833jvKBJEKW1HK4+
	 L1Z3cpoVqVGdt5GAMA4cMR5LUt3iCt/+g9oUITDZQsoMkXjieW/uODeLfj/h6NAngM
	 7RgCOUOmdsZFpEeyYr9TwkwYSctv2qR8A/PdoJFo=
Date: Thu, 02 Apr 2026 10:59:17 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch removed from -mm tree
Message-Id: <20260402175917.AFF9AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios
Date: Thu, 26 Mar 2026 16:47:27 +0800

In memfd_luo_preserve_folios(), two variables had types that could cause
silent data loss with large files:

1. 'size' was declared as 'long', truncating the 64-bit result of
   i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,
   causing the function to return early and discard all data.

2. 'max_folios' was declared as 'unsigned int', causing overflow for
   sparse files larger than 4TB. For example, a 16TB+4KB file would
   calculate 0x100000001 folios but truncate to 1 when assigned to
   max_folios, causing memfd_pin_folios() to pin only the first folio.

Fix by changing both variables to 'u64' to match the types returned
by i_size_read() and the folio count calculations.

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Link: https://lkml.kernel.org/r/20260326084727.118437-8-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios
+++ a/mm/memfd_luo.c
@@ -90,8 +90,8 @@ static int memfd_luo_preserve_folios(str
 {
 	struct inode *inode = file_inode(file);
 	struct memfd_luo_folio_ser *folios_ser;
-	unsigned int max_folios;
-	long i, size, nr_pinned;
+	u64 size, max_folios;
+	long i, nr_pinned;
 	struct folio **folios;
 	int err = -EINVAL;
 	pgoff_t offset;
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch

