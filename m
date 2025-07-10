Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AA1284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126239; cv=none; b=edAu0XpjKuppgUVtrQXYh+MpLhdHCVUwrRsStukf7arH7Ld5a8DadnawIyQIRWySgtDP3GRfzwa1sAQ0pdLwFrXfiv96+FoTaRZGdIRubJRLqcZE/iW/QTt0r4B/BXdGV6cmv0y+jqF+c8afrWpMMWb45NN+7Lg4a6mG1socbnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126239; c=relaxed/simple;
	bh=9SE6Qjj9UUERhNpxOs8kJTvXdLdeOv2Kri9i+02taQA=;
	h=Date:To:From:Subject:Message-Id; b=DoDWfAEu7H7GG17g5Zlve2DwHbZlhZ2ms5493iULECouGYxjbx2GRXWzh+tx4vr/u+TMtMEaoCXjEdGzgl2DvIafeyYbPkfriMSWlkv6WX0TcYRm8oX13MxXcODwhNkoamg2RvxjSFQreMNgr3tQXmmShD+FWKTieXeFpkOOuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mf/olY8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mf/olY8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66D4C4CEF5;
	Thu, 10 Jul 2025 05:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126239;
	bh=9SE6Qjj9UUERhNpxOs8kJTvXdLdeOv2Kri9i+02taQA=;
	h=Date:To:From:Subject:From;
	b=Mf/olY8oWklnN5mNzLAFXEek1Qs5XOAupCnbrWoMXrhNZGgsqOp99Vb6KeJQmrLAZ
	 djmPv7YlVJRe9AEt3pCs+jFiOGZUM23xuca4t21zezJSIvJnyGCFyZ9Zq45tRbd9NY
	 YVadV0yNn/UO5GpfnMPv2oAgOIzd5THcrnMTOxRM=
Date: Wed, 09 Jul 2025 22:43:58 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch removed from -mm tree
Message-Id: <20250710054359.A66D4C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: correctly prevent registering VM_DROPPABLE regions
has been removed from the -mm tree.  Its filename was
     userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: correctly prevent registering VM_DROPPABLE regions
Date: Thu, 19 Jun 2025 21:24:23 -0400

Patch series "mm: userfaultfd: assorted fixes and cleanups", v3.

Two fixes and two cleanups for userfaultfd.

Note that the third patch yields a small change in the ABI, but we seem to
have concluded that it is acceptable in this case.


This patch (of 4):

vma_can_userfault() masks off non-userfaultfd VM flags from vm_flags.  The
vm_flags & VM_DROPPABLE test will then always be false, incorrectly
allowing VM_DROPPABLE regions to be registered with userfaultfd.

Additionally, vm_flags is not guaranteed to correspond to the actual VMA's
flags.  Fix this test by checking the VMA's flags directly.

Link: https://lkml.kernel.org/r/20250619-uffd-fixes-v3-0-a7274d3bd5e4@columbia.edu
Link: https://lore.kernel.org/linux-mm/5a875a3a-2243-4eab-856f-bc53ccfec3ea@redhat.com/
Link: https://lkml.kernel.org/r/20250619-uffd-fixes-v3-1-a7274d3bd5e4@columbia.edu
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-correctly-prevent-registering-vm_droppable-regions
+++ a/include/linux/userfaultfd_k.h
@@ -218,7 +218,7 @@ static inline bool vma_can_userfault(str
 {
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
 	if ((vm_flags & VM_UFFD_MINOR) &&
_

Patches currently in -mm which might be from tz2294@columbia.edu are


