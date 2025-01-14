Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34539233522
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836062; cv=none; b=dSTDlQukc6eIzZGI7O3uyKM7+/RyXOigBnEqtOS+v8Gn1wZPC+I/3OS8k4dD0fMq5miym2FGZO6HzQTymCumeLTuv4BqIzf8q0OFA4tO2ctC/H+ZQDwb2PKQOj3o+cv+CHpdWyRfypy/yjzUvEwrHHW7Ki56G10jrh8C6gHLa+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836062; c=relaxed/simple;
	bh=m0h2SOdLwV3X9spoVpKZr/ENkGoHeWMl/8TQredjd6Y=;
	h=Date:To:From:Subject:Message-Id; b=ipuyS13UuF2w3+CQ0BJ6OTdR7lB9zssOqpSaoLyzmETPAm2b0obs3B3X9QKN5X6bxSOSiR8L008y00mC8YGA+uthwfJKFjwt97K/sN4N1l48GYjmYPEBDQh0x+MzIBtm8oMhbAijqZGBxF90Oq5AGigwjwu3at4AyRcWB44ALQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NSHDlQ0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NSHDlQ0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5E9C4CEDD;
	Tue, 14 Jan 2025 06:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836062;
	bh=m0h2SOdLwV3X9spoVpKZr/ENkGoHeWMl/8TQredjd6Y=;
	h=Date:To:From:Subject:From;
	b=NSHDlQ0/GvC1/z8/fh8skaVqgYKJbYF9cwGXvk8AfXifo0TcWIhxpAcAvGpCEX9UA
	 hIrp3tMi00Re15T+mdGlisG/3nXQz1yu3xrbAr/Te1pZaPMd8KttjmU7fYpwcWCLeu
	 snwlMBzJgZ1hJMPSCv2K0dl9rukG3Sv2QPEAKKbs=
Date: Mon, 13 Jan 2025 22:27:41 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch removed from -mm tree
Message-Id: <20250114062741.DF5E9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix typos in !memfd inline stub
has been removed from the -mm tree.  Its filename was
     mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch

This patch was dropped because it was folded into mm-perform-all-memfd-seal-checks-in-a-single-place.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fix typos in !memfd inline stub
Date: Mon, 9 Dec 2024 11:04:08 +0000

I typo'd the declaration of memfd_check_seals_mmap() in the case where
CONFIG_MEMFD_CREATE is not defined, resulting in build failures.

Fix this, and correct the misspelling of vm_flags which should be
vm_flags_ptr at the same time.

Link: https://lkml.kernel.org/r/7dee6c5d-480b-4c24-b98e-6fa47dbd8a23@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/memfd.h~mm-perform-all-memfd-seal-checks-in-a-single-place-fix
+++ a/include/linux/memfd.h
@@ -24,7 +24,8 @@ static inline struct folio *memfd_alloc_
 {
 	return ERR_PTR(-EINVAL);
 }
-int memfd_check_seals_mmap(struct file *file, unsigned long *vm_flags)
+static inline int memfd_check_seals_mmap(struct file *file,
+					 unsigned long *vm_flags_ptr)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch
mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state.patch
mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch
mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

