Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52851267387
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588766; cv=none; b=uEDx891C9EF9xdMlZcUQZvgoG+cje2G/1GJNqDEqoV35vhCPhevsTLcJk1lRpomK0OueqFC8ZMPSrjtEI531ZenxBQdqhymh7w176j7d6NJ6IGvfeREvGnFTKmlJfdbWR3G5CuTG0Cp+FBR+1ps3obLV4h6Sn4v2JsJCaBZCx1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588766; c=relaxed/simple;
	bh=yCYowuncMfrE0I6CToIiOvI3GoCK1TFwiWjEy4VMJmk=;
	h=Date:To:From:Subject:Message-Id; b=GGkl8On986aJuHjP1txUdbWFVtDFPj//DXQJuvwD1DDR8k20IKXqMWdIohPQGwunQ8aawsRTODA54bpyE5wESq/ZWHb6/4h7iBXtMf+fpnPY561SX+D1+bfV8NR5t4OxiGzq6Bayw+Mlu5jQoA1kyXdk2tF5x+YjNgtzb/DGlr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RZDnrCAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RZDnrCAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2BDC4CEED;
	Tue, 10 Jun 2025 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588765;
	bh=yCYowuncMfrE0I6CToIiOvI3GoCK1TFwiWjEy4VMJmk=;
	h=Date:To:From:Subject:From;
	b=RZDnrCAD20GXAtQAoMFr64/Bsc3jPZxV00FOuZu3fAcT7GZYJhio4SyfFs58Il0HX
	 mXF+UCdyE2WrotqDeKnw8KxON4P77lrmqviJYg2q+wUFiB/keza99zFhrImo9upCfh
	 ibHVESbeCjYISZrzoa4jx1cThuy0pmNTHJh1I2lI=
Date: Tue, 10 Jun 2025 13:52:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch added to mm-new branch
Message-Id: <20250610205245.CA2BDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add sys_mremap() helper to vm_util.h
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: add sys_mremap() helper to vm_util.h
Date: Mon, 9 Jun 2025 14:26:39 +0100

Add a helper to invoke the mremap() system call directly using syscall(). 
This is useful as otherwise glibc and friends will filter out newer flags
like MREMAP_RELOCATE_ANON and MREMAP_MUST_RELOCATE_ANON thus making it
impossible to test this functionality.

Link: https://lkml.kernel.org/r/c181dd5186dc0c13f2c78e4b859faa97a259a279.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    8 ++++++++
 tools/testing/selftests/mm/vm_util.h |    3 +++
 2 files changed, 11 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.c~tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -524,3 +524,11 @@ int read_sysfs(const char *file_path, un
 
 	return 0;
 }
+
+void *sys_mremap(void *old_address, unsigned long old_size,
+		 unsigned long new_size, int flags, void *new_address)
+{
+	return (void *)syscall(__NR_mremap, (unsigned long)old_address,
+			       old_size, new_size, flags,
+			       (unsigned long)new_address);
+}
--- a/tools/testing/selftests/mm/vm_util.h~tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -117,6 +117,9 @@ static inline void log_test_result(int r
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
+void *sys_mremap(void *old_address, unsigned long old_size,
+		 unsigned long new_size, int flags, void *new_address);
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

