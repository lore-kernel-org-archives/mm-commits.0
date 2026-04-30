Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C297082D
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566512; cv=none; b=KN14Z+3jlRDoExXwOBKxir2uY2YI+Urt1UPcsHnX9CPiO8v8VrRwEJaSAF7hea2xs9UgUZfk+WzIuCLd+H4rGIXUyRuHZ4J+ZCEZg2+urEdH5VnVigwuMAm/9WjCM1ilo+JKrCYA/O8f8HNoznFPqS7r0wif3zpoBdc8nnfntUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566512; c=relaxed/simple;
	bh=p4frOpTy0ZPS3J3CH5UHTjco4sieBcZSUfgTfgmLpzY=;
	h=Date:To:From:Subject:Message-Id; b=n1jOm+offqI6hQIoNrpDsWYKfk+Kisr4PnuOF+tWFPriQ99f9X5Ew+c9qYVY417Fq8ToyHIoxZiG8ahcCVhrNEtp7zDcq2MK75zWQCueSsd3B+pxxuOlqTmNbuG5rWSPMiciPbW7S7+P+3JUL45OIRPYjDQCegAeC3EBINw4Vgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gHiD/kwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gHiD/kwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DAEC2BCB3;
	Thu, 30 Apr 2026 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777566512;
	bh=p4frOpTy0ZPS3J3CH5UHTjco4sieBcZSUfgTfgmLpzY=;
	h=Date:To:From:Subject:From;
	b=gHiD/kwrBdyUdVTRg2eIFpcbY8Emlin61xkMr6QTRmuWHsxyeY6hSOhE1am324i0q
	 zhknefc1AuTS3fde9mA0p33od85IRGBt5qk3djbdWQN4lDlICjCVwYIh/mVtUa2xrH
	 5MCMI85+1AIxbkz8M0amb70bM8IhkY9/MkSRLFJg=
Date: Thu, 30 Apr 2026 09:28:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch added to mm-new branch
Message-Id: <20260430162832.72DAEC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged perror fixup
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch

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
Subject: selftests/mm: khugepaged perror fixup
Date: Thu, 30 Apr 2026 11:22:30 -0400

disambiguate error message

Link: https://lore.kernel.org/3BFC4C26-1C97-40AA-B4B7-7472B9768565@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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

 tools/testing/selftests/mm/khugepaged.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -446,7 +446,10 @@ static void file_fault_common(void *p, u
 		int madv_ops)
 {
 	if (madvise(((char *)p) + start, end - start, madv_ops)) {
-		perror("madvise(MADV_POPULATE_READ");
+		if (madv_ops =3D=3D MADV_POPULATE_READ)
+			perror("madvise(MADV_POPULATE_READ");
+		else if (madv_ops =3D=3D MADV_POPULATE_WRITE)
+			perror("madvise(MADV_POPULATE_WRITE");
 		exit(EXIT_FAILURE);
 	}
 }
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
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

