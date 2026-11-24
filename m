Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559265;
	b=fhjWV25GqRrZ5aIbmyAiAwSv5056ddQfTfEJlTG9/bBrPL73xFr4VI5b9exeKDETO9Wr
	 HMrvAJCp6oFp8QS/FgP9jYGKd0hEZ78WYl05SRXmpB20e5D11RHAzrBe8VLSXJMuHXoo6
	 XjiMcox9R/LCJoYxaYQTU8yrOy4Utcr8QU6lsizPY+39Am7vtn8dKBRYLAjetbQWGFO4Y
	 xVyiemVY3DDSenLh2ccwvx1CkzaE7r+4o53evSrdd1H0ZMLDY1F/kTeXA2jx3ycE/f0Rm
	 pZpz8yVvoqynsW8x7JF6AX/DcBfE0cJEjsaWSBsWVjk7nLO49ZC2MzNGPGn8NdRQ+mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559265;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=P2tCcFi2xm5hjYD9SdsyW9lugSeBC/jp3KNM15GOOXw=;
	b=EMq7W6ajleD8Zr9Z7/KkONSpSU2IDTLYDwjGbhxoa6fWlaqkM1HDr1hEOAyJ4g3Y0Lyx
	 BoL04GnbGw7iDrZPZAqp+S18G9bFf9Cdp1rj2N0iANnbp933FI9Wfb0HI3rl+DuKqpp2d
	 2EhG/KSqSlq/GYRxvy3U94/0N2ieFrftldm111ENKAXzhgsie1UMlmERTV6nVGLID4rHe
	 NligYWxpUEvaLhU4bEmsdjSPSWJ6LFW6XCY0w/rm3YAf8V6uSUxIwp3PSqfBlGAA9QcmH
	 ePT8a4JIQr28RE6Ms1TrpMK7odfgPXTJBOQ75pEjs2hglgU4mRxU+1Ianva0FNCfKOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="JAwWLq/x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212C5606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 22:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JAwWLq/x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB071F000D0;
	Tue, 24 Nov 2026 22:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795559264;
	bh=P2tCcFi2xm5hjYD9SdsyW9lugSeBC/jp3KNM15GOOXw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=JAwWLq/xJfeHhkKuZEGpDF8HPW6ONHPprUnIpVrgk/sCZ4SPjNSQDwsE8rLIMnJu8
	 xRlkCGPI52iX6cvDnotAwo1ptIdEkXocLZW2cacflWLy3miOswgPq8MoHhZvBeam3g
	 NGkr4rjYf8F/LHYya/blNe39T0v2WXFIxgbqLOX4=
Date: Tue, 24 Nov 2026 14:27:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,
	sfr@canb.auug.org.au,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,
	peterx@redhat.com,osalvador@suse.de,nico.pache@linux.dev,
	muchun.song@linux.dev,mirq-linux@rere.qmqm.pl,miko.lenczewski@arm.com,
	mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,
	leitao@debian.org,lance.yang@linux.dev,kas@kernel.org,jthoughton@google.com,
	joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,dev.jain@arm.com,
	david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,balbirs@nvidia.com,avagin@gmail.com,arnd@arndb.de,
	apopple@nvidia.com,aarcange@redhat.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
Subject: + mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch added to mm-new branch
Message-Id: <20261124222744.8CB071F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/userfaultfd: check the hugetlb alignment of every VMA in the pre-scan
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/userfaultfd: check the hugetlb alignment of every VMA in the pre-scan
Date: Tue, 17 Nov 2026 23:28:49 -0500

UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
before changing anything. For a hugetlb VMA, userfaultfd_register()
rejects a range whose start or end is not huge page aligned there.
However, userfaultfd_unregister() only checks the start.

An unaligned end only fails later, when vma_modify_flags_uffd() cannot
split the VMA there. At that point, userfaultfd_clear_vma() already
cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
stays registered, but accesses to its pages are no longer reported. This
requires a caller passing a misaligned range.

To fix it, move the alignment checks into vma_uffd_range_aligned() and
call it for every VMA in the pre-scan of both ioctls. UFFDIO_UNREGISTER
still returns -EINVAL for such a range, but no longer unregisters the
VMAs before the misaligned one first.

Checking every VMA the same way also changes the following:

- UFFDIO_UNREGISTER now returns -EINVAL if the end is not huge page
  aligned in a hugetlb VMA that is not registered. It used to skip that
  VMA and succeed.

- Both ioctls now accept a start that is not huge page aligned if it is
  not inside any VMA and the first VMA of the range is a hugetlb one.
  They used to return -EINVAL, although such a range covers that VMA
  from its start, which is always huge page aligned.

- UFFDIO_REGISTER now returns -EINVAL rather than -EPERM if the end is
  not huge page aligned in a hugetlb VMA without VM_MAYWRITE.

Link: https://patch.msgid.link/20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu
Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Cc: Breno Leitao <leitao@debian.org>

 mm/userfaultfd.c |   54 +++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan
+++ a/mm/userfaultfd.c
@@ -3710,6 +3710,20 @@ static __always_inline int validate_rang
 	return validate_unaligned_range(mm, start, len);
 }
 
+static bool vma_uffd_range_aligned(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	unsigned long size;
+
+	if (!vma_is_hugetlb(vma))
+		return true;
+
+	/* A hugetlb VMA can only be split at a huge page boundary. */
+	size = huge_page_size(hstate_vma(vma));
+	return IS_ALIGNED(max(start, vma->vm_start), size) &&
+	       IS_ALIGNED(min(end, vma->vm_end), size);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -3789,17 +3803,6 @@ static int userfaultfd_register(struct u
 		goto out_unlock;
 
 	/*
-	 * If the first vma contains huge pages, make sure start address
-	 * is aligned to huge page size.
-	 */
-	if (vma_is_hugetlb(vma)) {
-		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
-
-		if (start & (vma_hpagesize - 1))
-			goto out_unlock;
-	}
-
-	/*
 	 * Search for not compatible vmas.
 	 */
 	found = false;
@@ -3815,6 +3818,8 @@ static int userfaultfd_register(struct u
 		ret = -EINVAL;
 		if (!vma_can_userfault(cur, vm_flags, wp_async))
 			goto out_unlock;
+		if (!vma_uffd_range_aligned(cur, start, end))
+			goto out_unlock;
 
 		/*
 		 * RWP uses protnone as an access-tracking marker. PROT_NONE
@@ -3838,20 +3843,6 @@ static int userfaultfd_register(struct u
 		ret = -EPERM;
 		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
 			goto out_unlock;
-
-		/*
-		 * If this vma contains ending address, and huge pages
-		 * check alignment.
-		 */
-		if (vma_is_hugetlb(cur) && end <= cur->vm_end &&
-		    end > cur->vm_start) {
-			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
-
-			ret = -EINVAL;
-
-			if (end & (vma_hpagesize - 1))
-				goto out_unlock;
-		}
 		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
 			goto out_unlock;
 
@@ -3962,17 +3953,6 @@ static int userfaultfd_unregister(struct
 		goto out_unlock;
 
 	/*
-	 * If the first vma contains huge pages, make sure start address
-	 * is aligned to huge page size.
-	 */
-	if (vma_is_hugetlb(vma)) {
-		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
-
-		if (start & (vma_hpagesize - 1))
-			goto out_unlock;
-	}
-
-	/*
 	 * Search for not compatible vmas.
 	 */
 	found = false;
@@ -4000,6 +3980,8 @@ static int userfaultfd_unregister(struct
 		 */
 		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
 			goto out_unlock;
+		if (!vma_uffd_range_aligned(cur, start, end))
+			goto out_unlock;
 
 		found = true;
 	} for_each_vma_range(vmi, cur, end);
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch
userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch
fs-proc-task_mmu-downgrade-writable-migration-entries-in-pagemap_scan-write-protect.patch
fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch
mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch
mm-mremap-resolve-uffd-state-when-the-context-is-dropped-not-during-the-move.patch
mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch

