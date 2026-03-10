Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516A5319860
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167957; cv=none; b=OExriKLoqGwV7szml8yr799EbGChbVKN1ckgEaSWSsFUs3+AfBcxofI98pTiq+dHa7bdxZUa1TshTYJwhg1p7rRm5i3BV1T7W2tIhfdcxlGq17tW002eGOu3Xi9lMufmhuhuT5uclUUrMVNWZdzZnGhvXpXIg6k4PJih6xKxR7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167957; c=relaxed/simple;
	bh=uKJ5o2BW+UY+DdAeJ9s+kiwCpxFFyx+QZn93eYBGz/M=;
	h=Date:To:From:Subject:Message-Id; b=V7+FQiikwTeM7aezbEB8bDphX8ujtEgZRma41h6wF4Qb5MKdvuJWEH+OV00kqul4ihFKIAhkx4PZevOB0Zq34pza1rirMweEOC5zFhw9Ycbuzd6/ef2GSkUgOFUfvePlkIxvqxvKBuFNbwx3Qe9IRZEAJ3Xnf95mO45NtJnFCC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UuxPec0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UuxPec0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FA2C19423;
	Tue, 10 Mar 2026 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773167956;
	bh=uKJ5o2BW+UY+DdAeJ9s+kiwCpxFFyx+QZn93eYBGz/M=;
	h=Date:To:From:Subject:From;
	b=UuxPec0TReSiDxPxs9ncH5pd06poqIUYNZkfjvyLZ5DOEFTztKhV4icrROknKLCHa
	 0zbUAFP2uy2g1KTnU8QxeNCLGdXmGdtec/YqlqLEnED2Pwnbo2PdIIZkxig4jO1tDd
	 eLnJ7QZNAdX4peY71zB5DUHYaCGHLQIlvDCoz2K4=
Date: Tue, 10 Mar 2026 11:39:16 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20260310183916.D5FA2C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes
Date: Tue Mar 10 11:37:46 AM PDT 2026


ERROR: code indent should use tabs where possible
#78: FILE: mm/huge_memory.c:360:
+^I^I^I^I^I^I        &transparent_hugepage_flags);$

total: 1 errors, 0 warnings, 78 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-huge_memory-refactor-enabled_store-with-change_enabled.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes
+++ a/mm/huge_memory.c
@@ -354,10 +354,10 @@ static bool set_global_enabled_mode(enum
 	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
 		if (m == mode)
 			changed |= !__test_and_set_bit(thp_flags[m],
-						       &transparent_hugepage_flags);
+						&transparent_hugepage_flags);
 		else
 			changed |= __test_and_clear_bit(thp_flags[m],
-						        &transparent_hugepage_flags);
+						&transparent_hugepage_flags);
 	}
 
 	return changed;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

