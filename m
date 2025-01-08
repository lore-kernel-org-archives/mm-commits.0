Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5721A2390
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736318205; cv=none; b=jZ8ONKGsNuD5ilFwJaFEXUbAqRYceMOXwoTPpdNASWHaZFmJdsfXr+Egib3BXSgEBpL3ZI1dBTQ6cyfO6yYGu0Rr9PlLjVntKudtvCPPrYAmkDQYZYlB0jLcetF32pz3gu4x8LO0PPYDrUAjwgUAKOls0Kr6ca7SKbU6YMljH+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736318205; c=relaxed/simple;
	bh=f8qEi7qXn53o+GdcVOh1EUK9yzfgZCSLkCetqIW2wRU=;
	h=Date:To:From:Subject:Message-Id; b=kCRXVHGKVOQFpAHttUuGNKv+N5z1MNwZXsHxrTD3tggPxv0iKmV6Fb+SFg/AWZdzsJeq5WVsBGeWSKNLWg6SxnDQLLba4eqNCeR+f5mQIpsCmHTe26xoBGw2LXcurWTUd5GKyIgzsINFUbn/MTyZNCp5ggKQ9+AxmUUw/HiZxFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HEDsGZm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HEDsGZm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C123DC4CED0;
	Wed,  8 Jan 2025 06:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736318204;
	bh=f8qEi7qXn53o+GdcVOh1EUK9yzfgZCSLkCetqIW2wRU=;
	h=Date:To:From:Subject:From;
	b=HEDsGZm1nHrmZEBE0fm79sRzsD6wgoztiLuahU9PUnro79wOVf3OFt0kkwxRT9Iog
	 avHcQPo52EHfRp1kY4134OVmxzPDwMWrZFoBfxOsL+yxqaP0C/ZfLstsQssoAiL6UI
	 A85q4XWtCaqwIXxoRlwdeOSbphZ/rQp0fSM63hwA=
Date: Tue, 07 Jan 2025 22:36:44 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,lkp@intel.com,linmiaohe@huawei.com,lina@asahilina.net,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,catalin.marinas@arm.com,bjorn@rivosinc.com,bhelgaas@google.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-add-support-for-pud-sized-mappings-to-rmap-fix.patch added to mm-unstable branch
Message-Id: <20250108063644.C123DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rmap-add-support-for-pud-sized-mappings-to-rmap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-add-support-for-pud-sized-mappings-to-rmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-add-support-for-pud-sized-mappings-to-rmap-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rmap-add-support-for-pud-sized-mappings-to-rmap-fix
Date: Tue Jan  7 10:33:26 PM PST 2025

remove stray * in comment, per David

Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/rmap.h~rmap-add-support-for-pud-sized-mappings-to-rmap-fix
+++ a/include/linux/rmap.h
@@ -231,7 +231,7 @@ static inline void __folio_rmap_sanity_c
 		break;
 	case RMAP_LEVEL_PUD:
 		/*
-		 * Assume that we are creating * a single "entire" mapping of the
+		 * Assume that we are creating a single "entire" mapping of the
 		 * folio.
 		 */
 		VM_WARN_ON_FOLIO(folio_nr_pages(folio) != HPAGE_PUD_NR, folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
rmap-add-support-for-pud-sized-mappings-to-rmap-fix.patch
huge_memory-add-vmf_insert_folio_pud-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

