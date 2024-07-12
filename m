Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0091F12DD8E
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824900; cv=none; b=qs0V4wtmUMMllPCeVNYdxSWAs86byvXvn4ZvTj300xTvIs/XROSEtE1DD4nlXIe0swB40073IIa3VcC6VnLQFqdxfU4pmUmdO86CtET/ZjKN413YaepMB0Ee84Fyv0rcSXDuJyA6OEFVLmwfZj2ZTDs2MtMHDHsPY3STjh9Jw/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824900; c=relaxed/simple;
	bh=KnyPrAdWKzitPa7znsNxM0u+1wWqvVjBGr9cIcAAb/M=;
	h=Date:To:From:Subject:Message-Id; b=D1c6hU99Jq6dNYOH/pfaL8UELPZDxFO/65Z+baG6JHNsCl20ZsOIDmP+XXMD4gXl3YuHohy6X5/3Z9z0VY70IQDMq8jYSCbsW/KjbwFde0JUhsepnf3uKdogYXPVippSlWT+khJhgMh0pF4I1sRDn9GSqhCsLJYx0pBe16rCfRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lVIeqML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lVIeqML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E0CC32782;
	Fri, 12 Jul 2024 22:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824899;
	bh=KnyPrAdWKzitPa7znsNxM0u+1wWqvVjBGr9cIcAAb/M=;
	h=Date:To:From:Subject:From;
	b=0lVIeqMLLuJKM1aEGaLxtxMVQWEn0WUYWKp6MNENE021l7b/Exm6t2Mvq02Qp75EC
	 yBJHuMaeLEXqa9X75HRvYwYA3mgopJIxN0Ltf2QbO0hpmvGPlKi70PxIgn8xb0VbyV
	 iZ2IWBH9GohIsV4msBqS5zwcJf0mWX2RAp4ub+3s=
Date: Fri, 12 Jul 2024 15:54:59 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch removed from -mm tree
Message-Id: <20240712225459.C8E0CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove obsolete MF_MSG_DIFFERENT_COMPOUND
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch
mm-hugetlb-fix-possible-recursive-locking-detected-warning.patch

