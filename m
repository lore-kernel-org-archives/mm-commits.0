Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE664C83
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733372786; cv=none; b=Z+r2kg2JT61ChaLjMIOTKwskUtAsblUXfgewdyG6wylzbeWQ1ES+kHqwsa67fZGkRrzuxbGcw4FxDWMuTfmISt+Ztew7xGLR4MX+8eIpKWljpvEpSqrLUfa68sl/8y+RVxD4ywPFPq9Qzt+2hYPHsOM4u7O/nZEztN5nK8FKuzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733372786; c=relaxed/simple;
	bh=8l2WTGkq1KINjQeeLKtK4vuaSR+5we2cL5WOvSKHYz0=;
	h=Date:To:From:Subject:Message-Id; b=UXdHG5cYXQgmOtosT2fCxyUJcXq5bLiCHTIsAIBi8UJAZdlNE1ieoPU0/LjACOGj1kFgF4P0pgh3kcRam/EDgDF9tYrrvB85FbyRrnujV8X3Zn3oFEnRekDZG6P73+LjnY7fsEHysMqre7EvdYe52ZiYYVe+dtdhxti3LdBdpn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lb//pr6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lb//pr6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8D7C4CED6;
	Thu,  5 Dec 2024 04:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733372785;
	bh=8l2WTGkq1KINjQeeLKtK4vuaSR+5we2cL5WOvSKHYz0=;
	h=Date:To:From:Subject:From;
	b=lb//pr6nZWP946BdembH0VtIRi+R762jU0xjFEB69m2csnwC9gIso/fvJNbc5fxyd
	 j1ZEYmGgjMEHb2rGhIoBsz2rDrp0fvxSQi2gKm3EEk48NvhPwbRYUkhLQYHu4mRZLQ
	 GpXwnAJMf8kC/ikJPj2QD7XMVcRWAnvKjNgp4PhQ=
Date: Wed, 04 Dec 2024 20:26:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration.patch added to mm-unstable branch
Message-Id: <20241205042625.AF8D7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: drop redundant anonymous statistics for file folios migration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-migrate-drop-redundant-anonymous-statistics-for-file-folios-migration.patch

