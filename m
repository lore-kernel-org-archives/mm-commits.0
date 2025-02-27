Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD1321CC53
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696308; cv=none; b=CAtvvWr1km8qePu12oGAbHyy+yNf2VewS7hAIEjEqWCb4nvnj/XWhoLTnRAsdbWuBgJAHED2w3NsghrP+j4V34ffgzQGoM5MunKCuKDbH2/3p8UZ/p8YdcPKz8rYSSAHpfWtBzBW6K6r94w/gIHm8TEt3Fsx0ejXjSdlgxFgja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696308; c=relaxed/simple;
	bh=/7dDS8Dro6oYRhANwTpf5UmtQdIodNje38nI7w/hb5g=;
	h=Date:To:From:Subject:Message-Id; b=pMDUlWWfcbyRbww7F/QxeSvYBPD3bPxQLGZ/mmmqc41WIwHg+7cgAerV+DKsKU1UG19EmfEZ09zGRAOZNdn21Q9Mfus91WnI5OxHG5N3AegvmeprV+AhP6cRuAnkaB7iflcR3yJQDg4pL0xZ3I9wN148Q33SIMLIHaGuFjrbalQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R9TU8zBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R9TU8zBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312C5C4CEDD;
	Thu, 27 Feb 2025 22:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740696308;
	bh=/7dDS8Dro6oYRhANwTpf5UmtQdIodNje38nI7w/hb5g=;
	h=Date:To:From:Subject:From;
	b=R9TU8zBx6DnSZ0KB/XGGqoIn1MECLrzoUizyTT6YdSW74D929Nnq07FFpvcv4imuC
	 jxWyrcumeFRhoUmpHBE7MdBYqqYl21ljgeEUhnBaKIvrJ3QxZWHsAirtw2YFmaxKkE
	 cEY0+2h/msXHvUkBJjvN07es95RvPdjcfrLV4yCw=
Date: Thu, 27 Feb 2025 14:45:07 -0800
To: mm-commits@vger.kernel.org,bgeffon@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-finish_fault-handling-for-large-folios-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250227224508.312C5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-finish_fault-handling-for-large-folios-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-finish_fault-handling-for-large-folios-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-finish_fault-handling-for-large-folios-v3.patch

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
From: Brian Geffon <bgeffon@google.com>
Subject: mm-fix-finish_fault-handling-for-large-folios-v3
Date: Thu, 27 Feb 2025 08:32:36 -0500

tweak whitespace

Link: https://lkml.kernel.org/r/20250227133236.1296853-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-finish_fault-handling-for-large-folios-v3
+++ a/mm/memory.c
@@ -5229,7 +5229,7 @@ fallback:
 	 * inflating the RSS of the process.
 	 */
 	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-			unlikely(needs_fallback)) {
+	    unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-fix-finish_fault-handling-for-large-folios.patch
mm-fix-finish_fault-handling-for-large-folios-v3.patch

