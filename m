Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A144813AA2D
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762218296; cv=none; b=g7AJ8q9MqZJnuADf23we4dv9QDrzA7I60UukgFnCknnVpMgoGfnea5zF+R2XN42UesFh1jlB4qvXIN5zoTb9L9IB2csmFjOKg2KgkmK2JVZ3oqr3b7zHWLf0JhqocD2JRmdUzhvHqRCSoHOpRcdWPeN1Mn1thCyO+yKtV6GXUPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762218296; c=relaxed/simple;
	bh=/+h94JffHCt37aOS8Z9sA9QxwQO+uxKNYCEs6j5Myp0=;
	h=Date:To:From:Subject:Message-Id; b=b8TxlqmZ5cw1bq/WLbpFSgKUW2+XLRV3rZG5At8LyPvYRqzkQ4vMIDbls1Zuq2Sp6xGVyX2/UqYrGJJNbS+4dafrICX4rqWjxepXwILLiam117ep5TpCG3uKN+1F5xU4yVzHDlVLpQmnZ2pnUXUR5yXGIncADWv3cvcAFtqo9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m/GCxAZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m/GCxAZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A00C4CEE7;
	Tue,  4 Nov 2025 01:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762218296;
	bh=/+h94JffHCt37aOS8Z9sA9QxwQO+uxKNYCEs6j5Myp0=;
	h=Date:To:From:Subject:From;
	b=m/GCxAZNa/6ayYkw2r8rzK9ldF+3NqMh2DWvmwJKC4FuIqs3vtlicEo6kq80//F7C
	 6C/S+/WFWGoy8pULiRjK7UIFnUodNlBRM8mzVTOJkmXblBHmRWJBiDSAsZoiL7Ap5/
	 +1RxfG6GpmLUbfKNsm3SuSOz3PDDzk/4/sw0HBUI=
Date: Mon, 03 Nov 2025 17:04:55 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,david@kernel.org,broonie@kernel.org,b-padhi@ti.com,aishwarya.tcv@arm.com,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104010456.09A00C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix.patch

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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix
Date: Mon, 3 Nov 2025 14:30:12 +0000

Handle the arch mte_zero_clear_page_tags() code issuing MTE
instructions irrespective of whether the hardware supports it.

Link: https://lkml.kernel.org/r/aQi8dA_QpXM8XqrE@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lkml.kernel.org/r/aQiu-hU3x5V5drHF@finisterre.sirena.org.uk
Tested-by: Beleswar Padhi <b-padhi@ti.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/mm/fault.c~mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix
+++ a/arch/arm64/mm/fault.c
@@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_f
 
 void tag_clear_highpage(struct page *page)
 {
+	/*
+	 * Check if MTE is supported and fall back to clear_highpage().
+	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
+	 * post_alloc_hook() will invoke tag_clear_highpage().
+	 */
+	if (!system_supports_mte()) {
+		clear_highpage(page);
+		return;
+	}
+
 	/* Newly allocated page, shouldn't have been tagged yet */
 	WARN_ON_ONCE(!try_page_mte_tagging(page));
 	mte_zero_clear_page_tags(page_address(page));
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch
mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix.patch

