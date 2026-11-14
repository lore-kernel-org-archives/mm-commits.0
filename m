Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622234;
	b=WXN8RHSYvzhpvhePTZswbKP6i2B7HOcjOAMdkiX/1GgEN1hxN0G3Q9zNGmH4RA69S19o
	 f+0t+qQt15Ii0lc7LFO3+M9cgxOMEuiR+eeruOQqjsHSlVYADG3a4JDKxhgRu4NM+4CeE
	 f2vV5C+eYiDrKYSFZ5BgayNelG6Uy7lf0mHzpAElzodXz+xVYGIQxs2HRbN7LmUOobxdH
	 earq4oosNtqIbYuWTVsRIqGf83xZkW4VfssJwoD0x7t7cNNbmJONUlXsPD3eADmnEzsoi
	 5ODsprsjGujUPJ0HhAAg1ZSoJ3N/6yzkFIbh/kCfOu347yAmKweiJTKnkt3GJCJxJqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622234;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=E9VrLCp9fCbcAVvbA8CwSeFUDUfw7CReZTiENbyaPLU=;
	b=SUSEGC4S4vH6RcRRuEmAASFKbKaens3I4ZmnTmb1yKfySCm8e2s/6leTn1hMP5Di8gUO
	 AbGxItVn+l6PVNbo3zQvM7b0sNb2dhjgeTDe8lSCwp4EMwcXA/au3GZID437L0Un2IKg1
	 y493j1YXa8GiM56HHVBdyN51yjNk46BtWjJW6zXQqEDsiDNWmGnDZgvJ2+K86H6MwHW91
	 bZ+1U5Tgdk324UREyK9fKIFsArlwB0X0Jtm+G7NCVTma/qZc+R1k93cLGbDlCvVitML5z
	 eHjW+MnX+JqzF2E8KbGgjX1BzDhzO08CEDn2Azm1DJpzohd4Sb9S/mdjzy9UldHsG0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x6h6bw5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281D606A32D;
	Sat, 14 Nov 2026 02:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x6h6bw5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D411F000C7;
	Sat, 14 Nov 2026 02:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794622234;
	bh=E9VrLCp9fCbcAVvbA8CwSeFUDUfw7CReZTiENbyaPLU=;
	h=Date:To:From:Subject;
	b=x6h6bw5reBwMAE+afFc2ePzp0t7U8CcdSyciIn9t6dVAvQJXfQ0zuWOxvumxWhVWq
	 U29Xa0LTDJGSBImgmbGPY3KORUH58PtvsyzE3OoP/laYqcjUwJFEN67LS5050dWOlq
	 FoQZVlUWYpxVCYXDMmQtDQpbpZbILbmxVbth5aDo=
Date: Fri, 13 Nov 2026 18:10:33 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,
	ljs@kernel.org,leon@kernel.org,kas@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,
	david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-reject-shadow-stack-mappings.patch added to mm-new branch
Message-Id: <20261114021034.29D411F000C7@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hmm: reject shadow-stack mappings
has been added to the -mm mm-new branch.  Its filename is
     mm-hmm-reject-shadow-stack-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-reject-shadow-stack-mappings.patch

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
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/hmm: reject shadow-stack mappings
Date: Fri, 13 Nov 2026 14:55:36 -0500

On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
rejects ordinary stores to it, but pte_write() reports it writable because
shadow-stack instructions can write it.  HMM consequently sets
HMM_PFN_WRITE, which Nouveau turns into ordinary GPU write permission.  A
process with GPU access can then overwrite its own shadow stack,
potentially corrupting return addresses or bypassing that protection.

Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.  A
requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.

Link: https://lore.kernel.org/20261113195536.2660763-1-gourry@gourry.net
Link: https://lore.kernel.org/linux-mm/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/hmm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hmm.c~mm-hmm-reject-shadow-stack-mappings
+++ a/mm/hmm.c
@@ -596,6 +596,7 @@ static int hmm_vma_walk_test(unsigned lo
 	struct vm_area_struct *vma = walk->vma;
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
+	    !vma_test_single_mask(vma, VMA_SHADOW_STACK) &&
 	    vma->vm_flags & VM_READ)
 		return 0;
 
@@ -607,6 +608,8 @@ static int hmm_vma_walk_test(unsigned lo
 	 * allow write access either. HMM does not support architectures that
 	 * allow write without read.
 	 *
+	 * Devices must not gain ordinary write access to shadow stacks.
+	 *
 	 * If a fault is requested for an unsupported range then it is a hard
 	 * failure.
 	 */
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch
mm-hmm-reject-shadow-stack-mappings.patch

