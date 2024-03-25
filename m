Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D093DAC1C;
	Mon, 25 Mar 2024 18:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711391269; cv=none; b=cCRZTN+O78T9iEb11ztJo5qZquAbOmrJBAZWgiaojkeYVqrG9jaETROrpx9lQ8m5qGxHM2xwIuPgslwb3FAQ+DfFFDPkpXM3cFcrpbQjVPrUdh62DknRWEgTCZrJMmd24OJapyhcYXxFXjIz6R5MVyov3RXLeynUa/r5+ZJBnyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711391269; c=relaxed/simple;
	bh=eBt2AV4OAjLPdcjttMAd77PV3m18dm2aYpsEJKwnkmQ=;
	h=Date:To:From:Subject:Message-Id; b=EIpUeUWjXOc8UMWLpx7+zHeedij30SNi6eGuMSURNFsl0tTy1oMVgtWmKdKlzZ2NtsgqvmVFUoHkiyeW+AjLB7EcelJglyTTVG098deXcuKpK8Vq7l1jpDznZuReO7mcCGDwiYMJQkMVUbgMj1asLu9iyzMAS6kyaD3PW/lnblc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QX0s3s6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QX0s3s6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762B6C433F1;
	Mon, 25 Mar 2024 18:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711391269;
	bh=eBt2AV4OAjLPdcjttMAd77PV3m18dm2aYpsEJKwnkmQ=;
	h=Date:To:From:Subject:From;
	b=QX0s3s6pIuKC/QI2Vme+rMFFEN3rfxFq/5lIfSFY+hS7aA2fWQF9xMipLqcstVef9
	 DyD+D5VmdPMO01q4C7HHt/LPeCipsawI2BfpvUtUJ2xJcnF8FV8TyTgLFHIKnDCzQO
	 ijDuPPmB4hANxI5/zaVIS87LZmv5JOb+iZ7ExlJ4=
Date: Mon, 25 Mar 2024 11:27:48 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,stable@vger.kernel.org,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,miklos@szeredi.hu,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20240325182749.762B6C433F1@smtp.kernel.org>
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
Date: Mon, 25 Mar 2024 14:41:12 +0100

folio_is_secretmem() states that secretmem folios cannot be LRU folios: so
we may only exit early if we find an LRU folio.  Yet, we exit early if we
find a folio that is not a secretmem folio.

Consequently, folio_is_secretmem() fails to detect secretmem folios and,
therefore, we can succeed in grabbing a secretmem folio during GUP-fast,
crashing the kernel when we later try reading/writing to the folio,
because the folio has been unmapped from the directmap.

Link: https://lkml.kernel.org/r/20240325134114.257544-2-david@redhat.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/lkml/CABOYnLyevJeravW=QrH0JUPYEcDN160aZFb7kwndm-J2rmz0HQ@mail.gmail.com/
Debugged-by: Miklos Szeredi <miklos@szeredi.hu>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/secretmem.h~mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios
+++ a/include/linux/secretmem.h
@@ -16,7 +16,7 @@ static inline bool folio_is_secretmem(st
 	 * We know that secretmem pages are not compound and LRU so we can
 	 * save a couple of cycles here.
 	 */
-	if (folio_test_large(folio) || !folio_test_lru(folio))
+	if (folio_test_large(folio) || folio_test_lru(folio))
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

