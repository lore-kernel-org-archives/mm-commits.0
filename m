Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2161DF75B
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 23:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750202870; cv=none; b=E3CRf3BT1c1Xij3QsYlZjFYL91ku11PiZLOOWKVtYGt7g11UlOXDB2wrN5EHO7Xg2jhqvApU8V3xKM7NaUq791IN84P8pgprkPIRp7ZP3dmZ/2pwynvaLla3kyL/N80puMwbqCUXpDj8VaviDBzqRyh6gYc29SqWOMcahiat98o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750202870; c=relaxed/simple;
	bh=8LD1wZw2qoz7t4A47r6zp15zeOT+rYxDvqaM/Of0VnE=;
	h=Date:To:From:Subject:Message-Id; b=rtP8XQ91x+NWeBQspNow1AYn/akFlcWZjEWQCW+8TQc7oEdX3jQfMLDiagLjGM3/mQieW4G01Vd4/OvY/UdlcvBt+ySaO9Wijh18tksRGaNAKHpTTaSSNXkVFB5De3P121SWrkG05+M3jDCUmVGyA6sNd/ugrBNUzl7zV/kz+2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wr9UMYxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wr9UMYxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD609C4CEE3;
	Tue, 17 Jun 2025 23:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750202869;
	bh=8LD1wZw2qoz7t4A47r6zp15zeOT+rYxDvqaM/Of0VnE=;
	h=Date:To:From:Subject:From;
	b=wr9UMYxNTdl0nbEWMrjUO9chVTOq8tamWhoPDHfI+T7/7H8ddB1grq6HHaUwNLZEU
	 7b1gcN6LNGEsOV5YaZ4lKMEHZ0h2rJp2CB/PgNDBgh4TphhAHm8LxjhtXuNMUS5CI6
	 BSK17IqwXh5fs1r4BpDntjNzRVQtRbqYFGcT0pfw=
Date: Tue, 17 Jun 2025 16:27:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-additional-mmap-related-files-to-mmap-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250617232749.DD609C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add additional mmap-related files to mmap section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-additional-mmap-related-files-to-mmap-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-additional-mmap-related-files-to-mmap-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add additional mmap-related files to mmap section
Date: Tue, 17 Jun 2025 15:41:30 +0100

msync and nommu are directly related to memory mapping, mincore is less so
but all are roughly speaking operating on virtual memory mappings from the
point of view of the user so this seems the most appropriate place for
them.

Link: https://lkml.kernel.org/r/20250617144130.147847-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-additional-mmap-related-files-to-mmap-section
+++ a/MAINTAINERS
@@ -15985,11 +15985,14 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
+F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
 F:	mm/mprotect.c
 F:	mm/mremap.c
 F:	mm/mseal.c
+F:	mm/msync.c
+F:	mm/nommu.c
 F:	mm/vma.c
 F:	mm/vma.h
 F:	mm/vma_exec.c
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
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
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch
mm-nommu-use-file_has_valid_mmap_hooks-helper.patch
fs-consistently-use-file_has_valid_mmap_hooks-helper.patch
fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch
fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch
fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch
fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare.patch
fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

