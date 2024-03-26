Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D284D0D;
	Tue, 26 Mar 2024 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476508; cv=none; b=LY0WiS0cBk5Gge9qsC0F3+S5sJas41h85qJrLPV9JAhc9H9hVj18wuOEW6FV9Z5eBLM+A8XcMoMXJ3wSE/oDJHkEnNbcTqtdyz/twnxFXkNApHpP88Q/eMWGHT0PsKwfAUIgHX0c/TMIGEBkr5v7d7/7sThGSzfDidJYKQAa5Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476508; c=relaxed/simple;
	bh=aDpuWIg2C8GSfgg3yoqIFqThS/nE2Ersj1nNm9b4lnk=;
	h=Date:To:From:Subject:Message-Id; b=agdBYyaYIDNYlm4qS13XPck1v8Itr4LDLkenBskSMCyJZN/Dnej+LcKshkpzr6BIkY9XdQgJtX6C1r4FvfQ6K2Gbvh0QNwStlHrlEXtAWCHtW2+pdC2/kzip3mAGX2bRsdjaI3b4wboK83FjzvLvD0bC7j49yW15Krk8KY4C2T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2SzTirj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2SzTirj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6E1C433F1;
	Tue, 26 Mar 2024 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476508;
	bh=aDpuWIg2C8GSfgg3yoqIFqThS/nE2Ersj1nNm9b4lnk=;
	h=Date:To:From:Subject:From;
	b=N2SzTirj+aeFUSwsOpVTtGyj3dr3tKJCr2NaRC3LIBYCvNHBdh8UwvhrIM6IHhxuV
	 txFbwdk9KO3Wjfg8RhJhCSGLR28C7bisn2qqTA38gadStcnps0W2ssbmM6gt4+16GX
	 cDWv8tedOzXCPuPf809b6XFM9G2VHy6Co1b+nzhc=
Date: Tue, 26 Mar 2024 11:08:28 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,stable@vger.kernel.org,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,miklos@szeredi.hu,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch removed from -mm tree
Message-Id: <20240326180828.AC6E1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
has been removed from the -mm tree.  Its filename was
     mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

