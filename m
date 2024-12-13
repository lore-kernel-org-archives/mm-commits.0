Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB043398B
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 02:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734056990; cv=none; b=bQP78t2xe+Zdi5cbkCAQpDneAOcD5hQEBUxR7kuiSx8WsMZcbb2hsiRNugaYCXPZ4m+Nky4jrQ6n6pumZTqfwd7rU1IV4dZJboH4KDNtkFrKmP8gNGtk8rJh708Y82cs2C8gAtegNewqrt/GUNBpltTUfTtV+PH+jpbeDD46emY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734056990; c=relaxed/simple;
	bh=hMtdqqLUgAcf5AmbgpiuhpRJk/HgvWJQJt+erNliOok=;
	h=Date:To:From:Subject:Message-Id; b=ZSoDdE/wsHH8PYNa6heT0IdXYyx5hDPgLp2p+ozzysUOWFQnL+5yYvyr1HcvlNsiP+Et72Z5DDijDZPOfPe5Uot7KX90E7EOe5F0iVc309FKRdgXWzEDyF2ZdD7DPxYLtJcD3wQUr5uAFftNiLlN5nqII4HOE/4ga5GwERMWj1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zYLJ/Lhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zYLJ/Lhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930BBC4CECE;
	Fri, 13 Dec 2024 02:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734056989;
	bh=hMtdqqLUgAcf5AmbgpiuhpRJk/HgvWJQJt+erNliOok=;
	h=Date:To:From:Subject:From;
	b=zYLJ/LhemIYW7tFfp+8yfw5LRsBxTepDv/H33frcn/4guZVdB+4ocpxOZt4+aMfLE
	 XGv2Ni4RupGJir6PBbr+z6Eb/g6hBvS0EQDMHJD4MZmnnBeaLh9lv8Aq8XLWNHJOsm
	 pj2ZYcWTa6KNuZd6ne2XvBZo37ewq5PH8vswpm1k=
Date: Thu, 12 Dec 2024 18:29:49 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch added to mm-unstable branch
Message-Id: <20241213022949.930BBC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: assert mmap write lock held on do_mmap(), mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch

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
Subject: mm: assert mmap write lock held on do_mmap(), mmap_region()
Date: Thu, 12 Dec 2024 11:48:41 +0000

Both of these functions can be invoked outside of mm, so it is probably a
good idea to assert that the required lock is held.

Will only have an impact if CONFIG_DEBUG_VM is set, otherwise this amounts
to no change at all.

Link: https://lkml.kernel.org/r/20241212114841.55185-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mmap.c~mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region
+++ a/mm/mmap.c
@@ -291,6 +291,8 @@ unsigned long do_mmap(struct file *file,
 
 	*populate = 0;
 
+	mmap_assert_write_locked(mm);
+
 	if (!len)
 		return -EINVAL;
 
@@ -1023,6 +1025,8 @@ unsigned long mmap_region(struct file *f
 	unsigned long ret;
 	bool writable_file_mapping = false;
 
+	mmap_assert_write_locked(current->mm);
+
 	/* Check to see if MDWE is applicable. */
 	if (map_deny_write_exec(vm_flags, vm_flags))
 		return -EACCES;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch
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
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch

