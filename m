Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AF5239E88
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 18:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758479186; cv=none; b=WqX2AnyVEu7njmpEwzzZi++0atdw63JEJBfA2fVXYLBKuDoMMkDzoGwrz7/0U5uVOywQUaFxha9+xMjvV/8vzM5hVlyGmu4iBf0bSs+Cdf9HXYNXqjVRVy14zcBGrGOIibkXouLA4tkJviNQ6/smleOLv3p49T2Rh9SNb7zsaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758479186; c=relaxed/simple;
	bh=G+c3eZZVEEfYlzfWa3x30Xg1UD4JVzes+wORPkWYyNQ=;
	h=Date:To:From:Subject:Message-Id; b=NUEUXf3H6MKUDFmuBqfkAJv8wKRO9H2a8cK7SgrJto1d9S6EHWUa5OXyruk3CLQwgXzRKyR+QzAxqCqdRvV7LAeiyYwfLO8hlW99Gsph+5G62XwRodaohnXb4jBjOs1JAN4JhHB6xoHsbqsyLh6kchwPkZPtfDHvqUa+U8vCgcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CYnTwIZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CYnTwIZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B52C4CEE7;
	Sun, 21 Sep 2025 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758479185;
	bh=G+c3eZZVEEfYlzfWa3x30Xg1UD4JVzes+wORPkWYyNQ=;
	h=Date:To:From:Subject:From;
	b=CYnTwIZrcE5MkAc1uXEpvvPyCXTyJlLa2oh1T+4E87Zp3KNEgtfXT5buDuM2QvrMa
	 eo9rS1CEk0rxJz8o7mwojS/QYasTm/1+61EujrR8PhuTM60Od4JBq7QrCAT1NaeInZ
	 nCaCg9Wpf+9rxMlIxWVbcllj1XLS+kaAvQMcZ+aM=
Date: Sun, 21 Sep 2025 11:26:24 -0700
To: mm-commits@vger.kernel.org,joeypabalinas@gmail.com,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] memfd-move-mfd_all_flags-definition-to-memfdh.patch removed from -mm tree
Message-Id: <20250921182625.77B52C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: move MFD_ALL_FLAGS definition to memfd.h
has been removed from the -mm tree.  Its filename was
     memfd-move-mfd_all_flags-definition-to-memfdh.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memfd: move MFD_ALL_FLAGS definition to memfd.h
Date: Sun Aug 31 12:29:57 PM PDT 2025

It's not part of the UAPI, but putting it here is better from a
maintainability POV.
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Pabalinas <joeypabalinas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/memfd.h |    2 ++
 mm/memfd.c                 |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/memfd.h~memfd-move-mfd_all_flags-definition-to-memfdh
+++ a/include/uapi/linux/memfd.h
@@ -12,6 +12,8 @@
 #define MFD_NOEXEC_SEAL		0x0008U
 /* executable */
 #define MFD_EXEC		0x0010U
+#define MFD_ALL_FLAGS		(MFD_CLOEXEC | MFD_ALLOW_SEALING | \
+				 MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
 
 /*
  * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
--- a/mm/memfd.c~memfd-move-mfd_all_flags-definition-to-memfdh
+++ a/mm/memfd.c
@@ -313,8 +313,6 @@ long memfd_fcntl(struct file *file, unsi
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
-
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
 #ifdef CONFIG_SYSCTL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

