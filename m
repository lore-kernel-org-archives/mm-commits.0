Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B76C38F949
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141583; cv=none; b=U5sgaGc4VTH2w/d00ktGsouJqkVkn5X0OQQRPleI49aw+NNDb2/bOvC+aTcrhRKJpYShd3s23sD5kYO7R3rPfTLIEJTKTwyc0E3sKFRm4MPvQM3/O3K9strQ6OSErB7KI2CtUjtYZEAhmMv2xgCKn9SbnqFy4gagXnEjq2a2IRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141583; c=relaxed/simple;
	bh=soY/rSb9r0XUdZFzk7ShFdemNcgonUrWJftICLC+V0Y=;
	h=Date:To:From:Subject:Message-Id; b=KgvXY85AlmL3A2Oab/Jkrt11Pdf3zxXDPGp8MdN3NMYgY6zB4hQMgrJZ/dQQQr994MV2U4SBWhgUxsBM+pTLwvoYI2gccUUMKF51OBO25llvF2VEzIYkS6Q0MQGDaEwyEkvEp/AlcG4GsbEK6SgbyBKBJtHenc/tpAcJzkF5wLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qzkRkbGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qzkRkbGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FA5C2BCB7;
	Mon, 18 May 2026 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141582;
	bh=soY/rSb9r0XUdZFzk7ShFdemNcgonUrWJftICLC+V0Y=;
	h=Date:To:From:Subject:From;
	b=qzkRkbGexxJtZOd8GtPwSU5HXyEekHNso/2DPn5yNWpD5CNP9maU9hktSwEB1tIuD
	 yKowVshyDgXmQg3mYfjAChNCoQJUES0axSYxTxwAwTJ8yfMPOHGuWL+5LBchDWmkso
	 oCldFHZDWBRTPwu0ELJ9sBMazyfQD4u2mlJnk9hM=
Date: Mon, 18 May 2026 14:59:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch removed from -mm tree
Message-Id: <20260518215942.A2FA5C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Wed, 29 Apr 2026 11:35:35 -0400

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.  There is no need to open a file with read-only.

Link: https://lore.kernel.org/20260429153538.727855-8-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2237,9 +2226,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

