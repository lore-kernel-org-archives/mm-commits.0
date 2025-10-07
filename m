Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A5322D4DE
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 20:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870008; cv=none; b=q00jZIiMXjDIFReQb96z6TXBXTq69OtgRb6iFB3E5hrbcduXk5JbV5VbPDH5OUeeqr2xaaGaSYuBeqAU/76O5masPpWCdeSgR9sOK5uRv1RETMQ9DbBqZnQV90MDxo/hNc1BbQfb6dkTd/sQcEnfyu7Os9fh8B4R7dAaRWBOdTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870008; c=relaxed/simple;
	bh=QuMeT4iPt3MJKeA0TfO7zD25aa6qzpILMiMYcYyl4zs=;
	h=Date:To:From:Subject:Message-Id; b=Di88CNfcAmHSj2svJxriU+iQfaMw9c6c4AEmigiXbCOcwy9o1c6PjMaGtJ8cooS+CxeQ/rQ3BPXjk9VO8Wv/tBKMAPPXvFCvF/UMkXfbK9msVPbzEnRhis857/SukLfykP57PaK5+hczi+snw8I1e9412GhvWkGp1ctYq3J5j4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H7AKQM7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H7AKQM7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B15C4CEF1;
	Tue,  7 Oct 2025 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870008;
	bh=QuMeT4iPt3MJKeA0TfO7zD25aa6qzpILMiMYcYyl4zs=;
	h=Date:To:From:Subject:From;
	b=H7AKQM7EA024SjMPC73VNFJ6m1xyRRQef8jkg2EXDNADIGdqB+WatT6FropVtdQfJ
	 Aq2oUvRPvoSy3+kox21Bp10o6Ijgb0WAip6WdvwL0BVdvWO4BxJZOPwApJfw3ko1uI
	 vKgzPQ9Lx3uTQaJL4caYwk1j1s+0yUqKmSuJ7jqw=
Date: Tue, 07 Oct 2025 13:46:47 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-add-support-for-preserving-vmalloc-allocations-fix.patch removed from -mm tree
Message-Id: <20251007204648.17B15C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-add-support-for-preserving-vmalloc-allocations-fix
has been removed from the -mm tree.  Its filename was
     kho-add-support-for-preserving-vmalloc-allocations-fix.patch

This patch was dropped because it was folded into kho-add-support-for-preserving-vmalloc-allocations.patch

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho-add-support-for-preserving-vmalloc-allocations-fix
Date: Thu, 25 Sep 2025 13:05:08 +0200

Chunks are allocated using get_zeroed_page() so they should be freed
using free_page() not kfree().

Link: https://lkml.kernel.org/r/mafs0a52idbeg.fsf@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kho-add-support-for-preserving-vmalloc-allocations-fix
+++ a/kernel/kexec_handover.c
@@ -885,7 +885,7 @@ static void kho_vmalloc_free_chunks(stru
 		kho_vmalloc_unpreserve_chunk(chunk);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-add-support-for-preserving-vmalloc-allocations.patch

