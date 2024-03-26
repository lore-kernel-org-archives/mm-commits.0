Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04B4EB22;
	Tue, 26 Mar 2024 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476985; cv=none; b=gXQqlvRLx2S3SXnOSf9JzlA+2YVCaW7R1fiuz7fL8fjI7NIGJoB7WUW5kfW+GeR56BRJKc09/lW6RiQOQyfS0mKumHJDuua4ha2WJwMv72dSl/h9Xvp340+su2DwfDZVhoO6F3l3MrOXyWw+oAXd9Q78bjO1LR+nMZANY/KdF6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476985; c=relaxed/simple;
	bh=MQoub1cDl++U+lTzVG/k0v6PriqtgfcQ+T9+mrxvLt4=;
	h=Date:To:From:Subject:Message-Id; b=Sw5bx5iISQDGzZ8NsMhBFen1pUS3xxUZKZpLvVUon0myunMAcrb5vn9YyatV+MbwuePIVKvHn64ouArAEY5UODqg6VXOCc865splW69HFpUMlbKJhxGFWsBsh8xqwqxgaSVuY+jI6llRw4QPU7VQBK+onKEoRwqV0EEgfrO/iwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRJTDKLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRJTDKLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23307C433F1;
	Tue, 26 Mar 2024 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476984;
	bh=MQoub1cDl++U+lTzVG/k0v6PriqtgfcQ+T9+mrxvLt4=;
	h=Date:To:From:Subject:From;
	b=wRJTDKLy+5n44yMRDtsvHfCwNWQFLqwurS3FQGqc8qMDt1nBkB1fHutNMTesgXTlC
	 DVRGH1gBUOKJmFnXv6mriqKsMVyrMvQ90H2oXkSUwVNAuyUGWZicsCwt2o0I7kE04Q
	 6lhUamotda3fZOyzLbcfevjChbuyHSomBWza9/m4=
Date: Tue, 26 Mar 2024 11:16:23 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,stable@vger.kernel.org,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,miklos@szeredi.hu,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20240326181624.23307C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
Date: Tue, 26 Mar 2024 15:32:08 +0100

folio_is_secretmem() currently relies on secretmem folios being LRU
folios, to save some cycles.

However, folios might reside in a folio batch without the LRU flag set, or
temporarily have their LRU flag cleared.  Consequently, the LRU flag is
unreliable for this purpose.

In particular, this is the case when secretmem_fault() allocates a fresh
page and calls filemap_add_folio()->folio_add_lru().  The folio might be
added to the per-cpu folio batch and won't get the LRU flag set until the
batch was drained using e.g., lru_add_drain().

Consequently, folio_is_secretmem() might not detect secretmem folios and
GUP-fast can succeed in grabbing a secretmem folio, crashing the kernel
when we would later try reading/writing to the folio, because the folio
has been unmapped from the directmap.

Fix it by removing that unreliable check.

Link: https://lkml.kernel.org/r/20240326143210.291116-2-david@redhat.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/lkml/CABOYnLyevJeravW=QrH0JUPYEcDN160aZFb7kwndm-J2rmz0HQ@mail.gmail.com/
Debugged-by: Miklos Szeredi <miklos@szeredi.hu>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/secretmem.h~mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios
+++ a/include/linux/secretmem.h
@@ -13,10 +13,10 @@ static inline bool folio_is_secretmem(st
 	/*
 	 * Using folio_mapping() is quite slow because of the actual call
 	 * instruction.
-	 * We know that secretmem pages are not compound and LRU so we can
+	 * We know that secretmem pages are not compound, so we can
 	 * save a couple of cycles here.
 	 */
-	if (folio_test_large(folio) || !folio_test_lru(folio))
+	if (folio_test_large(folio))
 		return false;
 
 	mapping = (struct address_space *)
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

