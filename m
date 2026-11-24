Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795495615;
	b=mWxzi7oEwGBYA3WxcbR0o7Xg52q8wrMCpw+p+I/OBSTer2gVkjq6WIYi5tvf4nEqMLMC
	 hpIU2NdsIN69IqYWqv9ZTIOQ0Wo4NvGhuWVU6gwTuyljMXC6Ia8noBAq1ri1SAZQkx1fZ
	 k7/GpcbeYftsoqqRzs/tvS9+KebOTkr6wBXK9x5IfUb6+GT4KEucSAoNASSMsuQVcgCj5
	 Kgdb87EPBR7QHnHKJpKaSrz+6ljAO+anwRG9GhMixtJHwTWpRXa9BZoUC1uBbevFVgYUZ
	 3nhNoqGw8Zq0pqLabCjU1PhdqO1WFukdwASH7HCBYUpdI1y0BSckKIQU8MUuVkklpKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795495615;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=q0NFw1W3COOpyuevO6kgHroF3v4PnBlr/WcOMMqJAEQ=;
	b=EiSskegybib1m3+rN9q3QLZIUwatSFEZndyVBtheik8qEKMP+Sm8DRopf8ejfiObhQFM
	 5MUpYHWPLcrQg+sT/aOpOrgTDZ+awUijhAcHxkDphyYau5qaJV17WI0FjbHQ4bFEgreT0
	 r9hhbbu8AuJujXFEe3NUAUdhYttUE/4vA8nGfKHnB9+YkyaiWWod3iy1OqYr7b1Z9eCcb
	 sLWUI5zYG3SAwOfUveIkfys+9ZYEML2NpbAOXZbSyNi14Ufcq0THg9EKE9dnNIB03rRpw
	 mJfZFI+kwE7fUud5STTgUPFGVRNIIhpXhfWky38GjY0aEsiSdaW82d7MniW634T5liw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jeQPwFxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7E606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 04:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jeQPwFxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEEA1F000CA;
	Tue, 24 Nov 2026 04:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795495614;
	bh=q0NFw1W3COOpyuevO6kgHroF3v4PnBlr/WcOMMqJAEQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=jeQPwFxNgFICz9o5Hfu01YUQsxJUptKXDUpcGGVQI6gQGyrO5RMObHZhVkd+Z2htb
	 GD29ndY0U5ZOnMvHwTDpUi4ul94H/d1wJ/o2CxuGxPl6k5jiQX5dYFuAFqk8UwBG/U
	 p21tktYiCi309WdrExszdV9eOs4ehRjYA3hgAcv0=
Date: Mon, 23 Nov 2026 20:46:54 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	skhawaja@google.com,robin.murphy@arm.com,peterx@redhat.com,
	kevin.tian@intel.com,joro@8bytes.org,jhubbard@nvidia.com,jgg@ziepe.ca,
	david@kernel.org,xujiahao@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
Subject: [merged] mm-gup-add-file_is_memfd_compatible-helper.patch removed from -mm tree
Message-Id: <20261124044654.9CEEA1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/gup: add file_is_memfd_compatible() helper
has been removed from the -mm tree.  Its filename was
     mm-gup-add-file_is_memfd_compatible-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: mm/gup: add file_is_memfd_compatible() helper
Date: Thu, 19 Nov 2026 16:35:31 +0800

memfd_pin_folios() accepts only shmem and file-hugetlb files and enforces
that inline with shmem_file() and is_file_hugepages().  A caller that has
to know up front whether a file may be handed to memfd_pin_folios() cannot
use those predicates: since d3710111839d ("mm/shmem: make shmem_file()
check the file's inode") shmem_file() is an out-of-line function in
mm/shmem.c which is not exported, so modules cannot call it, and
is_file_hugepages() on its own is not the same question.

Provide the check as an exported helper next to memfd_pin_folios() and use
it inside memfd_pin_folios() itself, so that a single place decides which
files may be pinned.

Link: https://patch.msgid.link/20261119163531.788514-1-xujiahao@cmss.chinamobile.com
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jörg Rödel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>

 include/linux/mm.h |    1 +
 mm/gup.c           |   23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-gup-add-file_is_memfd_compatible-helper
+++ a/include/linux/mm.h
@@ -3604,6 +3604,7 @@ long pin_user_pages_unlocked(unsigned lo
 long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 		      struct folio **folios, unsigned int max_folios,
 		      pgoff_t *offset);
+bool file_is_memfd_compatible(struct file *file);
 int folio_add_pins(struct folio *folio, unsigned int pins);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
--- a/mm/gup.c~mm-gup-add-file_is_memfd_compatible-helper
+++ a/mm/gup.c
@@ -3450,6 +3450,27 @@ long pin_user_pages_unlocked(unsigned lo
 EXPORT_SYMBOL(pin_user_pages_unlocked);
 
 /**
+ * file_is_memfd_compatible() - check if a file may be used with
+ *				memfd_pin_folios()
+ * @file: the file to check
+ *
+ * memfd_pin_folios() only accepts files backed by shmem or by hugetlb.
+ * This is wider than "is a memfd": every shmem file matches, not only the
+ * unlinked ones memfd_create() produces, and file-hugetlb files are not
+ * memfds at all.
+ *
+ * Callers that have to validate a file before pinning it, or before taking
+ * a reference to it, can use this helper instead of duplicating the check.
+ *
+ * Return: true if @file may be passed to memfd_pin_folios().
+ */
+bool file_is_memfd_compatible(struct file *file)
+{
+	return shmem_file(file) || is_file_hugepages(file);
+}
+EXPORT_SYMBOL_GPL(file_is_memfd_compatible);
+
+/**
  * memfd_pin_folios() - pin folios associated with a memfd
  * @memfd:      the memfd whose folios are to be pinned
  * @start:      the first memfd offset
@@ -3493,7 +3514,7 @@ long memfd_pin_folios(struct file *memfd
 	if (!memfd)
 		return -EINVAL;
 
-	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
+	if (!file_is_memfd_compatible(memfd))
 		return -EINVAL;
 
 	if (end >= i_size_read(file_inode(memfd)))
_

Patches currently in -mm which might be from xujiahao@cmss.chinamobile.com are

iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch

