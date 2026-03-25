Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F433451CC
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 22:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477784; cv=none; b=tz++5BbZilGN2ZCH8hu1JoxzLBzssvHlklxlMkDFF57lpnY6jBst0bIoQiApsHPRGsVuVslX3gufgzERlNwn+RU+ApYJ121csljlc80vkIlHUwqvVTUg4WG8LSq/mGqZLlFMeeXGlUpt6AOqVEe5sEH9AwOWS8Lv9OorpxBsi7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477784; c=relaxed/simple;
	bh=+qEt8YQo7tO4WdkaCCUl23v/sa2RTkgjgM6dlUGT678=;
	h=Date:To:From:Subject:Message-Id; b=kGS88RUHGb1ubpxs5Yli4o4HDjF/Gwhy5S/fotnvMp8tZ25c73Wu2T+bxWhnzFuC4pQJWwDuSTVYPaBqxT5SEll10Al8qvehrEsvIVQqIOOK47vjZBiSTftkK9fNsJhb1ShC1rxQdwmlL2VFsx0VcrGnq2+b09KFn7Vo3yVOK2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hdolcMY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hdolcMY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C4C4CEF7;
	Wed, 25 Mar 2026 22:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774477783;
	bh=+qEt8YQo7tO4WdkaCCUl23v/sa2RTkgjgM6dlUGT678=;
	h=Date:To:From:Subject:From;
	b=hdolcMY0B8NmIkfG1fgSDqqybIkwHs6qxYEBBR1/3ua0y6kcr7tS0ht4dyRWsJue3
	 4QmxWmJhuJr5Dtz9dBt8H+LAHor5N3hQzRVYIyHmMrkOdbgXXpmInfG3YMfduLDiZv
	 pjmuDokKNSPc9zg3kgZCtUW5Lf55Ik85CutfbD34=
Date: Wed, 25 Mar 2026 15:29:43 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,avagin@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix.patch added to mm-unstable branch
Message-Id: <20260325222943.D19C4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix.patch

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
Subject: userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix
Date: Wed Mar 25 03:23:43 PM PDT 2026

update mfill_copy_folio_retry() for
userfaultfd-introduce-mfill_get_pmd-helper-fix.patch

Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix
+++ a/mm/userfaultfd.c
@@ -427,7 +427,7 @@ static int mfill_copy_folio_retry(struct
 	if (err)
 		return err;
 
-	err = mfill_get_pmd(state);
+	err = mfill_establish_pmd(state);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

