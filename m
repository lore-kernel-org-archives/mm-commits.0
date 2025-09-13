Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B22823D7DB
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794174; cv=none; b=mKbw3f6f08bJmvnpcHJrxfiHwaNtThlhEXcR0MGtvOz3wnuqCFlvLWz6bEd62c4MFXd6NLYahCW7qe995ZGX4gQgQO3M5Kr0PGKDPuosKhtgSI4k9hv+FPAD0sj7aPMtHoS/94BqEI6MF9u7LFPVVgL7OM17DZM8KnKjbPQzv54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794174; c=relaxed/simple;
	bh=jU3pe8mYaIOJGAy+iS9Q1DK7caiJDkTN6TRfahyngUU=;
	h=Date:To:From:Subject:Message-Id; b=FRZWpYlP31xwGVjOjUoHRXf+dvAnsi4mGDn95wZHKa2/3+hWQGB3eh2Y+mGyJ3V9ywrRmcqGJsbGSBE2TRvpIMY4An0xJn+sWuLN1TBfexfKaieZsmc8Nt6t7jLBKDI54S+gskBT1kEal61hjQufkSBWHuNR/fUSNpwuk4xyL9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BRh1UFmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BRh1UFmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D47C4CEEB;
	Sat, 13 Sep 2025 20:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794173;
	bh=jU3pe8mYaIOJGAy+iS9Q1DK7caiJDkTN6TRfahyngUU=;
	h=Date:To:From:Subject:From;
	b=BRh1UFmE9R/jhvO6wigGvNMGhambocD3P4Y+OPwpOdQqiRuK0hAFtknyO/T6d9N5z
	 iWqfjrCKqZAQzvY3QFuh8V3VjfcQzT60pJRjvl4xvyyxAc8EbRC0fHb2uWQkHhq8Eq
	 CPqx8wX5wpzC40FC1Lxuzy+3Qn0nOXGYSRTylKL8=
Date: Sat, 13 Sep 2025 13:09:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,riel@surriel.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-jann-horn-as-rmap-reviewer.patch removed from -mm tree
Message-Id: <20250913200933.B0D47C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Jann Horn as rmap reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-jann-horn-as-rmap-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add Jann Horn as rmap reviewer
Date: Mon, 8 Sep 2025 20:49:59 +0100

Jann has been an excellent contributor in all areas of memory management,
and has demonstrated great expertise in the reverse mapping.

It's therefore appropriate for him to become a reviewer.

Link: https://lkml.kernel.org/r/20250908194959.820913-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-jann-horn-as-rmap-reviewer
+++ a/MAINTAINERS
@@ -16195,6 +16195,7 @@ R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Harry Yoo <harry.yoo@oracle.com>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-update-cramfs-to-use-mmap_prepare.patch
fs-proc-add-the-proc_mmap_prepare-hook-for-procfs.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch
kcov-update-kcov-to-use-mmap_prepare.patch

