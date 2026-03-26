Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC8019006B
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774544760; cv=none; b=u7Jx9pLVyaQYAyAebOTnAaHtdDTUBswyFWjZ/qtqCx8FaGHH7qLaWEVokfQEyU4q6IzjFxGFIAwfM2H0gvQR74jJ3OUdD8f3cNFMci0WU7oReXmFzG8LX/ksWPFAqCqy0pJtXMAGvaS9+lFt7R+wxdG6t1OsjLW3YaNyU7XL3es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774544760; c=relaxed/simple;
	bh=zbnak03UdRsJrk1jnLbut0966d09yp3s0MLVu7/vJzE=;
	h=Date:To:From:Subject:Message-Id; b=Rt30iHj5txjsHAcDCQKV5HQ96oik/OcVUVgPnJVuxYidMXep+jyt3keABJp3gXpWCtoUGxC0G9P7qIt3dd9J6p3i3AiCSgrtMlqKQNm6RvWZTiczEgAlXSZwOLwHLAK3HJXvN14FfthdKAjM7aCNIGb959nCPsFQ2xaVRUtLMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4VczCB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4VczCB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A23C2BCB0;
	Thu, 26 Mar 2026 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774544760;
	bh=zbnak03UdRsJrk1jnLbut0966d09yp3s0MLVu7/vJzE=;
	h=Date:To:From:Subject:From;
	b=u4VczCB/3KxOTc4KxrFeCxtkye3MU/tCW8ZvrS3NS9WsT9pfTNm81bLD5/mpnX5BX
	 iA10d8LHmbkBWsGi/fMhgWWAkYiTkopr0IrFS4S71ynbA1J2oe5ehyEGGXm9MV/43M
	 ihN7O02Hy061GBb/JZQ8QGctRueGClmWkvqrG3eo=
Date: Thu, 26 Mar 2026 10:05:59 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,avagin@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix.patch removed from -mm tree
Message-Id: <20260326170600.86A23C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix-fix.patch

This patch was dropped because it was folded into userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch

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

userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

