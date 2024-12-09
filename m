Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ACE13B280
	for <mm-commits@vger.kernel.org>; Mon,  9 Dec 2024 19:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733773571; cv=none; b=sVItBHJMDFyspBjx/PVF2sk5zJsK3voEPC99w591K/lDswDHoP5we30ldo4gCr0ztXC30gz8Pyvb3tFrMtOTWBGYHINSHVXKfsdSyxNjSVuzAhgxYXmx/wlEsLy6Xu9XG7EuwFkpbozH4iexaOy1AF7pzI+EwnM+fQk+PCZgzDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733773571; c=relaxed/simple;
	bh=GaP8AgYjoVapM0pioNQee+GJCoj9ShS12i0juMs+DNk=;
	h=Date:To:From:Subject:Message-Id; b=p5BZwiHFY8P0hWvWsgSlyvvcnckTx4MpNIG3IZtraVYCiJ+aa+4h4zDwTiD4XdPvVfWPao/k6BjtDrVhB9Zrwa4wApEC2RfKGsdjthEWVmZe9wadxvysd1o4YJRxUxF3TQeXBI3jhXIVtDTWB4EArJc0KFJVxmBoWu/xQnTg6so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=riylzNFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="riylzNFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4CCC4CED1;
	Mon,  9 Dec 2024 19:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733773571;
	bh=GaP8AgYjoVapM0pioNQee+GJCoj9ShS12i0juMs+DNk=;
	h=Date:To:From:Subject:From;
	b=riylzNFeNV2PrcV6LSkSNQ0NzNCkPXtJj7FZr7+D9ED99JhAd88KYnNtKyVuJ003r
	 SKD4NeZcYJF8blfthTByj88gYleNVmalL7BBPNtIK0MUNBJm9zp5r8DS/GRyeFcdDZ
	 PqS6GgqleFAtplHrfZeC2k+3DzSvQ8by8Bf1XT1c=
Date: Mon, 09 Dec 2024 11:46:10 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch added to mm-unstable branch
Message-Id: <20241209194611.2E4CCC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix typos in !memfd inline stub
has been added to the -mm mm-unstable branch.  Its filename is
     mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch

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

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-group-all-vma-related-files-into-the-vma-section.patch

