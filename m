Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F054848A6
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866022; cv=none; b=O0+XsZdJLLP2Rvq0tec1fcav6pyCC+/KZ9/6Lqp1FFPOymzhX+EMfsCAcg1z7LjziKEjuFDIrvxWDl9YIbdGZx9eE/I8gFqNygQ58vjIPwEa8AqZkhiO3fExd/8WtHgzrTRN3fIWwHxlfqLEJrIWQSz2h3gsgMbTc6iOpXNxv2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866022; c=relaxed/simple;
	bh=T5UWN61dJ2E6uINktrg57TnYggYS5c0in5y5uul5ZKs=;
	h=Date:To:From:Subject:Message-Id; b=qxsqkgfPgzQs6pSIOeDM30zxxkWTd9Cg0lLVV6Y4ylk9EMPt+EyLB7Xr42mHVCXQxpkwA6u2FVLt1uqIbi9Csr8TLdwC/v3DfPl/2Qg9BstKuF6ihX9yQGUHjDnTQZK/SykeWwQtnRBgT0tHMPgQo1b+tj4aAR2IXXEfMhM2FZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b/9TUc63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b/9TUc63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460461F00893;
	Tue, 13 Oct 2026 04:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866019;
	bh=TThPb3ky/yS8OEHbCTzeV4lNNIZ+ajYTtWjR2i4kel4=;
	h=Date:To:From:Subject;
	b=b/9TUc63OZtA9JCROMRwhqcyueV+3gJf+xzmL6NQyHb0ZUgNxnta+yTXflsAOTJuc
	 DB741R9KdIGGkiVC+HYHj5/Az6vCs4T86773RJoFn8ZEgUdHgsXw0yqhFEjeARDVsC
	 aP4g0a2953J2dX5HvZFic2tQpIQQ1nAaPCMZE5pc=
Date: Mon, 12 Oct 2026 21:33:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch removed from -mm tree
Message-Id: <20261013043339.460461F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip khugepaged page cache cases without a PMD folio
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: skip khugepaged page cache cases without a PMD folio
Date: Sat, 19 Sep 2026 01:24:34 +0100

The page cache caps folio order at MAX_PAGECACHE_ORDER, which is below the
PMD order on arm64 with 64K pages, where a PMD is 512M.  A PMD-sized page
cache folio is impossible there, so the kernel refuses these collapses:
MADV_COLLAPSE answers -EINVAL and khugepaged passes over the range.  Four
shmem cases ask for a PMD-sized folio anyway, fail, and the run bails out
in the middle.

Skip the shmem and file mem types where the cap is below the PMD order.

The cap is not shmem-specific: it applies to every file folio.  Add
thp_file_supported_orders() to read the orders the page cache allows.

Anonymous collapse is unaffected: its orders are not capped this way.

Link: https://lore.kernel.org/20260919002451.496763-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/lib/mm/hugepage_settings.h        |    9 +++++++++
 tools/testing/selftests/mm/khugepaged.c |   19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/tools/lib/mm/hugepage_settings.h~selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio
+++ a/tools/lib/mm/hugepage_settings.h
@@ -87,6 +87,15 @@ void thp_set_read_ahead_path(char *path)
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+/*
+ * The per-order shmem_enabled attribute is created for the orders the page
+ * cache can hold, not just for shmem, so it answers for regular files too.
+ */
+static inline unsigned long thp_file_supported_orders(void)
+{
+	return thp_shmem_supported_orders();
+}
+
 bool thp_available(void);
 bool thp_is_enabled(void);
 
--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1358,6 +1358,25 @@ int main(int argc, char **argv)
 
 	setbuf(stdout, NULL);
 
+	/*
+	 * Without a PMD-order page cache folio the kernel refuses these
+	 * collapses, so there is nothing to test.
+	 */
+	if (!(thp_file_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("No mem_type left to run\n");
+	}
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

