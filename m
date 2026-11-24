Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795484336;
	b=bdxRs33MrlVQ4ndSe7CofrF9RjOwCgwhMCVPQMnzUqWy+XL/rVEk1HnN1bTAt33jpLqj
	 wP69aq7eeJUtbG3yRCiPxMEOu5RIcgXeyvbrfNoOpzH09dL61TDNjb6UPdTul4HxDcAD7
	 d110ebAuYdweeigNqX71C0pFS3kHbWuEqdyiitPcqebd/eOZABHvzKOKTuUN5j0sJMPzU
	 qfTPwMT+rDhkg779yboVmDSzTByTumse9uLUSvy+iUYxmeojsz3RX4Vi0pQIbacWxMPsF
	 dXURglAqh5ySOb2uh9ar90L6k0Ztum0SBkqvl2maWLUmVI1XCIIGwG8sjSGUCT3lX9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795484336;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Q3cGh87TzPB/BzY1qf6UuL84PN/42rJrsKXEZom1vtY=;
	b=5j62Ur5H9C26GM9w8wcEpDImwylnxs11s0rXixm0UHwhbB5MQqOiIO+OQBrnlidIGclx
	 ENkOa2UF/xnTqJ15ACQGlWoyhd+el++6jXL7n78Oo8dhWfKEIzI8l4VfFJlD2YCdeMgMm
	 2lcGnlTbOPDt5RHJR/FiHwLVLu0/IIB6kGJKnrNi/sHBULdzMd+BlDRl2bvmuPtQEudmA
	 +HGqkvldXrevwkIj4mlELs4tkuWvdNkqVm332yFGEZmRUVq2V0amHSfn7Brr9Ggm1Wplh
	 9jU1Kfv1iDm1tJzzx6GyRQMywA8MrmoDayEU0aHLShqDqQRZIz7pFt1ne/VHIcKXTrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=c4UxmdVV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7541A606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=c4UxmdVV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B111F000C4;
	Tue, 24 Nov 2026 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795484335;
	bh=Q3cGh87TzPB/BzY1qf6UuL84PN/42rJrsKXEZom1vtY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=c4UxmdVVeRgzyYSS/O/4oBUZF+AfjMH8iZ12uTHoadUYdN74IzPc5bpwbwJqbINvF
	 PVI+QzdsIxVRp2MpZTA3U/WHOCTiez4kxEaWqDugKcBBLaxaBMS1LZ2CG+FZIEAJOC
	 Ulj/XNAKzd8sBBSd8M7WByxgmq3VNttLumAYBnt4=
Date: Mon, 23 Nov 2026 17:38:55 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	skhawaja@google.com,robin.murphy@arm.com,peterx@redhat.com,
	kevin.tian@intel.com,joro@8bytes.org,jhubbard@nvidia.com,jgg@ziepe.ca,
	david@kernel.org,xujiahao@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
Subject: + mm-gup-add-file_is_memfd_compatible-helper.patch added to mm-new branch
Message-Id: <20261124013855.98B111F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/gup: add file_is_memfd_compatible() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-add-file_is_memfd_compatible-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-add-file_is_memfd_compatible-helper.patch

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
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: mm/gup: add file_is_memfd_compatible() helper
Date: Thu, 19 Nov 2026 16:35:31 +0800

memfd_pin_folios() accepts only shmem and file-hugetlb files and enforces
that inline with shmem_file() and is_file_hugepages().  A caller that has
to know up front whether a file may be handed to memfd_pin_folios() cannot
use those predicates: since d3710111839d ("mm/shmem: make shmem_file()
check the file's inode") shmem_file() is an out-of-line function in
mm/shmem.c which is not exported, so modules cannot call it, and
is_file_hugepages() on its own is not the same question.

Provide the check as an exported helper next to memfd_pin_folios() and use
it inside memfd_pin_folios() itself, so that a single place decides which
files may be pinned.

Link: https://patch.msgid.link/20261119163531.788514-1-xujiahao@cmss.chinamobile.com
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jörg Rödel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>

 include/linux/mm.h |    1 +
 mm/gup.c           |   23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-gup-add-file_is_memfd_compatible-helper
+++ a/include/linux/mm.h
@@ -3604,6 +3604,7 @@ long pin_user_pages_unlocked(unsigned lo
 long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 		      struct folio **folios, unsigned int max_folios,
 		      pgoff_t *offset);
+bool file_is_memfd_compatible(struct file *file);
 int folio_add_pins(struct folio *folio, unsigned int pins);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
--- a/mm/gup.c~mm-gup-add-file_is_memfd_compatible-helper
+++ a/mm/gup.c
@@ -3450,6 +3450,27 @@ long pin_user_pages_unlocked(unsigned lo
 EXPORT_SYMBOL(pin_user_pages_unlocked);
 
 /**
+ * file_is_memfd_compatible() - check if a file may be used with
+ *				memfd_pin_folios()
+ * @file: the file to check
+ *
+ * memfd_pin_folios() only accepts files backed by shmem or by hugetlb.
+ * This is wider than "is a memfd": every shmem file matches, not only the
+ * unlinked ones memfd_create() produces, and file-hugetlb files are not
+ * memfds at all.
+ *
+ * Callers that have to validate a file before pinning it, or before taking
+ * a reference to it, can use this helper instead of duplicating the check.
+ *
+ * Return: true if @file may be passed to memfd_pin_folios().
+ */
+bool file_is_memfd_compatible(struct file *file)
+{
+	return shmem_file(file) || is_file_hugepages(file);
+}
+EXPORT_SYMBOL_GPL(file_is_memfd_compatible);
+
+/**
  * memfd_pin_folios() - pin folios associated with a memfd
  * @memfd:      the memfd whose folios are to be pinned
  * @start:      the first memfd offset
@@ -3493,7 +3514,7 @@ long memfd_pin_folios(struct file *memfd
 	if (!memfd)
 		return -EINVAL;
 
-	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
+	if (!file_is_memfd_compatible(memfd))
 		return -EINVAL;
 
 	if (end >= i_size_read(file_inode(memfd)))
_

Patches currently in -mm which might be from xujiahao@cmss.chinamobile.com are

mm-gup-add-file_is_memfd_compatible-helper.patch
iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch

