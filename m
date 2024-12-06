Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F1C13D516
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733449432; cv=none; b=AIviJdCGNu6wSWRF1vJW5AX2jYj9fsansEWOUgp6UTX2Z2KARGnyUxAELZTGMejWUnQFXmehUvtQW5HP2pvvvdZBJJdrD8d8Nvwwb8+8F2b6qdp8SlkmCoTsu2HXmEIH4VEI6PMMsMHW5X9IiPW9GMuVQEF68fmwO1izyyKyugQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733449432; c=relaxed/simple;
	bh=TcvYYTjQEW15CA7YGOWFjekWGkT1yERWGATZZ8E6RA8=;
	h=Date:To:From:Subject:Message-Id; b=IpvWze3Dw9jgs73sSb4xN8IZQfkyMtX3zj5I6ZGTIP2Tun50PNherTJf6KRgQxyva2MlLIG5jxWJmFrxE1NG1Es93mriLbI7WplNjCnfUAeUa/UsN6PVqDkpFFsF+8oJcNWHXenTy3Oi8qORAHboPx8FYRXJHYuXAt42FTAePW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qcjm1AOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qcjm1AOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09F3C4CED1;
	Fri,  6 Dec 2024 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733449431;
	bh=TcvYYTjQEW15CA7YGOWFjekWGkT1yERWGATZZ8E6RA8=;
	h=Date:To:From:Subject:From;
	b=qcjm1AOgp2Ue914YzIU2peZ5wp8t4jcSqTzs9vQ/JJplxRxjw0EZ9EWcV2jTFUB/0
	 o/X3woMQx9vXrR1zJUT1QP0hA3HGvI8LONNaziQAo87j7kGS3FydrpE4AnidIg91qQ
	 cxhaTu+xvDxzE0mf0fGnKmbmcntreh4SsUcobReQ=
Date: Thu, 05 Dec 2024 17:43:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration.patch removed from -mm tree
Message-Id: <20241206014351.A09F3C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: drop redundant anonymous statistics for file folios migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: drop redundant anonymous statistics for file folios migration
Date: Thu, 5 Dec 2024 11:53:48 +0800

Commit 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
adds a new anonymous counter per THP size, however, when folio_mapping()
is not NULL during folio migration, it means this is not an anonymous
folio, so remove the redundant anonymous statistics in this case.

Link: https://lkml.kernel.org/r/d5e191ae02c2ab63c70cdf44877fe14fc69f5ae8.1733368611.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration
+++ a/mm/migrate.c
@@ -523,8 +523,6 @@ static int __folio_migrate_mapping(struc
 	 */
 	newfolio->index = folio->index;
 	newfolio->mapping = folio->mapping;
-	if (folio_test_anon(folio) && folio_test_large(folio))
-		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
 	if (folio_test_swapbacked(folio)) {
 		__folio_set_swapbacked(newfolio);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

