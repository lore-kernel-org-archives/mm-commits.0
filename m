Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296773FE357
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479226; cv=none; b=kJrkl0MRN70O2w9zl6AiuTazzJKtckUXt6kzjdB4sypdIEH/l79bv/bXAIczcaYj3i72m1S/2I79aJzY2hmsju4dREHdoeJjnokwmYqdkl5U8ibOklb8rWh/OW7GzYw7RV+j4vaUTemc2J9yyGkm2mZzbkoVT/J4od5DHlr7ZQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479226; c=relaxed/simple;
	bh=YSKLmpMKqXvZbDqEH3cUEWtYt1ewjQWgL3tDFH/sE3w=;
	h=Date:To:From:Subject:Message-Id; b=aaw0pOhzBTbDqLLP62GipGRs37IUpMDsGIEBTWzLopLR4FwO88wMnZybTHDma/WLErdDWYD/SvXvp9mgi66hkXj+dp23xX2KfAJ0GSDi8klIyRsS/Jnb9xzDZWm/DGh5r2txNos3GCMpSUtj5vK0BUi7w5+r12RFRcl254qf+Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17T5Cggy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17T5Cggy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3144AC19425;
	Wed, 29 Apr 2026 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777479224;
	bh=YSKLmpMKqXvZbDqEH3cUEWtYt1ewjQWgL3tDFH/sE3w=;
	h=Date:To:From:Subject:From;
	b=17T5CggyqqAvF8c5Esi4q5LWSv6GxmHb5Kdt2MM8yXOAukNXvT78KgJ3kW+7BAzj/
	 Y0PHR7qI3VBpDVBn8HidEoPrsLD2mxLfP2kzHpnpsShAT8tHUYsuxOK5o6lcvpTv+Z
	 N53V1E3dOF2PZbxpKHsbq7XdqmZt3yxmTIuWTDQ8=
Date: Wed, 29 Apr 2026 09:13:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch added to mm-new branch
Message-Id: <20260429161344.3144AC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

