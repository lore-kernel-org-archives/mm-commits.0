Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BAB364EB0
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084459; cv=none; b=jhY57DcU+Q/aPM1qiBBTD69CmolMKtihv4SlF8yWHHjsJeJ/+GfDLvUqCJV8rYLGN06aa5Na0kax/pmPp2sv9erVLrCbMK/pQzTJZlO2Qg1QlhU1T2VjI8ATGgdp5skPzYfRsJmBvzpJR02la95dH0hOFPOwebjFnFVTk28QBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084459; c=relaxed/simple;
	bh=m6BV/X//QQpr6pvN5WcHAVh+HKm48Qk8plFpFMTHzNs=;
	h=Date:To:From:Subject:Message-Id; b=abDyc6ByRONaxhAX6Qy0YZvVAzv9aO8RhFSVbbjhzRak93qaB3j/iRVMKGq6NHDbaXRBe6X/MnemX/gME0q2giPWiAzSQaIa+e81ZwlLdcsavQaFjIwbtpyepUbBVxpiksORjvHiSRZELgefa6ixNWeQ/4onqfgeb1d3+NCog2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OjO/sxHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OjO/sxHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D78C4CEF7;
	Mon,  9 Mar 2026 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773084458;
	bh=m6BV/X//QQpr6pvN5WcHAVh+HKm48Qk8plFpFMTHzNs=;
	h=Date:To:From:Subject:From;
	b=OjO/sxHGNwswWhALFxqvOaWlIcm+LSsgPf9LItfdyPu5LrtSaTjPvZ9aAne1vH1dt
	 gWHGIHqUK1iM3J/6n/H/A0Dd7/9SD37KZDqB+duilX701Pm8sQHfbGLkHxd9tq8xN7
	 8tq/Eg7wHQujdh4kgD9NYjCDfHclQaIrfvceMBRc=
Date: Mon, 09 Mar 2026 12:27:38 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch added to mm-new branch
Message-Id: <20260309192738.D1D78C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make sure preservations do not span multiple NUMA nodes
has been added to the -mm mm-new branch.  Its filename is
     kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch

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
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: kho: make sure preservations do not span multiple NUMA nodes
Date: Mon, 9 Mar 2026 12:34:06 +0000

The KHO restoration machinery is not capable of dealing with preservations
that span multiple NUMA nodes.  kho_preserve_folio() guarantees the
preservation will only span one NUMA node since folios can't span multiple
nodes.

This leaves kho_preserve_pages().  While semantically kho_preserve_pages()
only deals with 0-order pages, so all preservations should be single page
only, in practice it combines preservations to higher orders for
efficiency.  This can result in a preservation spanning multiple nodes. 
Break up the preservations into a smaller order if that happens.

Link: https://lkml.kernel.org/r/20260309123410.382308-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-make-sure-preservations-do-not-span-multiple-numa-nodes
+++ a/kernel/liveupdate/kexec_handover.c
@@ -895,9 +895,17 @@ int kho_preserve_pages(struct page *page
 	}
 
 	while (pfn < end_pfn) {
-		const unsigned int order =
+		unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
+		/*
+		 * Make sure all the pages in a single preservation are in the
+		 * same NUMA node. The restore machinery can not cope with a
+		 * preservation spanning multiple NUMA nodes.
+		 */
+		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
+			order--;
+
 		err = kho_radix_add_page(tree, pfn, order);
 		if (err) {
 			failed_pfn = pfn;
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-move-alloc-tag-init-to-kho_init_foliopages.patch
kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch
kho-drop-restriction-on-maximum-page-order.patch

