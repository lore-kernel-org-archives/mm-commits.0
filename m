Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE3E23B629
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821843; cv=none; b=FIFskFBJ5K7jRTS3CIOr7xmrBJ1x11tK9FgMGAWgeWE5xBZ6R/lZE1a6iQRgGhheeI5BFa2ecyQKFeOg7z4sc4NE9cerVOKMJWczB2s3Pwq6aRw1chWl+IVcnuvif7BXhW4KEtKi8OhDzWHLbebj1N8QR/VGpEQuzzya06qnI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821843; c=relaxed/simple;
	bh=Xm48iFurk6SUDKL36KiQwDOSjO1onlQpqF0b+dbkL34=;
	h=Date:To:From:Subject:Message-Id; b=Yb+UQct/sNhRcSOTNAwchAEwNsHJjFWEKofFIK35ecvYDBxTB7Va1OrEsV0Acmnn+S6U9K5qhw1Q+1huGtHopI4rkKFqAyKHsyEWy3D6yC+TTiYigkenr4FI2CNRxQKYp/hVCPvyb73zdvTROfG+EAHcsQAkRxMwYZevVYnspKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2bdRX0sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2bdRX0sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F43C4CEEF;
	Tue, 29 Jul 2025 20:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821842;
	bh=Xm48iFurk6SUDKL36KiQwDOSjO1onlQpqF0b+dbkL34=;
	h=Date:To:From:Subject:From;
	b=2bdRX0sgwuTX/D0QQgJT6sIm9fFXvQXHvOfvB6xlecI21x/fxVQfAMOWzjRC8Nkqd
	 SOV51dO7bpgWmQoDRljUIEy9WTRL09SmkJSBnt80HqRdzcbQfXgf/rU1ZT+fYpmj/8
	 Kpo6yhCj8YsftfZBi3xrnxhKO0y9sl2b9Lnx+UZM=
Date: Tue, 29 Jul 2025 13:44:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch added to mm-new branch
Message-Id: <20250729204402.61F43C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/selftests: fix incorrect pointer being passed to mark_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/selftests: fix incorrect pointer being passed to mark_range()
Date: Tue, 29 Jul 2025 11:03:57 +0530

Patch series "selftests/mm: Fix false positives and skip unsupported
tests", v3.

This series addresses false positives in the generic mm selftests and
skips tests that cannot run correctly due to missing features or system
limitations.


This patch (of 3):

In main(), the high address is stored in hptr, but for mark_range(), the
address passed is ptr, not hptr.  Fixed this by changing ptr[i] to hptr[i]
in mark_range() function call.

Link: https://lkml.kernel.org/r/20250729053403.1071807-1-aboorvad@linux.ibm.com
Link: https://lkml.kernel.org/r/20250729053403.1071807-2-aboorvad@linux.ibm.com
Fixes: b2a79f62133a ("selftests/mm: virtual_address_range: unmap chunks after validation")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -227,7 +227,7 @@ int main(int argc, char *argv[])
 		if (hptr[i] == MAP_FAILED)
 			break;
 
-		mark_range(ptr[i], MAP_CHUNK_SIZE);
+		mark_range(hptr[i], MAP_CHUNK_SIZE);
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

