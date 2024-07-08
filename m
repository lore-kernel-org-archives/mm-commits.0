Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE8C7345B
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 21:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720475311; cv=none; b=VNoVfJNvTmEfgmip+RdrRerXAkfln0KOU1noPawU4naSCl4Ytzkh4VHMaPfxZlBLl3YGlNorYjwmGLPPbMPFGNmkcTrijSSyTYCZhMLOLwn640VWs8lFFwLojgneO791NLW+L4j3qVAisIcsDgo5VfwjnIa+AduQ+iSrjMU8kJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720475311; c=relaxed/simple;
	bh=eM6LbOmVZ8hvAcbRzQ6h1gOwBESOMSB5H3B9TTH3QOc=;
	h=Date:To:From:Subject:Message-Id; b=Uf2FEzv0gawrXA6gLP695pF+zbFZmnYs525dG4PePmQpaX5Xq1Rpd6TZhA4R7a3JkoZ8xOdiC8DWV9WtK6QrWEVQFfUIzW1cHaKDQdGmtZg2Q48yQ27Puur3R+rQuzxak51U54NKnUXfuum7J274cLphpmey4KC5uZ3PjQXcYE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hogowVow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hogowVow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0213C116B1;
	Mon,  8 Jul 2024 21:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720475311;
	bh=eM6LbOmVZ8hvAcbRzQ6h1gOwBESOMSB5H3B9TTH3QOc=;
	h=Date:To:From:Subject:From;
	b=hogowVowee2+Phd8hFaG+RhT14fBMmvlkisX6sPOT1jXD4huTo4jIjTNJp9uQIw5n
	 FzBWoN3ahDbaIoLGQcEFPhbkyyCqm5oRs1Ma0+/WudpXC7vTCWok+u/JaXVNxQi5Ys
	 xi6DoUsc8yePuIjLAF/VS6zbQrpm0DJ2jEMOL1gU=
Date: Mon, 08 Jul 2024 14:48:30 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch added to mm-unstable branch
Message-Id: <20240708214830.E0213C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove obsolete MF_MSG_DIFFERENT_COMPOUND
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove obsolete MF_MSG_DIFFERENT_COMPOUND
Date: Mon, 8 Jul 2024 11:05:44 +0800

The page cannot become compound pages again just after a folio is split as
an extra refcnt is held.  So the MF_MSG_DIFFERENT_COMPOUND case is
obsolete and can be removed to get rid of this false assumption and code
burden.  But add one WARN_ON() here to keep the situation clear.

Link: https://lkml.kernel.org/r/20240708030544.196919-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |   19 +++----------------
 2 files changed, 3 insertions(+), 17 deletions(-)

--- a/include/ras/ras_event.h~mm-memory-failure-remove-obsolete-mf_msg_different_compound
+++ a/include/ras/ras_event.h
@@ -356,7 +356,6 @@ TRACE_EVENT(aer_event,
 #define MF_PAGE_TYPE		\
 	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
 	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
-	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
 	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
--- a/mm/memory-failure.c~mm-memory-failure-remove-obsolete-mf_msg_different_compound
+++ a/mm/memory-failure.c
@@ -919,7 +919,6 @@ static const char *action_name[] = {
 static const char * const action_page_types[] = {
 	[MF_MSG_KERNEL]			= "reserved kernel page",
 	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
-	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
 	[MF_MSG_GET_HWPOISON]		= "get hwpoison page",
@@ -2349,22 +2348,10 @@ try_again:
 
 	/*
 	 * We're only intended to deal with the non-Compound page here.
-	 * However, the page could have changed compound pages due to
-	 * race window. If this happens, we could try again to hopefully
-	 * handle the page next round.
+	 * The page cannot become compound pages again as folio has been
+	 * splited and extra refcnt is held.
 	 */
-	if (folio_test_large(folio)) {
-		if (retry) {
-			ClearPageHWPoison(p);
-			folio_unlock(folio);
-			folio_put(folio);
-			flags &= ~MF_COUNT_INCREASED;
-			retry = false;
-			goto try_again;
-		}
-		res = action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
-		goto unlock_page;
-	}
+	WARN_ON(folio_test_large(folio));
 
 	/*
 	 * We use page flags to determine what action should be taken, but
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch

