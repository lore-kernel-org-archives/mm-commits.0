Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EA21C862F
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 22:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769465978; cv=none; b=HymNXvBExmAVmVS3mXKm0IZ5luygUonxMF0LVcyNJTrNRjuQ8PePhrvKliWH8Jl+1xIk+H2uATeWSFATGTnGhK/x1bnuF5ZmwdEvPXHfUa5iO2lXylBZFDlOp4kVc6bGK1LYXffHa0zfvtofi4DhuhXPR5UGAx+13OSLAtfSE2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769465978; c=relaxed/simple;
	bh=iWXkCAGOx01sPrgUHq4HoQ2SGB/+OIBGnl/Z0TRIyOQ=;
	h=Date:To:From:Subject:Message-Id; b=WRnp+T2zNTL+aOSexVfTmaHXEs+pTh34keldZVncIUUNAbNkqc52KsN5xmomnYvlAyTU35AjXuOfcykoUAcMC3rXg3QgQm4R3dq8wWzKuOnQg5FrLmuFK4Bzj/s9advA/Z7HFt7MHatJ6XEi3tMKeb8MHROYGEhPzCdSa+qe3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jlelOgWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jlelOgWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E33CC116C6;
	Mon, 26 Jan 2026 22:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769465978;
	bh=iWXkCAGOx01sPrgUHq4HoQ2SGB/+OIBGnl/Z0TRIyOQ=;
	h=Date:To:From:Subject:From;
	b=jlelOgWREECMHZyG7xt9lSMr2LOq83iRzgVojadTUy1IAkEqVTv/YNxjI12Olnsyv
	 T2A88w/Yqi1izDDmP0t+gcR8agBRsUqqz8m1XbaRXX6KkBHdyeBwTnSr3HxbTSw3nn
	 2hdjFJkrhuPKRQ1q6NpxGvzgwFXifrO+CHMG6FKk=
Date: Mon, 26 Jan 2026 14:19:37 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,tycho@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-doc-for-kho_restore_pages.patch added to mm-nonmm-unstable branch
Message-Id: <20260126221938.4E33CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix doc for kho_restore_pages()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-doc-for-kho_restore_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-doc-for-kho_restore_pages.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: kho: fix doc for kho_restore_pages()
Date: Fri, 23 Jan 2026 12:05:06 -0700

This function returns NULL if kho_restore_page() returns NULL, which
happens in a couple of corner cases.  It never returns an error code.

Link: https://lkml.kernel.org/r/20260123190506.1058669-1-tycho@kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-doc-for-kho_restore_pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -299,7 +299,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
  * Restore a contiguous list of order 0 pages that was preserved with
  * kho_preserve_pages().
  *
- * Return: 0 on success, error code on failure
+ * Return: the first page on success, NULL on failure.
  */
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 {
_

Patches currently in -mm which might be from tycho@kernel.org are

kho-fix-doc-for-kho_restore_pages.patch

