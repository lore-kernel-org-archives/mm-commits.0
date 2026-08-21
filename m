Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE42F3D3324
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352246; cv=none; b=X2MhrIO2cpxHt2jMPdZeYZZAU257lFftjGPaiEYlkz1rCJ8RkQFSVnsprVL2vXkC9NmefpV23MQTTEH8H0njyfF7eCelDS2TGraq1xL8a1iCASRMrkTNqdZDjTbi30hepMn0b0yQxVDQvpGPfh/Eomt4nQPu4z/er0AXYNjTp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352246; c=relaxed/simple;
	bh=go9wSfogMBpMDfCHYVh5oLUwOmZasil2L8P+3JTwDUo=;
	h=Date:To:From:Subject:Message-Id; b=GrIjUedOGK91w/N6nisDP1dWgsx8T0nrXP5x9aefYM4M9RbcqSD6gB4wjakAE4hboVIfvRHCLmvyEBqK0PS+Zvha6xa48drhPDPudbHWyshb+D4oiXzjNUmVZo4pW2FWsyi2mtq3048/eVIwZFZCaIJ8UvQKrbMotT6JXrhXMX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Itc5Is6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Itc5Is6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D101F00A3E;
	Fri, 21 Aug 2026 22:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352244;
	bh=Mt61rRjwafH9dBgxOLNKHem78v2jSjWdapUcX+So8ak=;
	h=Date:To:From:Subject;
	b=Itc5Is6XOXyCkanFlb2AHtzUDEH97ZiSxKi9ZlY+o5d1Q20OPiS9GuHd/ln4XoEtq
	 OM/6d9S1RrMv7yRjTcbHly4spVRwr3Wl2b0Y/irnWIu6Nl53tzAD5m+yyTdETohiKn
	 XyDub5HLVHVybZK9hYyWyWKncCHJfVPvacDcvqDc=
Date: Fri, 21 Aug 2026 15:44:04 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-document-erase-and-allocations-better-fix.patch added to mm-unstable branch
Message-Id: <20260821224404.74D101F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-document-erase-and-allocations-better-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-document-erase-and-allocations-better-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-document-erase-and-allocations-better-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-document-erase-and-allocations-better-fix
Date: Fri Aug 21 03:27:57 PM PDT 2026

tweak mtree_erase() descripton, per Jason

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-document-erase-and-allocations-better-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -75,7 +75,8 @@ given index.  You can use mtree_erase()
 knowing one value within that range, or mtree_store() call with an entry of
 NULL may be used to partially erase a range or many ranges at once.  Note that
 mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
-fail, but may need to sleep - do not use mtree_erase() from a blocking context.
+fail.  mtree_erase() can sleep, so it must not be called from an atomic
+context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
maple_tree-document-erase-and-allocations-better-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

