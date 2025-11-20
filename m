Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7037D2D9EEC
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763673759; cv=none; b=QWRLj8/jJUohtgiSV+p8I2BjRLCrvhCJGlGjgc+4HbevVfinD0ryFqklClzHOPUmf02Xm1WMk3TeCoT5qWCAKfHBuHcOzEWqVtsFXrZqutw9N0b/ydWdBzaY7ddbFPVsDrzC8rJ/LaP0xXFkIst7HZltH2Dlc+Xy88blO1UBjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763673759; c=relaxed/simple;
	bh=efJiLxI9I+RURUOBIefOPJ+c/Yf34UyZaRQxrCykPfo=;
	h=Date:To:From:Subject:Message-Id; b=Y78S8xObMftNn/HY/qcTVxs0oyxdya+PdfYOhdIozgTBLwr+fCq19CF3ZXBiWTsmlDnC1EglIvXNpY0dzUFw28EC9b3KVAW7f/301g9HHorOfb9Z22At7mMsO4G4aIJDNvVVN1u4Dmep87afUs5Q9Rl3gaVr+QvdJyZ03Ej+p5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oU2Je/vC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oU2Je/vC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F42C4CEF1;
	Thu, 20 Nov 2025 21:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763673758;
	bh=efJiLxI9I+RURUOBIefOPJ+c/Yf34UyZaRQxrCykPfo=;
	h=Date:To:From:Subject:From;
	b=oU2Je/vC//if9PDpDurSpOBXAozcaSR5Hfuwbm7kinpS2ai5jYKJ2SaZezAxHiHmx
	 GFQ4uHR5UyPrKq8eJNOrxVOZA8N9OjDD8VbB61Jr+9couo7Yfl7PDMKwm5ja+9ztEf
	 /E3TO2Q8Tm3cI7USNojvVhyDmKvBCS85rLGXF+mo=
Date: Thu, 20 Nov 2025 13:22:38 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correctly-handle-uffd-pte-markers-fix.patch added to mm-unstable branch
Message-Id: <20251120212238.C4F42C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-correctly-handle-uffd-pte-markers-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correctly-handle-uffd-pte-markers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correctly-handle-uffd-pte-markers-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-correctly-handle-uffd-pte-markers-fix
Date: Thu Nov 20 01:21:44 PM PST 2025

fix comment typo, per Mike

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/userfaultfd.c~mm-correctly-handle-uffd-pte-markers-fix
+++ a/fs/userfaultfd.c
@@ -312,7 +312,7 @@ again:
 		return true;
 
 	/*
-	 * A race could arise which would result in a softleaf entry such a
+	 * A race could arise which would result in a softleaf entry such as
 	 * migration entry unexpectedly being present in the PMD, so explicitly
 	 * check for this and bail out if so.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-propagate-vm_softdirty-on-merge-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

