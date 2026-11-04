Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815488;
	b=C6ogvTrQFlruJq7ySI7jJ3tWt9G9nNwmoAZqAW7Ysjta98m1OOGpTJIByeag/XRxjMPx
	 P4BHyNOwld8rZmZx8D2d1spjcJebLyszYrQ0VoYyqTB1vJlR2dPMbCCG6UBgUCqOhP/zu
	 ecEVcoTB50jM/Av42QOZLccnEHiAlyqZPmNlQR29ca6QVvmFg6CYHSzFjZsTVpHzr4nTz
	 NklZIbjS4bnprzuQIJyadCYM6KL/g+VuD71L+zlAWVv0OtpV5UPySCjNhsmEf2QtxRcRa
	 H6WQ1xPWWTYsTuBKB1ycQcA1SgdLtNL6K2opqZ54cVp0zH+XZtCn0HQ0/CQWKaHZQsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815488;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=azgmO/c7erxIjuuP/E4HWpspy1buwqPL1vap21Ioe3Q=;
	b=whh+789l+uuB0TO9tQpQLv7YnrkCVR0gjF7zjosIQo0nA0AC+xCNIW2nDkdRkVHJCMZa
	 US/sGNFuGW15UWb/jGzz+gJB+ubI4AWwTb6I10cykgWAKHzTENOxH/MKrlxkDOadhohNd
	 T1Nb/qIrgOnD92VRo++4RywYI2nMPykj9a342ICq07fH6aBnoajQacvYigfs/gBq+NmMa
	 MVwUgxEBlahsA2ny8uZ47Erx8am6+bUrHILTU54yyAV9tGC8EO+wrLDHAUU/MipJEhFn9
	 cybusgGl66zN5ILmzoJ5KHX10PdFmCIajWn32wmciHV3A8UpRbQkADsCF36tTopHvTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t0XqHxEA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9B0606A328;
	Wed,  4 Nov 2026 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t0XqHxEA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C31F00A02;
	Wed,  4 Nov 2026 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793815488;
	bh=azgmO/c7erxIjuuP/E4HWpspy1buwqPL1vap21Ioe3Q=;
	h=Date:To:From:Subject;
	b=t0XqHxEAB2C5m4vydigRFcx8E5xAuIkmREGILopI7lwENBEwdLmvLklONaRXTbB4p
	 eb2PTq+r3x40guKloNzwUvpejmRUMteKWJHsgUf3Rc0kzkejucHy0CPcd5QGaIaCsK
	 nsde7ZqUC801lcrHqQ2ji5jKRof1v0s3tWICkFmc=
Date: Wed, 04 Nov 2026 10:04:47 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,
	osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch added to mm-new branch
Message-Id: <20261104180448.194C31F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch

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
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Tue, 03 Nov 2026 11:28:35 +0100

Patch series "mm/userfaultfd: recheck WP registration in the hugetlb
UFFDIO_COPY retry", v3.

The urgent fixes made hugetlb_fault() tolerate uffd bits left in VMAs
that are no longer registered for them, and asked for follow-ups that
remove the sources [1]. This is one: a hugetlb UFFDIO_COPY_MODE_WP copy
that has to fault in its source page doesn't recheck the WP registration
before retrying, so re-registering the range without WP in that window
leaves a uffd-wp PTE behind.

Patch 1 adds the missing check. Patch 2 adds a uffd-unit-tests case for
it, which fails on hugetlb without patch 1.

The other source 6/10 of [1] mentions, UFFDIO_COPY in MODE_WP racing
with UFFDIO_UNREGISTER [2], is closed by "mm/userfaultfd: write-lock the
VMA before waking waiters when unregistering" [3].

Based on mm-unstable.

Tested on x86_64 in QEMU.


This patch (of 2):

mfill_atomic_hugetlb() drops its locks to copy the source page with page
faults enabled and then looks the VMA up again. The retry doesn't check
that the VMA is still registered for WP, so if the range is re-registered
without WP in that window, a UFFDIO_COPY_MODE_WP copy installs a uffd-wp
PTE in a VMA without VM_UFFD_WP.

Recheck VM_UFFD_WP for UFFDIO_COPY_MODE_WP copies after looking the VMA
up again, and fail with -EINVAL if it is gone.

Link: https://lore.kernel.org/20261103102840.68903-1-azpijr@gmail.com
Link: https://lore.kernel.org/20261103102840.68903-2-azpijr@gmail.com
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org [1]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org [2]
Link: https://lore.kernel.org/20261031-fixes_core-v3-23-d6437171ecc3@kernel.org [3] (in linux-next)
Link: https://lore.kernel.org/sashiko-outbox-194303@kernel.org [4]
Fixes: 6041c6917903 ("mm/hugetlb: take care of UFFDIO_COPY_MODE_WP")
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry
+++ a/mm/userfaultfd.c
@@ -810,6 +810,10 @@ retry:
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
 			goto out_unlock_vma;
 
+		/* The range may have been re-registered without WP meanwhile. */
+		if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+			goto out_unlock_vma;
+
 		/*
 		 * If memory mappings are changing because of non-cooperative
 		 * operation (e.g. mremap) running in parallel, bail out and
_

Patches currently in -mm which might be from azpijr@gmail.com are

mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch
selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch

